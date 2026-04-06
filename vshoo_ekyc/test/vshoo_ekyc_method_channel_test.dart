import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vshoo_ekyc/vshoo_ekyc_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelVshooEkyc platform = MethodChannelVshooEkyc();
  const MethodChannel channel = MethodChannel('vshoo_ekyc');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
