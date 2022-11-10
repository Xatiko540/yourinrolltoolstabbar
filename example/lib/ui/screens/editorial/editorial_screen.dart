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

part 'widgets/_app_bar.dart';
part 'widgets/_callout.dart';
part 'widgets/_circular_title_bar.dart';
part 'widgets/_collapsing_pull_quote_image.dart';
part 'widgets/_large_simple_quote.dart';
part 'widgets/_scrolling_content.dart';
part 'widgets/_section_divider.dart';
part 'widgets/_sliding_image_stack.dart';
part 'widgets/_title_text.dart';
part 'widgets/_top_illustration.dart';

class WonderEditorialScreen extends StatefulWidget {
  const WonderEditorialScreen(this.data, {Key? key, required this.onScroll}) : super(key: key);
  final WonderData data;
  final void Function(double scrollPos) onScroll;

  @override
  State<WonderEditorialScreen> createState() => _WonderEditorialScreenState();
}

class _WonderEditorialScreenState extends State<WonderEditorialScreen> {
  late final ScrollController _scroller = ScrollController()..addListener(_handleScrollChanged);
  final _scrollPos = ValueNotifier(0.0);
  final _sectionIndex = ValueNotifier(0);

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  /// Various [ValueListenableBuilders] are mapped to the _scrollPos and will rebuild when it changes
  void _handleScrollChanged() {
    _scrollPos.value = _scroller.position.pixels;
    widget.onScroll.call(_scrollPos.value);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      bool shortMode = constraints.biggest.height < 700;
      double illustrationHeight = shortMode ? 250 : 280;
      double minAppBarHeight = shortMode ? 80 : 120;
      double maxAppBarHeight = shortMode ? 400 : 500;

      return PopRouterOnOverScroll(
        controller: _scroller,
        child: ColoredBox(
          color: $styles.colors.offWhite,
          child: Stack(
            children: [
              /// Background
              Positioned.fill(
                child: ValueListenableBuilder(
                  valueListenable: _scrollPos,
                  builder: (_, value, __) {
                    return Container(
                      color: widget.data.type.bgColor.withOpacity(_scrollPos.value > 1000 ? 0 : 1),
                    );
                  },
                ),
              ),

              /// Top Illustration - Sits underneath the scrolling content, fades out as it scrolls
              SizedBox(
                height: illustrationHeight,
                child: ValueListenableBuilder<double>(
                  valueListenable: _scrollPos,
                  builder: (_, value, child) {
                    // get some value between 0 and 1, based on the amt scrolled
                    double opacity = (1 - value / 700).clamp(0, 1);
                    return Opacity(opacity: opacity, child: child);
                  },
                  // This is due to a bug: https://github.com/flutter/flutter/issues/101872
                  child: RepaintBoundary(child: _TopIllustration(widget.data.type)),
                ),
              ),

              /// Scrolling content - Includes an invisible gap at the top, and then scrolls over the illustration
              CustomScrollView(
                primary: false,
                controller: _scroller,
                cacheExtent: 1000,
                slivers: [
                  /// Invisible padding at the top of the list, so the illustration shows through the btm
                  SliverToBoxAdapter(
                    child: SizedBox(height: illustrationHeight),
                  ),

                  /// Text content, animates itself to hide behind the app bar as it scrolls up
                  SliverToBoxAdapter(
                    child: ValueListenableBuilder<double>(
                      valueListenable: _scrollPos,
                      builder: (_, value, child) {
                        double offsetAmt = max(0, value * .3);
                        double opacity = (1 - offsetAmt / 150).clamp(0, 1);
                        return Transform.translate(
                          offset: Offset(0, offsetAmt),
                          child: Opacity(opacity: opacity, child: child),
                        );
                      },
                      child: _TitleText(widget.data, scroller: _scroller),
                    ),
                  ),

                  /// Collapsing App bar, pins to the top of the list
                  SliverAppBar(
                    pinned: true,
                    collapsedHeight: minAppBarHeight,
                    toolbarHeight: minAppBarHeight,
                    expandedHeight: maxAppBarHeight,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: SizedBox.shrink(),
                    flexibleSpace: SizedBox.expand(
                      child: _AppBar(
                        widget.data.type,
                        scrollPos: _scrollPos,
                        sectionIndex: _sectionIndex,
                      ).animate().fade(duration: $styles.times.med, delay: $styles.times.pageTransition),
                    ),
                  ),

                  /// Editorial content (text and images)
                  _ScrollingContent(widget.data, scrollPos: _scrollPos, sectionNotifier: _sectionIndex),

                  /// Bottom padding
                  SliverToBoxAdapter(
                    child: Container(height: 150, color: $styles.colors.offWhite),
                  ),
                ],
              ),

              /// Home Btn
              AnimatedBuilder(
                  animation: _scroller,
                  builder: (_, child) {
                    return AnimatedOpacity(
                      opacity: _scrollPos.value > 0 ? 0 : 1,
                      duration: $styles.times.med,
                      child: child,
                    );
                  },
                  child: BackBtn(icon: AppIcons.north).safe()),
            ],
          ),
        ),
      );
    });
  }
}
///////////////////////////////////////////////
class _AppBar extends StatelessWidget {
  _AppBar(this.wonderType, {Key? key, required this.sectionIndex, required this.scrollPos}) : super(key: key);
  final WonderType wonderType;
  final ValueNotifier<int> sectionIndex;
  final ValueNotifier<double> scrollPos;
  final _titleValues = [
    $strings.appBarTitleFactsHistory,
    $strings.appBarTitleConstruction,
    $strings.appBarTitleLocation,
  ];

  final _iconValues = const [
    'history.png',
    'construction.png',
    'geography.png',
  ];

  ArchType _getArchType() {
    switch (wonderType) {
      case WonderType.chichenItza:
        return ArchType.flatPyramid;
      case WonderType.christRedeemer:
        return ArchType.wideArch;
      case WonderType.colosseum:
        return ArchType.arch;
      case WonderType.greatWall:
        return ArchType.arch;
      case WonderType.machuPicchu:
        return ArchType.pyramid;
      case WonderType.petra:
        return ArchType.wideArch;
      case WonderType.pyramidsGiza:
        return ArchType.pyramid;
      case WonderType.tajMahal:
        return ArchType.spade;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arch = _getArchType();
    return LayoutBuilder(builder: (_, constraints) {
      bool showOverlay = constraints.biggest.height < 300;
      return Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: $styles.times.fast * .5,
            child: Stack(
              key: ValueKey(showOverlay),
              fit: StackFit.expand,
              children: [
                /// Masked image
                ClipPath(
                  // Switch arch type to Rect if we are showing the title bar
                  clipper: showOverlay ? null : ArchClipper(arch),
                  child: ValueListenableBuilder<double>(
                    valueListenable: scrollPos,
                    builder: (_, value, child) {
                      double opacity = (.4 + (value / 1500)).clamp(0, 1);
                      return ScalingListItem(
                        scrollPos: scrollPos,
                        child: Image.asset(
                          wonderType.photo1,
                          fit: BoxFit.cover,
                          opacity: AlwaysStoppedAnimation(opacity),
                        ),
                      );
                    },
                  ),
                ),

                /// Colored overlay
                if (showOverlay) ...[
                  ClipRect(
                    child: ColoredBox(
                      color: wonderType.bgColor.withOpacity(.8),
                    ).animate().fade(duration: $styles.times.fast),
                  ),
                ],
              ],
            ),
          ),

          /// Circular Titlebar
          BottomCenter(
            child: ValueListenableBuilder<int>(
              valueListenable: sectionIndex,
              builder: (_, value, __) {
                return _CircularTitleBar(
                  index: value,
                  titles: _titleValues,
                  icons: _iconValues,
                );
              },
            ),
          ),
        ],
      );
    });
  }
}