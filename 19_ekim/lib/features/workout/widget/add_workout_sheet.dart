import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AddWorkoutSheet extends StatefulWidget {
  final void Function(String title, int duration, int calories) onAdd;

  const AddWorkoutSheet({super.key, required this.onAdd});

  static Future<void> show(
    BuildContext context, {
    required void Function(String title, int duration, int calories) onAdd,
  }) {
    return showModalBottomSheet(
      context: context,
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
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final duration = int.tryParse(_durationController.text.trim()) ?? 0;
    final calories = int.tryParse(_caloriesController.text.trim()) ?? 0;

    if (title.isNotEmpty && duration > 0 && calories > 0) {
      widget.onAdd(title, duration, calories);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
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
