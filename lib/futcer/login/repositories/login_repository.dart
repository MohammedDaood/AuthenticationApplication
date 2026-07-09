import 'package:auth_app/core/api/api_consumer.dart';
import 'package:auth_app/core/api/end_ponits.dart';
import 'package:auth_app/core/errors/exceptions.dart';
import 'package:dartz/dartz.dart';

class LoginRepository {
  final ApiConsumer api;
  LoginRepository(this.api);
  Future<Either<String, void>> login({
    required String username,
    required String password,
    required String pairing_secret,
    required String android_id,
  }) async {
    try {
      await api.post(
        EndPoint.login,
        data: {
          ApiKey.username: username,
          ApiKey.pairing_secret: pairing_secret,
          ApiKey.android_id: android_id,
          ApiKey.password: password,
        },
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errModel.detail);
    }
  }
}
