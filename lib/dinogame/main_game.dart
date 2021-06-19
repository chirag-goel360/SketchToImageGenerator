import 'package:flutter/material.dart';
import 'screens/main_menu.dart';

class MyAppGame extends StatefulWidget {

  @override
  _MyAppGameState createState() => _MyAppGameState();
}

class _MyAppGameState extends State<MyAppGame> {
  @override
  void initState(){
    super.initState();
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
