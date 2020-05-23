void loop() {

  //-------------------------------------- ACTIVITY 2 --------------------------------------------
  if ( switchMotor == 1) {

    if (pattern == "fullstep90") {
      UpdateMotor();
      FullStep();
      delayMicroseconds(delayValueMotor);
    }
    else if (pattern == "microstep67") {
      UpdateMotor();
      MicroStep67();
      delayMicroseconds(delayValueMotor);
    }
    else if (pattern == "microstep45") {
      UpdateMotor();
      MicroStep45();
      delayMicroseconds(delayValueMotor);
    }
  } // else do nothing


  //-------------------------------------- BLUETOOTH --------------------------------------------
  // notify changed value
  //    if (deviceConnected) {
  //        pCharacteristic->setValue((uint8_t*)&value, 4);
  //        pCharacteristic->notify();
  //        value++;
  //        delay(500); // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
  //    }
  
  if((user_password!=device_password)&&(newPasswordTrigger==true)){
    newPasswordTrigger = false;
    user_password = " "; //reset
    uint16_t conn_id = pServer->getConnId();
    pServer->disconnect(conn_id);
    Serial.println("Invalid password, disconnecting..");
  }
  
  
  // disconnecting
  if ( (!deviceConnected && oldDeviceConnected)){
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
