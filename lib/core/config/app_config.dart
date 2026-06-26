/// Build flavors. The running flavor is selected by the entry point
/// (`main_dev` / `main_staging` / `main_production`), making the entry point
/// the single source of truth rather than a `--dart-define` that can be
/// forgotten.
enum Flavor { dev, staging, production }

/// Runtime configuration derived from the active [Flavor].
///
/// Initialized once in `bootstrap()` (or a test's setUp) via [AppConfig.init].
/// Reading [instance] before init throws, so a forgotten init surfaces loudly
/// instead of silently running as the wrong flavor.
class AppConfig {
  const AppConfig._(this.flavor);

  static AppConfig? _instance;

  static AppConfig get instance {
    final config = _instance;
    if (config == null) {
      throw StateError(
        'AppConfig.init(flavor) must be called before AppConfig.instance '
        '(done in bootstrap()).',
      );
    }
    return config;
  }

  static void init(Flavor flavor) => _instance = AppConfig._(flavor);

  final Flavor flavor;

  bool get isDev => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProduction => flavor == Flavor.production;

  /// dev currently points at the live API by design (no separate dev backend).
  String get apiBaseUrl => switch (flavor) {
    Flavor.production => 'https://api.dwelleo.sa',
    Flavor.staging => 'https://staging-api.dwelleo.sa',
    Flavor.dev => 'https://api.dwelleo.sa',
  };
}
