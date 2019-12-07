#include "MpuINT.h"

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
                                                          by writing 0x07 to register 0x68*/
  writeByte( MPU6050_ADDRESS, INT_PIN_CFG , 0x20);      /*write register 0x37 to select how to use the interrupt pin.
                                                          0x20 == LATCH_INT_EN = 1, the INT pin is active high, and held
                                                          until register 0x3A is read*/
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






}
