import 'dart:async';

import 'package:flutter/material.dart';

/// Animated three-dot loading indicator.
///
/// Cycles an active "pill" dot through all three positions every 600 ms.
class LoadingDotsWidget extends StatefulWidget {
  const LoadingDotsWidget({super.key});

  @override
  State<LoadingDotsWidget> createState() => _LoadingDotsWidgetState();
}

class _LoadingDotsWidgetState extends State<LoadingDotsWidget> {
  static const _primary = Color(0xFF51C878);
  static const _inactive = Color(0xFFC8E6C9);

  int _activeIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 600), (_) {
      if (!mounted) return;
      setState(() => _activeIndex = (_activeIndex + 1) % 3);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final isActive = i == _activeIndex;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: isActive ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? _primary : _inactive,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
