import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'game/audio_manager.dart';
import 'screens/main_menu.dart';

class MyAppGame extends StatefulWidget {

  @override
  _MyAppGameState createState() => _MyAppGameState();
}

class _MyAppGameState extends State<MyAppGame> {
  @override
  void initState(){
    funforinitialize();
    super.initState();
  }

  Future<void> funforinitialize() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.util.fullScreen();
  await Flame.util.setLandscape();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await AudioManager.instance
      .init(['8Bit Platformer Loop.wav', 'hurt7.wav', 'jump14.wav']);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dino Run',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Audiowide',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainMenu(),
    );
  }
}
