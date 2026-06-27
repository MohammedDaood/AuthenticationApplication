// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:auth_app/core/api/dio_consumer.dart';
import 'package:auth_app/core/api/end_ponits.dart';
import 'package:auth_app/core/errors/exceptions.dart';
import 'package:auth_app/core/helper/device_id.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final DioConsumer api;
  OtpCubit(this.api) : super(OtpInitial());

  getOtp(String qr_code, String android_id) async {
    emit(OtpLoding());
    try {
      final response = await api.post(
        EndPoint.getOtp,
        data: {ApiKey.qr_code: qr_code, ApiKey.android_id: android_id},
      );
      emit(OtpSuccess(otp: response));
    } on ServerException catch (e) {
      emit(OtpFailure(errMessage: e.errModel.detail));
    }
  }
}
