import 'package:camera_deep_ar/camera_deep_ar.dart';
import 'package:flutter/material.dart';

//Get your API Key from https://www.deepar.ai/
const apikey = "de7cf08460cde902330c0f2a0ecf57cb617adcfdcc122e0ccb99b15eb219f05720549d2fe6d19cbb";

class MyAppSnappy extends StatefulWidget {
  @override
  _MyAppSnappyState createState() => _MyAppSnappyState();
}

class _MyAppSnappyState extends State<MyAppSnappy> {
  CameraDeepArController cameraDeepArController;
  int effectcount = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            CameraDeepAr(
              onCameraReady: (isReady) {
                setState(() {});
              },
              onImageCaptured: (path) {
                setState(() {});
              },
              onVideoRecorded: (path) {
                setState(() {});
              },
              androidLicenceKey: apikey,
              iosLicenceKey: apikey,
              cameraDeepArCallback: (c) async {
                cameraDeepArController = c;
                setState(() {});
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.all(20),
                child: FloatingActionButton(
                  child: Icon(Icons.navigate_next),
                  onPressed: () => {
                    cameraDeepArController.changeMask(effectcount),
                    if (effectcount == 7)
                      {
                        effectcount = 0,
                      },
                    effectcount++,
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
