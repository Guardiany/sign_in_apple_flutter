
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

typedef void OnSignInAppleSuccess(dynamic info);
typedef void OnSignInAppleError(dynamic error);

class SignInAppleFlutter {
  static const MethodChannel _channel =
      const MethodChannel('sign_in_apple_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  
  static Future<dynamic> signInApple({
    OnSignInAppleSuccess? success,
    OnSignInAppleError? error,
  }) async {
    if (!Platform.isIOS) {
      return;
    }
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'success':
          if (success != null) {
            success(call.arguments);
          }
          break;
        case 'error':
          if (error != null) {
            error(call.arguments['message']);
          }
          break;
      }
    });
    return await _channel.invokeMethod('sign_in_apple');
  }
}