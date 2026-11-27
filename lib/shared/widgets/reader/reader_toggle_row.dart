import 'package:flutter/material.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';

/// Switch row of the reader's display settings.
class ReaderToggleRow extends StatelessWidget {
  const ReaderToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.badge,
    super.key,
  });

  final String label;
  final String? subtitle;
  final String? badge;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kReaderBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kReaderDark,
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 6),
                      _Badge(badge!),
                    ],
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 1),
                  Text(
                    subtitle!,
                    style: const TextStyle(fontSize: 11, color: kReaderMuted),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: kReaderDark,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD0D8CE),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: kReaderLime,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: kReaderDark,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
