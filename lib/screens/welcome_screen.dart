//page dependencies
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:spark/screens/home_screen.dart';
import 'package:spark/constants.dart';
import 'package:spark/components/signin_button.dart';

//decorative packages
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:spark/auth_google.dart';
import 'package:spark/auth_fb.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
    );

    controller.forward();
    controller.addListener(() {
//      print(controller.value);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kWelcomeScaffold,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(1.0 - animation.value),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Image.asset('images/logo.png'),
                      height: 120.0 * animation.value,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Spark',
                      style: GoogleFonts.montserrat(
                        textStyle: kLargeTitleStyle,
                      ),
                    ),
                    Text(
                      'by Imperial College London',
                      style: GoogleFonts.montserrat(
                        textStyle: kSmallTitleStyle,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 68.0,
              ),
              SignInButton(
                onPressed: () {
                  authServiceGoogle.googleSignIn().whenComplete(() {
                    Navigator.pushNamed(context, HomeScreen.id);
                  });
                },
                imageName: "google_logo",
                buttonColour: Colors.white,
                textColour: Colors.black54,
                signinText: ' Sign in with Google  ',
              ),
              SizedBox(
                height: 15.0,
              ),
              SignInButton(
                onPressed: () {
                  authServiceFB.loginWithFB().whenComplete(() {
                    Navigator.pushNamed(context, HomeScreen.id);
                  });
                },
                imageName: "facebook_logo",
                buttonColour: Color(0xFF1874EC),
                textColour: Colors.white,
                signinText: 'Login with Facebook',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
