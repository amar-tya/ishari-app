import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/core/wizard/wizard_state.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// Starts a reader's coach mark once, when the wizard is at [coachStep]:
/// either right after the first frame or when the wizard gets there later.
///
/// The latter needs a `BlocListener<WizardCubit, WizardState>` that forwards
/// to [onWizardState].
mixin WizardCoachTrigger<T extends StatefulWidget> on State<T> {
  bool _coachStarted = false;

  WizardStep get coachStep;

  void showCoach();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_claimCoach(context.read<WizardCubit>().state)) showCoach();
    });
  }

  void onWizardState(BuildContext _, WizardState state) {
    if (_claimCoach(state)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showCoach());
    }
  }

  bool _claimCoach(WizardState state) {
    if (_coachStarted || state is! WizardActive || state.step != coachStep) {
      return false;
    }
    _coachStarted = true;
    return true;
  }
}

/// A highlighted widget with a [_CoachTooltip] below it. Only the highlighted
/// area reacts to taps.
TargetFocus readerCoachTarget({
  required String identify,
  required GlobalKey keyTarget,
  required ShapeLightFocus shape,
  required String step,
  required String title,
  required String body,
  required String hint,
  double? radius,
}) {
  return TargetFocus(
    identify: identify,
    keyTarget: keyTarget,
    shape: shape,
    radius: radius,
    enableOverlayTab: false,
    enableTargetTab: true,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (_, _) =>
            _CoachTooltip(step: step, title: title, body: body, hint: hint),
      ),
    ],
  );
}

/// Shows [targets] over the reader. Skipping ends the whole [wizard].
void showReaderCoachMark(
  BuildContext context, {
  required WizardCubit wizard,
  required List<TargetFocus> targets,
  required VoidCallback onFinish,
}) {
  TutorialCoachMark(
    targets: targets,
    colorShadow: kReaderDark,
    opacityShadow: 0.88,
    onFinish: onFinish,
    onSkip: () {
      wizard.skip();
      return true;
    },
  ).show(context: context);
}

class _CoachTooltip extends StatelessWidget {
  const _CoachTooltip({
    required this.step,
    required this.title,
    required this.body,
    required this.hint,
  });

  final String step;
  final String title;
  final String body;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: kReaderLime,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  step,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: kReaderDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: kReaderDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF444444),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hint,
            style: const TextStyle(
              fontSize: 11,
              color: kReaderMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
