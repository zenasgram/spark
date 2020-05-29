# Spark <img align="right" width="100" height="100" src="https://github.com/zenasgram/spark/blob/master/images/readme_logo.png"> 

Download published app on the Android Playstore: https://play.google.com/store/apps/details?id=ac.imperial.spark

Spark is a pre-college outreach application to educate students on fundamental engineering concepts (eg. electromagnetism).


<p float="center">
  <img src="https://github.com/zenasgram/spark/blob/master/images/readme_welcome.jpg" width="210" />
  <img src="https://github.com/zenasgram/spark/blob/master/images/readme_home.jpg" width="210" /> 
  <img src="https://github.com/zenasgram/spark/blob/master/images/readme_auth.jpg" width="210" />
  <img src="https://github.com/zenasgram/spark/blob/master/images/readme_activity.jpg" width="210" />
</p>

Final Year Project Demo Video: <br/>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=C4DCKOrjJ8o
" target="_blank"><img src="http://img.youtube.com/vi/C4DCKOrjJ8o/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="480" height="360" border="10" /></a>

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


### Prerequisites

If you own a PC, it must:
- [x] be running Windows 7 or later 
- [x] have at least 400MB RAM, although 8GB RAM and above is highly recommended
- [x] have [git](https://git-scm.com/downloads) installed

If you own a Mac, it must:
- [x] be running MacOS X or later
- [x] have at least 700MB RAM, although 8GB RAM and above is highly recommended

Android Studio (recommended) or Visual Studio Code for Flutter development.
Android Studio benefits include better integration with iOS and Android mobile phone emulators, easy upgrades to Android X, etc. 

- For Android apps, you will also need the Android emulator (integrated with Android Studio) or a physical Android device
- For iOS testing and deployment, a MacOS machine running Xcode is required. For iOS apps, you will need either an iOS simulator or an Apple mobile device. Note that you will need to install [Cocoa Pods](https://guides.cocoapods.org/using/getting-started.html) for the Flutter program to compile for iOS.

Arduino Labs software is required to program the ESP32 microprocessor.


### Set Up

If you have a PC:
1) Install the Flutter SDK (save it directly to the C: drive, eg. C:\src\flutter)
2) Install Android Studio
3) Install the Android Emulator

For more information, check out the official Flutter team [documentation](https://flutter.dev/docs/get-started/install/windows).


If you have a MacOS Machine:
1) Install the Flutter SDK
2) Install Android Studio
3) Install the Android Emulator
4) Install Xcode and command-line tools
5) Test the iOS simulator

For more information, check out the official Flutter team [documentation](https://flutter.dev/docs/get-started/install/macos).


## Directory Layout

    .
    ├── android                             # Android environment configuration files
    ├── arduino                             # Arduino lab files for ESP32 hardware
    │   └── a_ESP32_global
    │       ├── a_ESP32_global.ino          # Arduino code for imported libraries, global variables and function declarations
    │       ├── b_activity1.ino             # Activity 1 control parameters and functions
    │       ├── c_activity2.ino             # Activity 2 control parameters and functions
    │       ├── d_activity3.ino             # Activity 3 control parameters and functions
    │       ├── e_commandParse.ino          # Command parser to handle data input from app client to ESP32 server
    │       ├── f_bluetooth.ino             # BLE callback functions for connection and read/write
    │       ├── g_setup.ino                 # ESP32 set up
    │       └── h_loop.ino                  # ESP32 run-time loop execution
    │    
    ├── assets                              # Folder containing Rive graphic animations for Activity Cards
    │   └── concepts                        # Animation soruce folder for Concept Tool Tips
    ├── images                              # Folder containing spark app logo and google/facebook sign in icons
    │   
    ├── ios                                 # iOS environment configuration files
    ├── lib                                 # Top library
    │   ├── components            
    │   │   ├── activity_card.dart          # Refactored code for home screen activity card design
    │   │   └── signin_button.dart          # Refactored code for registration/login button
    │   ├── screens     
    │   │   ├── activities                    
    │   │   │   ├── activity1.dart          # Flutter code for activity 1
    │   │   │   ├── activity2.dart          # Flutter code for activity 2
    │   │   │   ├── activity3.dart          # Flutter code for activity 3
    │   │   │   └── activity_template.dart  # Activity template for future development 
    │   │   ├── home_screen.dart            # Code for primary UI screen  
    │   │   └── welcome_screen.dart         # Code for initial screen on application boot
    │   │  
    │   ├── main.dart                       # Code for navigation route declaration 
    │   ├── auth_fb.dart                    # Code for Facebook sign in
    │   ├── auth_google.dart                # Code for Google sign in
    │   ├── config_data.dart                # Source file containing dictionaries of ESP32 port types
    │   └── constants.dart                  # Source file that stores constants (frequently used colors, widges, etc.)
    ├── test
    ├── pubspec.yaml                        # Package files (firebase, facebook login, rive, etc.)
    └── README.md



### Flutter Dependencies

#### Google Packages
* [firebase_core](https://pub.dev/packages/firebase_core) - ^0.4.4+3
* [firebase_analytics](https://pub.dev/packages/firebase_analytics) - ^5.0.11
* [cloud_firestore](https://pub.dev/packages/cloud_firestore) - ^0.13.4+2
* [firebase_auth](https://pub.dev/packages/firebase_auth) - ^0.15.5+3
* [google_sign_in](https://pub.dev/packages/google_sign_in) - ^4.3.0
* [rxdart](https://pub.dev/packages/rxdart) - ^0.23.0

#### Facebook Login Packages
* [flutter_facebook_login](https://pub.dev/packages/flutter_facebook_login) - ^3.0.0
* [http](https://pub.dev/packages/http) - ^0.12.0+2

#### Permission Package
* [permission_handler](https://pub.dev/packages/permission_handler) - ^5.0.0+hotfix.6

#### Bluetooth Package
* [flutter_blue](https://pub.dev/packages/flutter_blue) - ^0.7.0

#### Design Packages
* [rubber](https://pub.dev/packages/rubber) - ^0.4.0
* [flare_flutter](https://pub.dev/packages/flare_flutter) - ^2.0.1
* [rflutter_alert](https://pub.dev/packages/rflutter_alert) - ^1.0.3
* [cupertino_icons](https://pub.dev/packages/cupertino_icons) - ^0.1.2
* [google_fonts](https://pub.dev/packages/google_fonts) - ^0.3.10
* [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter) - ^8.8.1
* [wave_slider](https://pub.dev/packages/wave_slider) - ^0.2.0
* [sleek_circular_slider](https://pub.dev/packages/sleek_circular_slider) - ^1.1.0
* [lite_rolling_switch](https://pub.dev/packages/lite_rolling_switch) - ^0.1.1


## Authors

* **Lim Fei Yu, Zenas** - *Developer*
* **Dr Adrià Junyent-Ferré** - *Supervisor*

