// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:auth_app/core/api/dio_consumer.dart';
import 'package:auth_app/core/api/end_ponits.dart';
import 'package:auth_app/core/errors/exceptions.dart';
import 'package:auth_app/core/helper/device_id.dart' as PrefUtils;
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final DioConsumer api;
  OtpCubit(this.api) : super(OtpInitial());

  Future<void> getOtp(String qrCode) async {
    emit(OtpLoding());
    try {
      final response = await api.post(
        EndPoint.getOtp,
        data: {ApiKey.qr_code: qrCode, ApiKey.android_id: PrefUtils.getDeviceId()},
      );
      if (response.data[ApiKey.otp] == null) {
        emit(OtpExpiry(message: "انتهت صلاحية رمز الاستجابة السريعة. يرجى مسح رمز الاستجابة السريعة مرة أخرى."));
        return;
      }
      emit(OtpSuccess(otp: response.data[ApiKey.otp]));
    } on ServerException catch (e) {
      emit(OtpFailure(errMessage: e.errModel.detail));
    } on DioException {
      emit(OtpFailure(errMessage: 'تعذر الاتصال بالخادم، تحقق من اتصال الإنترنت.'));
    } catch (_) {
      emit(OtpFailure(errMessage: 'حدث خطأ غير متوقع، حاول مرة أخرى.'));
    }
  }
}
