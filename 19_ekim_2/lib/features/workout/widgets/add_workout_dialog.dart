import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Yeni egzersiz kaydetme alt sayfası (Bottom Sheet)
class AddWorkoutBottomSheet extends StatefulWidget {
  final void Function({
    required String title,
    required String category,
    required int durationMinutes,
    required int caloriesBurned,
  }) onSave;

  const AddWorkoutBottomSheet({
    super.key,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required void Function({
      required String title,
      required String category,
      required int durationMinutes,
      required int caloriesBurned,
    }) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddWorkoutBottomSheet(onSave: onSave),
    );
  }

  @override
  State<AddWorkoutBottomSheet> createState() => _AddWorkoutBottomSheetState();
}

class _AddWorkoutBottomSheetState extends State<AddWorkoutBottomSheet> {
  final _titleController = TextEditingController();
  final _durationController = TextEditingController(text: '30');
  final _calorieController = TextEditingController(text: '200');
  String _selectedCategory = 'Fitness';

  final List<String> _categories = const [
    'Fitness',
    'Koşu',
    'Bisiklet',
    'Yüzme',
    'Yürüyüş',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _calorieController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final title = _titleController.text.trim().isEmpty
        ? '$_selectedCategory Seansı'
        : _titleController.text.trim();
    final duration = int.tryParse(_durationController.text) ?? 30;
    final calories = int.tryParse(_calorieController.text) ?? 200;

    widget.onSave(
      title: title,
      category: _selectedCategory,
      durationMinutes: duration,
      caloriesBurned: calories,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(),
          const SizedBox(height: 16),
          _buildSheetTitle(),
          const SizedBox(height: 16),
          _buildCategoryChips(),
          const SizedBox(height: 16),
          _buildTextFields(),
          const SizedBox(height: 20),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.surfaceBorder,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildSheetTitle() {
    return const Text(
      'Yeni Egzersiz Ekle',
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      children: _categories.map((cat) {
        final isSelected = _selectedCategory == cat;
        return ChoiceChip(
          label: Text(cat),
          selected: isSelected,
          selectedColor: AppColors.firePrimary,
          backgroundColor: AppColors.surfaceElevated,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          side: BorderSide(
            color: isSelected ? AppColors.firePrimary : AppColors.surfaceBorder,
          ),
          onSelected: (_) => setState(() => _selectedCategory = cat),
        );
      }).toList(),
    );
  }

  Widget _buildTextFields() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: _inputDecoration('Süre (dk)'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _calorieController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: _inputDecoration('Kalori (kcal)'),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      filled: true,
      fillColor: AppColors.surfaceElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.surfaceBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.surfaceBorder),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.firePrimary,
          foregroundColor: Colors.white,
        ),
        child: const Text('Egzersizi Kaydet'),
      ),
    );
  }
}
