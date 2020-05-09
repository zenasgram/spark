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
  final String SERVICE_UUID = "c6bcdf5e-86da-11ea-bc55-0242ac130003";
  final String CHARACTERISTIC_UUID = "cec2788a-86da-11ea-bc55-0242ac130003";
  final String TARGET_DEVICE_NAME = "ESP32 for Spark by Imperial";

  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubscription;

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

  @override
  void initState() {
    super.initState();

    startScan();
  }

  startScan() {
    print('START Scan');
    setState(() {
      connectionText = "Start Scanning";
    });
    scanSubscription = flutterBlue.scan().listen((scanResult) {
      if (scanResult.device.name == TARGET_DEVICE_NAME) {
        print('DEVICE found');
        stopScan();
        setState(() {
          connectionText = "Found Target Device";
        });

        targetDevice = scanResult.device;
        connectToDevice();
      }
    }, onDone: () => stopScan());
  }

  stopScan() {
    scanSubscription?.cancel();
    scanSubscription = null;
  }

  connectToDevice() async {
    if (targetDevice == null) return;

    setState(() {
      connectionText = "Device Connecting";
    });

    await targetDevice.connect();
    print('DEVICE CONNECTED');
    setState(() {
      connected = true;
      connectionText = "Device Connected";
    });

    discoverServices();
  }

  disconnectedFromDevice() {
    if (targetDevice == null) return;

    targetDevice.disconnect();
    print('DEVICE DISCONNECTED');
    setState(() {
      connected = false;
      connectionText = "Device Disconnected";
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
            writeData("Spark by Imperial App is CONNECTED!");
            setState(() {
              connectionText = "All Ready with ${targetDevice.name}";
            });
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
                      IconButton(
                          icon: Icon(FontAwesomeIcons.bluetoothB),
                          color: connected ? Colors.greenAccent : Colors.grey,
                          iconSize: 30,
                          onPressed: () {
                            //Implement logout functionality
                            if (connected == true) {
                              disconnectedFromDevice();
                            } else {
                              connectToDevice();
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
