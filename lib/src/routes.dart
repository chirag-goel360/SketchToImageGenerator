import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:humangenerator/drawboard/main_drawboard.dart';
import 'package:humangenerator/snappy/main_snappy.dart';
import 'package:humangenerator/src/ui/screens/face_conversion/sketch_to_image_screen.dart';
import 'package:humangenerator/src/ui/screens/hand_bag_conversion/bag_conversion.dart';
import 'package:humangenerator/src/ui/screens/shoe_conversion/shoe_to_image.dart';
import 'package:humangenerator/src/ui/screens/splashscreen.dart';

class ProjectRouter {
  ProjectRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget Function(BuildContext context) builder;
    switch (settings.name) {
      case Routes.SPLASH:
        builder = (context) => SketchSplashScreen();
        break;
      case Routes.SKETCHTOFACE:
        builder = (context) => SketchToFaceScreen();
        break;
      case Routes.MYSNAPPY:
        builder = (context) => MyAppSnappy();
        break;
      case Routes.DRAWBOARD:
        builder = (context) => DrawingApp();
        break;
      case Routes.SHOESKETCh:
        builder = (context) => ShoeImage();
        break;
      case Routes.HANDBAGSKETCH:
        builder = (context) => Handbag();
        break;
      default:
        builder = (context) => SketchToFaceScreen();
    }
    return MaterialPageRoute(
      settings: settings,
      builder: builder,
    );
  }
}

class Routes {
  Routes._();
  static const String SPLASH = '';
  static const String SKETCHTOFACE = '/sketchToFace';
  static const String SHOESKETCh = '/shoesketch';
  static const String HANDBAGSKETCH = '/bagsketch';
  static const String MYSNAPPY = '/snappy';
  static const String DRAWBOARD = '/drawboard';
}
