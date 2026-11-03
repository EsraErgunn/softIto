// =============================================================================
// router.dart - Uygulamanın tüm sayfa rotaları ve giriş kontrolü (auth guard)
// Yapı:
//   - /welcome, /role, /login       -> giriş yapmamış kullanıcı sayfaları
//   - /onboarding                    -> girişimcinin ilk kurulum adımı
//   - StatefulShellRoute (4 sekme)   -> alt menülü ana bölüm (mentör, yatırımcı, program, topluluk)
//   - /profile, /settings, /demo ... -> alt menü dışında tam ekran açılan sayfalar
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/demo/demo_settings_provider.dart';
import '../core/models/models.dart';
import '../core/session/session_provider.dart';
import '../core/session/session_state.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/role_select_page.dart';
import '../features/auth/presentation/pages/welcome_page.dart';
import '../features/community/presentation/pages/community_page.dart';
import '../features/community/presentation/pages/post_composer_page.dart';
import '../features/community/presentation/pages/post_detail_page.dart';
import '../features/demo_panel/presentation/pages/demo_panel_page.dart';
import '../features/investors/presentation/pages/investor_detail_page.dart';
import '../features/investors/presentation/pages/investors_page.dart';
import '../features/matching/presentation/pages/matches_page.dart';
import '../features/mentors/presentation/pages/mentor_detail_page.dart';
import '../features/mentors/presentation/pages/mentors_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/profile/presentation/pages/person_profile_page.dart';
import '../features/profile/presentation/pages/profile_dashboard_page.dart';
import '../features/profile/presentation/pages/profile_edit_page.dart';
import '../features/profile/presentation/pages/settings_page.dart';
import '../features/profile/presentation/pages/startup_page.dart';
import '../features/programs/presentation/pages/program_detail_page.dart';
import '../features/programs/presentation/pages/programs_page.dart';
import '../features/support/presentation/pages/consultation_page.dart';
import '../features/support/presentation/pages/funding_support_page.dart';
import '../features/verification/presentation/pages/verification_page.dart';
import 'shell_scaffold.dart';

// Her yönlendirmede çalışan kontrol fonksiyonu.
// null dönerse kullanıcı istediği sayfaya gider; bir yol dönerse oraya yönlendirilir.
String? authGuard(SessionState session, String location) {
  final user = session.user;
  final isAuthRoute = location == '/welcome' || location.startsWith('/role') || location.startsWith('/login');

  // Giriş yapılmamışsa: sadece giriş sayfalarına izin var, diğerleri /welcome'a.
  if (user == null) {
    return isAuthRoute ? null : '/welcome';
  }

  // Giriş yapmış kullanıcı tekrar giriş sayfasına gitmeye çalışırsa ana sayfaya yollanır.
  if (isAuthRoute) {
    return '/mentors';
  }

  // Girişimci onboarding'i bitirmediyse başka hiçbir sayfaya geçemez.
  if (!session.onboardingDone && user.role == UserRole.entrepreneur) {
    if (location != '/onboarding') {
      return '/onboarding';
    }
    return null;
  }

  // Demo paneli kapalıysa /demo adresine erişim engellenir.
  if (location == '/demo' && !kDemoPanelEnabled) {
    return '/profile';
  }

  return null;
}

// GoRouter Riverpod provider'ı olarak üretilir; böylece oturum durumuna erişebilir.
final routerProvider = Provider<GoRouter>((ref) {
  // Oturum durumu bir ValueNotifier'a kopyalanır ve her değişiklikte güncellenir.
  // GoRouter'ın refreshListenable'ı bunu dinler: giriş/çıkış olunca redirect tekrar çalışır.
  // Router'ı ref.watch ile yeniden oluşturmak yerine bu yöntem gezinme geçmişini korur.
  final session = ValueNotifier(ref.read(sessionProvider));
  ref.listen(sessionProvider, (_, next) => session.value = next);
  // Provider yok edilince notifier da temizlenir.
  ref.onDispose(session.dispose);

  return GoRouter(
    initialLocation: '/mentors',
    refreshListenable: session,
    // Her sayfa geçişinden önce authGuard kontrolü yapılır.
    redirect: (context, state) => authGuard(session.value, state.matchedLocation),
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/role',
        builder: (context, state) => const RoleSelectPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(
          roleName: state.uri.queryParameters['role'],
        ),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      // Alt menülü yapı: her sekme (branch) kendi gezinme yığınını (stack) korur.
      // Ör. Mentörler'de detaya girip Topluluk'a geçip geri dönünce detay sayfası hâlâ açıktır.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                // 1. sekme: Mentörler. Alt rota ':id' -> /mentors/42 gibi detay sayfası.
                path: '/mentors',
                builder: (context, state) => const MentorsPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => MentorDetailPage(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/investors',
                builder: (context, state) => const InvestorsPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => InvestorDetailPage(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/programs',
                builder: (context, state) => const ProgramsPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => ProgramDetailPage(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/community',
                builder: (context, state) => const CommunityPage(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const PostComposerPage(),
                  ),
                  GoRoute(
                    path: 'post/:id',
                    builder: (context, state) => PostDetailPage(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        // Profil ve alt sayfaları sekmelerin dışında, tam ekran açılır.
        path: '/profile',
        builder: (context, state) => const ProfileDashboardPage(),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) => const ProfileEditPage(),
          ),
          GoRoute(
            path: 'startup',
            builder: (context, state) => const StartupPage(),
          ),
        ],
      ),
      GoRoute(
        // ":id" dinamik parametredir; state.pathParameters['id'] ile okunur.
        path: '/people/:id',
        builder: (context, state) => PersonProfilePage(
          id: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/verification',
        builder: (context, state) => const VerificationPage(),
      ),
      GoRoute(
        path: '/matches',
        builder: (context, state) => const MatchesPage(),
      ),
      GoRoute(
        path: '/support/funding',
        builder: (context, state) => const FundingSupportPage(),
      ),
      GoRoute(
        path: '/support/consultation',
        builder: (context, state) => const ConsultationPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/demo',
        builder: (context, state) => const DemoPanelPage(),
      ),
    ],
  );
});
