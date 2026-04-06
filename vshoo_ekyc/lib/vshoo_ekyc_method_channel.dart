import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'vshoo_ekyc_platform_interface.dart';

/// An implementation of [VshooEkycPlatform] that uses method channels.
class MethodChannelVshooEkyc extends VshooEkycPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('vshoo_ekyc');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
