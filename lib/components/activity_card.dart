import 'package:flutter/material.dart';
import 'package:spark/constants.dart';

//animation packages
import 'package:flare_flutter/flare_actor.dart';

//decoration packages
import 'package:google_fonts/google_fonts.dart';

class ActivityCard extends StatelessWidget {
  ActivityCard({@required this.flare, @required this.activityTitle});

  final String flare;
  final String activityTitle;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: AnimatedContainer(
//                    width: selected ? 200.0 : 100.0,
//                    height: selected ? 100.0 : 200.0,
//                  color: selected ? Colors.red : Colors.blue,
          height: 240,
          duration: Duration(milliseconds: 50),
          child: FlareActor(
            'assets/$flare.flr',
            alignment: Alignment.center,
            fit: BoxFit.fill,
            animation: 'go',
          ),
        ),
      ),
      Positioned(
        bottom: 10.0,
        left: 15.0,
        child: Text(
          activityTitle,
          style: GoogleFonts.montserrat(
            textStyle: kCardTitleStyle,
          ),
        ),
      ),
    ]);
  }
}
