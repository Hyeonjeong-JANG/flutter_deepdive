import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

final storage = FlutterSecureStorage();

// localhost
final emulatorIp = '10.0.0.2:3000';
final simulatorIp = '127.0.0.1:3000';
final deviceIp = '172.30.1.57:3000';

// 물리적 기기인지 확인하는 getter
bool get isPhysicalDevice =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

// IP 주소 결정 함수
String getIp() {
  if (Platform.isIOS && !isPhysicalDevice) {
    return simulatorIp;
  } else if (Platform.isAndroid && !isPhysicalDevice) {
    return emulatorIp;
  } else {
    return deviceIp;
  }
}

// 최종 IP 주소
final String ip = getIp();
