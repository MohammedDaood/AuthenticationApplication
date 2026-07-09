import 'package:auth_app/core/api/api_consumer.dart';
import 'package:auth_app/core/api/end_ponits.dart';
import 'package:auth_app/core/errors/exceptions.dart';
import 'package:auth_app/core/helper/shered_Pref.dart';
import 'package:dartz/dartz.dart';

class OtpRepository {
  final ApiConsumer api;
  OtpRepository(this.api);
  Future<Either<String, String>> getOtp({required String qrCode}) async {
    final deviceId = PrefUtils.getDeviceId();

    try {
      final response = await api.post(EndPoint.getOtp, data: {ApiKey.qr_code: qrCode, ApiKey.android_id: deviceId});
      if (response[ApiKey.otp] == null) {
        return Left("انتهت صلاحية رمز الاستجابة السريعة. يرجى مسح رمز الاستجابة السريعة مرة أخرى.");
      }
      return Right(response[ApiKey.otp].toString());
    } on ServerException catch (e) {
      return Left(e.errModel.detail);
    }
  }
}
