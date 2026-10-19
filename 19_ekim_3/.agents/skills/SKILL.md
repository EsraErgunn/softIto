---
name: flutter-feature-scaffold
description: Flutter projelerinde feature bazlı modüler yapı kurmak için klasör iskeletini, ValueNotifier reaktif durum mimarisini ve birim testlerini standartlara uygun olarak üretir.
---

# Flutter Feature Scaffold (Modüler Ekran İskeleti)

Bu yetenek (skill), **Susadım** projesinde yeni bir ekran veya işlev modülü eklerken Clean UI, 40 satır altı `build` kuralı ve reaktif `ValueNotifier` mimarisini garanti altına almak için tasarlanmıştır.

---

## 1. Temel Prensipler

1. **Asla Tek Dosyada Toplama:**
   - Sayfa arayüzü (`view/<feature_name>_view.dart`)
   - Durum denetleyicisi (`controller/<feature_name>_controller.dart`)
   - Veri modeli (`models/<feature_name>_model.dart`)
   - Atomik bileşenler (`widget/<feature_name>_card.dart`)
   kesinlikle ayrı klasörlerde ve bağımsız dosyalarda olmalıdır.
2. **Reaktif State Yönetimi (`ValueNotifier`):**
   - Sayfa düzeyinde ağır `setState` kesinlikle yasaktır.
   - Durum `ValueNotifier<T>` ile yönetilir ve arayüzde sadece değişen parçalar `ValueListenableBuilder` ile dinlenir.
3. **Const Zorunluluğu:**
   - Statik tüm widget'lar `const` anahtar kelimesi ile işaretlenmelidir.
4. **40 Satır Kuralı:**
   - 40 satırı geçen `build` metotları yasaktır. Arayüz mantıksal alt widget'lara bölünmelidir.
5. **Tema Uyumu:**
   - Renk ve tipografi doğrudan `Theme.of(context)` üzerinden alınır; widget içine hardcoded renk yazılamaz.

---

## 2. Klasör ve Dosya Yapısı

Bir özellik oluşturulurken aşağıdaki standart yapı takip edilir:

```text
lib/features/<feature_name>/
├── controller/
│   └── <feature_name>_controller.dart
├── models/
│   └── <feature_name>_model.dart
├── view/
│   └── <feature_name>_view.dart
└── widget/
    └── <feature_name>_card.dart
```

Birim testleri ise şu yolda konumlandırılır:
```text
test/features/<feature_name>/
└── <feature_name>_controller_test.dart
```

---

## 3. Otomatik Üretim Scripti

Tüm bu yapıyı, modelleri, controller'ı, widget'ı, view'ı ve birim testini tek komutla standartlara uygun üretmek için hazır script kullanılır:

- **Script Dosyası:** [.agents/skills/script/generate_feature.sh](file:///Users/d1-13/Documents/GitHub/softIto/19_ekim_3/.agents/skills/script/generate_feature.sh)

### Çalıştırma Örneği:
```bash
# Yetki ver (gerekliyse):
chmod +x .agents/skills/script/generate_feature.sh

# Özelliği oluştur:
.agents/skills/script/generate_feature.sh water_tracker
```

---

## 4. Adım Adım Kod Standartları

### Adım 1: Model Dosyası (`models/<feature_name>_model.dart`)
Model sınıfları değişmez (`@immutable`) olmalı; `const` constructor, `copyWith`, `fromJson` ve `toJson` metotlarını barındırmalıdır:

```dart
import 'package:flutter/foundation.dart';

@immutable
class WaterTrackerModel {
  final int currentWaterMl;
  final int dailyGoalMl;
  final bool isGoalAchieved;

  const WaterTrackerModel({
    required this.currentWaterMl,
    required this.dailyGoalMl,
    required this.isGoalAchieved,
  });

  factory WaterTrackerModel.initial() {
    return const WaterTrackerModel(
      currentWaterMl: 0,
      dailyGoalMl: 2000,
      isGoalAchieved: false,
    );
  }

  WaterTrackerModel copyWith({
    int? currentWaterMl,
    int? dailyGoalMl,
    bool? isGoalAchieved,
  }) {
    return WaterTrackerModel(
      currentWaterMl: currentWaterMl ?? this.currentWaterMl,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      isGoalAchieved: isGoalAchieved ?? this.isGoalAchieved,
    );
  }

  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackerModel(
      currentWaterMl: json['currentWaterMl'] as int? ?? 0,
      dailyGoalMl: json['dailyGoalMl'] as int? ?? 2000,
      isGoalAchieved: json['isGoalAchieved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentWaterMl': currentWaterMl,
      'dailyGoalMl': dailyGoalMl,
      'isGoalAchieved': isGoalAchieved,
    };
  }
}
```

### Adım 2: Controller Dosyası (`controller/<feature_name>_controller.dart`)
İş mantığı `ValueNotifier` etrafında kapsüllenir ve `dispose()` metodu sunar:

```dart
import 'package:flutter/foundation.dart';
import '../models/water_tracker_model.dart';

class WaterTrackerController {
  final ValueNotifier<WaterTrackerModel> state =
      ValueNotifier<WaterTrackerModel>(WaterTrackerModel.initial());

  WaterTrackerModel get current => state.value;

  void addWater(int amountMl) {
    if (amountMl <= 0) return;
    final newAmount = current.currentWaterMl + amountMl;
    state.value = current.copyWith(
      currentWaterMl: newAmount,
      isGoalAchieved: newAmount >= current.dailyGoalMl,
    );
  }

  void resetWater() {
    state.value = current.copyWith(
      currentWaterMl: 0,
      isGoalAchieved: false,
    );
  }

  void dispose() {
    state.dispose();
  }
}
```

### Adım 3: Widget Dosyası (`widget/<feature_name>_card.dart`)
Tek bir sorumluluğa sahip, Material 3 tema renklerini kullanan ve 40 satırın altındaki modüler bileşen:

```dart
import 'package:flutter/material.dart';
import '../models/water_tracker_model.dart';

class WaterTrackerCard extends StatelessWidget {
  final WaterTrackerModel data;
  final VoidCallback onAddWater;
  final VoidCallback onReset;

  const WaterTrackerCard({
    super.key,
    required this.data,
    required this.onAddWater,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = (data.currentWaterMl / (data.dailyGoalMl > 0 ? data.dailyGoalMl : 1))
        .clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${data.currentWaterMl} / ${data.dailyGoalMl} ml',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: ratio),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onReset, child: const Text('Sıfırla')),
                const SizedBox(width: 8),
                FilledButton(onPressed: onAddWater, child: const Text('+250 ml')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### Adım 4: View Dosyası (`view/<feature_name>_view.dart`)
Scaffold ve sayfa iskeletini kurar; `ValueListenableBuilder` ile dinleme yapar; `build` metodu 40 satırın altındadır:

```dart
import 'package:flutter/material.dart';
import '../controller/water_tracker_controller.dart';
import '../models/water_tracker_model.dart';
import '../widget/water_tracker_card.dart';

class WaterTrackerView extends StatefulWidget {
  const WaterTrackerView({super.key});

  @override
  State<WaterTrackerView> createState() => _WaterTrackerViewState();
}

class _WaterTrackerViewState extends State<WaterTrackerView> {
  late final WaterTrackerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WaterTrackerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Su Takibi')),
      body: SafeArea(
        child: ValueListenableBuilder<WaterTrackerModel>(
          valueListenable: _controller.state,
          builder: (context, data, _) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                WaterTrackerCard(
                  data: data,
                  onAddWater: () => _controller.addWater(250),
                  onReset: _controller.resetWater,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

---

## 5. Referans ve Örnek Kaynaklar

- **Detaylı Mimari ve Durum Akışı:** [.agents/skills/references/state_flow.md](file:///Users/d1-13/Documents/GitHub/softIto/19_ekim_3/.agents/skills/references/state_flow.md)
- **Kapsamlı Örnek Ekran Kodu:** [.agents/skills/examples/sample_screen.dart](file:///Users/d1-13/Documents/GitHub/softIto/19_ekim_3/.agents/skills/examples/sample_screen.dart)
- **Proje Kuralları ve Kırmızı Çizgiler:** [.agents/project.md](file:///Users/d1-13/Documents/GitHub/softIto/19_ekim_3/.agents/project.md)

---

## 6. Sıkça Sorulan Sorular (SSS)

### Soru: Hangi durumlarda bu yeteneği kullanmalıyım?
**Cevap:** Yeni bir ekran veya işlevsel modül (su takibi, egzersiz, haftalık rozet/ödül vb.) oluştururken bu yeteneği kullanmalısın.

### Soru: Bu yeteneği ne zaman kullanmamalıyım?
**Cevap:** Mevcut bir ekranda yalnızca metin, ufak bir stil veya tek satırlık bir hata düzeltmesi yaparken tüm feature iskeletini yeniden çalıştırmamalısın.