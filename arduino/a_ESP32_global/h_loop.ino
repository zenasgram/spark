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
