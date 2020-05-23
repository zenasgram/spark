#include <Arduino.h>
#include <analogWrite.h>

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#include <WiFi.h>

#include "mbedtls/md.h"

//**********************************************************************************************
//-----------------------------------  GLOBAL VARIABLES  ---------------------------------------
//**********************************************************************************************

String user_password = " "; //user input
String device_password = ""; //hash function to generate this

char deviceName[100]; //hash function to generate this
String device_ID;

bool newPasswordTrigger = false;

//**********************************************************************************************
//---------------------------------  FUNCTION DECLARATION  -------------------------------------
//**********************************************************************************************

// ACTIVITY 2
void setupMotor();
void UpdateMotor();
void FullStep();
void MicroStep67();
void MicroStep45();

// ACTIVITY 3
void playKey(int thisNote);
void playSharp(int thisNote);
void sing(String s, String type);
void buzz(int targetPin, long frequency, long length);

// COMMAND PARSE
void parseCommand(String com);

// EXECUTION
void setup();
void loop();
