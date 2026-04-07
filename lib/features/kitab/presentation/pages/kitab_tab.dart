import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/kitab/presentation/bloc/kitab_bloc.dart';
import 'package:ishari/features/kitab/presentation/pages/kitab_page.dart';
import 'package:ishari/injection_container.dart';

class KitabTab extends StatelessWidget {
  const KitabTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<KitabBloc>()..add(const KitabEvent.load()),
      child: const KitabPage(),
    );
  }
}
