abstract final class RoutePaths {
  static const String languageSelection = '/';
  static const String roleSelection = '/role';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String propertySearch = '/properties';
  static const String propertyDetail = '/properties/:slug';
  static String propertyDetailPath(String slug) => '/properties/$slug';
  static const String projects = '/projects';
  static const String projectDetail = '/projects/:id';
  static const String developers = '/developers';
  static const String developerDetail = '/developers/:id';
  static const String saved = '/saved';
  static const String map = '/map';
  static const String aiSearch = '/ai-search';
  static const String profile = '/profile';
}
