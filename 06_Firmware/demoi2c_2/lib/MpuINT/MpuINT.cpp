#include "MpuINT.h"

CI2C::Handle g_i2c_handle;
rawData_t rD;
floatData_t fD;
angles_t armAngles;

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
	writeReg(&g_i2c_handle, CONFIG, (digitalFilter << DLPF_CFG)); //bandwit 94 HZ delay 3 ms (FS=1KHZ)
	writeReg(&g_i2c_handle, PWR_MGMT_1, 0x09);
	writeReg(&g_i2c_handle, INT_PIN_CFG, 0x90);
	writeReg(&g_i2c_handle, GYRO_CONFIG, (gySens << FS_SEL));
	writeReg(&g_i2c_handle, ACCEL_CONFIG, (accSens << ASF_SEL)); //set G sensitivy at 4G
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
		nI2C->Read(g_i2c_handle, ACCEL_XOUT_H, rD.I2C_buf, sizeof(rawData_t),
				RxCallback);
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
		for (uint8_t i = 0; i < sizeof(rD); i += 2) {
			//Serial.println(i);
			app = rD.I2C_buf[i];
			rD.I2C_buf[i] = rD.I2C_buf[i + 1];
			rD.I2C_buf[i + 1] = app;
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

void i2FDatas() {
	// for accelerations
	iT2F_acc();
	// for temperatures
	iT2F_tmp();
	// for gyroscopes
	iT2F_gyro();
}

void iT2F_acc() {
	fD.flAccX = ((float) rD.rawAccX) / (1 << (14 - accSens)); // trucco per rendere parametrici i G
	fD.flAccY = ((float) rD.rawAccY) / (1 << (14 - accSens));
	fD.flAccZ = ((float) rD.rawAccZ) / (1 << (14 - accSens));
}
void iT2F_tmp() {
	fD.flTemp = (rD.rawTemp + 12412.0) / 340.0;
}
void iT2F_gyro() {
	fD.flGyrX = (rD.rawGyrX) / (131.0 / (1 << gySens));
	fD.flGyrY = (rD.rawGyrY) / (131.0 / (1 << gySens));
	fD.flGyrZ = (rD.rawGyrZ) / (131.0 / (1 << gySens));
}

void updateArmAngles(void) {
	//todo: farlo rispetto alla nostra terna di angoli
	iT2F_acc();

	armAngles.angleX = atan2(fD.flAccY, sqrt(
	sq(fD.flAccZ) + sq(fD.flAccX))) * RAD_TO_DEG;

	armAngles.angleY = atan2(fD.flAccX, sqrt(
	sq(fD.flAccZ) + sq(fD.flAccY))) * RAD_TO_DEG;

}

void mpuDebug(){
	i2FDatas();
	Serial.print("accX=");
		Serial.print(fD.flAccX);
		Serial.print("\taccY=");
		Serial.print(fD.flAccY);
		Serial.print("\taccZ=");
		Serial.print(fD.flAccZ);
		Serial.print("\tTemp=");
		Serial.print(fD.flTemp);
		Serial.print("\tgyroX=");
		Serial.print(fD.flGyrX);
		Serial.print("\tgyroY=");
		Serial.print(fD.flGyrY);
		Serial.print("\tgyroZ=");
		Serial.println(fD.flGyrZ);
}

void mpuDebugRaw() {
	Serial.print("accX=");
	Serial.print(rD.rawAccX);
	Serial.print("\taccY=");
	Serial.print(rD.rawAccY);
	Serial.print("\taccZ=");
	Serial.print(rD.rawAccZ);
	Serial.print("\tTemp=");
	Serial.print(rD.rawTemp);
	Serial.print("\tgyroX=");
	Serial.print(rD.rawGyrX);
	Serial.print("\tgyroY=");
	Serial.print(rD.rawGyrY);
	Serial.print("\tgyroZ=");
	Serial.println(rD.rawGyrZ);
}
void mpuDebugAngle() {
	updateArmAngles();

	Serial.print(armAngles.angleX);
	Serial.print("\t");
	Serial.println(armAngles.angleY);
}
