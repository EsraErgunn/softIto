import 'package:flutter_riverpod/flutter_riverpod.dart';

const bool kDemoPanelEnabled = true;

class DemoSettings {
  const DemoSettings({
    this.latency = const Duration(milliseconds: 600),
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
