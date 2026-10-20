import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum AvatarSize {
  sm(32, 12, 12),
  md(48, 18, 16),
  lg(80, 28, 22);

  const AvatarSize(this.dimension, this.fontSize, this.badgeSize);
  final double dimension;
  final double fontSize;
  final double badgeSize;
}

class VerifiedAvatar extends StatelessWidget {
  const VerifiedAvatar({
    super.key,
    required this.name,
    this.avatarAsset,
    this.isVerified = false,
    this.size = AvatarSize.md,
    this.heroTag,
  });

  final String name;
  final String? avatarAsset;
  final bool isVerified;
  final AvatarSize size;
  final String? heroTag;

  String _getInitials(String str) {
    final parts = str.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  Color _getBackgroundColor(ColorScheme colorScheme, String str) {
    final hash = str.hashCode.abs();
    final mod = hash % 3;
    return switch (mod) {
      0 => colorScheme.primaryContainer,
      1 => colorScheme.secondaryContainer,
      _ => colorScheme.tertiaryContainer,
    };
  }

  Color _getForegroundColor(ColorScheme colorScheme, String str) {
    final hash = str.hashCode.abs();
    final mod = hash % 3;
    return switch (mod) {
      0 => colorScheme.onPrimaryContainer,
      1 => colorScheme.onSecondaryContainer,
      _ => colorScheme.onTertiaryContainer,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColors = theme.extension<StatusColors>() ?? StatusColors.light;

    Widget avatar = Container(
      width: size.dimension,
      height: size.dimension,
      decoration: BoxDecoration(
        color: _getBackgroundColor(colorScheme, name),
        shape: BoxShape.circle,
        image: avatarAsset != null
            ? DecorationImage(
                image: AssetImage(avatarAsset!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      alignment: Alignment.center,
      child: avatarAsset == null
          ? Text(
              _getInitials(name),
              style: TextStyle(
                fontSize: size.fontSize,
                fontWeight: FontWeight.bold,
                color: _getForegroundColor(colorScheme, name),
              ),
            )
          : null,
    );

    if (heroTag != null) {
      avatar = Hero(tag: heroTag!, child: avatar);
    }

    if (!isVerified) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: size.badgeSize,
            height: size.badgeSize,
            decoration: BoxDecoration(
              color: statusColors.info,
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.surface,
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.check,
              size: size.badgeSize * 0.7,
              color: statusColors.onInfo,
            ),
          ),
        ),
      ],
    );
  }
}
