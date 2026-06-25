abstract final class AppConstants {
  static const String appName = 'Dwelleo';
  static const String defaultLocale = 'en';
  static const List<String> supportedLocales = ['en', 'ar'];

  // Token storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String localeKey = 'locale';
  static const String onboardingDoneKey = 'onboarding_done';
  static const String selectedRoleKey = 'selected_role';

  // Network timeouts (ms)
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 30000;

  // Pagination
  static const int defaultPageSize = 20;

  // Cache durations
  static const Duration lookupCacheDuration = Duration(hours: 24);
}

abstract final class FlavorConstants {
  // Set via --dart-define=FLAVOR=dev|staging|prod
  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static bool get isDev => flavor == 'dev';
  static bool get isStaging => flavor == 'staging';
  static bool get isProd => flavor == 'prod';
}

abstract final class BaseUrls {
  static String get api => switch (FlavorConstants.flavor) {
    'prod' => 'https://api.dwelleo.sa',
    'staging' => 'https://staging-api.dwelleo.sa',
    _ => 'https://api.dwelleo.sa',
  };

  static String get salesAgent => switch (FlavorConstants.flavor) {
    'staging' => 'https://staging-sales-agent.dwelleo.sa',
    _ => 'https://sales-agent.dwelleo.sa',
  };
}
