//**********************************************************************************************
//-------------------------------------- ACTIVITY 2 --------------------------------------------
//**********************************************************************************************

int pin1 = 27;
int pin2 = 26;
int pin3 = 25;
int pin4 = 33;

int dir;
int seq;

String pattern = "fullstep90"; //default
int motorFrequency = 75; //in Hz (minimum delay between steps is 2ms, and max phase shift is 180 for the app, hence max freq is capped at 250Hz)
float steps = 4.0; //full step mode is default , 8.0 for microstepping


float delayValueMotor = 2500.0; //in micro second ( = 2ms) which is the minimum delay the stepper motor can function
int switchMotor = 0; // On/Off

void setupMotor () {
  pinMode(pin1, OUTPUT);
  pinMode(pin2, OUTPUT);
  pinMode(pin3, OUTPUT);
  pinMode(pin4, OUTPUT);
}

void UpdateMotor() {
  delayValueMotor = (1000000.0 / motorFrequency) / steps;
}

void FullStep() {
  seq = (seq + (dir ? 1 : -1)) & 3;

  switch (seq) {
    /* Pattern for 8 microsteps: A - B - C - D */
    /*      [        A        ][         B        ][         C        ][         D        ] */
    case 0: digitalWrite(pin1, 1); digitalWrite(pin2, 0); digitalWrite(pin3, 0); digitalWrite(pin4, 0); break;
    case 1: digitalWrite(pin1, 0); digitalWrite(pin2, 1); digitalWrite(pin3, 0); digitalWrite(pin4, 0); break;
    case 2: digitalWrite(pin1, 0); digitalWrite(pin2, 0); digitalWrite(pin3, 1); digitalWrite(pin4, 0); break;
    case 3: digitalWrite(pin1, 0); digitalWrite(pin2, 0); digitalWrite(pin3, 0); digitalWrite(pin4, 1); break;
  }
}

void MicroStep67() {
  seq = (seq - 1) & 11;

  if (dir == 0) {
    switch (seq) {
      /* Pattern for 12 microsteps: AA-AA-AB-BB-BB-BC-CC-CC-CD-DD-DD-DA */
      /*      [        A        ][         B        ][         C        ][         D        ] */
      case 0:  digitalWrite(pin1, 1); digitalWrite(pin2, 0); digitalWrite(pin3, 0); digitalWrite(pin4, 1); break;
      case 1:  digitalWrite(pin1, 1); digitalWrite(pin2, 0); digitalWrite(pin3, 0); digitalWrite(pin4, 0); break;
      case 2:  digitalWrite(pin1, 1); digitalWrite(pin2, 0); digitalWrite(pin3, 0); digitalWrite(pin4, 0); break;
      case 3:  digitalWrite(pin1, 1); digitalWrite(pin2, 1); digitalWrite(pin3, 0); digitalWrite(pin4, 0); break;
      case 4:  digitalWrite(pin1, 0); digitalWrite(pin2, 1); digitalWrite(pin3, 0); digitalWrite(pin4, 0); break;
      case 5:  digitalWrite(pin1, 0); digitalWrite(pin2, 1); digitalWrite(pin3, 0); digitalWrite(pin4, 0); break;
      case 6:  digitalWrite(pin1, 0); digitalWrite(pin2, 1); digitalWrite(pin3, 1); digitalWrite(pin4, 0); break;
      case 7:  digitalWrite(pin1, 0); digitalWrite(pin2, 0); digitalWrite(pin3, 1); digitalWrite(pin4, 0); break;
      case 8:  digitalWrite(pin1, 0); digitalWrite(pin2, 0); digitalWrite(pin3, 1); digitalWrite(pin4, 0); break;
      case 9:  digitalWrite(pin1, 0); digitalWrite(pin2, 0); digitalWrite(pin3, 1); digitalWrite(pin4, 1); break;
      case 10: digitalWrite(pin1, 0); digitalWrite(pin2, 0); digitalWrite(pin3, 0); digitalWrite(pin4, 1); break;
      case 11: digitalWrite(pin1, 0); digitalWrite(pin2, 0); digitalWrite(pin3, 0); digitalWrite(pin4, 1); break;
    }
  }
  else {
    switch (seq) {
      /* Pattern for 12 microsteps: AA-AA-AB-BB-BB-BC-CC-CC-CD-DD-DD-DA */
      /*      [        D        ][         C        ][         B        ][         A        ] */
      case 0:  digitalWrite(pin4, 1); digitalWrite(pin3, 0); digitalWrite(pin2, 0); digitalWrite(pin1, 1); break;
      case 1:  digitalWrite(pin4, 1); digitalWrite(pin3, 0); digitalWrite(pin2, 0); digitalWrite(pin1, 0); break;
      case 2:  digitalWrite(pin4, 1); digitalWrite(pin3, 0); digitalWrite(pin2, 0); digitalWrite(pin1, 0); break;
      case 3:  digitalWrite(pin4, 1); digitalWrite(pin3, 1); digitalWrite(pin2, 0); digitalWrite(pin1, 0); break;
      case 4:  digitalWrite(pin4, 0); digitalWrite(pin3, 1); digitalWrite(pin2, 0); digitalWrite(pin1, 0); break;
      case 5:  digitalWrite(pin4, 0); digitalWrite(pin3, 1); digitalWrite(pin2, 0); digitalWrite(pin1, 0); break;
      case 6:  digitalWrite(pin4, 0); digitalWrite(pin3, 1); digitalWrite(pin2, 1); digitalWrite(pin1, 0); break;
      case 7:  digitalWrite(pin4, 0); digitalWrite(pin3, 0); digitalWrite(pin2, 1); digitalWrite(pin1, 0); break;
      case 8:  digitalWrite(pin4, 0); digitalWrite(pin3, 0); digitalWrite(pin2, 1); digitalWrite(pin1, 0); break;
      case 9:  digitalWrite(pin4, 0); digitalWrite(pin3, 0); digitalWrite(pin2, 1); digitalWrite(pin1, 1); break;
      case 10: digitalWrite(pin4, 0); digitalWrite(pin3, 0); digitalWrite(pin2, 0); digitalWrite(pin1, 1); break;
      case 11: digitalWrite(pin4, 0); digitalWrite(pin3, 0); digitalWrite(pin2, 0); digitalWrite(pin1, 1); break;
    }
  }

}

void MicroStep45() {
  seq = (seq + (dir ? 1 : -1)) & 7;

  switch (seq) {
    /* Pattern for 8 microsteps: AD-AD-AB-AB-BC-BC-CD-CD */
    /*      [        A        ][         B        ][         C        ][         D        ] */
    case 0: digitalWrite(pin1, 1); digitalWrite(pin2, 0); digitalWrite(pin3, 0); digitalWrite(pin4, 1); break;
    case 1: digitalWrite(pin1, 1); digitalWrite(pin2, 0); digitalWrite(pin3, 0); digitalWrite(pin4, 1); break;
    case 2: digitalWrite(pin1, 1); digitalWrite(pin2, 1); digitalWrite(pin3, 0); digitalWrite(pin4, 0); break;
    case 3: digitalWrite(pin1, 1); digitalWrite(pin2, 1); digitalWrite(pin3, 0); digitalWrite(pin4, 0); break;
    case 4: digitalWrite(pin1, 0); digitalWrite(pin2, 1); digitalWrite(pin3, 1); digitalWrite(pin4, 0); break;
    case 5: digitalWrite(pin1, 0); digitalWrite(pin2, 1); digitalWrite(pin3, 1); digitalWrite(pin4, 0); break;
    case 6: digitalWrite(pin1, 0); digitalWrite(pin2, 0); digitalWrite(pin3, 1); digitalWrite(pin4, 1); break;
    case 7: digitalWrite(pin1, 0); digitalWrite(pin2, 0); digitalWrite(pin3, 1); digitalWrite(pin4, 1); break;
  }
}
