import 'package:flutter/material.dart';
import 'package:spark/auth_fb.dart';
import 'package:spark/constants.dart';
import 'package:spark/components/activity_card.dart';
import 'package:spark/screens/activities/activity1.dart';
import 'package:spark/screens/activities/activity2.dart';
import 'package:spark/screens/activities/activity3.dart';
import 'package:spark/screens/welcome_screen.dart';

//decorative package
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:spark/auth_google.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackground,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 30.0, right: 30.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Spark',
                    style: GoogleFonts.montserrat(
                      textStyle: kHomeTitleStyle,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(FontAwesomeIcons.signOutAlt),
                          color: kAppBlue,
                          iconSize: 30,
                          onPressed: () {
                            //Implement logout functionality
                            authServiceGoogle.signOut();
                            authServiceFB.logout();
                            Navigator.pushNamed(context, WelcomeScreen.id);
                          }),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(30.0),
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pushNamed(context, Activity1.id);
                      });
                    },
                    child: ActivityCard(
                      flare: 'switch',
                      activityTitle: 'Switch Control',
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pushNamed(context, Activity2.id);
                      });
                    },
                    child: ActivityCard(
                      flare: 'switch',
                      activityTitle: 'Motor Stepper',
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pushNamed(context, Activity3.id);
                      });
                    },
                    child: ActivityCard(
                      flare: 'switch',
                      activityTitle: 'Tone Generator',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
