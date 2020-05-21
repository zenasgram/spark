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

#define SERVICE_UUID        "364dc5da-99d3-11ea-bb37-0242ac130002"
#define CHARACTERISTIC_UUID "3cf252f2-99d3-11ea-bb37-0242ac130002"


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

    void onWrite(BLECharacteristic *pCharacteristic) {
      std::string value = pCharacteristic->getValue();

      if (value.length() > 0) {

        Serial.println("***********");
        //      Serial.print("New value: ");
        for (int i = 0; i < value.length(); i++) {
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
