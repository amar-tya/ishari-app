enum WizardStep {
  muhudSplit,
  muhudAudio,
  tabBeranda,
  tabCari,
  tabKitab,
  tabBookmark,
  tabTatanan,
  tatananCreate,
  tatananDetail,
}

sealed class WizardState {
  const WizardState();
}

final class WizardInactive extends WizardState {
  const WizardInactive();
}

final class WizardActive extends WizardState {
  const WizardActive(this.step);
  final WizardStep step;
}

final class WizardDone extends WizardState {
  const WizardDone();
}
