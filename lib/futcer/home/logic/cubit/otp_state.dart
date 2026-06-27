part of 'otp_cubit.dart';

sealed class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

final class OtpInitial extends OtpState {}

final class OtpLoding extends OtpState {}

final class OtpSuccess extends OtpState {
  final String otp;
  const OtpSuccess({required this.otp});
}

final class OtpFailure extends OtpState {
  final String errMessage;
  const OtpFailure({required this.errMessage});
}
