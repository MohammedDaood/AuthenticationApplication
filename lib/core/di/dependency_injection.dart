import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:auth_app/core/api/api_consumer.dart';
import 'package:auth_app/core/api/dio_consumer.dart';
import 'package:auth_app/futcer/login/logic/cubit/login_cubit.dart';
import 'package:auth_app/futcer/home/logic/cubit/otp_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: getIt<Dio>()));

  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<ApiConsumer>() as DioConsumer));

  getIt.registerFactory<OtpCubit>(() => OtpCubit(getIt<ApiConsumer>() as DioConsumer));
}
