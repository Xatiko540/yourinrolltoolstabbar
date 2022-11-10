part of '../main.dart';




//part 'widgets/_title_text.dart';
//part 'widgets/_top_illustration.dart';
//part 'widgets/_scrolling_content.dart';
//part 'widgets/_circular_title_bar.dart';

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

/////////////////////////////////////


class _TopIllustration extends StatelessWidget {
  const _TopIllustration(this.type, {Key? key}) : super(key: key);
  final WonderType type;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WonderIllustration(type, config: WonderIllustrationConfig.bg(enableAnims: false, shortMode: true)),
        Positioned.fill(
          bottom: 50,
          child: AnimatedClouds(wonderType: type, enableAnimations: false, opacity: .5),
        ),
        Transform.translate(
          // Small bump down to make sure we cover the edge between the editorial page and the sky.
          offset: Offset(0, 10),
          child: WonderIllustration(
            type,
            config: WonderIllustrationConfig.mg(enableAnims: false, shortMode: true),
          ),
        ),
      ],
    );
  }
}


/////////////////////////////////////
class _CircularTitleBar extends StatelessWidget {
  const _CircularTitleBar({Key? key, required this.titles, required this.icons, required this.index})
      : assert(titles.length == icons.length, 'The number of titles and icons do not match.'),
        super(key: key);
  final List<String> titles;
  final List<String> icons;
  final int index;

  @override
  Widget build(BuildContext context) {
    double barSize = 100; // the actual size of this widget
    double barTopPadding = 40; // negative space at the top of the bar
    double circleSize = 190; // circle is bigger than bar, and overhangs it
    assert(index >= 0 && index < titles.length, 'Can not find a title for index $index');
    // note: this offset eliminates a subpixel line Flutter draws below the header
    return Transform.translate(
      offset: Offset(0, 1),
      child: SizedBox(
        height: barSize,
        child: Stack(
          children: [
            // Bg
            BottomCenter(child: Container(height: barSize - barTopPadding, color: $styles.colors.offWhite)),

            ClipRect(
              child: OverflowBox(
                alignment: Alignment.topCenter,
                maxHeight: circleSize,
                child: _AnimatedCircleWithText(titles: titles, index: index),
              ),
            ),

            BottomCenter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Image.asset('${ImagePaths.common}/${icons[index]}')
                    .animate(key: ValueKey(index))
                    .fade()
                    .scale(begin: .5, end: 1, curve: Curves.easeOutBack, duration: $styles.times.med),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCircleWithText extends StatefulWidget {
  const _AnimatedCircleWithText({
    Key? key,
    required this.titles,
    required this.index,
  }) : super(key: key);

  final List<String> titles;
  final int index;

  @override
  State<_AnimatedCircleWithText> createState() => _AnimatedCircleWithTextState();
}

class _AnimatedCircleWithTextState extends State<_AnimatedCircleWithText> with SingleTickerProviderStateMixin {
  int _prevIndex = -1;
  String get oldTitle => _prevIndex == -1 ? '' : widget.titles[_prevIndex];
  String get newTitle => widget.titles[widget.index];
  late final _anim = AnimationController(
    vsync: this,
    duration: $styles.times.med,
  )..forward();

  bool get isAnimStopped => _anim.value == 0 || _anim.value == _anim.upperBound;

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _AnimatedCircleWithText oldWidget) {
    // Spin 180 degrees each time index changes
    if (oldWidget.index != widget.index) {
      _prevIndex = oldWidget.index;
      // If the animation is already in motion, we don't need to interrupt it, just let the text change
      if (isAnimStopped) {
        _anim.forward(from: 0);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(_) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        var rot = _prevIndex > widget.index ? -pi : pi;
        return Transform.rotate(
          angle: Curves.easeInOut.transform(_anim.value) * rot,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: $styles.colors.offWhite),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16),
              // 2 circles that are counter rotated / opposite (one on top, one on bottom)
              // Each time index is changed, the stack is rotated 180 degrees.
              // When the animation completes, the rotation snaps back to 0 and the titles also swap position
              // This creates the effect of a new title always rolling in, with the old rolling out
              child: Semantics(
                label: newTitle,
                child: Stack(
                  children: [
                    Transform.rotate(
                      angle: _anim.isCompleted ? rot : 0,
                      child: _buildCircularText(_anim.isCompleted ? newTitle : oldTitle),
                    ),
                    if (!_anim.isCompleted) ...[
                      Transform.rotate(
                        angle: _anim.isCompleted ? 0 : rot,
                        child: _buildCircularText(_anim.isCompleted ? oldTitle : newTitle),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircularText(String title) {
    final textStyle = $styles.text.monoTitleFont.copyWith(fontSize: 22, color: $styles.colors.accent1);
    return CircularText(
      position: CircularTextPosition.inside,
      children: [
        TextItem(
          text: Text(title.toUpperCase(), style: textStyle),
          space: 9,
          startAngle: -90,
          startAngleAlignment: StartAngleAlignment.center,
          direction: CircularTextDirection.clockwise,
        ),
      ],
    );
  }
}



////////////////////////


class _ScrollingContent extends StatelessWidget {
  const _ScrollingContent(this.data, {Key? key, required this.scrollPos, required this.sectionNotifier})
      : super(key: key);
  final WonderData data;
  final ValueNotifier<double> scrollPos;
  final ValueNotifier<int> sectionNotifier;

  String _fixNewlines(String text) {
    const nl = '\n';
    final chunks = text.split(nl);
    while (chunks.last == nl) {
      chunks.removeLast();
    }
    chunks.removeWhere((element) => element.trim().isEmpty);
    final result = chunks.join('$nl$nl');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Text buildText(String value) => Text(_fixNewlines(value), style: $styles.text.body);

    Widget buildDropCapText(String value) {
      final TextStyle dropStyle = $styles.text.dropCase;
      final TextStyle bodyStyle = $styles.text.body;
      final String dropChar = value.substring(0, 1);
      final textScale = MediaQuery.of(context).textScaleFactor;
      final double dropCapWidth = StringUtils.measure(dropChar, dropStyle).width * textScale;
      final bool skipCaps = !localeLogic.isEnglish;
      return Semantics(
        label: value,
        child: ExcludeSemantics(
          child: !skipCaps
              ? DropCapText(
            _fixNewlines(value).substring(1),
            dropCap: DropCap(
              width: dropCapWidth,
              height: $styles.text.body.fontSize! * $styles.text.body.height! * 2,
              child: Transform.translate(
                offset: Offset(0, bodyStyle.fontSize! * (bodyStyle.height! - 1) - 2),
                child: Text(
                  dropChar,
                  overflow: TextOverflow.visible,
                  style: $styles.text.dropCase.copyWith(
                    color: $styles.colors.accent1,
                    height: 1,
                  ),
                ),
              ),
            ),
            style: $styles.text.body,
            dropCapPadding: EdgeInsets.only(right: 6),
            dropCapStyle: $styles.text.dropCase.copyWith(
              color: $styles.colors.accent1,
              height: 1,
            ),
          )
              : Text(value, style: bodyStyle),
        ),
      );
    }

    Widget buildHiddenCollectible({required int slot}) {
      List<WonderType> getTypesForSlot(slot) {
        switch (slot) {
          case 0:
            return [WonderType.chichenItza, WonderType.colosseum];
          case 1:
            return [WonderType.pyramidsGiza, WonderType.petra];
          case 2:
            return [WonderType.machuPicchu, WonderType.christRedeemer];
          default:
            return [WonderType.tajMahal, WonderType.greatWall];
        }
      }

      return HiddenCollectible(
        data.type,
        index: 0,
        matches: getTypesForSlot(slot),
        size: 128,
      );
    }

    return SliverBackgroundColor(
      color: $styles.colors.offWhite,
      sliver: SliverPadding(
        padding: EdgeInsets.symmetric(vertical: $styles.insets.md),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            ..._contentSection([
              Center(child: buildHiddenCollectible(slot: 0)),

              /// History 1
              buildDropCapText(data.historyInfo1),

              /// Quote1
              _CollapsingPullQuoteImage(data: data, scrollPos: scrollPos),
              Center(child: buildHiddenCollectible(slot: 1)),

              /// Callout1
              ////////////_Callout(text: data.callout1),

              /// History 2
              buildText(data.historyInfo2),
              ////////_SectionDivider(scrollPos, sectionNotifier, index: 1),

              /// Construction 1
              buildDropCapText(data.constructionInfo1),
              Center(child: buildHiddenCollectible(slot: 2)),
            ]),
            Gap($styles.insets.md),
            _YouTubeThumbnail(id: data.videoId, caption: data.videoCaption),
            Gap($styles.insets.md),
            ..._contentSection([
              /// Callout2
              Gap($styles.insets.xs),
              //_Callout(text: data.callout2),

              /// Construction 2
              buildText(data.constructionInfo2),
              ///////////_SlidingImageStack(scrollPos: scrollPos, type: data.type),
              ///////_SectionDivider(scrollPos, sectionNotifier, index: 2),

              /// Location
              buildDropCapText(data.locationInfo1),
              ///////_LargeSimpleQuote(text: data.pullQuote2, author: data.pullQuote2Author),
              buildText(data.locationInfo2),
            ]),
            Gap($styles.insets.md),
            _MapsThumbnail(data, height: 200),
            Gap($styles.insets.md),
            ..._contentSection([Center(child: buildHiddenCollectible(slot: 3))]),
          ]),
        ),
      ),
    );
  }

  /// Helper widget to provide hz padding to multiple widgets. Keeps the layout of the scrolling content cleaner.
  List<Widget> _contentSection(List<Widget> children) {
    return [
      for (int i = 0; i < children.length - 1; i++) ...[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: $styles.insets.md),
          child: children[i],
        ),
        Gap($styles.insets.md)
      ],
      Padding(
        padding: EdgeInsets.symmetric(horizontal: $styles.insets.md),
        child: children.last,
      ),
    ];
  }

  _CollapsingPullQuoteImage({required WonderData data, required ValueNotifier<double> scrollPos}) {}
}

class _YouTubeThumbnail extends StatelessWidget {
  const _YouTubeThumbnail({Key? key, required this.id, required this.caption}) : super(key: key);
  final String id;
  final String caption;

  String get imageUrl => 'http://img.youtube.com/vi/$id/hqdefault.jpg';

  @override
  Widget build(BuildContext context) {
    void handlePressed() => context.push(ScreenPaths.video(id));
    return MergeSemantics(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          children: [
            AppBtn.basic(
              semanticLabel: $strings.scrollingContentSemanticYoutube,
              onPressed: handlePressed,
              child: Stack(children: [
                AppImage(image: NetworkImage(imageUrl), fit: BoxFit.cover, scale: 1.0),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all($styles.insets.xs),
                      decoration: BoxDecoration(
                        color: $styles.colors.black.withOpacity(0.66),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: $styles.colors.white,
                        size: $styles.insets.xl,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Gap($styles.insets.xs),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: $styles.insets.md),
                child: Text(caption, style: $styles.text.caption)),
          ],
        ),
      ),
    );
  }
}

class _MapsThumbnail extends StatefulWidget {
  const _MapsThumbnail(this.data, {Key? key, required this.height}) : super(key: key);
  final WonderData data;
  final double height;

  @override
  State<_MapsThumbnail> createState() => _MapsThumbnailState();
}

class _MapsThumbnailState extends State<_MapsThumbnail> {
  CameraPosition get startPos => CameraPosition(target: LatLng(widget.data.lat, widget.data.lng), zoom: 3);

  @override
  Widget build(BuildContext context) {
    void handlePressed() => context.push(ScreenPaths.maps(widget.data.type));
    return MergeSemantics(
      child: Column(
        children: [
          SizedBox(
            height: widget.height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular($styles.corners.md),
              child: AppBtn.basic(
                semanticLabel: $strings.scrollingContentSemanticOpen,
                onPressed: handlePressed,

                /// To prevent the map widget from absorbing the onPressed action, use a Stack + IgnorePointer + a transparent Container
                child: Stack(
                  children: [
                    Positioned.fill(child: ColoredBox(color: Colors.transparent)),
                    IgnorePointer(
                      child: GoogleMap(
                        markers: {getMapsMarker(startPos.target)},
                        zoomControlsEnabled: false,
                        mapType: MapType.normal,
                        mapToolbarEnabled: false,
                        initialCameraPosition: startPos,
                        myLocationButtonEnabled: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Gap($styles.insets.xs),
          Semantics(
            sortKey: OrdinalSortKey(0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: $styles.insets.md),
              child: Text(widget.data.mapCaption, style: $styles.text.caption),
            ),
          ),
        ],
      ),
    );
  }
}

class SliverBackgroundColor extends SingleChildRenderObjectWidget {
  const SliverBackgroundColor({
    Key? key,
    required this.color,
    Widget? sliver,
  }) : super(key: key, child: sliver);

  final Color color;

  @override
  RenderSliverBackgroundColor createRenderObject(BuildContext context) {
    return RenderSliverBackgroundColor(
      color,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderSliverBackgroundColor renderObject) {
    renderObject.color = color;
  }
}

class RenderSliverBackgroundColor extends RenderProxySliver {
  RenderSliverBackgroundColor(this._color);

  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (value == color) {
      return;
    }
    _color = color;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && child!.geometry!.visible) {
      final SliverPhysicalParentData childParentData = child!.parentData! as SliverPhysicalParentData;
      final Rect childRect =
      offset + childParentData.paintOffset & Size(constraints.crossAxisExtent, child!.geometry!.paintExtent);
      context.canvas.drawRect(
          childRect,
          Paint()
            ..style = PaintingStyle.fill
            ..color = color);
      context.paintChild(child!, offset + childParentData.paintOffset);
    }
  }
}

//////


class _TitleText extends StatelessWidget {
  const _TitleText(this.data, {Key? key, required this.scroller}) : super(key: key);
  final WonderData data;
  final ScrollController scroller;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: DefaultTextColor(
        color: $styles.colors.offWhite,
        child: StaticTextScale(
          child: Column(
            children: [
              Gap($styles.insets.md),
              Gap(30),

              /// Sub-title row
              SeparatedRow(
                padding: EdgeInsets.symmetric(horizontal: $styles.insets.sm),
                separatorBuilder: () => Gap($styles.insets.sm),
                children: [
                  Expanded(
                    child: Divider(
                      color: data.type.fgColor,
                    ).animate().scale(curve: Curves.easeOut, delay: 500.ms),
                  ),
                  Semantics(
                    header: true,
                    sortKey: OrdinalSortKey(1),
                    child: Text(
                      data.subTitle.toUpperCase(),
                      style: $styles.text.title2,
                    ).animate().fade(delay: 100.ms),
                  ),
                  Expanded(
                    child: Divider(
                      color: data.type.fgColor,
                    ).animate().scale(curve: Curves.easeOut, delay: 500.ms),
                  ),
                ],
              ),
              Gap($styles.insets.md),

              /// Wonder title text
              Semantics(
                sortKey: OrdinalSortKey(0),
                child: AnimatedBuilder(
                    animation: scroller,
                    builder: (_, __) {
                      final yPos = ContextUtils.getGlobalPos(context)?.dy ?? 0;
                      bool enableHero = yPos > -100;
                      return WonderTitleText(data, enableHero: enableHero);
                    }),
              ),
              Gap($styles.insets.xs),

              /// Region
              Text(
                data.regionTitle.toUpperCase(),
                style: $styles.text.title1,
                textAlign: TextAlign.center,
              ),
              Gap($styles.insets.md),

              /// Compass divider
              ExcludeSemantics(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: $styles.insets.md),
                  child: AnimatedBuilder(
                    animation: scroller,
                    builder: (_, __) => CompassDivider(
                      isExpanded: scroller.position.pixels <= 0,
                      linesColor: data.type.fgColor,
                      compassColor: $styles.colors.offWhite,
                    ),
                  ),
                ),
              ),
              Gap($styles.insets.sm),

              /// Date
              Text(
                StringUtils.supplant(
                  $strings.titleLabelDate,
                  {
                    '{fromDate}': StringUtils.formatYr(data.startYr),
                    '{endDate}': StringUtils.formatYr(data.endYr),
                  },
                ),
                style: $styles.text.h4,
                textAlign: TextAlign.center,
              ),
              Gap($styles.insets.sm),
            ],
          ),
        ),
      ),
    );
  }
}


/////////////////////