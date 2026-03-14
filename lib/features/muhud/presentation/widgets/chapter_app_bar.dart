import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';

class ChapterAppBar extends StatelessWidget {
  const ChapterAppBar({
    required this.chapter,
    required this.showTranslation,
    super.key,
  });

  final ChapterEntity chapter;
  final bool showTranslation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE8EAE9)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1C1B1F)),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1B1F),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (chapter.category.isNotEmpty)
                  Text(
                    chapter.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF79747E),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: showTranslation ? 'Sembunyikan terjemahan' : 'Tampilkan terjemahan',
            icon: Icon(
              showTranslation ? Icons.translate : Icons.translate_outlined,
              color: showTranslation ? const Color(0xFF51C878) : const Color(0xFF79747E),
            ),
            onPressed: () =>
                context.read<MuhudBloc>().add(const MuhudEvent.toggleTranslation()),
          ),
        ],
      ),
    );
  }
}
