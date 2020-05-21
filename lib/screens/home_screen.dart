import 'package:flutter/material.dart';
import 'package:spark/auth_fb.dart';
import 'package:spark/constants.dart';
import 'package:spark/components/activity_card.dart';
import 'package:spark/screens/activities/activity1.dart';
import 'package:spark/screens/activities/activity2.dart';
import 'package:spark/screens/activities/activity3.dart';
import 'package:spark/screens/welcome_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

//decorative package
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:spark/auth_google.dart';

//bluetooth package
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert' show utf8;
import 'dart:async';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

BluetoothDevice targetDevice;
BluetoothCharacteristic targetCharacteristic;

class _HomeScreenState extends State<HomeScreen> {
  bool connected = false;
  final String SERVICE_UUID = "364dc5da-99d3-11ea-bb37-0242ac130002";
  final String CHARACTERISTIC_UUID = "3cf252f2-99d3-11ea-bb37-0242ac130002";
//  final String TARGET_DEVICE_NAME = "ESP32 for Spark by Imperial";
  String TARGET_DEVICE_NAME;
  String TARGET_DEVICE_PASSWORD;

  FlutterBlue flutterBlue = FlutterBlue.instance;
  var subscription;

  String connectionText = "";

  var alertStyle = AlertStyle(
    backgroundColor: Color(0xAAFFFFFF),
    animationType: AnimationType.grow,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(
      color: Colors.black87,
      fontSize: 15.0,
      fontWeight: FontWeight.w300,
    ),
    animationDuration: Duration(milliseconds: 300),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
      side: BorderSide(
        color: Colors.transparent,
      ),
    ),
    titleStyle: TextStyle(
      color: kAppBlue,
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
    ),
  );

  TextEditingController _controller = new TextEditingController();
  TextEditingController _passwordcontroller = new TextEditingController();
  var bleAlertStyle = AlertStyle(
    backgroundColor: Color(0xCCFFFFFF),
    animationType: AnimationType.grow,
    isCloseButton: true,
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
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
  );

  @override
  void initState() {
    super.initState();

//    startScan();
  }

  startScan() {
    bool deviceFound = false;

    print('START Scan');
    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    setState(() {
      connectionText = "Scanning..";
    });

    // Listen to scan results
    subscription = flutterBlue.scanResults.listen(
      (scanResult) {
        print(
            '************************** REFRESH ****************************');
        int index = 0;
        // do something with scan results
        for (ScanResult r in scanResult) {
          print(
              '${index}. ${r.device.name} ----> \t RSSI: ${r.rssi}'); //RSSI = Received Signal Strength Indicator
          if ((r.device.name == TARGET_DEVICE_NAME) && (deviceFound == false)) {
            deviceFound = true;
            print(' ');
            print('~~~~~~~~~~~~~~~ TARGET DEVICE FOUND ~~~~~~~~~~~~~~~');
            print(' ');
            stopScan();
            targetDevice = r.device;
            connectToDevice();
          }

          index++;
        }
        if (deviceFound == false) {
          setState(() {
            connectionText = "Not Found";
          });
        }
      },
      onDone: () => stopScan(),
    );
  }

  stopScan() {
//    subscription.cancel();
    flutterBlue.stopScan();
  }

  connectToDevice() async {
    if (targetDevice == null) return;

    setState(() {
      connectionText = "...";
    });

    await targetDevice.connect();
    print('DEVICE CONNECTED');
    setState(() {
      connected = true;
      connectionText = "${targetDevice.name}";
    });
//    stopScan();
    discoverServices();
  }

  disconnectedFromDevice() {
    if (targetDevice == null) return;
    targetDevice.disconnect();
    print('DEVICE DISCONNECTED');

    setState(() {
      connected = false;
      connectionText = "Disconnected";
    });
  }

  discoverServices() async {
    if (targetDevice == null) return;
    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) {
      // do something with service
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;
            writeData("ESP32 is connected to Spark!");

            String dataValues = "password: ${TARGET_DEVICE_PASSWORD}";
            writeData(dataValues);
          }
        });
      }
    });
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
                      Text(
                        connectionText,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: connected ? Colors.greenAccent : Colors.grey,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                          icon: connected
                              ? Icon(Icons.bluetooth_connected)
                              : Icon(Icons.bluetooth),
                          color: connected ? Colors.greenAccent : Colors.grey,
                          iconSize: 30,
                          onPressed: () {
                            //Implement logout functionality
                            if (connected == true) {
                              disconnectedFromDevice();
                            } else {
                              Alert(
                                context: context,
                                style: bleAlertStyle,
                                type: AlertType.none,
                                title: "AUTHENTICATE",
                                content: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 15.0,
                                          bottom: 10.0),
                                      child: TextField(
                                        style: TextStyle(
                                          color: Colors.black87,
                                        ),
                                        controller: _controller,
                                        autocorrect: false,
//                                        textCapitalization:
//                                            TextCapitalization.characters,
//                                        maxLength: 17,
                                        cursorColor: kAppBlue,
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.developer_board,
                                            color: kAppBlue,
                                          ),
                                          labelText: 'Device ID',
                                          labelStyle: TextStyle(
                                              color: kAppBlue,
                                              fontWeight: FontWeight.w300),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xAA003BC0)),
                                          ),
                                        ),
                                        onChanged: (text) {
                                          TARGET_DEVICE_NAME = _controller.text;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 5.0,
                                          bottom: 25.0),
                                      child: TextField(
                                        style: TextStyle(
                                          color: Colors.black87,
                                        ),
                                        controller: _passwordcontroller,
                                        autocorrect: false,
//                                        textCapitalization:
//                                            TextCapitalization.characters,
//                                        maxLength: 17,
                                        cursorColor: kAppBlue,
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.lock,
                                            color: kAppBlue,
                                          ),
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                              color: kAppBlue,
                                              fontWeight: FontWeight.w300),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xAA003BC0)),
                                          ),
                                        ),
                                        onChanged: (text) {
                                          TARGET_DEVICE_PASSWORD =
                                              _passwordcontroller.text;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "CONNECT",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      print(TARGET_DEVICE_NAME);
                                      print(TARGET_DEVICE_PASSWORD);
                                      startScan();
                                      Navigator.pop(context);
                                    },
                                    color: kAppBlue,
                                    radius: BorderRadius.circular(20.0),
                                  ),
                                ],
                              ).show();
                            }
                          }),
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
                        if (connected == false) {
                          Alert(
                            context: context,
                            style: alertStyle,
                            type: AlertType.none,
                            title: "NOT CONNECTED",
                            desc:
                                "Please tap the bluetooth icon above to connect with the ESP32 first.",
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
                        } else {
                          Navigator.pushNamed(context, Activity1.id);
                        }
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
                        if (connected == false) {
                          Alert(
                            context: context,
                            style: alertStyle,
                            type: AlertType.none,
                            title: "NOT CONNECTED",
                            desc:
                                "Please tap the bluetooth icon above to connect with the ESP32 first.",
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
                        } else {
                          Navigator.pushNamed(context, Activity2.id);
                        }
                      });
                    },
                    child: ActivityCard(
                      flare: 'motor',
                      activityTitle: 'Motor Stepper',
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (connected == false) {
                          Alert(
                            context: context,
                            style: alertStyle,
                            type: AlertType.none,
                            title: "NOT CONNECTED",
                            desc:
                                "Please tap the bluetooth icon above to connect with the ESP32 first.",
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
                        } else {
                          Navigator.pushNamed(context, Activity3.id);
                        }
                      });
                    },
                    child: ActivityCard(
                      flare: 'tone',
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

//writeData(String data) async {
//  if (targetCharacteristic == null) return;
//
//  List<int> bytes = utf8.encode(data);
//  await targetCharacteristic.write(bytes);
//}

//removed async for faster transmission
writeData(String data) {
  if (targetCharacteristic == null) return;

  List<int> bytes = utf8.encode(data);
  targetCharacteristic.write(bytes);
}
