class EndPoint {
  static String baseUrl = "http://187.124.168.239:8001/";
  static String login = "account/authdevices/create";
  static String getUserDataEndPoint(id) {
    return "user/get-user/$id";
  }
}

class ApiKey {
  static String detail = "detail";
  static String password = "password";
  static String username = "username";
  static String android_id = "android_id";
  static String pairing_secret = "pairing_secret";
}
