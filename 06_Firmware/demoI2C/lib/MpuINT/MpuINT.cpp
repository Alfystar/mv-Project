#include "MpuINT.h"

//###################################################//
              /* I2C COMMUNICATION */
//###################################################//

// void writeByte(uint8_t address, uint8_t subAddress, uint8_t data) {
  // /* Function used to write over I2C to send single command to a register */
  // Wire.begin();
  // Wire.beginTransmission(address);  // Initialize the Tx buffer
  // Wire.write(subAddress);           // Put slave register address in Tx buffer
  // Wire.write(data);                 // Put data in Tx buffer
  // Wire.endTransmission();           // Send the Tx buffer
// }

// uint8_t readByte(uint8_t address, uint8_t subAddress) {
  // /* Function used to read from MPU6050 a single data, triggered at every interrupt */
  // uint8_t data;                            // `data` will store the register data
  // Wire.beginTransmission(address);         // Initialize the Tx buffer
  // Wire.write(subAddress);                  // Put slave register address in Tx buffer
  // Wire.endTransmission(false);             // Send the Tx buffer, but send a restart to keep connection alive
  // Wire.requestFrom(address, (uint8_t) 1);  // Read one byte from slave register address
  // data = Wire.read();                      // Fill Rx buffer with result
  // return data;                             // Return data read from slave register
// }

// uint16_t obtain16bitData(uint8_t address, uint8_t subAddress_h, uint8_t subAddress_l) {

  // uint16_t byteHigh = readByte(address, subAddress_h);
  // uint16_t byteLow = readByte(address, subAddress_l);

  // return byteHigh << 8 | byteLow;
// }

//###################################################//
              /* INTERRUPT FUNCTION */
//###################################################//


// void intFunction(void) {

  // readRawData[rAX] = obtain16bitData(MPU6050_ADDRESS, ACCEL_XOUT_H, ACCEL_XOUT_L);
  // readRawData[rAY] = obtain16bitData(MPU6050_ADDRESS, ACCEL_YOUT_H, ACCEL_YOUT_L);
  // readRawData[rAZ] = obtain16bitData(MPU6050_ADDRESS, ACCEL_XOUT_H, ACCEL_ZOUT_L);
  // readRawData[rGX] = obtain16bitData(MPU6050_ADDRESS, GYRO_XOUT_H, GYRO_XOUT_L);
  // readRawData[rGY] = obtain16bitData(MPU6050_ADDRESS, GYRO_YOUT_H, GYRO_YOUT_L);
  // readRawData[rGZ] = obtain16bitData(MPU6050_ADDRESS, GYRO_ZOUT_H, GYRO_ZOUT_L);

// }

//###################################################//
              /* COMPUTATIONAL FUNCTIONS */
//###################################################//


void intToFloatDatas(void) {

  ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
	// for accelerations
	structFloatData.flAccX = ((float)structRawData.rawAccX)/16384.0;
	structFloatData.flAccY = ((float)structRawData.rawAccY)/16384.0;
	structFloatData.flAccZ = ((float)structRawData.rawAccZ)/16384.0;

    // for temperatures
	structFloatData.flTemp = ((float)structRawData.rawTemp + 12412.0) / 340.0;

    // for gyroscopes
	structFloatData.flGyrX = ((float)structRawData.rawGyrX)/65.5;
	structFloatData.flGyrY = ((float)structRawData.rawGyrY)/65.5;
	structFloatData.flGyrZ = ((float)structRawData.rawGyrZ)/65.5;
  }
  return;
}


void updateArmSpeeds(void) {

  ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
	  // atomic/uninterrupted code here
	  angSpeeds.angSpeedX = ((float)structRawData.rawGyrX)/65.5;
	  angSpeeds.angSpeedY = ((float)structRawData.rawGyrY)/65.5;
	  angSpeeds.angSpeedZ = ((float)structRawData.rawGyrZ)/65.5;
  }
  return;
}


void updateArmAngles(void) {

  ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
    // atomic/uninterrupted code here
    armAngles.angleX = atan2(structRawData.rawAccY, sqrt(sq(structRawData.rawAccZ) + sq(structRawData.rawAccX) )) * 360 / (2.0 * PI);
    armAngles.angleY = atan2(structRawData.rawAccX, sqrt(sq(structRawData.rawAccZ) + sq(structRawData.rawAccY) )) * 360 / (-2.0 * PI);
  }
  return;
}
