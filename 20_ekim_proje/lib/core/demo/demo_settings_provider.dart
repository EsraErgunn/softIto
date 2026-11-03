// =============================================================================
// demo_settings_provider.dart - Demo (sunum/test) ayarları
// Uygulamada gerçek backend yok; veriler sahte (mock) depolardan gelir.
// Bu ayarlarla ağ gecikmesi ve hata durumları taklit edilerek yükleniyor/hata
// ekranları da denenebilir (Demo Paneli sayfasından değiştirilir).
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

// false yapılırsa /demo sayfası kapanır (router.dart'taki authGuard engeller).
const bool kDemoPanelEnabled = true;

class DemoSettings {
  const DemoSettings({
    // Her sahte isteğin bekleme süresi (varsayılan 0,6 sn).
    this.latency = const Duration(milliseconds: 600),
    // true ise depolar istek atıldığında hata fırlatır; hata ekranını test etmek için.
    this.simulateErrors = false,
  });

  final Duration latency;
  final bool simulateErrors;

  DemoSettings copyWith({
    Duration? latency,
    bool? simulateErrors,
  }) {
    return DemoSettings(
      latency: latency ?? this.latency,
      simulateErrors: simulateErrors ?? this.simulateErrors,
    );
  }
}

// Ayarları tutan Notifier; state'e yeni kopya atanınca dinleyen her yer güncellenir.
class DemoSettingsNotifier extends Notifier<DemoSettings> {
  @override
  DemoSettings build() => const DemoSettings();

  void setLatency(Duration latency) {
    state = state.copyWith(latency: latency);
  }

  void setSimulateErrors(bool simulateErrors) {
    state = state.copyWith(simulateErrors: simulateErrors);
  }
}

final demoSettingsProvider = NotifierProvider<DemoSettingsNotifier, DemoSettings>(
  DemoSettingsNotifier.new,
);
