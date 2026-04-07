import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/muhud/domain/usecases/get_all_chapters.dart';
import 'package:ishari/features/muhud/domain/usecases/get_verses_by_chapter.dart';
import 'package:ishari/features/muhud/presentation/bloc/split_panel_cubit.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_detail/tatanan_detail_bloc.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_settings_cubit.dart';
import 'package:ishari/features/tatanan/presentation/widgets/tatanan_reader_body.dart';
import 'package:ishari/injection_container.dart';

class TatananDetailPage extends StatelessWidget {
  const TatananDetailPage({required this.tatananId, super.key});

  static const routePath = '/tatanan/:tatananId';

  final String tatananId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<TatananDetailBloc>()
            ..add(TatananDetailEvent.load(tatananId: tatananId)),
        ),
        BlocProvider(
          create: (_) => SplitPanelCubit(
            getAllChapters: sl<GetAllChapters>(),
            getVersesByChapter: sl<GetVersesByChapter>(),
          ),
        ),
        BlocProvider(create: (_) => TatananSettingsCubit()),
      ],
      child: TatananReaderBody(tatananId: tatananId),
    );
  }
}
