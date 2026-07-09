import 'package:auth_app/futcer/home/data/repositories/otp_repositories.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:auth_app/core/api/api_consumer.dart';
import 'package:auth_app/core/api/dio_consumer.dart';

import 'package:auth_app/futcer/login/repositories/login_repository.dart';
import 'package:auth_app/futcer/login/logic/cubit/login_cubit.dart';

import 'package:auth_app/futcer/home/logic/cubit/otp_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  // ApiConsumer
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: getIt<Dio>()));

  // Repository
  getIt.registerLazySingleton<LoginRepository>(() => LoginRepository(getIt<ApiConsumer>()));

  getIt.registerLazySingleton<OtpRepository>(() => OtpRepository(getIt<ApiConsumer>()));

  // Cubits
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<LoginRepository>()));

  getIt.registerFactory<OtpCubit>(() => OtpCubit(getIt<OtpRepository>()));
}
