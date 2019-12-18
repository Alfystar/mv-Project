#include "MpuINT.h"

CI2C::Handle g_i2c_handle;
readRawData_t rawData;
processedData_t procData;
divFloatData_t structFloatData;
angles_t armAngles;
angSpeeds_t angSpeeds;

volatile bool mpuFlag = false;

void initi2c(byte intPin) {
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

	mpuFlag = false;

	pinMode(intPin, INPUT_PULLUP);

	attachInterrupt(digitalPinToInterrupt(intPin), readInt, FALLING);
}

//###################################################//
// INTERRUPT FUNCTION //
//###################################################//

void MPUUpdate() {
	if (mpuFlag) {
		nI2C->Read(g_i2c_handle, ACCEL_XOUT_H, rawData.dataFromI2C,
				sizeof(readRawData_t), RxCallback);
		mpuFlag = false;
	}
}

void readInt() {
	mpuFlag = true;
}

uint8_t app;
void RxCallback(const uint8_t status) {
	// Check that no errors occurred
	if (status == 0) {
		//Inversione da Big-Endian(mpu) a littleEndian(atmega)
		for (uint8_t i = 0; i < sizeof(divRawData_t); i += 2) {
			//Serial.println(i);
			app = rawData.dataFromI2C[i];
			rawData.dataFromI2C[i] = rawData.dataFromI2C[i + 1];
			rawData.dataFromI2C[i + 1] = app;
		}
	} else {
		/*
		 Status values are as follows:
		 0:success
		 1:busy
		 2:timeout
		 3:data too long to fit in transmit buffer
		 4:memory allocation failure
		 5:attempted illegal transition of state
		 6:received NACK on transmit of address
		 7:received NACK on transmit of data
		 8:illegal start or stop condition on bus
		 9:lost bus arbitration to other master
		 */
		Serial.print("[RxCallback]Communication Status #: ");
		Serial.println(status);
		delay(100);
	}
}

//###################################################//
// I2C COMMUNICATION //
//###################################################//

void writeReg(CI2C::Handle* handler, byte reg, byte val) {
	nI2C->Write(*handler, reg, &val, 1);
}

//###################################################//
// COMPUTATIONAL FUNCTIONS //
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

void mpuDebug() {
	Serial.print("accX=");
	Serial.print(rawData.rawData.rawAccX);
	Serial.print("\taccY=");
	Serial.print(rawData.rawData.rawAccY);
	Serial.print("\taccZ=");
	Serial.print(rawData.rawData.rawAccZ);
	Serial.print("\tTemp=");
	Serial.print(rawData.rawData.rawTemp);
	Serial.print("\tgyroX=");
	Serial.print(rawData.rawData.rawGyrX);
	Serial.print("\tgyroY=");
	Serial.print(rawData.rawData.rawGyrY);
	Serial.print("\tgyroZ=");
	Serial.println(rawData.rawData.rawGyrZ);
}

