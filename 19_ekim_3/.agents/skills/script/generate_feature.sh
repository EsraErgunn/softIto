#!/usr/bin/env bash
# ==============================================================================
# Susadım - Flutter Feature Scaffold Üretici Scripti
# ------------------------------------------------------------------------------
# Bu script, "project.md" ve "SKILL.md" standartlarına uygun olarak yeni bir özellik
# (feature) iskeletini eksiksiz, const kurallarına ve ValueNotifier mimarisine uygun
# biçimde üretir.
#
# Kullanım:
#   ./generate_feature.sh <feature_name>
#   Örnek: ./generate_feature.sh water_tracker
# ==============================================================================

set -euo pipefail

# Renk Kodları
readonly COLOR_RESET="\033[0m"
readonly COLOR_GREEN="\033[1;32m"
readonly COLOR_BLUE="\033[1;34m"
readonly COLOR_YELLOW="\033[1;33m"
readonly COLOR_RED="\033[1;31m"
readonly COLOR_CYAN="\033[1;36m"

# Yardım Mesajı
show_help() {
  cat << EOF
Susadım - Flutter Feature Scaffold Üretici

Kullanım:
  ./generate_feature.sh [seçenekler] <özellik_adı>

Argümanlar:
  <özellik_adı>        Oluşturulacak özelliğin snake_case adı (Örn: water_tracker, workout, achievement)

Seçenekler:
  -h, --help           Bu yardım kılavuzunu görüntüler.
  -f, --force          Var olan dosyaların üzerine zorla yazar.

Örnekler:
  ./generate_feature.sh water_tracker
  ./generate_feature.sh workout
  ./generate_feature.sh achievement
EOF
}

# Parametre Kontrolü
FORCE_OVERWRITE=false
FEATURE_NAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_help
      exit 0
      ;;
    -f|--force)
      FORCE_OVERWRITE=true
      shift
      ;;
    *)
      if [[ -z "$FEATURE_NAME" ]]; then
        FEATURE_NAME="$1"
      else
        echo -e "${COLOR_RED}Hata: Bilinmeyen veya fazla argüman '$1'${COLOR_RESET}" >&2
        show_help
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ -z "$FEATURE_NAME" ]]; then
  echo -e "${COLOR_RED}Hata: Özellik adı (feature name) belirtilmedi!${COLOR_RESET}" >&2
  show_help
  exit 1
fi

# snake_case doğrulama
if [[ ! "$FEATURE_NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo -e "${COLOR_RED}Hata: Özellik adı küçük harf ve alt çizgi ile snake_case formatında olmalıdır! (Örn: water_tracker)${COLOR_RESET}" >&2
  exit 1
fi

# İsim Dönüşümleri (snake_case -> PascalCase ve Title Case)
PASCAL_NAME=$(echo "$FEATURE_NAME" | awk -F'_' '{for(i=1;i<=NF;i++) printf "%s", toupper(substr($i,1,1)) tolower(substr($i,2))}')
TITLE_NAME=$(echo "$FEATURE_NAME" | awk -F'_' '{for(i=1;i<=NF;i++) printf "%s%s", toupper(substr($i,1,1)) tolower(substr($i,2)), (i==NF?"":" ")}')

# Proje Kök Dizinini Bulma
ROOT_DIR="$(pwd)"
if [[ ! -f "$ROOT_DIR/pubspec.yaml" ]]; then
  # Bir üst dizinleri veya .agents'ın bulunduğu üst dizini kontrol et
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  CANDIDATE_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
  if [[ -f "$CANDIDATE_DIR/pubspec.yaml" ]]; then
    ROOT_DIR="$CANDIDATE_DIR"
  fi
fi

FEATURE_DIR="$ROOT_DIR/lib/features/$FEATURE_NAME"
TEST_DIR="$ROOT_DIR/test/features/$FEATURE_NAME"

echo -e "${COLOR_CYAN}======================================================${COLOR_RESET}"
echo -e "${COLOR_CYAN}  Susadım Feature Scaffold: ${COLOR_GREEN}${FEATURE_NAME}${COLOR_CYAN} (${PASCAL_NAME})${COLOR_RESET}"
echo -e "${COLOR_CYAN}======================================================${COLOR_RESET}"

# Klasörleri Oluştur
mkdir -p "$FEATURE_DIR/controller"
mkdir -p "$FEATURE_DIR/models"
mkdir -p "$FEATURE_DIR/view"
mkdir -p "$FEATURE_DIR/widget"
mkdir -p "$TEST_DIR"

MODEL_FILE="$FEATURE_DIR/models/${FEATURE_NAME}_model.dart"
CONTROLLER_FILE="$FEATURE_DIR/controller/${FEATURE_NAME}_controller.dart"
WIDGET_FILE="$FEATURE_DIR/widget/${FEATURE_NAME}_card.dart"
VIEW_FILE="$FEATURE_DIR/view/${FEATURE_NAME}_view.dart"
TEST_FILE="$TEST_DIR/${FEATURE_NAME}_controller_test.dart"

check_file_exists() {
  local target="$1"
  if [[ -f "$target" && "$FORCE_OVERWRITE" != true ]]; then
    echo -e "${COLOR_YELLOW}Uyarı: '$target' zaten mevcut. Üzerine yazmak için --force kullanın.${COLOR_RESET}"
    return 1
  fi
  return 0
}

# 1. Model Dosyasını Üret
if check_file_exists "$MODEL_FILE"; then
  cat << EOF > "$MODEL_FILE"
import 'package:flutter/foundation.dart';

/// [$PASCAL_NAME] veri modelidir.
/// 'project.md' kuralları gereği değişmez (immutable) yapıda tasarlanmıştır.
@immutable
class ${PASCAL_NAME}Model {
  final String id;
  final String title;
  final int currentValue;
  final int targetValue;
  final bool isCompleted;
  final DateTime updatedAt;

  const ${PASCAL_NAME}Model({
    required this.id,
    required this.title,
    required this.currentValue,
    required this.targetValue,
    required this.isCompleted,
    required this.updatedAt,
  });

  /// Başlangıç varsayılan durumu
  factory ${PASCAL_NAME}Model.initial() {
    return ${PASCAL_NAME}Model(
      id: 'default_${FEATURE_NAME}',
      title: '$TITLE_NAME',
      currentValue: 0,
      targetValue: 100,
      isCompleted: false,
      updatedAt: DateTime.now(),
    );
  }

  /// İmmutable kopyalama metodu
  ${PASCAL_NAME}Model copyWith({
    String? id,
    String? title,
    int? currentValue,
    int? targetValue,
    bool? isCompleted,
    DateTime? updatedAt,
  }) {
    return ${PASCAL_NAME}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue ?? this.targetValue,
      isCompleted: isCompleted ?? this.isCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// JSON serileştirme
  factory ${PASCAL_NAME}Model.fromJson(Map<String, dynamic> json) {
    return ${PASCAL_NAME}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      currentValue: json['currentValue'] as int? ?? 0,
      targetValue: json['targetValue'] as int? ?? 100,
      isCompleted: json['isCompleted'] as bool? ?? false,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'currentValue': currentValue,
      'targetValue': targetValue,
      'isCompleted': isCompleted,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ${PASCAL_NAME}Model &&
        other.id == id &&
        other.title == title &&
        other.currentValue == currentValue &&
        other.targetValue == targetValue &&
        other.isCompleted == isCompleted &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        currentValue,
        targetValue,
        isCompleted,
        updatedAt,
      );
}
EOF
  echo -e "  ${COLOR_GREEN}✓ Oluşturuldu:${COLOR_RESET} lib/features/$FEATURE_NAME/models/${FEATURE_NAME}_model.dart"
fi

# 2. Controller Dosyasını Üret
if check_file_exists "$CONTROLLER_FILE"; then
  cat << EOF > "$CONTROLLER_FILE"
import 'package:flutter/foundation.dart';
import '../models/${FEATURE_NAME}_model.dart';

/// [$PASCAL_NAME] iş mantığını ve durumunu yöneten Controller sınıfıdır.
/// Harici ağır state paketleri yerine yerel 'ValueNotifier' kullanır.
class ${PASCAL_NAME}Controller {
  final ValueNotifier<${PASCAL_NAME}Model> state =
      ValueNotifier<${PASCAL_NAME}Model>(${PASCAL_NAME}Model.initial());

  ${PASCAL_NAME}Model get current => state.value;

  /// Değer artırma veya güncelleme aksiyonu
  void incrementValue(int amount) {
    if (amount <= 0) return;
    final newValue = current.currentValue + amount;
    final isDone = newValue >= current.targetValue;

    state.value = current.copyWith(
      currentValue: newValue,
      isCompleted: isDone,
      updatedAt: DateTime.now(),
    );
  }

  /// Tamamlanma durumunu değiştirme
  void toggleCompleted() {
    state.value = current.copyWith(
      isCompleted: !current.isCompleted,
      updatedAt: DateTime.now(),
    );
  }

  /// Durumu sıfırlama aksiyonu
  void reset() {
    state.value = current.copyWith(
      currentValue: 0,
      isCompleted: false,
      updatedAt: DateTime.now(),
    );
  }

  /// Bellek sızıntılarını önlemek için dinleyicileri temizler
  void dispose() {
    state.dispose();
  }
}
EOF
  echo -e "  ${COLOR_GREEN}✓ Oluşturuldu:${COLOR_RESET} lib/features/$FEATURE_NAME/controller/${FEATURE_NAME}_controller.dart"
fi

# 3. Widget Dosyasını Üret (40 satır altı kuralına uygun)
if check_file_exists "$WIDGET_FILE"; then
  cat << EOF > "$WIDGET_FILE"
import 'package:flutter/material.dart';
import '../models/${FEATURE_NAME}_model.dart';

/// [$PASCAL_NAME] modülünün atomik kart bileşenidir.
/// 'const' constructor ve Material 3 tema entegrasyonu içerir.
class ${PASCAL_NAME}Card extends StatelessWidget {
  final ${PASCAL_NAME}Model data;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  const ${PASCAL_NAME}Card({
    super.key,
    required this.data,
    required this.onIncrement,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun kompakt ve modüler build
    final theme = Theme.of(context);
    final progress = (data.currentValue / (data.targetValue > 0 ? data.targetValue : 1))
        .clamp(0.0, 1.0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  data.isCompleted ? Icons.check_circle : Icons.timelapse,
                  color: data.isCompleted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              borderRadius: BorderRadius.circular(8),
              minHeight: 8,
            ),
            const SizedBox(height: 12),
            Text(
              '\${data.currentValue} / \${data.targetValue}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onReset,
                  child: const Text('Sıfırla'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: onIncrement,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Ekle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
EOF
  echo -e "  ${COLOR_GREEN}✓ Oluşturuldu:${COLOR_RESET} lib/features/$FEATURE_NAME/widget/${FEATURE_NAME}_card.dart"
fi

# 4. View Dosyasını Üret (Build metodu < 40 satır)
if check_file_exists "$VIEW_FILE"; then
  cat << EOF > "$VIEW_FILE"
import 'package:flutter/material.dart';
import '../controller/${FEATURE_NAME}_controller.dart';
import '../models/${FEATURE_NAME}_model.dart';
import '../widget/${FEATURE_NAME}_card.dart';

/// [$PASCAL_NAME] ana ekran görünümüdür.
/// Sayfa düzeyinde ağır setState yasaktır; ValueListenableBuilder kullanılır.
class ${PASCAL_NAME}View extends StatefulWidget {
  const ${PASCAL_NAME}View({super.key});

  @override
  State<${PASCAL_NAME}View> createState() => _${PASCAL_NAME}ViewState();
}

class _${PASCAL_NAME}ViewState extends State<${PASCAL_NAME}View> {
  late final ${PASCAL_NAME}Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = ${PASCAL_NAME}Controller();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 40 satırı geçmeyen sade ve okunabilir Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('$TITLE_NAME'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ValueListenableBuilder<${PASCAL_NAME}Model>(
          valueListenable: _controller.state,
          builder: (context, data, _) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ${PASCAL_NAME}Card(
                  data: data,
                  onIncrement: () => _controller.incrementValue(10),
                  onReset: _controller.reset,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
EOF
  echo -e "  ${COLOR_GREEN}✓ Oluşturuldu:${COLOR_RESET} lib/features/$FEATURE_NAME/view/${FEATURE_NAME}_view.dart"
fi

# 5. Controller Birim Test Dosyasını Üret
if check_file_exists "$TEST_FILE"; then
  cat << EOF > "$TEST_FILE"
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/${FEATURE_NAME}/controller/${FEATURE_NAME}_controller.dart';

void main() {
  group('$PASCAL_NAME Controller Testleri', () {
    late ${PASCAL_NAME}Controller controller;

    setUp(() {
      controller = ${PASCAL_NAME}Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç durumu varsayılan değerlerle açılmalıdır', () {
      expect(controller.current.currentValue, 0);
      expect(controller.current.isCompleted, false);
      expect(controller.current.targetValue, 100);
    });

    test('incrementValue değeri artırmalı ve hedef aşılınca tamamlandı olmalıdır', () {
      controller.incrementValue(50);
      expect(controller.current.currentValue, 50);
      expect(controller.current.isCompleted, false);

      controller.incrementValue(60);
      expect(controller.current.currentValue, 110);
      expect(controller.current.isCompleted, true);
    });

    test('reset metodu değeri sıfırlamalıdır', () {
      controller.incrementValue(30);
      controller.reset();
      expect(controller.current.currentValue, 0);
      expect(controller.current.isCompleted, false);
    });
  });
}
EOF
  echo -e "  ${COLOR_GREEN}✓ Oluşturuldu:${COLOR_RESET} test/features/$FEATURE_NAME/${FEATURE_NAME}_controller_test.dart"
fi

echo -e "\n${COLOR_GREEN}✔ Özellik başarıyla oluşturuldu!${COLOR_RESET}"
echo -e "${COLOR_BLUE}Doğrulama Adımları:${COLOR_RESET}"
echo -e "  1. Statik kod analizi : ${COLOR_YELLOW}flutter analyze${COLOR_RESET}"
echo -e "  2. Birim testleri     : ${COLOR_YELLOW}flutter test test/features/$FEATURE_NAME/${COLOR_RESET}"
echo -e "${COLOR_CYAN}======================================================${COLOR_RESET}"
