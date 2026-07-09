// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:auth_app/futcer/home/data/repositories/otp_repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final OtpRepository repository;
  OtpCubit(this.repository) : super(OtpInitial());

  Future<String> getOtp(String qrCode) async {
    emit(OtpLoding());
    final result = await repository.getOtp(qrCode: qrCode);
    result.fold((l) => emit(OtpFailure(errMessage: l)), (r) => emit(OtpSuccess(otp: r)));
    return result.getOrElse(() => '');
  }
}
