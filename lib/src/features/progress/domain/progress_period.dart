/// Time period selection for the progress screen.
enum ProgressPeriod {
  sevenDays(7, '7 days'),
  thirtyDays(30, '30 days');

  const ProgressPeriod(this.days, this.label);

  final int days;
  final String label;
}
