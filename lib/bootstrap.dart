import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'core/di/service_locator.dart';
import 'core/localization/locale_cubit.dart';

/// Single startup path shared by every flavor entry point
/// (`main_dev`, `main_staging`, `main_prod`).
///
/// Keeping initialization here means the four `main_*.dart` files stay
/// one-liners and can never drift out of sync.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Reads the native config bundled per platform/flavor:
  // android/app/google-services.json and ios/Runner/GoogleService-Info.plist.
  await Firebase.initializeApp();

  await setupServiceLocator();
  await sl<LocaleCubit>().init();

  runApp(const DwelleoApp());
}
