import 'package:flutter_test/flutter_test.dart';
import 'package:yourinrolltoolstabbar/yourinrolltoolstabbar.dart';
import 'package:yourinrolltoolstabbar/yourinrolltoolstabbar_platform_interface.dart';
import 'package:yourinrolltoolstabbar/yourinrolltoolstabbar_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockYourinrolltoolstabbarPlatform
    with MockPlatformInterfaceMixin
    implements YourinrolltoolstabbarPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final YourinrolltoolstabbarPlatform initialPlatform = YourinrolltoolstabbarPlatform.instance;

  test('$MethodChannelYourinrolltoolstabbar is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelYourinrolltoolstabbar>());
  });

  test('getPlatformVersion', () async {
    Yourinrolltoolstabbar yourinrolltoolstabbarPlugin = Yourinrolltoolstabbar();
    MockYourinrolltoolstabbarPlatform fakePlatform = MockYourinrolltoolstabbarPlatform();
    YourinrolltoolstabbarPlatform.instance = fakePlatform;

    expect(await yourinrolltoolstabbarPlugin.getPlatformVersion(), '42');
  });
}
