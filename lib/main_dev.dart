import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/di/service_locator.dart';
import 'core/localization/locale_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  await sl<LocaleCubit>().init();
  runApp(const DwelleoApp());
}
