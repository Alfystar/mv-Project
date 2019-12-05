#include "MpuINT.h"

/*We can obtain the full 16-bit 2’s complement value data with the function below
  ACCEL_XOUT_H 0x3B   ACCEL_XOUT_L 0x3C
  ACCEL_YOUT_H 0x3D   ACCEL_YOUT_L 0x3E
  ACCEL_ZOUT_H 0x3F   ACCEL_ZOUT_L 0x40
  TEMP_OUT_H   0x41   TEMP_OUT_L   0x42
  GYRO_XOUT_H  0x43   GYRO_XOUT_L  0x44
  GYRO_YOUT_H  0x45   GYRO_YOUT_L  0x46
  GYRO_ZOUT_H  0x47   GYRO_ZOUT_L  0x48
*/

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

uint16_t obtain16bitData(uint8_t address, uint8_t subAddress_h, uint8_t subAddress_l){

  uint16_t byteHigh = readByte(address, subAddress_h);
  uint16_t byteLow = readByte(address, subAddress_l);

  return byteHigh << 8 | byteLow;    
}