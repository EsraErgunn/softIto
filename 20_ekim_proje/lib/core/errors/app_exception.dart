// =============================================================================
// app_exception.dart - Uygulamaya özel hata sınıfı
// Kullanıcıya gösterilecek anlaşılır bir mesaj (message) ve isteğe bağlı asıl
// hata nedeni (cause) taşır. Exception'ı implements ettiği için throw edilebilir.
// =============================================================================

class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  // Hata ekrana yazdırılırken sadece okunabilir mesaj görünür.
  String toString() => message;
}
