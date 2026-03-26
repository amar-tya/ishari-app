import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChapterAppBar extends StatelessWidget {
  const ChapterAppBar({
    required this.isEmbeddedInTab,
    required this.onOpenQuickTools,
    this.title,
    this.showTitle = false,
    super.key,
  });

  final bool isEmbeddedInTab;
  final VoidCallback onOpenQuickTools;
  final String? title;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFFF0F5EE),
      child: Row(
        children: [
          if (!isEmbeddedInTab)
            _IconBtn(
              icon: Icons.arrow_back_ios_new,
              onTap: () => context.pop(),
            ),
          Expanded(
            child: AnimatedOpacity(
              opacity: showTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Text(
                title ?? '',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          _IconBtn(
            icon: Icons.tune_rounded,
            onTap: onOpenQuickTools,
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE2E8DF), width: 1.5),
        ),
        child: Icon(icon, color: const Color(0xFF111111), size: 18),
      ),
    );
  }
}
