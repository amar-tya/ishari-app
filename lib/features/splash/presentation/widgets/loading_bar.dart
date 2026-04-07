import 'package:flutter/material.dart';

/// Static horizontal loading bar shown at the bottom of the splash screen.
class LoadingBarWidget extends StatelessWidget {
  const LoadingBarWidget({super.key});

  static const _primaryDim = Color(0xFFA8D900);
  static const _mutedLight = Color(0xFFAAAAAA);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFF111111).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.6,
              child: Container(
                decoration: BoxDecoration(
                  color: _primaryDim,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Memuat konten…',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: _mutedLight,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
