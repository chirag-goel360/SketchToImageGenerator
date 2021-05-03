import 'package:flutter/material.dart';
import 'package:humangenerator/src/localisation.dart';
import 'package:humangenerator/src/routes.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:humangenerator/src/utils/strings.dart';

class SketchSplashScreen extends StatefulWidget {
  @override
  _SketchSplashScreenState createState() => _SketchSplashScreenState();
}

class _SketchSplashScreenState extends State<SketchSplashScreen> {
  @override
  Widget build(BuildContext context) {
    final _translate = AppLocalization.of(context).translate;
    final _textTheme = Theme.of(context).textTheme;
    return SplashScreen(
      backgroundColor: ShipsyColors.PRIMARY_DARK,
      seconds: 3,
      routeName: Routes.SKETCHTOFACE,
      title: Text(
        _translate(Strings.SKETCH_TO_IMAGE),
        style: _textTheme.subtitle1,
       ),
       navigateAfterSeconds:  Routes.SKETCHTOFACE,
      loaderColor: ShipsyColors.DEFAULT,
      image: Image.asset(
         'assets/module_icons/sketchHuman.png',
         color: ShipsyColors.DEFAULT,
      ),
      loadingText:Text(
        _translate(Strings.SKETCH_TO_IMAGE),
        style: _textTheme.subtitle2,
       ) ,
       photoSize: 150,
       useLoader: true,
    );
  }
}