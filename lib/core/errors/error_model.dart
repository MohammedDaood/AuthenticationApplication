import 'package:auth_app/core/api/end_ponits.dart';

class ErrorModel {
  final String detail;

  ErrorModel({required this.detail});
  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    return ErrorModel(detail: jsonData[ApiKey.detail]);
  }
}
