import 'package:flutter/material.dart';
import 'package:spark/constants.dart';

import 'package:rubber/rubber.dart';
import 'package:google_fonts/google_fonts.dart';

//decorative packages
import 'package:wave_slider/wave_slider.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:spark/config_data.dart';

import 'package:spark/screens/home_screen.dart';

class Activity2 extends StatefulWidget {
  static String id = 'activity_2';

  @override
  _Activity2State createState() => _Activity2State();
}

class _Activity2State extends State<Activity2>
    with SingleTickerProviderStateMixin {
  RubberAnimationController _controller;

  double _dragPercentage1 = 0;
  double _dragPercentage2 = 0;
  int switch1 = 0;

  int port1key = null;
  List<String> port1List = PWMPinsLIST;
  String selectedPort1 = PWMPinsLIST[0];

  int port2key = null;
  List<String> port2List = PWMPinsLIST;
  String selectedPort2 = PWMPinsLIST[0];

  int port3key = null;
  List<String> port3List = PWMPinsLIST;
  String selectedPort3 = PWMPinsLIST[0];

  int port4key = null;
  List<String> port4List = PWMPinsLIST;
  String selectedPort4 = PWMPinsLIST[0];

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
          "Motor Stepper",
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
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Color(0xFFFF2957),
            Color(0xFFEF2957),
            Color(0xFFE72947),
            Color(0xFFD51930),
          ],
        ),
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
              height: 25.0,
            ),
            Flexible(
              flex: 4,
              child: Center(
                child: SleekCircularSlider(
                    min: 0,
                    max: 100,
                    appearance: CircularSliderAppearance(
                      customColors: CustomSliderColors(
                        dotColor: Color(0xFF005FE0),
                        progressBarColor: Color(0xFF003FC0),
                        trackColor: Color(0xFFDDDDDD),
                        hideShadow: true,
                      ),
                      infoProperties: InfoProperties(
                        topLabelText: 'Frequency',
                        topLabelStyle: GoogleFonts.montserrat(
                          textStyle: kSliderText,
                        ),
                        mainLabelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onChange: (double dragUpdate) {
                      setState(() {
                        _dragPercentage1 =
                            dragUpdate; // dragUpdate is a fractional value between 0 and 1
                        String dataValues =
                            "activity2::Slider1: ${_dragPercentage1.toStringAsFixed(2)}";
                        print(dataValues);
                        writeData(dataValues);
                      });
                    }),
              ),
            ),
            Flexible(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: WaveSlider(
                      color: Color(0xFF003FC0),
                      displayTrackball: false,
                      sliderHeight: 50,
                      onChanged: (double dragUpdate) {
                        setState(() {
                          _dragPercentage2 = dragUpdate *
                              180; // dragUpdate is a fractional value between 0 and 1
                          String dataValues =
                              "activity2::Slider2: ${_dragPercentage2.toStringAsFixed(2)}";
                          print(dataValues);
                          writeData(dataValues);
                        });
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, left: 8.0, right: 8.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '0',
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            '45',
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            '90',
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            '135',
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            '180',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Phase Shift',
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
              height: 20.0,
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
                      'Motor Power',
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
                      colorOff: Colors.grey,
                      iconOn: Icons.lightbulb_outline,
                      iconOff: Icons.power_settings_new,
                      onChanged: (bool state) {
                        switch1 = state ? 1 : 0;
                        print('switch 1: turned ${(state) ? 'on' : 'off'}');
                        String dataValues = "activity2::Switch1: $switch1";
                        print(dataValues);
                        writeData(dataValues);
                      },
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
                              String dataPorts = "activity2::Port1: $port1key";
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
                              String dataPorts = "activity2::Port2: $port2key";
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
                          'Port 3',
                          style: kSliderText,
                        ),
                        DropdownButton<String>(
                          value: selectedPort3,
                          items: getDropdownItems(port3List),
                          onChanged: (value) {
                            setState(() {
                              selectedPort3 = value;
                              port3key = PWMPins.keys.firstWhere(
                                  (k) => PWMPins[k] == selectedPort3,
                                  orElse: () => null);
                              String dataPorts = "activity2::Port3: $port3key";
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
                          'Port 4',
                          style: kSliderText,
                        ),
                        DropdownButton<String>(
                          value: selectedPort4,
                          items: getDropdownItems(port4List),
                          onChanged: (value) {
                            setState(() {
                              selectedPort4 = value;
                              port4key = PWMPins.keys.firstWhere(
                                  (k) => PWMPins[k] == selectedPort4,
                                  orElse: () => null);
                              String dataPorts = "activity2::Port4: $port4key";
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
