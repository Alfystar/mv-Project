#include "Arduino.h"
#include "lib/nI2C/nI2C.h"
#include "lib/MpuINT/MpuINT.h"

// Global handle to I2C device
CI2C::Handle g_i2c_handle;

// Global buffer for received I2C data
// Could be allocated locally as long as the buffer remains in scope for the
// duration of the I2C transfer. Easiest guarantee is to simply make global.
//uint8_t g_rx_buffer[100] = { 0 };

// we allocate global variables which will contain data

readRawData_t rawData;
divRawData_t structRawData;

processedData_t procData;
divFloatData_t structFloatData;

angles_t armAngles;
angSpeeds_t angSpeeds;



// Callback function prototype
void RxCallback(const uint8_t error);

#define wakeUpPin 2
void setup() {
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
	nI2C->SetTimeoutMS(300); // Set timeout to 100ms in this example.
	uint8_t val;
	val = 0x07;
	nI2C->Write(g_i2c_handle, SMPRT_DIV, &val,1);
	val = 0x09;
	nI2C->Write(g_i2c_handle, PWR_MGMT_1, &val,1);
	val = 0x90;
	nI2C->Write(g_i2c_handle, INT_PIN_CFG, &val,1);
	val = 0x08;
	nI2C->Write(g_i2c_handle, GYRO_CONFIG, &val,1);
	val = 0x08;
	nI2C->Write(g_i2c_handle, ACCEL_CONFIG, &val,1);
	val = 0x01;
	nI2C->Write(g_i2c_handle, INT_ENABLE, &val,1);

	// Initialize Serial communication
	Serial.begin(115200);
	pinMode(13, OUTPUT);
	pinMode(12, OUTPUT);

	pinMode(wakeUpPin,INPUT_PULLUP);

	attachInterrupt(digitalPinToInterrupt(wakeUpPin), readInt, FALLING);
}

volatile bool flag=false;

void readInt(){
	digitalWrite(13, !digitalRead(13));
	digitalWrite(12, 0);
	flag=true;
	//digitalWrite(13, 0);
}

// The loop function is called in an endless loop
void loop() {

	if(flag){
		nI2C->Read(g_i2c_handle, ACCEL_XOUT_H, rawData.dataFromI2C, sizeof(rawData), RxCallback);
		flag=false;
	}
	// Perform non-blocking I2C read
	// RxCallback() will be invoked upon completion of I2C transfer
	// Request 6 bytes from slave device
	/*
	digitalWrite(12, 0);
	digitalWrite(13, 1);
	uint8_t status = nI2C->Read(g_i2c_handle, 0x3B, (uint8_t*) g_rx_buffer, 14);
	RxCallback(status);
	digitalWrite(13, 0);
	*/

	/*--------------------------------------------------------------------------
	 Note: You may also want the alternative method listed below which
	 automatically handles writing the slave register address before reading.
	 This is the standard approach for RTCs and EEPROMs.

	 Replace <address> with the slave device register address

	 nI2C->Read(g_i2c_handle, <address>, message, sizeof(message));
	 --------------------------------------------------------------------------*/
/*
	if (status) {
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
/*
		Serial.print("\t[loop]Communication Status #: ");
		Serial.println(status);
	}
*/

	//delay(1);
}

void RxCallback(const uint8_t status) {
	digitalWrite(12, 1);

	// Check that no errors occurred
	if (status == 0) {
		Serial.print("Received: ");
		//int i = g_rx_buffer[0] << 8 | g_rx_buffer[1];
		Serial.println(structRawData.rawAccX);
		//delay(500);
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
		//delay(500);
	}
}

