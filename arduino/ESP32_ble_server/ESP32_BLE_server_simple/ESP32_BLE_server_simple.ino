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


#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

//**********************************************************************************************
//-------------------------------------- ACTIVITY 1 --------------------------------------------
//**********************************************************************************************

int led1 = 1; // 12 corresponds to GPIO12
int led2 = 2;

// setting PWM properties
int freq1 = 5000;
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
    
  }
  else if (part1.equalsIgnoreCase("activity2::Port2:")){
   
  }
  else if (part1.equalsIgnoreCase("activity2::Port3:")){
   
  }
  else if (part1.equalsIgnoreCase("activity2::Port4:")){
   
  }
  else if (part1.equalsIgnoreCase("activity2::Slider1:")){
    
  }
  else if (part1.equalsIgnoreCase("activity2::Slider2:")){
    
  }
  else if (part1.equalsIgnoreCase("activity2::Switch1:")){
    
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
  
  // configure LED PWM functionalitites
  ledcSetup(ledChannel1, freq1, resolution1);
  ledcSetup(ledChannel2, freq2, resolution2);
 
  // attach the channel to the GPIO to be controlled
  ledcAttachPin(led1, ledChannel1);
  ledcAttachPin(led2, ledChannel2);

  
  
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
