Map<String, dynamic> resolveRelativeDates(Map<String, dynamic> json, DateTime now) {
  final copy = {...json};
  if (copy.remove('deadlineInDays') case final int days) {
    copy['deadline'] = DateTime(now.year, now.month, now.day + days).toIso8601String();
  }
  if (copy.remove('createdMinutesAgo') case final int mins) {
    copy['createdAt'] = now.subtract(Duration(minutes: mins)).toIso8601String();
  }
  return copy;
}
