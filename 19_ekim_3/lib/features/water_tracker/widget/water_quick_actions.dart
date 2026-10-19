import 'package:flutter/material.dart';

class WaterQuickActions extends StatelessWidget {
  final ValueChanged<int> onAddWater;
  final VoidCallback onReset;

  const WaterQuickActions({
    super.key,
    required this.onAddWater,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => onAddWater(250),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('+250 ml'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: () => onAddWater(500),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('+500 ml'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Bugünü Sıfırla'),
        ),
      ],
    );
  }
}
