#include <avr/sleep.h>  
#include <Wire.h>

//Analog port 4 (A4) = SDA (serial data)
//Analog port 5 (A5) = SCL (serial clock)

#define SIGNAL_PATH_RESET   0x68 // reset signal paths (NOT clear sensor registers); bits [2:0] available.
#define INT_PIN_CFG         0x37 // configures the behavior of the interrupt signals at INT pin. See below in setup() 
#define ACCEL_CONFIG        0x1C // trigger accelerometer self-test and configure its full scale range
#define GYRO_CONFIG         0x1B // trigger gyroscope self-test and configure its full scale range.
#define MOT_THR             0x1F // Motion detection threshold bits [7:0]
#define MOT_DUR             0x20 // Duration counter threshold for motion interrupt generation, 1 kHz rate, as b0010 0000
#define MOT_DETECT_CTRL     0x69 // add delay to the accelerometer power on time (TODO: activate gyroscope)
#define INT_ENABLE          0x38 // enables interrupt generation by interrupt sources
#define WHO_AM_I_MPU6050    0x75 // Should return 0x68, as it verifies the identity of the device
#define INT_STATUS          0x3A // shows the interrupt status of each interrupt generation source
#define PWR_MGMT_1          0x6B // configure power mode and clock source, reset the entire device and disable temp sensor

//when nothing connected to AD0 than address is 0x68
#define AD0 0

#if AD0
#define MPU6050_ADDRESS 0x69  // Device address when AD0 = 1
#else
#define MPU6050_ADDRESS 0x68  // Device address when AD0 = 0
#endif

#define FAST_MODE 400000 // set i2c speed (Hz)

int wakePin = 2;                 // pin used for waking up
int led=13;
int flag=0;

void wakeUpNow(){

// THE PROGRAM CONTINUES FROM HERE AFTER WAKING UP    (i.e. after getting interrupt)
// execute code here after wake-up before returning to the loop() function
// timers and code using timers (serial.print and more...) will not work here.
// we don't really need to execute any special functions here, since we
// just want the thing to wake up

  delay(500);
  Serial.println("Rajat9");
  delay(500);
  int count = 10;
  while (count != 0){
    delay(1000);
    count--;
    Serial.println(count);
    delay(1000);
  }
}

void writeByte(uint8_t address, uint8_t subAddress, uint8_t data){
  /* Function used to write over I2C to send single command to a register */
  Wire.begin();
  Wire.beginTransmission(address);  // Initialize the Tx buffer
  Wire.write(subAddress);           // Put slave register address in Tx buffer
  Wire.write(data);                 // Put data in Tx buffer
  Wire.endTransmission();           // Send the Tx buffer
}

uint8_t readByte(uint8_t address, uint8_t subAddress){
  /* Function used to read from MPU6050 a single data, triggered at every interrupt */
  uint8_t data;                            // `data` will store the register data
  Wire.beginTransmission(address);         // Initialize the Tx buffer
  Wire.write(subAddress);                  // Put slave register address in Tx buffer
  Wire.endTransmission(false);             // Send the Tx buffer, but send a restart to keep connection alive
  Wire.requestFrom(address, (uint8_t) 1);  // Read one byte from slave register address
  data = Wire.read();                      // Fill Rx buffer with result
  return data;                             // Return data read from slave register
}

void setup() {
  Serial.begin(9600);

  Wire.setClock(FAST_MODE);

  writeByte( MPU6050_ADDRESS, PWR_MGMT_1, 0x00);        /*Putting 0x00 we use the internal 8MHz oscillator. We could 
                                                          put the TEMP_DIS (3rd) bit to 1 to disable temp sensor*/   
  writeByte( MPU6050_ADDRESS, SIGNAL_PATH_RESET, 0x07); /*Reset all internal signal paths in the MPU-6050 
                                                          by writing 0x07 to register 0x68*/
  writeByte( MPU6050_ADDRESS, INT_PIN_CFG , 0x20);      /*write register 0x37 to select how to use the interrupt pin.
                                                          0x20 == LATCH_INT_EN = 1, the INT pin is active high, and held
                                                          until register 0x3A is read*/
  writeByte( MPU6050_ADDRESS, ACCEL_CONFIG, 0x01|0xE8); /*Write register 0x1C to set the Digital High Pass Filter,
                                                          bits 3:0. For example set it to 0x01 for 5Hz.
                                                          (These 3 bits are grey in the data sheet, but they are used!
                                                          Leaving them 0 means the filter always outputs 0.). Moreover,
                                                          enable self-test on all three axes and set accelerometer
                                                          range to +/- 4g */
  writeByte( MPU6050_ADDRESS, GYRO_CONFIG, 0xE8);       /*Enable self-test on all three axes and set gyroscope range
                                                          to +/- 500°/s */                                                 
  writeByte( MPU6050_ADDRESS, MOT_THR, 20);             /*Write the desired Motion threshold to register 0x1F (For 
                                                          example, write decimal 20).*/
  writeByte( MPU6050_ADDRESS, MOT_DUR, 40);             /*Set motion detect duration to 1  ms; LSB is 1 ms @ 1 kHz rate */
  writeByte( MPU6050_ADDRESS, MOT_DETECT_CTRL, 0x15);   /*to register 0x69, write the motion detection decrement and a
                                                          few other settings (for example write 0x15 to set both 
                                                          free-fall and motion decrements to 1 and accelerometer start-up
                                                          delay to 5ms total by adding 1ms. )*/
  writeByte( MPU6050_ADDRESS, INT_ENABLE, 0x40);        /*write register 0x38, bit 6 (0x40), to enable motion 
                                                          detection interrupt.*/
  writeByte( MPU6050_ADDRESS, INT_PIN_CFG, 0xA0);       /* now INT pin is active low */

  pinMode(wakePin, INPUT_PULLUP);  // wakePin is pin no. 2
  pinMode(led, OUTPUT);          //   led is pin no. 13
}

void sleepNow(){
  set_sleep_mode(SLEEP_MODE_PWR_DOWN);   // sleep mode is set here
  sleep_enable();                        // enables the sleep bit in the mcucr register
  delay(500);
  Serial.println("Rajat");
  delay(500);
  attachInterrupt(0, wakeUpNow, LOW); // use interrupt 0 (pin 2) and run function
  delay(500);
  Serial.println("Rajat62");
  delay(500);
  sleep_mode();     // here the device is actually put to sleep...!!


  // THE PROGRAM CONTINUES FROM HERE AFTER INTERRUPT IS CLOSED
  delay(500);
  Serial.println("Rajat2");
  delay(500);

  sleep_disable();         // first thing after waking from sleep: disable sleep...
  delay(500);
  Serial.println("Rajat3");
  delay(500);
  detachInterrupt(0);   //We detach the interrupt to stop it from continuously firing while the interrupt pin is low.
}

uint16_t readdata;

uint16_t obtain16bitData(uint8_t address, uint8_t subAddress_h, uint8_t subAddress_l){

  uint16_t byteHigh = readByte(address, subAddress_h);
  uint16_t byteLow = readByte(address, subAddress_l);

  return byteHigh << 8 | byteLow;    
}


void loop() {
  if (digitalRead(2) == 0) {
      digitalWrite(13, 1);
      delay(100);
      digitalWrite(13, 0);
      delay(100);
  }
  sleepNow();     // sleep function called here

  /*These are Debug readings; we obtain INT_STATUS (0x3A) and INT_PIN_CFG (0X37)*/
  readdata = readByte(MPU6050_ADDRESS, 0x3A);
  Serial.print(readdata); Serial.print(",");
  readdata = readByte(MPU6050_ADDRESS, 0x37);
  Serial.println(readdata);

  /*We can obtain the full 16-bit 2’s complement value data with the function below
  ACCEL_XOUT_H 0x3B   ACCEL_XOUT_L 0x3C
  ACCEL_YOUT_H 0x3D   ACCEL_YOUT_L 0x3E
  ACCEL_ZOUT_H 0x3F   ACCEL_ZOUT_L 0x40
  TEMP_OUT_H   0x41   TEMP_OUT_L   0x42
  GYRO_XOUT_H  0x43   GYRO_XOUT_L  0x44
  GYRO_YOUT_H  0x45   GYRO_YOUT_L  0x46
  GYRO_ZOUT_H  0x47   GYRO_ZOUT_L  0x48
  */
  readdata = obtain16bitData(MPU6050_ADDRESS, 0x3B, 0x3C); // acc_X
  Serial.println(readdata); 
}
