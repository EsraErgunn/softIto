// =============================================================================
// water_progress_ring.dart - Günlük su ilerlemesini gösteren dairesel halka
// Stack ile üç katman üst üste konur:
//   1) gri arka plan halkası (%100 dolu)
//   2) neon renkli ilerleme halkası (progress kadar dolu)
//   3) ortadaki metinler (ml ve yüzde)
// =============================================================================

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WaterProgressRing extends StatelessWidget {
  final int currentMl;
  final int goalMl;
  final double progress;

  const WaterProgressRing({
    super.key,
    required this.currentMl,
    required this.goalMl,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    // 0.0-1.0 arası oranı tam sayı yüzdeye çevirir (0.42 -> 42).
    final percent = (progress * 100).toInt();
    final theme = Theme.of(context);

    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _RingBackground(),
            _RingIndicator(progress: progress),
            _RingContent(
              currentMl: currentMl,
              goalMl: goalMl,
              percent: percent,
              textTheme: theme.textTheme,
            ),
          ],
        ),
      ),
    );
  }
}

// value: 1.0 -> tam dolu gri halka; ilerleme halkasının arkasında "boş kısım" gibi görünür.
class _RingBackground extends StatelessWidget {
  const _RingBackground();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 200,
      height: 200,
      child: CircularProgressIndicator(
        value: 1.0,
        strokeWidth: 14,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.surfaceElevated),
      ),
    );
  }
}

// Asıl ilerleme halkası. StrokeCap.round uçları yuvarlak yapar.
class _RingIndicator extends StatelessWidget {
  final double progress;
  const _RingIndicator({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 14,
        strokeCap: StrokeCap.round,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
      ),
    );
  }
}

// Halkanın ortasındaki yazılar.
class _RingContent extends StatelessWidget {
  final int currentMl;
  final int goalMl;
  final int percent;
  final TextTheme textTheme;

  const _RingContent({
    required this.currentMl,
    required this.goalMl,
    required this.percent,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.water_drop_rounded, color: AppColors.neonCyan, size: 32),
        const SizedBox(height: 4),
        Text('$currentMl', style: textTheme.headlineMedium),
        Text('/ $goalMl ml', style: textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text('%$percent', style: textTheme.labelSmall?.copyWith(color: AppColors.neonCyan)),
      ],
    );
  }
}
