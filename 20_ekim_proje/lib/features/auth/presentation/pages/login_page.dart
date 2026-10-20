import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/session/session_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.roleName});
  final String? roleName;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Mert Özkan');
  final _emailController = TextEditingController(text: 'mert@ornek.com');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    final role = switch (widget.roleName) {
      'mentor' => UserRole.mentor,
      'investor' => UserRole.investor,
      _ => UserRole.entrepreneur,
    };

    final user = AppUser(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      city: 'İstanbul',
      role: role,
      bio: 'Girişim Destek Platformu kullanıcısı.',
      verificationStatus: VerificationStatus.notStarted,
      hasBusinessPlan: false,
    );

    ref.read(sessionProvider.notifier).login(user);
    if (role == UserRole.entrepreneur) {
      context.go('/onboarding');
    } else {
      context.go('/mentors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap')),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Ad Soyad',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen adınızı girin' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-Posta Adresi',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Geçerli bir e-posta girin' : null,
                ),
                const Spacer(),
                FilledButton(
                  onPressed: _handleLogin,
                  child: const Text('Giriş Yap'),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
