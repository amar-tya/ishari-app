import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Full-screen page shown when the current app version is below [minVersion].
///
/// The user cannot navigate away — back button and swipe are disabled.
class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({
    super.key,
    required this.storeUrl,
    required this.releaseNotes,
  });

  static const routePath = '/force-update';

  final String storeUrl;
  final String releaseNotes;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F5EE),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                const Icon(Icons.system_update_rounded, size: 72, color: Color(0xFF51C878)),
                const SizedBox(height: 32),
                const Text(
                  'Pembaruan Diperlukan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Versi aplikasi ini sudah tidak didukung.\nSilakan update untuk melanjutkan.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF777777), height: 1.5),
                  textAlign: TextAlign.center,
                ),
                if (releaseNotes.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Yang baru:',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Text(releaseNotes, style: const TextStyle(fontSize: 13, height: 1.6)),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => launchUrl(
                      Uri.parse(storeUrl),
                      mode: LaunchMode.externalApplication,
                    ),
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Update Sekarang'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
