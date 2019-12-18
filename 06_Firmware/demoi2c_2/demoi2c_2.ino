#include "Arduino.h"
#include "lib/MpuINT/MpuINT.h"

CI2C::Handle g_i2c_handle;
readRawData_t rawData;
processedData_t procData;
divFloatData_t structFloatData;
angles_t armAngles;
angSpeeds_t angSpeeds;

// Callback function prototype
void RxCallback(const uint8_t error);

#define wakeUpPin 2
void setup() {
	// Initialize Serial communication
	Serial.begin(115200);
	
	//initi2c();
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

	pinMode(13, OUTPUT);
	pinMode(12, OUTPUT);
	
	pinMode(wakeUpPin, INPUT_PULLUP);
	
	attachInterrupt(digitalPinToInterrupt(wakeUpPin), readInt, FALLING);
	
}


void writeReg(CI2C::Handle* handler, byte reg, byte val) {
	nI2C->Write(*handler, reg, &val, 1);
}

volatile bool flag = false;

void readInt() {
	digitalWrite(13, !digitalRead(13));
	digitalWrite(12, 0);
	flag = true;
}

// The loop function is called in an endless loop
long timer = 0;
void loop() {
	
	if (flag) {
		nI2C->Read(g_i2c_handle, ACCEL_XOUT_H, rawData.dataFromI2C, sizeof(readRawData_t), RxCallback);
		flag = false;
	}
	
	if (millis() - timer > 10) {
		timer=millis();
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
	
}

uint8_t app;
void RxCallback(const uint8_t status) {
	digitalWrite(12, 1);
	
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

