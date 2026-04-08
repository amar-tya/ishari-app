import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shown when a newer (non-mandatory) version is available.
///
/// User can dismiss with "Nanti" or go to the store with "Update Sekarang".
class SoftUpdateDialog extends StatelessWidget {
  const SoftUpdateDialog({
    super.key,
    required this.latestVersion,
    required this.storeUrl,
    required this.releaseNotes,
  });

  final String latestVersion;
  final String storeUrl;
  final String releaseNotes;

  static Future<void> show(
    BuildContext context, {
    required String latestVersion,
    required String storeUrl,
    required String releaseNotes,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => SoftUpdateDialog(
        latestVersion: latestVersion,
        storeUrl: storeUrl,
        releaseNotes: releaseNotes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ada Versi Terbaru!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(
            'v$latestVersion tersedia',
            style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.normal),
          ),
        ],
      ),
      content: releaseNotes.isNotEmpty
          ? Text(releaseNotes, style: const TextStyle(fontSize: 14))
          : null,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Nanti'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            launchUrl(Uri.parse(storeUrl), mode: LaunchMode.externalApplication);
          },
          child: const Text('Update Sekarang'),
        ),
      ],
    );
  }
}
