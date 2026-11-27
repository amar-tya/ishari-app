import 'package:flutter/material.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';

/// Full screen shown when the tatanan cannot be loaded.
class TatananErrorView extends StatelessWidget {
  const TatananErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kReaderBackground,
      appBar: AppBar(
        backgroundColor: kReaderBackground,
        elevation: 0,
        leading: const BackButton(color: kReaderDark),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_outlined,
                size: 48,
                color: Color(0xFF79747E),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF79747E)),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: FilledButton.styleFrom(
                  backgroundColor: kReaderDark,
                  foregroundColor: kReaderLime,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
