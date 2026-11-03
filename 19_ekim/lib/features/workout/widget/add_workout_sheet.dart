// =============================================================================
// add_workout_sheet.dart - Özel antrenman ekleme formu (alttan açılan panel)
// Kullanıcı ad, süre ve kalori girer; geçerliyse onAdd çağrılır ve panel kapanır.
// =============================================================================

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// TextEditingController'ları tutup dispose etmek gerektiği için StatefulWidget.
class AddWorkoutSheet extends StatefulWidget {
  final void Function(String title, int duration, int calories) onAdd;

  const AddWorkoutSheet({super.key, required this.onAdd});

  // Kolay kullanım için statik yardımcı: AddWorkoutSheet.show(context, onAdd: ...)
  static Future<void> show(
    BuildContext context, {
    required void Function(String title, int duration, int calories) onAdd,
  }) {
    return showModalBottomSheet(
      context: context,
      // Panelin klavye açılınca yukarı kayabilmesi ve gerektiği kadar uzayabilmesi için şart.
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddWorkoutSheet(onAdd: onAdd),
    );
  }

  @override
  State<AddWorkoutSheet> createState() => _AddWorkoutSheetState();
}

class _AddWorkoutSheetState extends State<AddWorkoutSheet> {
  // Her TextField'ın metnini okumak için ayrı controller.
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();

  @override
  // Controller'lar bellek tutar; panel kapanınca mutlaka dispose edilmeli.
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  // Formu doğrular ve kaydeder.
  void _submit() {
    final title = _titleController.text.trim();
    // tryParse: metin sayıya çevrilemezse hata fırlatmak yerine null döner; "?? 0" ile 0 yapılır.
    final duration = int.tryParse(_durationController.text.trim()) ?? 0;
    final calories = int.tryParse(_caloriesController.text.trim()) ?? 0;

    // Sadece tüm alanlar geçerliyse kayıt yapılır, aksi halde panel açık kalır.
    if (title.isNotEmpty && duration > 0 && calories > 0) {
      widget.onAdd(title, duration, calories);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Klavyenin yüksekliği. Alt boşluğa eklenerek form klavyenin altında kalmaz.
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SheetHeader(onClose: () => Navigator.of(context).pop()),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Antrenman Adı',
              hintText: 'Örn: Bacak Günü, Yüzme',
            ),
          ),
          const SizedBox(height: 12),
          _InputsRow(durationController: _durationController, caloriesController: _caloriesController),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonLime),
            child: const Text('Antrenmanı Kaydet'),
          ),
        ],
      ),
    );
  }
}

// Panel başlığı ve kapatma (X) butonu.
class _SheetHeader extends StatelessWidget {
  final VoidCallback onClose;
  const _SheetHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Özel Antrenman Ekle', style: theme.textTheme.titleMedium),
        IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
          onPressed: onClose,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

// Süre ve kalori alanları yan yana. keyboardType.number ile sayısal klavye açılır.
class _InputsRow extends StatelessWidget {
  final TextEditingController durationController;
  final TextEditingController caloriesController;

  const _InputsRow({
    required this.durationController,
    required this.caloriesController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: durationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Süre (dk)', hintText: '30'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: caloriesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Kalori (kcal)', hintText: '250'),
          ),
        ),
      ],
    );
  }
}
