import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'yourinrolltoolstabbar_platform_interface.dart';

/// An implementation of [YourinrolltoolstabbarPlatform] that uses method channels.
class MethodChannelYourinrolltoolstabbar extends YourinrolltoolstabbarPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('yourinrolltoolstabbar');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
