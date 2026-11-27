import 'package:flutter/material.dart';
import 'package:ishari/features/push_notification/data/services/notification_permission_prompter.dart';
import 'package:ishari/features/push_notification/data/services/push_error_report.dart';
import 'package:ishari/injection_container.dart';

const _kDark = Color(0xFF111111);
const _kSubtle = Color(0xFF79747E);

const _deniedMessage =
    'Notifikasi belum aktif. Aktifkan lewat '
    'Pengaturan > Aplikasi > Sholawat Hadrah Ishari > Notifikasi.';

/// Explains the "audio baru" notifications over the page of [context], and asks
/// the system for the permission only if the user chooses to turn them on.
///
/// Does nothing unless that page is on screen, [isAllowed] agrees and
/// [NotificationPermissionPrompter] allows another showing. Never throws.
Future<void> offerNotificationPrompt(
  BuildContext context, {
  bool Function()? isAllowed,
}) async {
  try {
    final prompter = sl<NotificationPermissionPrompter>();
    if (!prompter.tryAcquire()) return;
    try {
      await _offer(context, prompter, isAllowed);
    } finally {
      prompter.release();
    }
  } on Object catch (error, stack) {
    reportPushError(error, stack);
  }
}

Future<void> _offer(
  BuildContext context,
  NotificationPermissionPrompter prompter,
  bool Function()? isAllowed,
) async {
  if (!await prompter.shouldPrompt()) return;
  // Checked after the wait: another page may have taken over meanwhile.
  if (!context.mounted) return;
  if (!(ModalRoute.of(context)?.isCurrent ?? false)) return;
  if (!(isAllowed?.call() ?? true)) return;

  // The app's messenger outlives the page, so the hint survives leaving it.
  final messenger = ScaffoldMessenger.maybeOf(context);
  final answer = showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _NotificationPromptSheet(),
  );
  await prompter.recordShown();

  if (!(await answer ?? false)) return;
  if (await prompter.requestPermission()) return;
  messenger?.showSnackBar(const SnackBar(content: Text(_deniedMessage)));
}

class _NotificationPromptSheet extends StatelessWidget {
  const _NotificationPromptSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.notifications_active_outlined,
              size: 48,
              color: _kDark,
            ),
            const SizedBox(height: 16),
            const Text(
              'Dapatkan notifikasi audio baru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Kami kabari saat ada audio Hadi baru untuk didengarkan.',
              style: TextStyle(fontSize: 14, color: _kSubtle),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(backgroundColor: _kDark),
                child: const Text('Aktifkan'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Nanti saja'),
            ),
          ],
        ),
      ),
    );
  }
}
