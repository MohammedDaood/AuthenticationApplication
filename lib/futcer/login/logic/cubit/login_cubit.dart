import 'package:auth_app/core/api/dio_consumer.dart';
import 'package:auth_app/core/api/end_ponits.dart';
import 'package:auth_app/core/errors/exceptions.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final DioConsumer api;
  LoginCubit(this.api) : super(LoginInitial());

  Login(
    String username,
    String password,
    String pairing_secret,
    String android_id,
  ) async {
    try {
      emit(LoginLoding());
      final Response = await api.post(
        EndPoint.login,
        data: {
          ApiKey.username: username,
          ApiKey.pairing_secret: pairing_secret,
          // to do?
          ApiKey.android_id: android_id,
          ApiKey.password: password,
        },
      );
      emit(LoginSuccess());
    } on ServerException catch (e) {
      emit(LoginFailure(errMessage: e.errModel.detail));
    }
  }
}
