/*
    Video: https://www.youtube.com/watch?v=oCMOYS71NIU
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleNotify.cpp
    Ported to Arduino ESP32 by Evandro Copercini
    updated by chegewara
   Create a BLE server that, once we receive a connection, will send periodic notifications.
   The service advertises itself as: 4fafc201-1fb5-459e-8fcc-c5c9c331914b
   And has a characteristic of: beb5483e-36e1-4688-b7f5-ea07361b26a8
   The design of creating the BLE server is:
   1. Create a BLE Server
   2. Create a BLE Service
   3. Create a BLE Characteristic on the Service
   4. Create a BLE Descriptor on the characteristic
   5. Start the service.
   6. Start advertising.
   A connect hander associated with the server starts a background task that performs notification
   every couple of seconds.
*/
#include <Arduino.h>
#include <analogWrite.h>

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#include <elapsedMillis.h>

#include <Stepper.h>

//**********************************************************************************************
//-------------------------------------- ACTIVITY 1 --------------------------------------------
//**********************************************************************************************

int led1 = 1; // 12 corresponds to GPIO12
int led2 = 2;

// setting PWM properties
int freq1 = 50;
int ledChannel1 = 0;
int resolution1 = 8;
int freq2 = 5000;
int ledChannel2 = 1;
int resolution2 = 8;

int switch1 = 0;
int switch2 = 0;

int dutyCycle1 = 0;
int dutyCycle2 = 0;


//**********************************************************************************************
//-------------------------------------- ACTIVITY 2 --------------------------------------------
//**********************************************************************************************



// Setup tpins
int pin1 = 27;
int pin2 = 26;
int pin3 = 25;
int pin4 = 33;
 
int pinChannel1 = 3;
int pinChannel2 = 4;
int pinChannel3 = 5;
int pinChannel4 = 6;
int resolutionMotorPWM = 8;

int motorFrequency = 100; //in Hz (minimum delay between steps is

// Set the PWM duty cycle and counter pin.
int dutyCycleMotor = 25; // 25%
int motorPhase = 90; // degrees

long delayValueMotor = 1000000;


int switchMotor = 0; // On/Off


// Periodically print status info.
elapsedMillis timeSinceLastPrint;
const int printDelayTime = 1000;



//**********************************************************************************************
//-------------------------------------- ACTIVITY 3 --------------------------------------------
//**********************************************************************************************
//Credit: Dipto Pratyaksa 

int passivePin = 18;
int activePin =19;

int buzzer1freq = 2000; //eg.2000Hz
int buzzer2freq = 1000;

int timePeriod1 = 500; //eg. 500ms
int timePeriod2 = 500;

int switch1tone = 0;
int switch2tone = 0;
  
//PUBLIC CONSTANTS
#define NOTE_B0  31
#define NOTE_C1  33
#define NOTE_CS1 35
#define NOTE_D1  37
#define NOTE_DS1 39
#define NOTE_E1  41
#define NOTE_F1  44
#define NOTE_FS1 46
#define NOTE_G1  49
#define NOTE_GS1 52
#define NOTE_A1  55
#define NOTE_AS1 58
#define NOTE_B1  62
#define NOTE_C2  65
#define NOTE_CS2 69
#define NOTE_D2  73
#define NOTE_DS2 78
#define NOTE_E2  82
#define NOTE_F2  87
#define NOTE_FS2 93
#define NOTE_G2  98
#define NOTE_GS2 104
#define NOTE_A2  110
#define NOTE_AS2 117
#define NOTE_B2  123
#define NOTE_C3  131
#define NOTE_CS3 139
#define NOTE_D3  147
#define NOTE_DS3 156
#define NOTE_E3  165
#define NOTE_F3  175
#define NOTE_FS3 185
#define NOTE_G3  196
#define NOTE_GS3 208
#define NOTE_A3  220
#define NOTE_AS3 233
#define NOTE_B3  247
#define NOTE_C4  262
#define NOTE_CS4 277
#define NOTE_D4  294
#define NOTE_DS4 311
#define NOTE_E4  330
#define NOTE_F4  349
#define NOTE_FS4 370
#define NOTE_G4  392
#define NOTE_GS4 415
#define NOTE_A4  440
#define NOTE_AS4 466
#define NOTE_B4  494
#define NOTE_C5  523
#define NOTE_CS5 554
#define NOTE_D5  587
#define NOTE_DS5 622
#define NOTE_E5  659
#define NOTE_F5  698
#define NOTE_FS5 740
#define NOTE_G5  784
#define NOTE_GS5 831
#define NOTE_A5  880
#define NOTE_AS5 932
#define NOTE_B5  988
#define NOTE_C6  1047
#define NOTE_CS6 1109
#define NOTE_D6  1175
#define NOTE_DS6 1245
#define NOTE_E6  1319
#define NOTE_F6  1397
#define NOTE_FS6 1480
#define NOTE_G6  1568
#define NOTE_GS6 1661
#define NOTE_A6  1760
#define NOTE_AS6 1865
#define NOTE_B6  1976
#define NOTE_C7  2093
#define NOTE_CS7 2217
#define NOTE_D7  2349
#define NOTE_DS7 2489
#define NOTE_E7  2637
#define NOTE_F7  2794
#define NOTE_FS7 2960
#define NOTE_G7  3136
#define NOTE_GS7 3322
#define NOTE_A7  3520
#define NOTE_AS7 3729
#define NOTE_B7  3951
#define NOTE_C8  4186
#define NOTE_CS8 4435
#define NOTE_D8  4699
#define NOTE_DS8 4978


//#####################################################################
//~~~~~~~~~~~~~~~~~~~~~~~~~~ TUNE 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//Mario main theme melody
int melody[] = {
  NOTE_E7, NOTE_E7, 0, NOTE_E7,
  0, NOTE_C7, NOTE_E7, 0,
  NOTE_G7, 0, 0,  0,
  NOTE_G6, 0, 0, 0,

  NOTE_C7, 0, 0, NOTE_G6,
  0, 0, NOTE_E6, 0,
  0, NOTE_A6, 0, NOTE_B6,
  0, NOTE_AS6, NOTE_A6, 0,

  NOTE_G6, NOTE_E7, NOTE_G7,
  NOTE_A7, 0, NOTE_F7, NOTE_G7,
  0, NOTE_E7, 0, NOTE_C7,
  NOTE_D7, NOTE_B6, 0, 0,

  NOTE_C7, 0, 0, NOTE_G6,
  0, 0, NOTE_E6, 0,
  0, NOTE_A6, 0, NOTE_B6,
  0, NOTE_AS6, NOTE_A6, 0,

  NOTE_G6, NOTE_E7, NOTE_G7,
  NOTE_A7, 0, NOTE_F7, NOTE_G7,
  0, NOTE_E7, 0, NOTE_C7,
  NOTE_D7, NOTE_B6, 0, 0
};



//Mario main them tempo
int tempo[] = {
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  9, 9, 9,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  9, 9, 9,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
};

//#####################################################################
//~~~~~~~~~~~~~~~~~~~~~~~~~~ TUNE 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//Underworld melody
int underworld_melody[] = {
  NOTE_C4, NOTE_C5, NOTE_A3, NOTE_A4,
  NOTE_AS3, NOTE_AS4, 0,
  0,
  NOTE_C4, NOTE_C5, NOTE_A3, NOTE_A4,
  NOTE_AS3, NOTE_AS4, 0,
  0,
  NOTE_F3, NOTE_F4, NOTE_D3, NOTE_D4,
  NOTE_DS3, NOTE_DS4, 0,
  0,
  NOTE_F3, NOTE_F4, NOTE_D3, NOTE_D4,
  NOTE_DS3, NOTE_DS4, 0,
  0, NOTE_DS4, NOTE_CS4, NOTE_D4,
  NOTE_CS4, NOTE_DS4,
  NOTE_DS4, NOTE_GS3,
  NOTE_G3, NOTE_CS4,
  NOTE_C4, NOTE_FS4, NOTE_F4, NOTE_E3, NOTE_AS4, NOTE_A4,
  NOTE_GS4, NOTE_DS4, NOTE_B3,
  NOTE_AS3, NOTE_A3, NOTE_GS3,
  0, 0, 0
};


//Underwolrd tempo
int underworld_tempo[] = {
  12, 12, 12, 12,
  12, 12, 6,
  3,
  12, 12, 12, 12,
  12, 12, 6,
  3,
  12, 12, 12, 12,
  12, 12, 6,
  3,
  12, 12, 12, 12,
  12, 12, 6,
  6, 18, 18, 18,
  6, 6,
  6, 6,
  6, 6,
  18, 18, 18, 18, 18, 18,
  10, 10, 10,
  10, 10, 10,
  3, 3, 3
};


int song = 0;

void sing(int s, String type) {
  // iterate over the notes of the melody:

  int melodyPin; 
  if(type == "active"){
    melodyPin = activePin;
  }else{
    melodyPin = passivePin;
  }
  
  song = s;
  if (song == 2) {
    Serial.println(" 'Underworld Theme'");
    int size = sizeof(underworld_melody) / sizeof(int);
    for (int thisNote = 0; thisNote < size; thisNote++) {

      // to calculate the note duration, take one second
      // divided by the note type.
      //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
      int noteDuration = 1000 / underworld_tempo[thisNote];

      buzz(melodyPin, underworld_melody[thisNote], noteDuration);

      // to distinguish the notes, set a minimum time between them.
      // the note's duration + 30% seems to work well:
      int pauseBetweenNotes = noteDuration * 1.30;
      delay(pauseBetweenNotes);

      // stop the tone playing:
      buzz(melodyPin, 0, noteDuration);

    }

  } else {

    Serial.println(" 'Mario Theme'");
    int size = sizeof(melody) / sizeof(int);
    for (int thisNote = 0; thisNote < size; thisNote++) {

      // to calculate the note duration, take one second
      // divided by the note type.
      //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
      int noteDuration = 1000 / tempo[thisNote];

      buzz(melodyPin, melody[thisNote], noteDuration);

      // to distinguish the notes, set a minimum time between them.
      // the note's duration + 30% seems to work well:
      int pauseBetweenNotes = noteDuration * 1.30;
      delay(pauseBetweenNotes);

      // stop the tone playing:
      buzz(melodyPin, 0, noteDuration);

    }
  }
}

void buzz(int targetPin, long frequency, long length) {


  long delayValue; // calculate the delay value between transitions

  if(frequency==0){
    delayValue = 1000000;
  }
  else{
    delayValue = (1000000 / frequency) / 2; 

  }
  

  //// 1 second's worth of microseconds, divided by the frequency, then split in half since
  //// there are two phases to each cycle
  long numCycles = (frequency * length) / 1000; // calculate the number of cycles for proper timing
  //// multiply frequency, which is really cycles per second, by the number of seconds to
  //// get the total number of cycles to produce
  for (long i = 0; i < numCycles; i++) { // for the calculated length of time...

     
    digitalWrite(targetPin, HIGH); // write the buzzer pin high to push out the diaphram
    delayMicroseconds(delayValue); // wait for the calculated delay value
    
    digitalWrite(targetPin, LOW); // write the buzzer pin low to pull back the diaphram
    delayMicroseconds(delayValue); // wait again or the calculated delay value
  }

}

//**********************************************************************************************
//----------------------------------- Command Parsing ------------------------------------------
//**********************************************************************************************

String command;

void parseCommand(String com){
  String part1;
  String part2;

  part1 = com.substring(0, com.indexOf(" "));
  part2 = com.substring(com.indexOf(" ") + 1);

  if(part1.equalsIgnoreCase("activity1::Port1:")){
    led1 = part2.toInt();
    ledcAttachPin(led1, ledChannel1);
    
  }
  else if (part1.equalsIgnoreCase("activity1::Port2:")){
    led2 = part2.toInt();
    ledcAttachPin(led2, ledChannel2);
  }
  else if (part1.equalsIgnoreCase("activity1::Slider1:")){
    dutyCycle1 = part2.toInt() * 2; //to scale range to 0 to 200 (max is 255)
    if(switch1 == 1){
      ledcWrite(ledChannel1, dutyCycle1);
    }
    else{
      ledcWrite(ledChannel1, 0);
    }
  }
  else if (part1.equalsIgnoreCase("activity1::Slider2:")){
    dutyCycle2 = part2.toInt() * 2;
    if(switch2 == 1){
      ledcWrite(ledChannel2, dutyCycle2);
    }
    else{
      ledcWrite(ledChannel2, 0);
    }
    
  }
  else if (part1.equalsIgnoreCase("activity1::Switch1:")){
    switch1 = part2.toInt();
    if(switch1 == 1){
      ledcWrite(ledChannel1, dutyCycle1);
    }
    else{
      ledcWrite(ledChannel1, 0);
    }
  }
  else if (part1.equalsIgnoreCase("activity1::Switch2:")){
    switch2 = part2.toInt();
    if(switch2 == 1){
      ledcWrite(ledChannel2, dutyCycle2);
    }
  }
  //**********************************************************************************************
  
  else if(part1.equalsIgnoreCase("activity2::Port1:")){
      
    pin1 = part2.toInt();
    ledcAttachPin(pin1, pinChannel1);
    
//    pinMode(pin1, OUTPUT);

  }
  else if (part1.equalsIgnoreCase("activity2::Port2:")){

    pin2 = part2.toInt();
    ledcAttachPin(pin2, pinChannel2);
    
  }
  else if (part1.equalsIgnoreCase("activity2::Port3:")){

    pin3 = part2.toInt();
    ledcAttachPin(pin3, pinChannel3);
    
  }
  else if (part1.equalsIgnoreCase("activity2::Port4:")){

    pin4 = part2.toInt();
    ledcAttachPin(pin4, pinChannel4);
    
  }
  else if (part1.equalsIgnoreCase("activity2::Slider1:")){
    motorFrequency = part2.toInt();

    delayValueMotor = (1/motorFrequency) * (motorPhase/360); 

    ledcSetup(pinChannel1, motorFrequency, resolutionMotorPWM);
    ledcSetup(pinChannel2, motorFrequency, resolutionMotorPWM);
    ledcSetup(pinChannel3, motorFrequency, resolutionMotorPWM);
    ledcSetup(pinChannel4, motorFrequency, resolutionMotorPWM);
    
    ledcAttachPin(pin1, pinChannel1);
    ledcAttachPin(pin2, pinChannel2);
    ledcAttachPin(pin3, pinChannel3);
    ledcAttachPin(pin4, pinChannel4);

    
    if(switchMotor == 1){
      ledcWrite(pinChannel1, dutyCycleMotor);
      delayMicroseconds(delayValueMotor); // wait for the calculated delay value
      ledcWrite(pinChannel2, dutyCycleMotor);
      delayMicroseconds(delayValueMotor);
      ledcWrite(pinChannel3, dutyCycleMotor);
      delayMicroseconds(delayValueMotor);
      ledcWrite(pinChannel4, dutyCycleMotor);
      delayMicroseconds(delayValueMotor);
    }
    else{
      ledcWrite(pinChannel1, 0);
      ledcWrite(pinChannel2, 0);
      ledcWrite(pinChannel3, 0);
      ledcWrite(pinChannel4, 0);
    }

  }
  else if (part1.equalsIgnoreCase("activity2::Slider2:")){
    motorPhase = part2.toInt();
    
    delayValueMotor = (1/motorFrequency) * (motorPhase/360); 

    ledcSetup(pinChannel1, motorFrequency, resolutionMotorPWM);
    ledcSetup(pinChannel2, motorFrequency, resolutionMotorPWM);
    ledcSetup(pinChannel3, motorFrequency, resolutionMotorPWM);
    ledcSetup(pinChannel4, motorFrequency, resolutionMotorPWM);
    
    ledcAttachPin(pin1, pinChannel1);
    ledcAttachPin(pin2, pinChannel2);
    ledcAttachPin(pin3, pinChannel3);
    ledcAttachPin(pin4, pinChannel4);

    
    if(switchMotor == 1){
      ledcWrite(pinChannel1, dutyCycleMotor);
      delayMicroseconds(delayValueMotor); 
      ledcWrite(pinChannel2, dutyCycleMotor);
      delayMicroseconds(delayValueMotor);
      ledcWrite(pinChannel3, dutyCycleMotor);
      delayMicroseconds(delayValueMotor);
      ledcWrite(pinChannel4, dutyCycleMotor);
      delayMicroseconds(delayValueMotor);
    }
    else{
      ledcWrite(pinChannel1, 0);
      ledcWrite(pinChannel2, 0);
      ledcWrite(pinChannel3, 0);
      ledcWrite(pinChannel4, 0);
    }
  }
  else if (part1.equalsIgnoreCase("activity2::Slider3:")){
    dutyCycleMotor = part2.toInt();
    
    delayValueMotor = (1/motorFrequency) * (motorPhase/360); 

    ledcSetup(pinChannel1, motorFrequency, resolutionMotorPWM);
    ledcSetup(pinChannel2, motorFrequency, resolutionMotorPWM);
    ledcSetup(pinChannel3, motorFrequency, resolutionMotorPWM);
    ledcSetup(pinChannel4, motorFrequency, resolutionMotorPWM);
    
    ledcAttachPin(pin1, pinChannel1);
    ledcAttachPin(pin2, pinChannel2);
    ledcAttachPin(pin3, pinChannel3);
    ledcAttachPin(pin4, pinChannel4);

    
    if(switchMotor == 1){
      ledcWrite(pinChannel1, dutyCycleMotor);
      delayMicroseconds(delayValueMotor); 
      ledcWrite(pinChannel2, dutyCycleMotor);
      delayMicroseconds(delayValueMotor);
      ledcWrite(pinChannel3, dutyCycleMotor);
      delayMicroseconds(delayValueMotor);
      ledcWrite(pinChannel4, dutyCycleMotor);
      delayMicroseconds(delayValueMotor);
    }
    else{
      ledcWrite(pinChannel1, 0);
      ledcWrite(pinChannel2, 0);
      ledcWrite(pinChannel3, 0);
      ledcWrite(pinChannel4, 0);
    }
    
  }
  else if (part1.equalsIgnoreCase("activity2::Switch1:")){

     switchMotor = part2.toInt();
    if(switchMotor == 1){
      ledcWrite(pinChannel1, dutyCycleMotor);
      delayMicroseconds(delayValueMotor); 
      ledcWrite(pinChannel2, dutyCycleMotor);
      delayMicroseconds(delayValueMotor);
      ledcWrite(pinChannel3, dutyCycleMotor);
      delayMicroseconds(delayValueMotor);
      ledcWrite(pinChannel4, dutyCycleMotor);
      delayMicroseconds(delayValueMotor);
      
    }
    else{
      ledcWrite(pinChannel1, 0);
      ledcWrite(pinChannel2, 0);
      ledcWrite(pinChannel3, 0);
      ledcWrite(pinChannel4, 0);
    }
  }
  //**********************************************************************************************
  else if(part1.equalsIgnoreCase("activity3::Port1:")){
    
  }
  else if (part1.equalsIgnoreCase("activity3::Port2:")){
   
  }
  else if (part1.equalsIgnoreCase("activity3::Slider1:")){
    
  }
  else if (part1.equalsIgnoreCase("activity3::Slider2:")){
    
  }
  else if (part1.equalsIgnoreCase("activity3::Switch1:")){
    
  }
  else if (part1.equalsIgnoreCase("activity3::Switch2:")){
    
  }
  else{
    Serial.println(" ");
  }
}

//**********************************************************************************************
//--------------------------------------- BLUETOOTH --------------------------------------------
//**********************************************************************************************


BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
//uint32_t value = 0;

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "c6bcdf5e-86da-11ea-bc55-0242ac130003"
#define CHARACTERISTIC_UUID "cec2788a-86da-11ea-bc55-0242ac130003"




class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      BLEDevice::startAdvertising();
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};

class MyCallbacks: public BLECharacteristicCallbacks {

  void onWrite(BLECharacteristic *pCharacteristic){
    std::string value = pCharacteristic->getValue();

    if(value.length() > 0){

      Serial.println("***********");
//      Serial.print("New value: ");
      for(int i=0; i<value.length(); i++){
        Serial.print(value[i]);
        command += value[i];
      }
      parseCommand(command);
          command = "";

      Serial.println();
      Serial.println("***********");      
    }

  }
  
};







void setup() {

//-------------------------------------- ACTIVITY 1 --------------------------------------------
  
  // configure LED PWM functionalitites
  ledcSetup(ledChannel1, freq1, resolution1);
  ledcSetup(ledChannel2, freq2, resolution2);
 
  // attach the channel to the GPIO to be controlled
  ledcAttachPin(led1, ledChannel1);
  ledcAttachPin(led2, ledChannel2);


//-------------------------------------- ACTIVITY 2 --------------------------------------------

  // configure LED PWM functionalitites
  ledcSetup(pinChannel1, motorFrequency, resolutionMotorPWM);
  ledcSetup(pinChannel2, motorFrequency, resolutionMotorPWM);
  ledcSetup(pinChannel3, motorFrequency, resolutionMotorPWM);
  ledcSetup(pinChannel4, motorFrequency, resolutionMotorPWM);

  delayValueMotor = (1/motorFrequency) * (motorPhase/360); 
  
  ledcAttachPin(pin1, pinChannel1);
  delayMicroseconds(delayValueMotor); 
  ledcAttachPin(pin2, pinChannel2);
  delayMicroseconds(delayValueMotor); 
  ledcAttachPin(pin3, pinChannel3);
  delayMicroseconds(delayValueMotor); 
  ledcAttachPin(pin4, pinChannel4);
  delayMicroseconds(delayValueMotor); 



//-------------------------------------- ACTIVITY 3 --------------------------------------------

  pinMode(passivePin, OUTPUT);//passive buzzer
  pinMode(activePin, OUTPUT);//active buzzer
//
//  ledcSetup(0,1E5,12);
//  ledcAttachPin(18,0);'

//  ledcSetup(passiveChannel, passiveFreq, passiveResolution);
//  ledcAttachPin(passivePin, passiveChannel);
//
//  ledcSetup(activeChannel, activeFreq, activeResolution);
//  ledcAttachPin(activePin, activeChannel);

  
//-------------------------------------- BLUETOOTH ---------------------------------------------
  
  // Start serial comms over USB
  Serial.begin(115200);

  // Create the BLE Device
  BLEDevice::init("ESP32 for Spark by Imperial");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );

  pCharacteristic->setCallbacks(new MyCallbacks());
 
  // https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml
  // Create a BLE Descriptor
  pCharacteristic->addDescriptor(new BLE2902());

  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}

void loop() {

//-------------------------------------- ACTIVITY 2 --------------------------------------------
 
//  // Stop the stepper when it reaches its step target.
//  if (stepperDir == 1 && stepsTaken >= stepTarget) {
//    analogWrite(stepPin, 0);
//  }
//  else if (stepperDir == -1 && stepsTaken <= stepTarget) {
//    analogWrite(stepPin, 0);
//  }

  // Periodically print the stepper position.
//  if (timeSinceLastPrint > printDelayTime) {
//    Serial.println(stepsTaken);
//    timeSinceLastPrint = 0;
//  }



//-------------------------------------- ACTIVITY 3 --------------------------------------------
 
  //sing the tunes
//    sing(1,"passive");
//    sing(1, "active");
//    sing(2, "passive");
//  

  
//-------------------------------------- BLUETOOTH --------------------------------------------
    // notify changed value
//    if (deviceConnected) {
//        pCharacteristic->setValue((uint8_t*)&value, 4);
//        pCharacteristic->notify();
//        value++;
//        delay(500); // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
//    }
    // disconnecting
    if (!deviceConnected && oldDeviceConnected) {
        delay(500); // give the bluetooth stack the chance to get things ready
        pServer->startAdvertising(); // restart advertising
        Serial.println("Start advertising");
        oldDeviceConnected = deviceConnected;
    }
    // connecting
    if (deviceConnected && !oldDeviceConnected) {
        // do stuff here on connecting
        oldDeviceConnected = deviceConnected;
    }
}
