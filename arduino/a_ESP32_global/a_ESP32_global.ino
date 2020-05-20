#include <Arduino.h>
#include <analogWrite.h>

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#include <WiFi.h>


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

// BLUETOOTH
const char* MACtoDeviceName (String mac);

// EXECUTION
void setup();
void loop();
