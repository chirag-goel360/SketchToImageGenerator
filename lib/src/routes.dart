import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:humangenerator/src/ui/screens/sketch_to_image_screen.dart';
import 'package:humangenerator/src/ui/screens/splashscreen.dart';

class ProjectRouter{
  ProjectRouter._();

   static Route<dynamic> generateRoute(RouteSettings settings){
     Widget Function(BuildContext context) builder;
     switch (settings.name) {
      case Routes.SPLASH:
        builder = (context) => SketchSplashScreen();
        break;
      case Routes.SKETCHTOFACE:
        builder = (context) => SketchToFaceScreen();
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

class Routes{

  Routes._();
  static const String SPLASH = '';
  static const String SKETCHTOFACE = '/sketchToFace';
}