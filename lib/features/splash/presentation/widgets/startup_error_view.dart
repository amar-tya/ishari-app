import 'package:flutter/material.dart';

/// Shown instead of the splash when startup failed or took too long.
///
/// It must not depend on anything startup sets up (DI, Supabase, Firebase).
class StartupErrorView extends StatelessWidget {
  const StartupErrorView({required this.onRetry, super.key});

  final VoidCallback onRetry;

  static const _bg = Color(0xFFF0F5EE);
  static const _dark = Color(0xFF111111);
  static const _lime = Color(0xFFCAFF00);
  static const _muted = Color(0xFF777777);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: _muted),
                const SizedBox(height: 16),
                const Text(
                  'Gagal memulai aplikasi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Periksa koneksi internet, lalu coba lagi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _dark,
                    foregroundColor: _lime,
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
