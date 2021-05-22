import 'package:flutter/material.dart';
import 'package:humangenerator/src/localisation.dart';
import 'package:humangenerator/src/routes.dart';
import 'package:humangenerator/src/ui/common/iconbutton.dart';
import 'package:humangenerator/src/ui/common/safe_area.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/sized_boxes.dart';
import 'package:humangenerator/src/utils/strings.dart';

class ProjectDrawer extends StatefulWidget {
  @override
  _ProjectDrawerState createState() => _ProjectDrawerState();
}

class _ProjectDrawerState extends State<ProjectDrawer> {
  @override
  Widget build(BuildContext context) {
    Widget _buildMenuItem(IconData icon, String name, String routeName) {
      return GestureDetector(
        onTap: () {
          if (ModalRoute.of(context).settings.name != routeName) {
            print(routeName);
            Navigator.pushNamedAndRemoveUntil(
                context, routeName, (route) => false);
          }
        },
        child: Container(
          padding: ProjectEdgeInsets.VERTICAL_15,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 18,
                color: ProjectColors.DEFAULT,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: ProjectColors.DEFAULT,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Widget _buildSmallMenuItem(String str, void Function() onTap) {
    //   return GestureDetector(
    //     onTap: onTap,
    //     child: Container(
    //       padding: ProjectEdgeInsets.VERTICAL_10,
    //       child: Text(
    //         AppLocalization.of(context).translate(str),
    //         style: Theme.of(context).textTheme.bodyText2.copyWith(
    //               color: ProjectColors.DEFAULT,
    //             ),
    //       ),
    //     ),
    //   );
    // }

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: ProjectColors
            .PRIMARY_DARK, // This will change the drawer background to dark blue
      ),
      child: Material(
        elevation: 16,
        child: Container(
          color: ProjectColors.PRIMARY_DARK,
          child: ProjectSafeArea(
            child: Drawer(
              elevation: 0,
              child: Padding(
                padding: ProjectEdgeInsets.VERTICAL_30
                    .add(ProjectEdgeInsets.LEFT_30)
                    .add(ProjectEdgeInsets.RIGHT_20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Menu Heading
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalization.of(context)
                                  .translate(Strings.MENU),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                    color: ProjectColors.DEFAULT,
                                  ),
                            ),
                            ProjectIconButton(
                                icon: Icons.close,
                                theme: ICON_BUTTON_THEMES.DARK,
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                        ProjectSizedBoxes.HEIGHT_20,
                        _buildMenuItem(
                          Icons.insights,
                          AppLocalization.of(context)
                              .translate(Strings.SKETCH_TO_IMAGE),
                          Routes.SKETCHTOFACE,
                        ),
                        _buildMenuItem(
                          Icons.insights,
                          AppLocalization.of(context)
                              .translate(Strings.SHOE_TO_IMAGE),
                          Routes.SHOESKETCh,
                        ),
                        _buildMenuItem(
                          Icons.insights,
                          AppLocalization.of(context)
                              .translate(Strings.BAG_TO_IMAGE),
                          Routes.HANDBAGSKETCH,
                        ),

                        ProjectSizedBoxes.HEIGHT_20,
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: ProjectColors.SECONDARY_DARK,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
