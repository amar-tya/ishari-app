import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_list/tatanan_list_bloc.dart';
import 'package:ishari/features/tatanan/presentation/pages/tatanan_list_page.dart';
import 'package:ishari/injection_container.dart';

/// Tatanan tab — wraps [TatananListBloc] and builds the full list page.
///
/// Guest users should never see this page (gated at [MainScaffold] level).
class TatananTab extends StatelessWidget {
  const TatananTab({required this.isActive, super.key});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().state.maybeWhen(
          authenticated: (user) => user.id,
          orElse: () => '',
        );

    return BlocProvider(
      create: (_) {
        final bloc = sl<TatananListBloc>();
        if (userId.isNotEmpty) {
          bloc.add(TatananListEvent.load(userId: userId));
        }
        return bloc;
      },
      child: _TatananTabBody(isActive: isActive, userId: userId),
    );
  }
}

class _TatananTabBody extends StatefulWidget {
  const _TatananTabBody({required this.isActive, required this.userId});

  final bool isActive;
  final String userId;

  @override
  State<_TatananTabBody> createState() => _TatananTabBodyState();
}

class _TatananTabBodyState extends State<_TatananTabBody> {
  @override
  void didUpdateWidget(_TatananTabBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload when tab becomes active
    if (widget.isActive && !oldWidget.isActive && widget.userId.isNotEmpty) {
      context
          .read<TatananListBloc>()
          .add(TatananListEvent.load(userId: widget.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TatananListPage(userId: widget.userId);
  }
}
