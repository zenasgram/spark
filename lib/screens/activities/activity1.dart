import 'package:flutter/material.dart';
import 'package:spark/constants.dart';

import 'package:rubber/rubber.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wave_slider/wave_slider.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class Activity1 extends StatefulWidget {
  static String id = 'activity_1';

  @override
  _Activity1State createState() => _Activity1State();
}

class _Activity1State extends State<Activity1>
    with SingleTickerProviderStateMixin {
  RubberAnimationController _controller;

  double _dragPercentage1 = 0;
  double _dragPercentage2 = 0;
  bool switch1 = false;
  bool switch2 = false;

  @override
  void initState() {
    _controller = RubberAnimationController(
        vsync: this,
        upperBoundValue: AnimationControllerValue(percentage: 0.78),
        lowerBoundValue: AnimationControllerValue(pixel: 150),
        duration: Duration(milliseconds: 200));
    _controller.addStatusListener(_statusListener);
    _controller.animationState.addListener(_stateListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_statusListener);
    _controller.animationState.removeListener(_stateListener);
    super.dispose();
  }

  void _stateListener() {
    print("state changed ${_controller.animationState.value}");
  }

  void _statusListener(AnimationStatus status) {
    print("changed status ${_controller.status}");
  }

  void _expand() {
    _controller.expand();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202020),
      appBar: AppBar(
        title: Text(
          "Switch Control",
          style: GoogleFonts.montserrat(
            textStyle: kActivityTitleStyle,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: RubberBottomSheet(
          lowerLayer: _getLowerLayer(),
          upperLayer: _getUpperLayer(),
          animationController: _controller,
        ),
      ),
    );
  }

  Widget _getLowerLayer() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Control Panel',
              style: GoogleFonts.montserrat(
                textStyle: kControlPanelTitle,
              ),
              textAlign: TextAlign.start,
            ),
            Column(
              children: <Widget>[
                WaveSlider(
                  color: Color(0xFFe42c64),
                  displayTrackball: true,
                  sliderHeight: 50,
                  onChanged: (double dragUpdate) {
                    setState(() {
                      _dragPercentage1 = dragUpdate *
                          100; // dragUpdate is a fractional value between 0 and 1
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Slider 1',
                    style: GoogleFonts.montserrat(
                      textStyle: kSliderText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$_dragPercentage1',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
            Column(
              children: <Widget>[
                WaveSlider(
                  color: Color(0xFFe42c64),
                  displayTrackball: true,
                  sliderHeight: 50,
                  onChanged: (double dragUpdate) {
                    setState(() {
                      _dragPercentage2 = dragUpdate *
                          100; // dragUpdate is a fractional value between 0 and 1
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Slider 2',
                    style: GoogleFonts.montserrat(
                      textStyle: kSliderText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$_dragPercentage2',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 35.0),
                  child: Text(
                    'Switch 1',
                    style: GoogleFonts.montserrat(
                      textStyle: kSliderText,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, right: 0.0),
                  child: LiteRollingSwitch(
                    value: false,
                    textOn: 'active',
                    textOff: 'inactive',
                    colorOn: Color(0xFF64F58D),
                    colorOff: Colors.blueGrey,
                    iconOn: Icons.lightbulb_outline,
                    iconOff: Icons.power_settings_new,
                    onChanged: (bool state) {
                      switch1 = state;
                      print('switch 1: turned ${(switch1) ? 'on' : 'off'}');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 35.0),
                  child: Text(
                    'Switch 2',
                    style: GoogleFonts.montserrat(
                      textStyle: kSliderText,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, right: 0.0),
                  child: LiteRollingSwitch(
                    value: false,
                    textOn: 'active',
                    textOff: 'inactive',
                    colorOn: Color(0xFF64F58D),
                    colorOff: Colors.blueGrey,
                    iconOn: Icons.lightbulb_outline,
                    iconOff: Icons.power_settings_new,
                    onChanged: (bool state) {
                      switch2 = state;
                      print('switch 2: turned ${(switch2) ? 'on' : 'off'}');
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Color(0xFF2d248a),
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF101010),
            blurRadius: 20.0, // has the effect of softening the shadow
            spreadRadius: 5.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              0.0, // vertical, move down 10
            ),
          )
        ],
      ),
    );
  }

  Widget _getUpperLayer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xAA505050),
            blurRadius: 20.0, // has the effect of softening the shadow
            spreadRadius: 5.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              0.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Configure',
              style: GoogleFonts.montserrat(
                textStyle: kConfigurePanelTitle,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
