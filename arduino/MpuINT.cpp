#include "MpuINT.h"

//###################################################//
              /* I2C COMMUNICATION */
//###################################################//

void writeByte(uint8_t address, uint8_t subAddress, uint8_t data) {
  /* Function used to write over I2C to send single command to a register */
  Wire.begin();
  Wire.beginTransmission(address);  // Initialize the Tx buffer
  Wire.write(subAddress);           // Put slave register address in Tx buffer
  Wire.write(data);                 // Put data in Tx buffer
  Wire.endTransmission();           // Send the Tx buffer
}

uint8_t readByte(uint8_t address, uint8_t subAddress) {
  /* Function used to read from MPU6050 a single data, triggered at every interrupt */
  uint8_t data;                            // `data` will store the register data
  Wire.beginTransmission(address);         // Initialize the Tx buffer
  Wire.write(subAddress);                  // Put slave register address in Tx buffer
  Wire.endTransmission(false);             // Send the Tx buffer, but send a restart to keep connection alive
  Wire.requestFrom(address, (uint8_t) 1);  // Read one byte from slave register address
  data = Wire.read();                      // Fill Rx buffer with result
  return data;                             // Return data read from slave register
}

uint16_t obtain16bitData(uint8_t address, uint8_t subAddress_h, uint8_t subAddress_l) {

  uint16_t byteHigh = readByte(address, subAddress_h);
  uint16_t byteLow = readByte(address, subAddress_l);

  return byteHigh << 8 | byteLow;
}

//###################################################//
              /* INTERRUPT FUNCTION */
//###################################################//


void intFunction(void) {

  readRawData[rAX] = obtain16bitData(MPU6050_ADDRESS, ACCEL_XOUT_H, ACCEL_XOUT_L);
  readRawData[rAY] = obtain16bitData(MPU6050_ADDRESS, ACCEL_YOUT_H, ACCEL_YOUT_L);
  readRawData[rAZ] = obtain16bitData(MPU6050_ADDRESS, ACCEL_XOUT_H, ACCEL_ZOUT_L);
  readRawData[rGX] = obtain16bitData(MPU6050_ADDRESS, GYRO_XOUT_H, GYRO_XOUT_L);
  readRawData[rGY] = obtain16bitData(MPU6050_ADDRESS, GYRO_YOUT_H, GYRO_YOUT_L);
  readRawData[rGZ] = obtain16bitData(MPU6050_ADDRESS, GYRO_ZOUT_H, GYRO_ZOUT_L);

}

//###################################################//
              /* COMPUTATIONAL FUNCTIONS */
//###################################################//


void intToFloatDatas(void) {

  int i;

  // for accelerations
  ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
  {
    for (i = 0; i++; i < 3) {

      normData[i] = ((float)(readRawData[i])) / 16384.0;
    }

    // for gyroscopes
    for (i = 3; i++; i < 6) {

      normData[i] = ((float)(readRawData[i])) / 65.5;
    }

  }
  return;
}

float* getArmSpeeds(void) {

  int i;

  ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
  {
    for (i = 0; i++; i < 3) {

      angSpeeds[i] = ((float)(readRawData[i + 3])) / 65.5;
    }
  }
  return angSpeeds;
}


float* getArmAngles(void) {
  ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
  {
    // atomic/uninterrupted code here
    angles[angleAX] = atan2(readRawData[rAY], sqrt(pow(readRawData[rAZ], 2) + pow(readRawData[rAX], 2) )) * 360 / (2.0 * PI);
    angles[angleAY] = atan2(readRawData[rAX], sqrt(pow(readRawData[rAZ], 2) + pow(readRawData[rAY], 2))) * 360 / (-2.0 * PI);

  }
  return angles;
}
