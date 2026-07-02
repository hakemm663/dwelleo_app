import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/signup_form_screen.dart';
import '../../features/auth/presentation/screens/verification_code_screen.dart';
import '../../features/onboarding/presentation/screens/language_selection_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/properties/presentation/screens/properties_list_screen.dart';
import '../../features/properties/presentation/screens/property_detail_screen.dart';
import 'route_paths.dart';

class AppRouter {
  AppRouter._();

  // NOTE: a "skip onboarding once completed + auth" redirect guard will be added
  // when the login/signup flow lands. It is intentionally omitted now so the
  // onboarding flow is always reachable while we build and verify it.
  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.onboarding,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutePaths.onboarding,
        name: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.language,
        name: RoutePaths.language,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RoutePaths.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.signupRole,
        name: RoutePaths.signupRole,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: RoutePaths.signupForm,
        name: RoutePaths.signupForm,
        builder: (context, state) =>
            SignupFormScreen(role: state.extra as String?),
      ),
      GoRoute(
        path: RoutePaths.signupOtp,
        name: RoutePaths.signupOtp,
        builder: (context, state) =>
            VerificationCodeScreen(email: (state.extra as String?) ?? ''),
      ),
      GoRoute(
        path: RoutePaths.propertySearch,
        name: RoutePaths.propertySearch,
        builder: (context, state) => PropertiesListScreen(
          listingType: state.uri.queryParameters['type'],
        ),
      ),
      GoRoute(
        path: RoutePaths.propertyDetail,
        name: RoutePaths.propertyDetail,
        builder: (context, state) {
          final slug = state.pathParameters['slug'];
          if (slug == null || slug.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Property not found')),
            );
          }
          return PropertyDetailScreen(slug: slug);
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}
