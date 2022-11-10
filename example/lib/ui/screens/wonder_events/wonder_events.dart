import 'package:yourinrolltoolstabbar_example/common_libs.dart';
import 'package:yourinrolltoolstabbar_example/logic/common/string_utils.dart';
import 'package:yourinrolltoolstabbar_example/logic/data/wonder_data.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/app_backdrop.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/compass_divider.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/curved_clippers.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/hidden_collectible.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/list_gradient.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/pop_router_on_over_scroll.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/themed_text.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/timeline_event_card.dart';
import 'package:yourinrolltoolstabbar_example/ui/common/wonders_timeline_builder.dart';
import 'package:yourinrolltoolstabbar_example/ui/wonder_illustrations/common/wonder_title_text.dart';

part 'widgets/_events_list.dart';
part 'widgets/_top_content.dart';

class WonderEvents extends StatelessWidget {
  static const double _topHeight = 450;
  WonderEvents({Key? key, required this.type}) : super(key: key);
  final WonderType type;
  late final _data = wondersLogic.getData(type);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return Container(
        color: $styles.colors.black,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              /// Top content, sits underneath scrolling list
              _TopContent(data: _data),

              /// Scrolling Events list, takes up the full view
              _EventsList(data: _data),
            ],
          ),
        ),
      );
    });
  }
}
