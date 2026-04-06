import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'vshoo_ekyc_method_channel.dart';

abstract class VshooEkycPlatform extends PlatformInterface {
  /// Constructs a VshooEkycPlatform.
  VshooEkycPlatform() : super(token: _token);

  static final Object _token = Object();

  static VshooEkycPlatform _instance = MethodChannelVshooEkyc();

  /// The default instance of [VshooEkycPlatform] to use.
  ///
  /// Defaults to [MethodChannelVshooEkyc].
  static VshooEkycPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VshooEkycPlatform] when
  /// they register themselves.
  static set instance(VshooEkycPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
