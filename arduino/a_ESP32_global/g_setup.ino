void setup() {

  // Start serial comms over USB
  Serial.begin(115200);

  //----------------------------------- GET MAC ADDRESS -------------------------------------------

  Serial.print("ESP Board MAC Address:  ");
  Serial.println(WiFi.macAddress()); //eg. 24:62:AB:C9:F4:18
//  const char* deviceName = "ESP32 for Spark by Imperial";

  //---------------------------------- GENERATING PASSWORD -----------------------------------------

  char *payload = "Hello SHA 256 from ESP32learning";
  byte shaResult[32];
   
  mbedtls_md_context_t ctx;
  mbedtls_md_type_t md_type = MBEDTLS_MD_SHA256;
   
  const size_t payloadLength = strlen(payload);
   
  mbedtls_md_init(&ctx);
  mbedtls_md_setup(&ctx, mbedtls_md_info_from_type(md_type), 0);
  mbedtls_md_starts(&ctx);
  mbedtls_md_update(&ctx, (const unsigned char *) payload, payloadLength);
  mbedtls_md_finish(&ctx, shaResult);
  mbedtls_md_free(&ctx);
   
  Serial.print("Hash: ");

  // generating random sequence for dynamic password
  int ab = random(1, sizeof(shaResult)-1);
  int cd = random(1, sizeof(shaResult)-1);
  int ef = random(1, sizeof(shaResult)-1);
  int gh = random(1, sizeof(shaResult)-1);

//  Serial.println(ab);
//  Serial.println(cd);
//  Serial.println(ef);
//  Serial.println(gh);
  
  for(int i= 0; i< sizeof(shaResult); i++)
  {
    char str[3];
    sprintf(str, "%02x", (int)shaResult[i]);
    Serial.print(str);

    if (i==0){
      device_ID = str; //capture unique ID for ESP32
    }
    
    if(i==ab || i==cd || i==ef || i==gh){
      device_password = device_password + str; //limit password to 8 characters
    }
    
  }

  char* prefix = "ESP32-";
  strcpy(deviceName,prefix); // copy string one into the result.
  strcat(deviceName,device_ID.c_str());

  //-------------------------------- PRINTING DEVICE INFO -----------------------------------------
  // Use SHA256 encryption
  Serial.println(" ");
  Serial.println(" ");
  Serial.println("***************************************************************");
  Serial.print("Device ID: \t");
  Serial.println(deviceName); 
  
  Serial.print("Password: \t");
  Serial.println(device_password);
  Serial.println("***************************************************************");
  Serial.println(" ");
  Serial.println(" ");
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
