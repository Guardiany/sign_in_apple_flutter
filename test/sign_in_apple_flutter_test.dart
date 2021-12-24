import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sign_in_apple_flutter/sign_in_apple_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('sign_in_apple_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SignInAppleFlutter.platformVersion, '42');
  });
}
