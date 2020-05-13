//**********************************************************************************************
//----------------------------------- Command Parsing ------------------------------------------
//**********************************************************************************************

String command;

void parseCommand(String com) {
  String part1;
  String part2;

  part1 = com.substring(0, com.indexOf(" "));
  part2 = com.substring(com.indexOf(" ") + 1);

  if (part1.equalsIgnoreCase("activity1::Port1:")) {
    led1 = part2.toInt();
    ledcAttachPin(led1, ledChannel1);

  }
  else if (part1.equalsIgnoreCase("activity1::Port2:")) {
    led2 = part2.toInt();
    ledcAttachPin(led2, ledChannel2);
  }
  else if (part1.equalsIgnoreCase("activity1::Slider1:")) {
    dutyCycle1 = (int)(part2.toInt() * 2.55); //to scale range to 0 to 255 (max is 255)

    if (switch1 == 1) {
      ledcWrite(ledChannel1, dutyCycle1);
    }
    else {
      ledcWrite(ledChannel1, 0);
    }
  }
  else if (part1.equalsIgnoreCase("activity1::Slider2:")) {
    dutyCycle2 = (int)(part2.toInt() * 2.55); //to scale range to 0 to 255 (max is 255)


    if (switch2 == 1) {
      ledcWrite(ledChannel2, dutyCycle2);
    }
    else {
      ledcWrite(ledChannel2, 0);
    }

  }
  else if (part1.equalsIgnoreCase("activity1::Switch1:")) {
    switch1 = part2.toInt();
    if (switch1 == 1) {
      ledcWrite(ledChannel1, dutyCycle1);
    }
    else {
      ledcWrite(ledChannel1, 0);
    }
  }
  else if (part1.equalsIgnoreCase("activity1::Switch2:")) {
    switch2 = part2.toInt();
    if (switch2 == 1) {
      ledcWrite(ledChannel2, dutyCycle2);
    }
    else {
      ledcWrite(ledChannel2, 0);
    }
  }
  //**********************************************************************************************

  else if (part1.equalsIgnoreCase("activity2::Port1:")) {
    pin1 = part2.toInt();
    setupMotor();
  }
  else if (part1.equalsIgnoreCase("activity2::Port2:")) {
    pin2 = part2.toInt();
    setupMotor();
  }
  else if (part1.equalsIgnoreCase("activity2::Port3:")) {
    pin3 = part2.toInt();
    setupMotor();
  }
  else if (part1.equalsIgnoreCase("activity2::Port4:")) {
    pin4 = part2.toInt();
    setupMotor();
  }
  else if (part1.equalsIgnoreCase("activity2::Slider1:")) {
    motorFrequency = part2.toInt();
    UpdateMotor();
  }
  else if (part1.equalsIgnoreCase("activity2::Pattern:")) {
    pattern = part2;

    if (pattern == "fullstep90") {
      steps = 4.0;
    }
    else if (pattern == "microstep67") {
      steps = 12.0;
    }
    else if (pattern == "microstep45") {
      steps = 8.0;
    }
    UpdateMotor();
  }
  else if (part1.equalsIgnoreCase("activity2::Direction:")) {
    dir = part2.toInt();
    // 1 - clockwise
    // 0 - anti-clockwise
  }
  else if (part1.equalsIgnoreCase("activity2::Switch1:")) {
    switchMotor = part2.toInt();
  }
  //**********************************************************************************************
  else if (part1.equalsIgnoreCase("activity3::Port1:")) {

  }
  else if (part1.equalsIgnoreCase("activity3::Port2:")) {

  }
  else if (part1.equalsIgnoreCase("activity3::Slider1:")) {

  }
  else if (part1.equalsIgnoreCase("activity3::Slider2:")) {

  }
  else if (part1.equalsIgnoreCase("activity3::Switch1:")) {

  }
  else if (part1.equalsIgnoreCase("activity3::Switch2:")) {

  }
  else {
    Serial.println(" ");
  }
}
