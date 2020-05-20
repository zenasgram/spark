void setup() {

  // Start serial comms over USB
  Serial.begin(115200);

  //----------------------------------- GET MAC ADDRESS -------------------------------------------

  Serial.print("ESP Board MAC Address:  ");
  Serial.println(WiFi.macAddress()); //eg. 24:62:AB:C9:F4:18
//  const char* deviceName = "ESP32 for Spark by Imperial";
  const char* deviceName = MACtoDeviceName(WiFi.macAddress());

  Serial.print("Device ID:  ");
  Serial.println(deviceName); 
  
  //-------------------------------------- ACTIVITY 1 --------------------------------------------

  // configure LED PWM functionalitites
  ledcSetup(ledChannel1, freq1, resolution1);
  ledcSetup(ledChannel2, freq2, resolution2);

  // attach the channel to the GPIO to be controlled
  ledcAttachPin(led1, ledChannel1);
  ledcAttachPin(led2, ledChannel2);


  //-------------------------------------- ACTIVITY 2 --------------------------------------------

  setupMotor();

  //-------------------------------------- ACTIVITY 3 --------------------------------------------

  pinMode(passivePin, OUTPUT);//passive buzzer
  pinMode(activePin, OUTPUT);//active buzzer


  //-------------------------------------- BLUETOOTH ---------------------------------------------



  // Create the BLE Device
  BLEDevice::init(deviceName);

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
