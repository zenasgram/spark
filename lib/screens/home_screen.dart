import 'package:flutter/material.dart';
import 'package:spark/constants.dart';
import 'package:flare_flutter/flare_actor.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selected = !selected;
                  });
                },
                child: AnimatedContainer(
//                  width: selected ? 200.0 : 100.0,
//                  height: selected ? 100.0 : 200.0,
//                  color: selected ? Colors.red : Colors.blue,
                  height: 250,
                  width: 150,
                  color: Colors.blue,
                  duration: Duration(seconds: 10),
                  child: FlareActor(
                    'assets/switch.flr',
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                    animation: 'go',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
