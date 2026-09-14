/// Jedno konkretne, mierzalne wymaganie celu głównego aktu albo questa
/// pobocznego - pokazywane w zakładce Cele z aktualnym postępem, nie tylko
/// jako statyczny opis tekstowy. [progress] jest opcjonalny: część wymagań
/// jest czysto zero-jedynkowa (np. "Ratusz zbudowany") i nie ma naturalnego
/// licznika do pokazania.
class GoalRequirement {
  final String label;
  final bool met;
  final String? progress;

  const GoalRequirement({required this.label, required this.met, this.progress});
}
