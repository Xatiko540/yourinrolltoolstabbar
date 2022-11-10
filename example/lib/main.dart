import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:yourinrolltoolstabbar/yourinrolltoolstabbar.dart';
import 'package:yourinrolltoolstabbar_example/flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:yourinrolltoolstabbar_example/common_libs.dart';
import 'package:yourinrolltoolstabbar_example/logic/collectibles_logic.dart';
import 'package:yourinrolltoolstabbar_example/logic/locale_logic.dart';
import 'package:yourinrolltoolstabbar_example/logic/met_api_logic.dart';
import 'package:yourinrolltoolstabbar_example/logic/met_api_service.dart';
import 'package:yourinrolltoolstabbar_example/logic/timeline_logic.dart';
import 'package:yourinrolltoolstabbar_example/logic/unsplash_logic.dart';
import 'package:yourinrolltoolstabbar_example/logic/wallpaper_logic.dart';
import 'package:yourinrolltoolstabbar_example/logic/wonders_logic.dart';
///////////////////////////////////////////////////
//import 'package:yourinrolltoolstabbar_example/ui/screens/editorial/widgets/_app_bar.dart';
import 'package:yourinrolltoolstabbar_example/ui/screens/editorial/editorial_screen.dart';
//import 'package:yourinrolltoolstabbar_example/widgets/_app_bar.dart';
import 'dart:async';

import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yourinrolltoolstabbar_example/common_libs.dart';
import 'package:yourinrolltoolstabbar_example/logic/common/string_utils.dart';
import 'package:yourinrolltoolstabbar_example/logic/data/wonder_data.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/app_icons.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/blend_mask.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/compass_divider.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/curved_clippers.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/google_maps_marker.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/gradient_container.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/hidden_collectible.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/pop_router_on_over_scroll.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/scaling_list_item.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/static_text_scale.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/themed_text.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/utils/context_utils.dart';
import 'package:yourinrolltoolstabbar_example/ui/wonder_illustrations/common/animated_clouds.dart';
import 'package:yourinrolltoolstabbar_example/ui/wonder_illustrations/common/wonder_illustration.dart';
import 'package:yourinrolltoolstabbar_example/ui/wonder_illustrations/common/wonder_illustration_config.dart';
import 'package:yourinrolltoolstabbar_example/ui/wonder_illustrations/common/wonder_title_text.dart';


/////////////
import 'package:yourinrolltoolstabbar_example/ui/screens/wonder_details/wonder_details_tab_menu.dart';
///////////////////////////////
part 'widgets/_app_bar1.dart';


///////////////////////////////
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  get data => null;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  get _scrollPos => null;

  get _sectionIndex => null;



  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
    //  platformVersion =
    //      await _yourinrolltoolstabbarPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
 //     _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin of TabBar'),
        ),
        body: Center(
          child:
 //   crossAxisAlignment: CrossAxisAlignment.end,
  //  children: [
    // Holds a gap for the Home button which pushed the other icons to the side
             //   WonderDetailsTabMenu(),

          _AppBar(
            widget.data.type,
            scrollPos: _scrollPos,
            sectionIndex: _sectionIndex,
          ).animate().fade(duration: $styles.times.med, delay: $styles.times.pageTransition),

        ),
      ),
    );
  }
}


////////////////////////////////////////////////////

/// Create singletons (controllers and services) that can be shared across the app.
void registerSingletons() {
  // Top level app controller
  GetIt.I.registerLazySingleton<AppLogic>(() => AppLogic());
  // Wonders
  GetIt.I.registerLazySingleton<WondersLogic>(() => WondersLogic());
  // Timeline / Events
  GetIt.I.registerLazySingleton<TimelineLogic>(() => TimelineLogic());
  // Search
  GetIt.I.registerLazySingleton<MetAPILogic>(() => MetAPILogic());
  GetIt.I.registerLazySingleton<MetAPIService>(() => MetAPIService());
  // Settings
  GetIt.I.registerLazySingleton<SettingsLogic>(() => SettingsLogic());
  // Unsplash
  GetIt.I.registerLazySingleton<UnsplashLogic>(() => UnsplashLogic());
  // Collectibles
  GetIt.I.registerLazySingleton<CollectiblesLogic>(() => CollectiblesLogic());
  // Localizations
  GetIt.I.registerLazySingleton<LocaleLogic>(() => LocaleLogic());
}

/// Add syntax sugar for quickly accessing the main logical controllers in the app
/// We deliberately do not create shortcuts for services, to discourage their use directly in the view/widget layer.
AppLogic get appLogic => GetIt.I.get<AppLogic>();
WondersLogic get wondersLogic => GetIt.I.get<WondersLogic>();
TimelineLogic get timelineLogic => GetIt.I.get<TimelineLogic>();
SettingsLogic get settingsLogic => GetIt.I.get<SettingsLogic>();
UnsplashLogic get unsplashLogic => GetIt.I.get<UnsplashLogic>();
MetAPILogic get metAPILogic => GetIt.I.get<MetAPILogic>();
CollectiblesLogic get collectiblesLogic => GetIt.I.get<CollectiblesLogic>();
WallPaperLogic get wallpaperLogic => GetIt.I.get<WallPaperLogic>();
LocaleLogic get localeLogic => GetIt.I.get<LocaleLogic>();
AppLocalizations get $strings => localeLogic.strings;
