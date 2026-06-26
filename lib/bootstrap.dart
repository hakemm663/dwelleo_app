import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/di/service_locator.dart';
import 'core/localization/locale_cubit.dart';

/// Single startup path shared by every flavor entry point
/// (`main_dev` / `main_staging` / `main_production`). The [flavor] is passed in
/// by the entry point, so the running environment is unambiguous.
Future<void> bootstrap(Flavor flavor) async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      AppConfig.init(flavor);

      try {
        // Reads the per-flavor native config: android/app/google-services.json
        // (selected by applicationId) and the GoogleService-Info.plist copied
        // into the iOS bundle by the flavor build phase.
        await Firebase.initializeApp();
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      } catch (error, stack) {
        // Never block app launch on telemetry/init failure.
        debugPrint('Firebase initialization failed: $error\n$stack');
      }

      await setupServiceLocator();
      await sl<LocaleCubit>().init();

      runApp(const DwelleoApp());
    },
    (error, stack) {
      // Reporting must never throw out of the last-resort handler.
      try {
        if (Firebase.apps.isNotEmpty) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        }
      } catch (_) {}
      debugPrint('Uncaught zone error: $error\n$stack');
    },
  );
}
