#include "MpuINT.h"

/*
extern readRawData_t rawData;
extern processedData_t procData;
extern angles_t armAngles;
extern angSpeeds_t angSpeeds;
*/

//###################################################//
/* I2C COMMUNICATION */
//###################################################//
/*
void initi2c() {
	// You may register up to 63 devices with unique addresses. Each device
	// must be registered and receive a unique handle. Simply pass a device's
	// handle to the library to communicate with the device. Devices are allowed
	// to have different address sizes and different communication speeds.

	// Register device with address size of 1 byte using Fast communication (400KHz)
	g_i2c_handle = nI2C->RegisterDevice(MPU6050_ADDRESS, 1, CI2C::Speed::FAST);

	// Any transaction that takes longer than the configured timeout will
	// exit and generate an error status. Use this to force reads to complete
	// even if the slave device is stalling (clock-stretching). You may
	// configure the timeout to 0ms if no timeout is desired.
	nI2C->SetTimeoutMS(100); // Set timeout to 100ms in this example.

	writeReg(&g_i2c_handle, SMPRT_DIV, 0x07);
	writeReg(&g_i2c_handle, CONFIG, 0x02); //bandwit 94 HZ delay 3 ms (FS=1KHZ)
	writeReg(&g_i2c_handle, PWR_MGMT_1, 0x09);
	writeReg(&g_i2c_handle, INT_PIN_CFG, 0x90);
	writeReg(&g_i2c_handle, GYRO_CONFIG, 0x08);
	writeReg(&g_i2c_handle, ACCEL_CONFIG, 0x08);
	writeReg(&g_i2c_handle, INT_ENABLE, 0x01);

}

void writeReg(CI2C::Handle* handler, byte reg, byte val) {
	nI2C->Write(*handler, reg, &val, 1);
}
*/
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

	ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
	{
		// for accelerations
		procData.floatData.flAccX = ((float) rawData.rawData.rawAccX) / 16384.0;
		procData.floatData.flAccY = ((float) rawData.rawData.rawAccY) / 16384.0;
		procData.floatData.flAccZ = ((float) rawData.rawData.rawAccZ) / 16384.0;

		// for temperatures
		procData.floatData.flTemp = ((float) rawData.rawData.rawTemp + 12412.0)
				/ 340.0;

		// for gyroscopes
		procData.floatData.flGyrX = ((float) rawData.rawData.rawGyrX) / 65.5;
		procData.floatData.flGyrY = ((float) rawData.rawData.rawGyrY) / 65.5;
		procData.floatData.flGyrZ = ((float) rawData.rawData.rawGyrZ) / 65.5;
	}
	return;
}

void updateArmSpeeds(void) {

	ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
	{
		// atomic/uninterrupted code here
		angSpeeds.angSpeedX = ((float) rawData.rawData.rawGyrX) / 65.5;
		angSpeeds.angSpeedY = ((float) rawData.rawData.rawGyrY) / 65.5;
		angSpeeds.angSpeedZ = ((float) rawData.rawData.rawGyrZ) / 65.5;
	}
	return;
}

void updateArmAngles(void) {

	ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
	{
		// atomic/uninterrupted code here
		armAngles.angleX = atan2(rawData.rawData.rawAccY,
				sqrt(sq(rawData.rawData.rawAccZ) + sq(rawData.rawData.rawAccX)))
				* 360 / (2.0 * PI);
		armAngles.angleY = atan2(rawData.rawData.rawAccX,
				sqrt(sq(rawData.rawData.rawAccZ) + sq(rawData.rawData.rawAccY)))
				* 360 / (-2.0 * PI);
	}
	return;
}

