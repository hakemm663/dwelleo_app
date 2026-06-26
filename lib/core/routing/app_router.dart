import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/screens/language_selection_screen.dart';
import '../../features/onboarding/presentation/screens/role_selection_screen.dart';
import '../../features/properties/presentation/screens/properties_list_screen.dart';
import '../../features/properties/presentation/screens/property_detail_screen.dart';
import 'route_paths.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.languageSelection,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutePaths.languageSelection,
        name: RoutePaths.languageSelection,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: RoutePaths.roleSelection,
        name: RoutePaths.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
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
