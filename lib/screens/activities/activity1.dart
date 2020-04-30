import 'package:flutter/material.dart';
import 'package:spark/constants.dart';

import 'package:rubber/rubber.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wave_slider/wave_slider.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import 'package:spark/config_data.dart';

import 'package:spark/screens/home_screen.dart';

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
  int switch1 = 0;
  int switch2 = 0;

  int port1key = null;
  List<String> port1List = PWMPinsLIST;
  String selectedPort1 = PWMPinsLIST[0];

  int port2key = null;
  List<String> port2List = PWMPinsLIST;
  String selectedPort2 = PWMPinsLIST[0];

  List<DropdownMenuItem> getDropdownItems(List<String> portList) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String port in portList) {
      var newItem = DropdownMenuItem(
        child: Text(port),
        value: port,
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  @override
  void initState() {
    _controller = RubberAnimationController(
        vsync: this,
        upperBoundValue: AnimationControllerValue(percentage: 0.78),
        lowerBoundValue: AnimationControllerValue(percentage: 0.1),
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
      resizeToAvoidBottomInset: false,
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
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Text(
                'Control Panel',
                style: GoogleFonts.montserrat(
                  textStyle: kControlPanelTitle,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Flexible(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: WaveSlider(
                      color: Color(0xFFe42c64),
                      displayTrackball: false,
                      sliderHeight: 50,
                      onChanged: (double dragUpdate) {
                        setState(() {
                          _dragPercentage1 = dragUpdate *
                              100; // dragUpdate is a fractional value between 0 and 1
                          String dataValues =
                              "Slider1: ${_dragPercentage1.toStringAsFixed(2)}";
                          print(dataValues);
                          writeData(dataValues);
                        });
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Slider 1',
                        style: GoogleFonts.montserrat(
                          textStyle: kSliderText,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${_dragPercentage1.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: WaveSlider(
                      color: Color(0xFFe42c64),
                      displayTrackball: false,
                      sliderHeight: 50,
                      onChanged: (double dragUpdate) {
                        setState(() {
                          _dragPercentage2 = dragUpdate *
                              100; // dragUpdate is a fractional value between 0 and 1
                          String dataValues =
                              "Slider2: ${_dragPercentage2.toStringAsFixed(2)}";
                          print(dataValues);
                          writeData(dataValues);
                        });
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Slider 2',
                        style: GoogleFonts.montserrat(
                          textStyle: kSliderText,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${_dragPercentage2.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Flexible(
              flex: 2,
              child: Row(
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
                        switch1 = state ? 1 : 0;
                        print('switch 1: turned ${(state) ? 'on' : 'off'}');
                        String dataValues = "Switch1: $switch1";
                        print(dataValues);
                        writeData(dataValues);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Flexible(
              flex: 2,
              child: Row(
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
                        switch2 = state ? 1 : 0;
                        print('switch 2: turned ${(state) ? 'on' : 'off'}');
                        String dataValues = "Switch2: $switch2";
                        print(dataValues);
                        writeData(dataValues);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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
            color: Color(0xCC202020),
            blurRadius: 20.0, // has the effect of softening the shadow
            spreadRadius: 5.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              0.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: 1000,
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
                SizedBox(
                  height: 10.0,
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0x44333333),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 40.0, right: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Port 1',
                          style: kSliderText,
                        ),
                        DropdownButton<String>(
                          value: selectedPort1,
                          items: getDropdownItems(port1List),
                          onChanged: (value) {
                            setState(() {
                              selectedPort1 = value;
                              port1key = PWMPins.keys.firstWhere(
                                  (k) => PWMPins[k] == selectedPort1,
                                  orElse: () => null);
                              String dataPorts = "Port1: $port1key";
                              print(dataPorts);
                              writeData(dataPorts);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0x44333333),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 40.0, right: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Port 2',
                          style: kSliderText,
                        ),
                        DropdownButton<String>(
                          value: selectedPort2,
                          items: getDropdownItems(port2List),
                          onChanged: (value) {
                            setState(() {
                              selectedPort2 = value;
                              port2key = PWMPins.keys.firstWhere(
                                  (k) => PWMPins[k] == selectedPort2,
                                  orElse: () => null);
                              String dataPorts = "Port2: $port2key";
                              print(dataPorts);
                              writeData(dataPorts);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
