import 'package:flutter_test/flutter_test.dart';
import 'package:vshoo_ekyc/vshoo_ekyc.dart';
import 'package:vshoo_ekyc/vshoo_ekyc_platform_interface.dart';
import 'package:vshoo_ekyc/vshoo_ekyc_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVshooEkycPlatform
    with MockPlatformInterfaceMixin
    implements VshooEkycPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final VshooEkycPlatform initialPlatform = VshooEkycPlatform.instance;

  test('$MethodChannelVshooEkyc is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVshooEkyc>());
  });

  test('getPlatformVersion', () async {
    VshooEkyc vshooEkycPlugin = VshooEkyc();
    MockVshooEkycPlatform fakePlatform = MockVshooEkycPlatform();
    VshooEkycPlatform.instance = fakePlatform;

    expect(await vshooEkycPlugin.getPlatformVersion(), '42');
  });
}
