//decorative packages
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kAppBlue = Color(0xFF003BC0);
const kHomeBackground = Color(0xFFEFEFEF);

//--------------------------------------

const kWelcomeScaffold = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.5, 0.7, 0.9],
    colors: [
      Color(0xFF003FC0),
      Color(0xFF003BC0),
      Color(0xFF0039A0),
      Color(0xFF001A80),
    ],
  ),
);

const kLargeTitleStyle = TextStyle(
  fontSize: 70.0,
  fontWeight: FontWeight.w500,
);

const kMediumTitleStyle = TextStyle(
  fontSize: 35.0,
  fontWeight: FontWeight.normal,
);

const kSmallTitleStyle = TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
);

const kHomeTitleStyle = TextStyle(
  fontSize: 40.0,
  fontWeight: FontWeight.w600,
  color: kAppBlue,
);

const kCardTitleStyle = TextStyle(
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
);

const kActivityTitleStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.w500,
);

const kControlPanelTitle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w300,
);

const kSliderText = TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
);

const kConfigurePanelTitle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w300,
  color: Colors.black,
);

const kConfigureText = TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

const kConceptToolText = TextStyle(
  color: Colors.black87,
  fontSize: 14.0,
  fontWeight: FontWeight.w300,
);

const kConceptButtonTitle = TextStyle(
  fontSize: 15.0,
  color: Colors.black87,
  fontWeight: FontWeight.w500,
);
