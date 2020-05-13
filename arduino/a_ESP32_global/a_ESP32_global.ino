#include <Arduino.h>
#include <analogWrite.h>

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#include <elapsedMillis.h>

#include <Stepper.h>

#include "driver/mcpwm.h"
#include "soc/mcpwm_reg.h"
#include "soc/mcpwm_struct.h"



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
void sing(int s, String type);
void buzz(int targetPin, long frequency, long length);

// COMMAND PARSE
void parseCommand(String com);

// EXECUTION
void setup();
void loop();
