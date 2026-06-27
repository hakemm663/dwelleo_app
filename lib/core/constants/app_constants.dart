abstract final class AppConstants {
  static const String appName = 'Dwelleo';
  static const String defaultLocale = 'en';
  static const List<String> supportedLocales = ['en', 'ar'];

  // Token storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String localeKey = 'locale';
  static const String themeModeKey = 'theme_mode';
  static const String onboardingDoneKey = 'onboarding_done';

  // Network timeouts (ms)
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 30000;

  // Pagination
  static const int defaultPageSize = 20;

  // Cache durations
  static const Duration lookupCacheDuration = Duration(hours: 24);
}
