
import 'vshoo_ekyc_platform_interface.dart';

class VshooEkyc {
  Future<String?> getPlatformVersion() {
    return VshooEkycPlatform.instance.getPlatformVersion();
  }
}
