#include "MpuINT.h"

<<<<<<< HEAD
#define FAST_MODE 400000 // set i2c speed (Hz)

int wakePin = 2;    // pin used for waking up
int led = 13;
int flag = 0;
uint16_t readdata;  // 16bit used for storing collected data

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

void setup() {
  Serial.begin(115200);
  Wire.setClock(FAST_MODE);

  writeByte( MPU6050_ADDRESS, PWR_MGMT_1, 0x00);        /*Putting 0x00 we use the internal 8MHz oscillator. We could 
                                                          put the TEMP_DIS (3rd) bit to 1 to disable temp sensor*/   
  writeByte( MPU6050_ADDRESS, SIGNAL_PATH_RESET, 0x07); /*Reset all internal signal paths in the MPU-6050 
=======
#define FAST_MODE 400000 /* set i2c speed (Hz) {TODO: find if it's a global setting, or
                                                we have to set at every Wire.begin() } */

#define wakePin 2 // pin2 which is interrupt_0
#define intPin digitalPinToInterrupt(wakePin) //simpler to use 

#define led 13


uint16_t volatile readRawData[6];  // 16bit used for storing collected data

float normData[6]; //computed data with 

float angles[2]; // computed angles;

float angSpeeds[3]; //computed velocities, based on rawGyro datas


void setup() {
  Serial.begin(115200);

  writeByte( MPU6050_ADDRESS, PWR_MGMT_1, 0x08);        /*Activate the internal 8MHz oscillator and TEMP_DIS (bit_3)
                                                          to disable temp sensor*/
  writeByte( MPU6050_ADDRESS, SIGNAL_PATH_RESET, 0x07); /*Reset all internal signal paths in the MPU-6050
>>>>>>> ca8a2734597323e7bd75f8f24ddfebb5109cc0e7
                                                          by writing 0x07 to register 0x68*/
  writeByte( MPU6050_ADDRESS, INT_PIN_CFG , 0x20);      /*write register 0x37 to select how to use the interrupt pin.
                                                          0x20 == LATCH_INT_EN = 1, the INT pin is active high, and held
                                                          until register 0x3A is read*/
<<<<<<< HEAD
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
  
  // With the next line we instead obtain an acc_data
  readdata = obtain16bitData(MPU6050_ADDRESS, 0x3F, 0x40); // acc_Z
  Serial.println(readdata); 
=======
  writeByte( MPU6050_ADDRESS, ACCEL_CONFIG, 0x08);      /*Set accelerometer range to +/- 4g */
  writeByte( MPU6050_ADDRESS, GYRO_CONFIG, 0x08);       /*Set gyroscope range to +/- 500°/s */
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


  pinMode(wakePin, INPUT_PULLUP);  // since attachInterrupt doesn't change pinmode
  attachInterrupt(intPin, intFunction, LOW); // use interrupt 0 (pin 2) and run function when LOW
  pinMode(led, OUTPUT);          //   led is pin no. 13 (for debugging )
}


void loop() {






>>>>>>> ca8a2734597323e7bd75f8f24ddfebb5109cc0e7
}
