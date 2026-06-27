/// Routes registered in [AppRouter]. Add a constant here only when its
/// GoRoute exists — keep this list in sync with the router so every path
/// resolves.
abstract final class RoutePaths {
  /// First-run value-prop onboarding (entry point).
  static const String onboarding = '/';

  /// Optional standalone language picker (the in-app-bar toggle is primary).
  static const String language = '/language';

  /// Login (Welcome Back).
  static const String login = '/login';

  /// Account-type selection — part of the SIGN-UP flow, not onboarding.
  static const String signupRole = '/signup/role';

  static const String propertySearch = '/properties';
  static const String propertyDetail = '/properties/:slug';

  static String propertyDetailPath(String slug) => '/properties/$slug';

  /// Properties list, optionally filtered by listing type
  /// (`for-sale` / `for-rent`). Null = curated set.
  static String propertySearchPath([String? listingType]) => Uri(
    path: propertySearch,
    queryParameters: listingType == null ? null : {'type': listingType},
  ).toString();
}
