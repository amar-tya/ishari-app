/**
 * Screenshot specific phone frames from mockup HTML files
 * and save them as PNG assets for the Flutter onboarding screen.
 *
 * Run: node scripts/screenshot_mockups.js
 */

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

// Install playwright if needed
try {
  require.resolve('playwright');
} catch {
  console.log('Installing playwright...');
  execSync('npm install playwright --prefix /tmp/pw-temp', { stdio: 'inherit' });
}

const pw = require('/tmp/pw-temp/node_modules/playwright');

const ROOT = path.resolve(__dirname, '..');
const MOCKUPS_DIR = path.join(ROOT, 'plans', 'mockups');
const OUT_DIR = path.join(ROOT, 'assets', 'images', 'intro');

// Each entry: which mockup file, which CSS selector to clip, output filename
const shots = [
  {
    file: 'homepage-mobile.mockup.html',
    // First .phone element in the mockup (chapter list)
    selector: '.phone',
    nth: 0,
    out: 'slide_1_chapters.png',
  },
  {
    file: 'muhud-chapter-reader.mockup.html',
    selector: '.phone',
    nth: 0,
    out: 'slide_2_reader.png',
  },
  {
    file: 'bookmark-page.mockup.html',
    selector: '.phone',
    nth: 0,
    out: 'slide_3_bookmark.png',
  },
  {
    file: 'kitab-page-mobile.mockup.html',
    selector: '.phone',
    nth: 0,
    out: 'slide_4_kitab.png',
  },
  {
    file: 'homepage-mobile.mockup.html',
    selector: '.phone',
    nth: 0,
    out: 'slide_5_signin.png',
  },
];

(async () => {
  const chromePath = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';

  const browser = await pw.chromium.launch({
    executablePath: chromePath,
    headless: true,
  });

  const ctx = await browser.newContext({
    viewport: { width: 1400, height: 900 },
    deviceScaleFactor: 2, // Retina quality
  });

  for (const shot of shots) {
    const filePath = path.join(MOCKUPS_DIR, shot.file);
    if (!fs.existsSync(filePath)) {
      console.warn(`⚠  Not found: ${shot.file}`);
      continue;
    }

    const page = await ctx.newPage();
    await page.goto(`file:///${filePath.replace(/\\/g, '/')}`);

    // Wait for fonts to load
    await page.waitForTimeout(1500);

    const elements = await page.$$(shot.selector);
    const el = elements[shot.nth];

    if (!el) {
      console.warn(`⚠  Selector '${shot.selector}' [${shot.nth}] not found in ${shot.file}`);
      await page.close();
      continue;
    }

    const outPath = path.join(OUT_DIR, shot.out);
    await el.screenshot({ path: outPath });
    console.log(`✓  ${shot.out}`);
    await page.close();
  }

  await browser.close();
  console.log('\nDone! Screenshots saved to assets/images/intro/');
})().catch(err => {
  console.error(err);
  process.exit(1);
});
