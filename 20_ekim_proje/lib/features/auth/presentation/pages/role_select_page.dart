import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';

class RoleSelectPage extends StatefulWidget {
  const RoleSelectPage({super.key});

  @override
  State<RoleSelectPage> createState() => _RoleSelectPageState();
}

class _RoleSelectPageState extends State<RoleSelectPage> {
  UserRole _selectedRole = UserRole.entrepreneur;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Rolünü Seç')),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'Platformu hangi rolde kullanacaksın?',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildRoleCard(UserRole.entrepreneur, 'Girişimci', 'İş fikrim var, destek ve yatırım arıyorum.', Icons.lightbulb_outline),
              const SizedBox(height: AppSpacing.md),
              _buildRoleCard(UserRole.mentor, 'Mentör', 'Tecrübelerimi yeni girişimlerle paylaşmak istiyorum.', Icons.school_outlined),
              const SizedBox(height: AppSpacing.md),
              _buildRoleCard(UserRole.investor, 'Yatırımcı', 'Yenilikçi projelere sermaye sağlamak istiyorum.', Icons.trending_up),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go('/login?role=${_selectedRole.name}'),
                child: const Text('Devam Et'),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(UserRole role, String title, String subtitle, IconData icon) {
    final isSelected = _selectedRole == role;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: isSelected ? colorScheme.primaryContainer.withAlpha(80) : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        leading: Icon(icon, color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant, size: 32),
        title: Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
        trailing: isSelected ? Icon(Icons.check_circle, color: colorScheme.primary) : null,
        onTap: () => setState(() => _selectedRole = role),
      ),
    );
  }
}
