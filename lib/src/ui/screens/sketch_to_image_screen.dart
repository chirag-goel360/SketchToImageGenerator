import 'package:flutter/material.dart';
import 'package:humangenerator/src/ui/common/safe_area.dart';
import 'package:humangenerator/src/ui/screens/sketch_to_image.dart';
import 'package:humangenerator/src/utils/colors.dart';

class SketchToFaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShipsyColors.SECONDARY_LIGHT,
       body: ShipsySafeArea(
          child: Home()
        ),
    );
  }
}