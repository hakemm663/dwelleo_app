/// Routes registered in [AppRouter]. Add a constant here only when its
/// GoRoute exists — keep this list in sync with the router so every path
/// resolves.
abstract final class RoutePaths {
  static const String languageSelection = '/';
  static const String roleSelection = '/role';
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
