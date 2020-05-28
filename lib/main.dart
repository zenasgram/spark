import 'package:flutter/material.dart';
import 'package:spark/screens/welcome_screen.dart';
import 'package:spark/screens/home_screen.dart';
import 'package:spark/screens/activities/activity1.dart';
import 'package:spark/screens/activities/activity2.dart';
import 'package:spark/screens/activities/activity3.dart';

import 'package:spark/screens/activities/activity_template.dart';

//bluetooth packages

void main() => runApp(Spark());

class Spark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
//        textTheme: TextTheme(
//          body1: TextStyle(color: Colors.black54),
//            ),
          ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        Activity1.id: (context) => Activity1(),
        Activity2.id: (context) => Activity2(),
        Activity3.id: (context) => Activity3(),
//        Activity4.id: (context) => Activity4(),
      },
    );
  }
}
