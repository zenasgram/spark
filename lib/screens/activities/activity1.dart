import 'package:flutter/material.dart';
import 'package:spark/constants.dart';

class Activity1 extends StatefulWidget {
  static String id = 'activity_1';

  @override
  _Activity1State createState() => _Activity1State();
}

class _Activity1State extends State<Activity1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
    );
  }
}
