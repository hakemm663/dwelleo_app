import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../config/app_config.dart';
import '../constants/app_constants.dart';
import '../localization/locale_cubit.dart';
import '../network/dio_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/locale_interceptor.dart';
import '../storage/secure_storage.dart';
import '../theme/theme_cubit.dart';
import '../../features/properties/data/datasources/property_remote_data_source.dart';
import '../../features/properties/data/repositories/property_repository_impl.dart';
import '../../features/properties/domain/repositories/property_repository.dart';
import '../../features/properties/domain/usecases/get_properties.dart';
import '../../features/properties/domain/usecases/get_property_detail.dart';
import '../../features/properties/presentation/cubit/properties_cubit.dart';
import '../../features/properties/presentation/cubit/property_detail_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ── Storage ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<SecureStorage>(
    () => SecureStorage(sl<FlutterSecureStorage>()),
  );

  // ── Locale & Theme ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit(sl<SecureStorage>()));
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl<SecureStorage>()));

  // ── Network ──────────────────────────────────────────────────────────────
  // Dedicated Dio for token refresh — no AuthInterceptor to prevent re-entry,
  // but carries LocaleInterceptor so the server sees the correct locale.
  final refreshDio = Dio(
    BaseOptions(
      baseUrl: AppConfig.instance.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.add(LocaleInterceptor(sl<SecureStorage>()));

  sl.registerLazySingleton<Dio>(
    () => DioClient.create(
      baseUrl: AppConfig.instance.apiBaseUrl,
      interceptors: [
        LocaleInterceptor(sl<SecureStorage>()),
        AuthInterceptor(sl<SecureStorage>(), refreshDio),
      ],
    ),
  );

  // ── Feature: Properties ──────────────────────────────────────────────────
  sl.registerLazySingleton<PropertyRemoteDataSource>(
    () => PropertyRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<PropertyRepository>(
    () => PropertyRepositoryImpl(sl<PropertyRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetProperties(sl<PropertyRepository>()));
  sl.registerLazySingleton(() => GetPropertyDetail(sl<PropertyRepository>()));
  sl.registerFactory(() => PropertiesCubit(sl<GetProperties>()));
  sl.registerFactory(() => PropertyDetailCubit(sl<GetPropertyDetail>()));
}
