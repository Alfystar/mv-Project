#include "Arduino.h"
#include "lib/nI2C/nI2C.h"

#define ADDRESS_I2C 0x68

// Global handle to I2C device
CI2C::Handle g_i2c_handle;

// Global buffer for received I2C data
// Could be allocated locally as long as the buffer remains in scope for the
// duration of the I2C transfer. Easiest guarantee is to simply make global.
uint8_t g_rx_buffer[100] = { 0 };

// Callback function prototype
void RxCallback(const uint8_t error);

#define wakeUpPin 2
void setup() {
	// You may register up to 63 devices with unique addresses. Each device
	// must be registered and receive a unique handle. Simply pass a device's
	// handle to the library to communicate with the device. Devices are allowed
	// to have different address sizes and different communication speeds.

	// Register device with address size of 1 byte using Fast communication (400KHz)
	g_i2c_handle = nI2C->RegisterDevice(ADDRESS_I2C, 1, CI2C::Speed::FAST);

	// Any transaction that takes longer than the configured timeout will
	// exit and generate an error status. Use this to force reads to complete
	// even if the slave device is stalling (clock-stretching). You may
	// configure the timeout to 0ms if no timeout is desired.
	nI2C->SetTimeoutMS(300); // Set timeout to 100ms in this example.
	uint8_t val;
	val = 0x07;
	nI2C->Write(g_i2c_handle, 0x19, &val,1);
	val = 0x09;
	nI2C->Write(g_i2c_handle, 0x6B, &val,1);
	val = 0x90;
	nI2C->Write(g_i2c_handle, 0x37, &val,1);
	val = 0x08;
	nI2C->Write(g_i2c_handle, 0x1b, &val,1);
	val = 0x08;
	nI2C->Write(g_i2c_handle, 0x1c, &val,1);
	val = 0x09;
	nI2C->Write(g_i2c_handle, 0x6B, &val,1);
	val = 0x01;
	nI2C->Write(g_i2c_handle, 0x38, &val,1);

	// Initialize Serial communication
	Serial.begin(115200);
	pinMode(13, OUTPUT);
	pinMode(12, OUTPUT);

	pinMode(wakeUpPin,INPUT_PULLUP);
	attachInterrupt(digitalPinToInterrupt(wakeUpPin),readInt,FALLING);
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
		nI2C->Read(g_i2c_handle, 0x3B, (uint8_t*) g_rx_buffer, 14, RxCallback);
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
		int i = g_rx_buffer[0] << 8 | g_rx_buffer[1];
		Serial.println(i);
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

