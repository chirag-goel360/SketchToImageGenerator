import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:humangenerator/src/localisation.dart';
import 'package:humangenerator/src/ui/common/app_bar.dart';
import 'package:humangenerator/src/ui/common/card.dart';
import 'package:humangenerator/src/ui/common/loading_indicator.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:humangenerator/src/utils/drawingarea.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/sized_boxes.dart';
import 'package:humangenerator/src/utils/strings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class HandBagConversionConsumer extends StatefulWidget {
  @override
  _HandBagConversionConsumerState createState() => _HandBagConversionConsumerState();
}

class _HandBagConversionConsumerState extends State<HandBagConversionConsumer> {
  List<DrawingArea> points = [];
  Widget imageOutput;
  var img1;
  final picker = ImagePicker();
  bool loading = false;

  void loadImage(File file) {
    setState(() {
      img1 = Image.file(file);
    });
  }

  void saveToImage(List<DrawingArea> points) async {
    final recorder = ui.PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(200, 200)));
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, 256, 256), paint2);
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i].point, points[i + 1].point, paint);
      }
    }
    final picture = recorder.endRecording();
    final img = await picture.toImage(256, 256);
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    final listBytes = Uint8List.view(pngBytes.buffer);
    File file = await writeBytes(listBytes);
    String base64 = base64Encode(listBytes);
    fetchResponse(base64);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/test.png');
  }

  Future<File> writeBytes(listBytes) async {
    final file = await _localFile;

    return file.writeAsBytes(listBytes, flush: true);
  }

  void fetchResponse(var base64Image) async {
    // String base64 = base64Encode(base64Image);
    setState(() {
      loading = true;
    });
    var data = {"Image": base64Image};
    var url = 'http://192.168.0.107:5000/predict';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Connection': 'Keep-Alive',
    };
    var body = json.encode(data);
    try {
      var response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      print(response.statusCode);
      final Map<String, dynamic> responseData = json.decode(response.body);
      String outputBytes = responseData['Image'];
      print(outputBytes.substring(2, outputBytes.length - 1));
      displayResponseImage(outputBytes.substring(2, outputBytes.length - 1));
    } catch (e) {
      print(e);
      print("Error has Occured");
      setState(() {
        loading =false;
      });
      return null;
    }
  }

  void displayResponseImage(String bytes) async {
    Uint8List convertedBytes = base64Decode(bytes);
    setState(() {
      loading = false;
      imageOutput = Container(
        width: 256,
        height: 256,
        child: Image.memory(convertedBytes, fit: BoxFit.cover),
      );
    });
  }

  void pickImage() async {
    // var file = await picker.getImage(source: ImageSource.gallery);
    // //
    // setState(() {
    //   if (file != null) {
    //     var _image = File(file.path);
    //     print(_image);
    //     fetchResponse(_image.);
    //   } else {
    //     print('No image selected.');
    //   }
    // });

    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path);
      loadImage(file);
      fetchResponse(file);
    } else {
      print("File Picking error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _translate = AppLocalization.of(context).translate;
    final _textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    Widget _buildMobileUI() {
      return Container(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProjectAppBar(
                    icon: 'assets/module_icons/sketchHuman.png',
                    title: _translate(Strings.BAG_TO_IMAGE)),
                Padding(
                  padding: ProjectEdgeInsets.ALL_10,
                  child: Container(
                    height: size.height * 0.41,
                    width: 310,
                    child: ProjectCard(
                      heading: _translate(Strings.SKETCH_BOARD),
                      headingSuffix: Row(
                        children: [
                          GestureDetector(
                            child: Icon(
                              Icons.layers_clear,
                              color: Colors.black,
                            ),
                            onTap: () {
                              this.setState(() {
                                points.clear();
                              });
                            },
                          ),
                          ProjectSizedBoxes.WIDTH_3,
                          GestureDetector(
                            child: Icon(
                              Icons.save,
                              color: Colors.black,
                            ),
                            onTap: () {
                              saveToImage(points);
                            },
                          ),
                          ProjectSizedBoxes.WIDTH_3,
                          GestureDetector(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                            onTap: () {
                              pickImage();
                            },
                          ),
                        ],
                      ),
                      body: Padding(
                        padding: ProjectEdgeInsets.TOP_10,
                        child: Container(
                          width: 256,
                          height: 256,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 5.0,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onPanDown: (details) {
                              this.setState(() {
                                points.add(
                                  DrawingArea(
                                      point: details.localPosition,
                                      areaPaint: Paint()
                                        ..strokeCap = StrokeCap.round
                                        ..isAntiAlias = true
                                        ..color = Colors.white
                                        ..strokeWidth = 2.0),
                                );
                              });
                            },
                            onPanUpdate: (details) {
                              this.setState(() {
                                points.add(
                                  DrawingArea(
                                      point: details.localPosition,
                                      areaPaint: Paint()
                                        ..strokeCap = StrokeCap.round
                                        ..isAntiAlias = true
                                        ..color = Colors.white
                                        ..strokeWidth = 2.0),
                                );
                              });
                            },
                            onPanEnd: (details) {
                              saveToImage(points);
                              this.setState(() {
                                points.add(null);
                              });
                            },
                            child: SizedBox.expand(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                child: CustomPaint(
                                  painter: MyCustomPainter(
                                    points: points,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ProjectSizedBoxes.HEIGHT_5,
                Container(
                  height: size.height * 0.38,
                  width: 310,
                  child: ProjectCard(
                    heading: _translate(Strings.OUTPUT_BOARD),
                    body: Container(
                      height: 256,
                      width: 256,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: loading ? CenterLoadingIndicator() : imageOutput,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _buildWebUI() {
      return Column(
        children: [
          SingleChildScrollView(
            child: Container(
              height: size.height,
              child: Column(
                children: [
                  ProjectAppBar(
                      icon: 'assets/module_icons/sketchHuman.png',
                      title: _translate(Strings.SKETCH_TO_IMAGE)),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 500,
                          width: 600,
                          padding: ProjectEdgeInsets.ALL_10,
                          child: ProjectCard(
                            tray: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.layers_clear,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    this.setState(() {
                                      points.clear();
                                    });
                                  },
                                ),
                              ],
                            ),
                            heading: _translate(Strings.SKETCH_BOARD),
                            padding: ProjectEdgeInsets.ALL_10,
                            // bodyHeight:550,
                            body: Container(
                              width: 256,
                              height: 256,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 5.0,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onPanDown: (details) {
                                  this.setState(() {
                                    points.add(
                                      DrawingArea(
                                          point: details.localPosition,
                                          areaPaint: Paint()
                                            ..strokeCap = StrokeCap.round
                                            ..isAntiAlias = true
                                            ..color = Colors.white
                                            ..strokeWidth = 2.0),
                                    );
                                  });
                                },
                                onPanUpdate: (details) {
                                  this.setState(() {
                                    points.add(
                                      DrawingArea(
                                          point: details.localPosition,
                                          areaPaint: Paint()
                                            ..strokeCap = StrokeCap.round
                                            ..isAntiAlias = true
                                            ..color = Colors.white
                                            ..strokeWidth = 2.0),
                                    );
                                  });
                                },
                                onPanEnd: (details) {
                                  saveToImage(points);
                                  this.setState(() {
                                    points.add(null);
                                  });
                                },
                                child: SizedBox.expand(
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    child: CustomPaint(
                                      painter: MyCustomPainter(
                                        points: points,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ProjectSizedBoxes.WIDTH_10,
                        Container(
                          height: 500,
                          width: 600,
                          padding: ProjectEdgeInsets.ALL_10,
                          child: ProjectCard(
                            heading: _translate(Strings.OUTPUT_BOARD),
                            padding: ProjectEdgeInsets.ALL_10,
                            bodyHeight: 256,
                            body: Container(
                              height: 256,
                              width: 256,
                              child: imageOutput,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return VxDevice(mobile: _buildMobileUI(), web: _buildWebUI());
  }
}
