import 'package:auth_app/futcer/login/repositories/login_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository repository;
  LoginCubit(this.repository) : super(LoginInitial());

  Future<void> login(String username, String password, String pairing_secret, String android_id) async {
    emit(LoginLoding());
    final result = await repository.login(
      username: username,
      password: password,
      pairing_secret: pairing_secret,
      android_id: android_id,
    );
    result.fold((l) => emit(LoginFailure(errMessage: l)), (r) => emit(LoginSuccess()));
  }
}
