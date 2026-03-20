import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF51C878), Color(0xFF45B868)],
        ),
      ),
      child: Row(
        children: [
          if (!isEmbeddedInTab)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          Expanded(
            child: AnimatedOpacity(
              opacity: showTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Text(
                title ?? '',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Quick Tools',
            icon: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
            ),
            onPressed: onOpenQuickTools,
          ),
        ],
      ),
    );
  }
}
