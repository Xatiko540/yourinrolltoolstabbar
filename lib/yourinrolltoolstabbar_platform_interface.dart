import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'yourinrolltoolstabbar_method_channel.dart';

abstract class YourinrolltoolstabbarPlatform extends PlatformInterface {
  /// Constructs a YourinrolltoolstabbarPlatform.
  YourinrolltoolstabbarPlatform() : super(token: _token);

  static final Object _token = Object();

  static YourinrolltoolstabbarPlatform _instance = MethodChannelYourinrolltoolstabbar();

  /// The default instance of [YourinrolltoolstabbarPlatform] to use.
  ///
  /// Defaults to [MethodChannelYourinrolltoolstabbar].
  static YourinrolltoolstabbarPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [YourinrolltoolstabbarPlatform] when
  /// they register themselves.
  static set instance(YourinrolltoolstabbarPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
