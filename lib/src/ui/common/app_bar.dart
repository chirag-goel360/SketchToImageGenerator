import 'package:humangenerator/src/ui/common/iconbutton.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/sized_boxes.dart';
import 'package:flutter/material.dart';

class ShipsyAppBar extends StatelessWidget {
  final String icon;
  final String title;

  ShipsyAppBar({
    Key key,
    @required this.icon,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _handleMenuPressed() {
      if (!Scaffold.of(context).isEndDrawerOpen) {
        Scaffold.of(context).openEndDrawer();
      }
    }

    return Padding(
      padding: ShipsyEdgeInsets.ALL_10,
      child: Row(
        children: <Widget>[
          Image.asset(
            icon,
            height: 54,
            width: 54,
          ),
          ShipsySizedBoxes.WIDTH_10,
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          ShipsySizedBoxes.WIDTH_20,
          ShipsyIconButton(
            icon: Icons.menu,
            onPressed: _handleMenuPressed,
          ),
        ],
      ),
    );
  }
}
