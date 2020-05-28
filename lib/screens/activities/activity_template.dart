import 'package:flutter/material.dart';
import 'package:spark/constants.dart';

import 'package:rubber/rubber.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:spark/config_data.dart';
import 'package:spark/screens/home_screen.dart';

//concept tool packages
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flare_flutter/flare_actor.dart';

class Activity4 extends StatefulWidget {
  static String id = 'activity_4';

  @override
  _Activity4State createState() => _Activity4State();
}

class _Activity4State extends State<Activity4>
    with SingleTickerProviderStateMixin {
  RubberAnimationController _controller;

  //--------------------------------------------------------
  //               CONCEPT TOOL TIP STYLE
  //--------------------------------------------------------

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
      fontSize: 23.0,
      fontWeight: FontWeight.bold,
    ),
  );

  //--------------------------------------------------------
  //          DECLARE ACTIVITY VARIABLES HERE
  //--------------------------------------------------------
  int port1key = null;
  List<String> port1List = PWMPinsLIST;
  String selectedPort1 = PWMPinsLIST[0]; //GPIO 1  as default

  int port2key = null;
  List<String> port2List = PWMPinsLIST;
  String selectedPort2 = PWMPinsLIST[0]; //GPIO 1 as default

  //--------------------------------------------------------
  //          DECLARE ACTIVITY FUNCTIONS HERE
  //--------------------------------------------------------
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
          "Activity Title",
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

  //--------------------------------------------------------
  //                      CONTROL LAYER
  //--------------------------------------------------------

  Widget _getLowerLayer() {
    return Container(
      height: MediaQuery.of(context).size.height,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          title: "CONCEPT TITLE",
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
                                    'assets/concepts/led.flr', //insert flare animation file here
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
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                                  style: kConceptToolText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
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
              height: 10.0,
              width: double.maxFinite,
            ),
            //--------------------------------------------------------
            //            ADDITIONAL UI ELEMENTS GO HERE
            //--------------------------------------------------------
            // IMPORTANT: All components MUST be wrapped in a flexible widget to ensure that they render correctly across devices of different screen sizes
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.1, //end column list with this to ensure that the last component is not blocked out by the Configure Panel
            ),
          ],
        ),
      ),
    );
  }

  //--------------------------------------------------------
  //                   CONFIGURE LAYER
  //--------------------------------------------------------
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
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 10.0,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
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
                                String dataPorts =
                                    "activity4::Port1: $port1key";
                                print(dataPorts);
                                writeData(dataPorts);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 10.0,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
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
                                String dataPorts =
                                    "activity4::Port2: $port2key";
                                print(dataPorts);
                                writeData(dataPorts);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
//--------------------------------------------------------
//          ADDITIONAL PORT ELEMENTS GO HERE
//--------------------------------------------------------
                Flexible(
                  flex:
                      5, // IMPORTANT: Adjust this last flex value to fill up the 'empty gap' if it exist
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
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
