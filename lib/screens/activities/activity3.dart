import 'package:flutter/material.dart';
import 'package:spark/constants.dart';

import 'package:rubber/rubber.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:spark/config_data.dart';
import 'package:spark/screens/home_screen.dart';

//concept tool packages
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flare_flutter/flare_actor.dart';

class Activity3 extends StatefulWidget {
  static String id = 'activity_3';

  @override
  _Activity3State createState() => _Activity3State();
}

class _Activity3State extends State<Activity3>
    with SingleTickerProviderStateMixin {
  var alertStyle = AlertStyle(
    backgroundColor: Color(0xAAFFFFFF),
    animationType: AnimationType.fromBottom,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    animationDuration: Duration(milliseconds: 300),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
      side: BorderSide(
        color: Colors.transparent,
      ),
    ),
    titleStyle: TextStyle(
      color: kAppBlue,
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
    ),
  );

  RubberAnimationController _controller;

  // 0 - Unpressed, 1 - Pressed

  void playKey(int keyNumber) {
    print('key$keyNumber: pressed');
    String dataValues = "activity3::Key$keyNumber: pressed";
    writeData(dataValues);
  }

  void playSharp(int sharpNumber) {
    print('sharp$sharpNumber: pressed');
    String dataValues = "activity3::Sharp$sharpNumber: pressed";
    writeData(dataValues);
  }

  List<bool> _octaveSelect = [false, false, true, false, false];
  List<int> octaveStates = [-2, -1, 0, 1, 2];

  List<bool> _modeSelect = [true, false];
  List<String> modeStates = ["passive", "active"];

  Expanded buildKey(int keyNumber) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: RaisedButton(
          onPressed: () {
            playKey(keyNumber);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Color(0xAAFFFFFF),
        ),
      ),
    );
  }

  Expanded buildSharp(int sharpNumber) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: RaisedButton(
          onPressed: () {
            playSharp(sharpNumber);
          },
          child: Text("                             "),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Color(0xDD000000),
        ),
      ),
    );
  }

  int port1key = null;
  List<String> port1List = PWMPinsLIST;
  String selectedPort1 = PWMPinsLIST[17]; //GPIO 18  as default

  int port2key = null;
  List<String> port2List = PWMPinsLIST;
  String selectedPort2 = PWMPinsLIST[18]; //GPIO 19 as default

  List<String> songList = ["Mario", "Underwater"];
  String song = "Mario"; //Default

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
          "Tone Generator",
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
            Color(0xFF25A45F),
            Color(0xFF12A674),
            Color(0xFF07A886),
            Color(0xFF0AA78E),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Control Panel',
                    style: GoogleFonts.montserrat(
                      textStyle: kControlPanelTitle,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  IconButton(
                    icon: Icon(Icons.info),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        Alert(
                          context: context,
                          style: alertStyle,
                          type: AlertType.none,
                          title: "NOTE FREQUENCIES",
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: AnimatedContainer(
                                  height: 200,
                                  duration: Duration(milliseconds: 50),
                                  child: FlareActor(
                                    'assets/concepts/buzzer.flr', //insert flare animation file here
                                    alignment: Alignment.center,
                                    fit: BoxFit.fill,
                                    animation: 'go',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "A piezo buzzer houses a ceramic disc that compresses and expands at a certain frequency when a PWM signal is applied. The flexing of the disc generates a note that we hear as sound.",
                                  style: kConceptToolText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "In this activity, you can configure the buzzer to play musical notes and experiment with difference octave scales. Have fun!",
                                  style: kConceptToolText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          buttons: [
                            DialogButton(
                              child: Text(
                                "OKAY",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              color: kAppBlue,
                              radius: BorderRadius.circular(20.0),
                            ),
                          ],
                        ).show();
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
              width: double.maxFinite,
            ),
            Flexible(
              flex: 8,
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      buildKey(0),
                      buildKey(1),
                      buildKey(2),
                      buildKey(3),
                      buildKey(4),
                      buildKey(5),
                      buildKey(6),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        height: 25.0,
                        width: double.maxFinite,
                      ),
                      buildSharp(0),
                      buildSharp(1),
                      SizedBox(
                        height: 55.0,
                        width: double.maxFinite,
                      ),
                      buildSharp(2),
                      buildSharp(3),
                      buildSharp(4),
                      SizedBox(
                        height: 25.0,
                        width: double.maxFinite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "Octave",
                    style: GoogleFonts.montserrat(
                      textStyle: kSliderText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: ToggleButtons(
                      children: <Widget>[
                        Text(
                          '      -2      ',
                        ),
                        Text(
                          '      -1      ',
                        ),
                        Text(
                          '      0      ',
                        ),
                        Text(
                          '      +1      ',
                        ),
                        Text(
                          '      +2      ',
                        )
                      ],
                      isSelected: _octaveSelect,
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0;
                              buttonIndex < _octaveSelect.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              _octaveSelect[buttonIndex] =
                                  !_octaveSelect[buttonIndex];
                            } else {
                              _octaveSelect[buttonIndex] = false;
                            }
                          }
                          int octave = octaveStates[index];
                          print('octave: $octave');
                          String dataValues = "activity3::Octave: $octave";
                          writeData(dataValues);
                        });
                      },
                      color: Colors.white,
                      selectedColor: Colors.white,
                      fillColor: Color(0xFFFFAF0A),
                      borderWidth: 2.0,
                      borderRadius: BorderRadius.circular(25),
                      textStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      constraints: BoxConstraints(minHeight: 40.0),
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
                          'Passive',
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
                              String dataPorts = "activity3::Port1: $port1key";
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
                          'Active',
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
                              String dataPorts = "activity3::Port2: $port2key";
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
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.1, 0.3, 0.6, 0.9],
                      colors: [
                        Color(0xFFFDC13F),
                        Color(0xFFFEA641),
                        Color(0xFFFF7D56),
                        Color(0xFFFF6D46),
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 40.0, right: 40.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Melody',
                              style: kSliderText,
                            ),
                            DropdownButton<String>(
                              value: song,
                              items: getDropdownItems(songList),
                              onChanged: (value) {
                                setState(() {
                                  song = value;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Center(
                          child: ClipOval(
                            child: Material(
                              color: Color(0xFFFE1E49), // button color
                              child: InkWell(
                                child: SizedBox(
                                    width: 65,
                                    height: 65,
                                    child: Icon(Icons.play_arrow)),
                                onTap: () {
                                  setState(() {
                                    String dataSong =
                                        "activity3::MelodyPlay: $song";
                                    writeData(dataSong);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: ToggleButtons(
                            children: <Widget>[
                              Text(
                                '      Passive      ',
                              ),
                              Text(
                                '      Active      ',
                              ),
                            ],
                            isSelected: _modeSelect,
                            onPressed: (int index) {
                              setState(() {
                                for (int buttonIndex = 0;
                                    buttonIndex < _modeSelect.length;
                                    buttonIndex++) {
                                  if (buttonIndex == index) {
                                    _modeSelect[buttonIndex] =
                                        !_modeSelect[buttonIndex];
                                  } else {
                                    _modeSelect[buttonIndex] = false;
                                  }
                                }
                                String mode = modeStates[index];
                                print('mode: $mode');
                                String dataValues = "activity3::Mode: $mode";
                                writeData(dataValues);
                              });
                            },
                            color: Colors.white,
                            selectedColor: Colors.white,
                            fillColor: Color(0xFFFF1E49),
                            borderWidth: 2.0,
                            borderRadius: BorderRadius.circular(25),
                            textStyle: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            constraints: BoxConstraints(minHeight: 40.0),
                          ),
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
