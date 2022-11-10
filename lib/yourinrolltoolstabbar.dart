
import 'yourinrolltoolstabbar_platform_interface.dart';

class Yourinrolltoolstabbar {
  Future<String?> getPlatformVersion() {
    return YourinrolltoolstabbarPlatform.instance.getPlatformVersion();
  }
}
