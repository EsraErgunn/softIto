// =============================================================================
// date_resolver.dart - Sahte verilerdeki göreceli tarihleri gerçek tarihe çevirir
// Mock JSON'larda sabit tarih yerine "deadlineInDays: 10" veya "createdMinutesAgo: 30"
// yazılır; böylece demo veriler her gün güncel görünür.
// =============================================================================

Map<String, dynamic> resolveRelativeDates(Map<String, dynamic> json, DateTime now) {
  // Orijinal Map değiştirilmesin diye spread (...) ile kopyası alınır.
  final copy = {...json};
  // Dart 3 "if-case" deseni: remove alanı silip değerini döner; değer int ise
  // "days" değişkenine bağlanır ve blok çalışır, değilse (null) atlanır.
  if (copy.remove('deadlineInDays') case final int days) {
    copy['deadline'] = DateTime(now.year, now.month, now.day + days).toIso8601String();
  }
  if (copy.remove('createdMinutesAgo') case final int mins) {
    copy['createdAt'] = now.subtract(Duration(minutes: mins)).toIso8601String();
  }
  return copy;
}
