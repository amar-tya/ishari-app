import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/core/router/app_router.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/core/wizard/wizard_state.dart';
import 'package:ishari/features/push_notification/presentation/notification_prompt.dart';

/// Offers notifications on the home page, whenever it is the page on screen and
/// the wizard tour is not running.
class HomeNotificationPrompt extends StatefulWidget {
  const HomeNotificationPrompt({
    required this.wizardReady,
    required this.child,
    super.key,
  });

  /// Completes once [WizardCubit] has loaded whether the tour has to run. Until
  /// then an inactive wizard could just as well be one about to start.
  final Future<void> wizardReady;

  final Widget child;

  @override
  State<HomeNotificationPrompt> createState() => _HomeNotificationPromptState();
}

class _HomeNotificationPromptState extends State<HomeNotificationPrompt>
    with RouteAware {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    unawaited(_offerWhenReady());
  }

  Future<void> _offerWhenReady() async {
    await widget.wizardReady;
    _ready = true;
    _offer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<void>) appRouteObserver.subscribe(this, route);
  }

  // Covers a tour that ended on a page pushed over this one.
  @override
  void didPopNext() => _offer();

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  /// Runs after the frame: [didPopNext] arrives while the navigator is still
  /// building.
  void _offer() {
    if (!_ready || !mounted) return;
    WidgetsBinding.instance
      ..addPostFrameCallback((_) {
        if (!mounted) return;
        final wizard = context.read<WizardCubit>();
        unawaited(
          offerNotificationPrompt(
            context,
            isAllowed: () => wizard.state is! WizardActive,
          ),
        );
      })
      // The app may be idle, with no frame on the way.
      ..ensureVisualUpdate();
  }

  @override
  Widget build(BuildContext context) {
    // Covers a tour that ends while home is on screen.
    return BlocListener<WizardCubit, WizardState>(
      listenWhen: (_, state) => state is WizardDone,
      listener: (_, _) => _offer(),
      child: widget.child,
    );
  }
}
