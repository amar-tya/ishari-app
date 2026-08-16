// notify-new-audio
//
// Triggered by a Supabase Database Webhook on INSERT into `verse_media`.
// Sends a single FCM topic message (`new_audio`) — the client subscribes to
// this topic on first launch, so this stays a flat-cost broadcast no matter
// how many devices are subscribed (see AMA-60 PRD: topic vs. per-token send).
//
// Required secrets (`supabase secrets set ...`):
//   FCM_SERVICE_ACCOUNT      — full JSON of the Firebase service account key
//   NOTIFY_WEBHOOK_SECRET    — shared secret checked against the webhook's
//                              Authorization header (optional but recommended;
//                              verify_jwt is off for this function so anyone
//                              who finds the URL could otherwise call it)
//
// SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are injected automatically by
// the Edge Runtime — no need to set them manually.

import { createClient } from "jsr:@supabase/supabase-js@2";

const WEBHOOK_SECRET = Deno.env.get("NOTIFY_WEBHOOK_SECRET");
const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
const FCM_SERVICE_ACCOUNT_RAW = Deno.env.get("FCM_SERVICE_ACCOUNT");

const FCM_TOPIC = "new_audio";
const FCM_SCOPE = "https://www.googleapis.com/auth/firebase.messaging";
const GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";

interface WebhookPayload {
  type: "INSERT" | "UPDATE" | "DELETE";
  table: string;
  record: { id: number | string } | null;
  schema: string;
  old_record: Record<string, unknown> | null;
}

interface ServiceAccount {
  client_email: string;
  private_key: string;
  project_id: string;
}

interface ChapterInfo {
  chapterId: string;
  chapterTitle: string;
}

Deno.serve(async (req) => {
  try {
    if (WEBHOOK_SECRET) {
      const authHeader = req.headers.get("authorization") ?? "";
      if (authHeader !== `Bearer ${WEBHOOK_SECRET}`) {
        return new Response("Unauthorized", { status: 401 });
      }
    }

    let payload: WebhookPayload;
    try {
      payload = (await req.json()) as WebhookPayload;
    } catch (error) {
      console.error("notify-new-audio: invalid JSON body", error);
      return new Response("Bad Request: invalid JSON", { status: 400 });
    }

    if (payload.table !== "verse_media" || payload.type !== "INSERT") {
      return Response.json({ skipped: true });
    }

    const recordId = payload.record?.id;
    if (recordId === undefined || recordId === null) {
      console.error(
        "notify-new-audio: webhook payload missing record.id",
        payload,
      );
      return new Response("Bad Request: missing record.id", { status: 400 });
    }

    const chapter = await resolveChapter(recordId);
    if (!chapter) {
      console.error(
        "notify-new-audio: could not resolve chapter for verse_media.id",
        recordId,
      );
      return new Response(
        "Not Found: chapter could not be resolved",
        { status: 404 },
      );
    }

    const accessToken = await getFcmAccessToken();
    const fcmResponse = await sendFcmTopicMessage(accessToken, chapter);

    if (!fcmResponse.ok) {
      const body = await fcmResponse.text();
      console.error(
        "notify-new-audio: FCM send failed",
        fcmResponse.status,
        body,
      );
      return new Response("Bad Gateway: FCM send failed", { status: 502 });
    }

    return Response.json({ sent: true, chapterId: chapter.chapterId });
  } catch (error) {
    console.error("notify-new-audio: unhandled error", error);
    return new Response("Internal Server Error", { status: 500 });
  }
});

/// Re-queries `verse_media` (with a service-role join through `verses` to
/// `chapters`) instead of trusting webhook record fields — the webhook only
/// guarantees `id`, and this stays correct even if verse_media's raw column
/// names change.
async function resolveChapter(
  verseMediaId: number | string,
): Promise<ChapterInfo | null> {
  const supabaseAdmin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
  const { data, error } = await supabaseAdmin
    .from("verse_media")
    .select("verse_id, verses(chapter_id, chapters(title))")
    .eq("id", verseMediaId)
    .single();

  if (error || !data) {
    console.error("notify-new-audio: resolveChapter query error", error);
    return null;
  }

  const verses = data.verses as
    | { chapter_id: number | string; chapters: { title: string } | null }
    | null;
  if (!verses?.chapter_id) return null;

  return {
    chapterId: String(verses.chapter_id),
    chapterTitle: verses.chapters?.title ?? "Ishari",
  };
}

async function getFcmAccessToken(): Promise<string> {
  if (!FCM_SERVICE_ACCOUNT_RAW) {
    throw new Error("FCM_SERVICE_ACCOUNT secret is not set");
  }
  const serviceAccount = JSON.parse(FCM_SERVICE_ACCOUNT_RAW) as ServiceAccount;

  const now = Math.floor(Date.now() / 1000);
  const jwt = await signJwt(
    { alg: "RS256", typ: "JWT" },
    {
      iss: serviceAccount.client_email,
      scope: FCM_SCOPE,
      aud: GOOGLE_TOKEN_URL,
      iat: now,
      exp: now + 3600,
    },
    serviceAccount.private_key,
  );

  const response = await fetch(GOOGLE_TOKEN_URL, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(
      `Failed to obtain FCM access token: ${response.status} ${body}`,
    );
  }

  const { access_token: accessToken } = (await response.json()) as {
    access_token: string;
  };
  return accessToken;
}

/// Manual RS256 JWT signing via Web Crypto — avoids pulling in a full
/// Node-oriented Google auth library just to do a JWT-bearer token exchange.
async function signJwt(
  header: Record<string, string>,
  claims: Record<string, unknown>,
  privateKeyPem: string,
): Promise<string> {
  const encoder = new TextEncoder();
  const base64url = (input: ArrayBuffer | string) => {
    const bytes = typeof input === "string"
      ? encoder.encode(input)
      : new Uint8Array(input);
    let binary = "";
    for (const byte of bytes) binary += String.fromCharCode(byte);
    return btoa(binary).replace(/\+/g, "-").replace(/\//g, "_").replace(
      /=+$/,
      "",
    );
  };

  const headerB64 = base64url(JSON.stringify(header));
  const claimsB64 = base64url(JSON.stringify(claims));
  const signingInput = `${headerB64}.${claimsB64}`;

  const key = await importPrivateKey(privateKeyPem);
  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    encoder.encode(signingInput),
  );

  return `${signingInput}.${base64url(signature)}`;
}

async function importPrivateKey(pem: string): Promise<CryptoKey> {
  const pemBody = pem
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\s/g, "");
  const binary = atob(pemBody);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);

  return crypto.subtle.importKey(
    "pkcs8",
    bytes.buffer,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
}

async function sendFcmTopicMessage(
  accessToken: string,
  chapter: ChapterInfo,
): Promise<Response> {
  const serviceAccount = JSON.parse(
    FCM_SERVICE_ACCOUNT_RAW as string,
  ) as ServiceAccount;
  const url =
    `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`;

  return fetch(url, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${accessToken}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      message: {
        topic: FCM_TOPIC,
        notification: {
          title: "Audio Baru",
          body: `Audio baru tersedia di ${chapter.chapterTitle}`,
        },
        data: {
          chapterId: chapter.chapterId,
          type: "new_audio",
        },
      },
    }),
  });
}

/* To invoke locally:

  1. Run `supabase start`
  2. supabase secrets set --env-file supabase/.env.local FCM_SERVICE_ACCOUNT='...' NOTIFY_WEBHOOK_SECRET='...'
  3. curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/notify-new-audio' \
       --header 'Authorization: Bearer <NOTIFY_WEBHOOK_SECRET>' \
       --header 'Content-Type: application/json' \
       --data '{"type":"INSERT","table":"verse_media","record":{"id":1},"schema":"public","old_record":null}'

*/
