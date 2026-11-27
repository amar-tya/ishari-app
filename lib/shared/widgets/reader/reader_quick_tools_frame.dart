import 'package:flutter/material.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';

/// "Quick Tools" side panel (from the right) over a scrim. Must be laid out
/// inside the reader's `Stack`.
class ReaderQuickToolsFrame extends StatelessWidget {
  const ReaderQuickToolsFrame({
    required this.onClose,
    required this.child,
    super.key,
  });

  final VoidCallback onClose;

  /// Panel content below the header; gets the remaining height.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark scrim — tapping closes the panel
        GestureDetector(
          onTap: onClose,
          child: const ColoredBox(
            color: Color(0x80000000),
            child: SizedBox.expand(),
          ),
        ),
        // Panel — absorbs taps so they don't reach the scrim
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.82,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(onClose: onClose),
                    const Divider(height: 1, color: kReaderBorder),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      child: Row(
        children: [
          // Close button
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: kReaderBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 14,
                color: kReaderMuted,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Quick Tools',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: kReaderDark,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}
