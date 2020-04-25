const Map<int, String> inputOnlyPins = {
  34: 'GPIO 34',
  35: 'GPIO 35',
  36: 'GPIO 36',
  39: 'GPIO 39',
};

var inputOnlyPinsKEYS = inputOnlyPins.keys.toList();
var inputOnlyPinsLIST = inputOnlyPins.values.toList();

const Map<int, String> SPIFlashPins = {
  6: 'GPIO 6 (SCK/CLK)',
  7: 'GPIO 7 (SDO/SD0)',
  8: 'GPIO 8 (SDI/SD1)',
  9: 'GPIO 9 (SHD/SD3)',
  10: 'GPIO 10 (SWP/SD3)',
  11: 'GPIO 11 (CSC/CMD)',
};

var SPIFlashPinsKEYS = SPIFlashPins.keys.toList();
var SPIFlashPinsLIST = SPIFlashPins.values.toList();

const Map<int, String> capacitiveTouchPins = {
  4: 'T0 - GPIO 4',
  0: 'T1 - GPIO 0',
  2: 'T2 - GPIO 2',
  15: 'T3 - GPIO 15',
  13: 'T4 - GPIO 13',
  12: 'T5 - GPIO 12',
  14: 'T6 - GPIO 14',
  27: 'T7 - GPIO 27',
  33: 'T8 - GPIO 33',
  32: 'T9 - GPIO 32'
};

var capacitiveTouchPinsKEYS = capacitiveTouchPins.keys.toList();
var capacitiveTouchPinsLIST = capacitiveTouchPins.values.toList();

const Map<int, String> ADCPins = {
  36: 'ADC1_CH0 - GPIO 36',
  37: 'ADC1_CH1 - GPIO 37',
  38: 'ADC1_CH2 - GPIO 38',
  39: 'ADC1_CH3 - GPIO 39',
  32: 'ADC1_CH4 - GPIO 32',
  33: 'ADC1_CH5 - GPIO 33',
  34: 'ADC1_CH6 - GPIO 34',
  35: 'ADC1_CH7 - GPIO 35',
  4: 'ADC2_CH0 - GPIO 4',
  0: 'ADC2_CH1 - GPIO 0',
  2: 'ADC2_CH2 - GPIO 2',
  15: 'ADC2_CH3 - GPIO 15',
  13: 'ADC2_CH4 - GPIO 13',
  12: 'ADC2_CH5 - GPIO 12',
  14: 'ADC2_CH6 - GPIO 14',
  27: 'ADC2_CH7 - GPIO 27',
  25: 'ADC2_CH8 - GPIO 25',
  26: 'ADC2_CH9 - GPIO 26',
};

var ADCPinsKEYS = ADCPins.keys.toList();
var ADCPinsLIST = ADCPins.values.toList();

const Map<int, String> DACPins = {
  25: 'DAC1 - GPIO 25',
  26: 'DAC2 - GPIO 26',
};

var DACPinsKEYS = DACPins.keys.toList();
var DACPinsLIST = DACPins.values.toList();

const Map<int, String> RTCPins = {
  36: 'RTC_GPIO0 - GPIO 36',
  39: 'RTC_GPIO3 - GPIO 39',
  34: 'RTC_GPIO4 - GPIO 34',
  35: 'RTC_GPIO5 - GPIO 35',
  25: 'RTC_GPIO6 - GPIO 25',
  26: 'RTC_GPIO7 - GPIO 26',
  33: 'RTC_GPIO8 - GPIO 33',
  32: 'RTC_GPIO9 - GPIO 32',
  4: 'RTC_GPIO10 - GPIO 4',
  0: 'RTC_GPIO11 - GPIO 0',
  2: 'RTC_GPIO12 - GPIO 2',
  15: 'RTC_GPIO13 - GPIO 15',
  13: 'RTC_GPIO14 - GPIO 13',
  12: 'RTC_GPIO15 - GPIO 12',
  14: 'RTC_GPIO16 - GPIO 14',
  27: 'RTC_GPIO17 - GPIO 27',
};

var RTCPinsKEYS = RTCPins.keys.toList();
var RTCPinsLIST = RTCPins.values.toList();

const Map<int, String> I2CPins = {
  21: 'SDA - GPIO 21',
  22: 'SCL - GPIO 22',
};

var I2CPinsKEYS = I2CPins.keys.toList();
var I2CPinsLIST = I2CPins.values.toList();
