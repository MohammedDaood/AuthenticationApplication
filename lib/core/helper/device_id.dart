import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<String?> getDeviceId() async {
  if (Platform.isAndroid) {
    const androidIdPlugin = AndroidId();
    return await androidIdPlugin.getId();
  }

  if (Platform.isIOS) {
    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;

    return iosInfo.identifierForVendor;
  }

  return null;
}
