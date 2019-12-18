/*
 * MpuINTtype.h
 *
 *  Created on: 18 dic 2019
 *      Author: alfyhack
 */

#ifndef LIB_MPUINT_MPUINTTYPE_H_
#define LIB_MPUINT_MPUINTTYPE_H_

//Analog port 4 (A4) = SDA (serial data)
//Analog port 5 (A5) = SCL (serial clock)

//###################################################//
				/* DEFINITIONS */
//###################################################//


#define SMPRT_DIV 			0x19 // we set sample rate = 8MHZ/(1 + inserted number)
#define SIGNAL_PATH_RESET   0x68 // reset signal paths (NOT clear sensor registers); bits [2:0] available.
#define INT_PIN_CFG         0x37 // configures the behavior of the interrupt signals at INT pin. See in arduino.ino->setup()
#define ACCEL_CONFIG        0x1C // trigger accelerometer self-test and configure its full scale range
#define CONFIG         		0x1A // config the external sync & Digital-Low-Pass filter.
#define GYRO_CONFIG         0x1B // trigger gyroscope self-test and configure its full scale range.
#define INT_ENABLE          0x38 // enables interrupt generation by interrupt sources
#define WHO_AM_I_MPU6050    0x75 // Should return 0x68, as it verifies the identity of the device
#define INT_STATUS          0x3A // shows the interrupt status of each interrupt generation source
#define PWR_MGMT_1          0x6B // configure power mode and clock source, reset the entire device and disable temp sensor

//when nothing connected to AD0 than address is 0x68
#define AD0 0

#if AD0
#define MPU6050_ADDRESS 0x69  // Device address when AD0 = 1
#else
#define MPU6050_ADDRESS 0x68  // Device address when AD0 = 0
#endif

//We can obtain the full 16-bit 2’s complement value data with the addresses below
#define  ACCEL_XOUT_H 0x3B
#define ACCEL_XOUT_L 0x3C

#define  ACCEL_YOUT_H 0x3D
#define ACCEL_YOUT_L 0x3E

#define  ACCEL_ZOUT_H 0x3F
#define ACCEL_ZOUT_L 0x40

#define GYRO_XOUT_H  0x43
#define GYRO_XOUT_L  0x44

#define GYRO_YOUT_H  0x45
#define GYRO_YOUT_L  0x46

#define GYRO_ZOUT_H  0x47
#define GYRO_ZOUT_L  0x48


//###################################################//
				/* DATA STRUCTURES */
//###################################################//

typedef struct _divRawData {
		short rawAccX;
		short rawAccY;
		short rawAccZ;
		short rawTemp;
		short rawGyrX;
		short rawGyrY;
		short rawGyrZ;
} divRawData_t ;

typedef union _readRawData{

	divRawData_t rawData;
	uint8_t dataFromI2C[sizeof(divRawData_t)];

} readRawData_t ;


typedef struct _divFloatData {
		float flAccX;
		float flAccY;
		float flAccZ;
		float flTemp;
		float flGyrX;
		float flGyrY;
		float flGyrZ;
} divFloatData_t;

typedef union _processedData{
	divFloatData_t floatData;
	float datas[sizeof(divRawData_t)];
} processedData_t ;


typedef struct _angles {
	float angleX;
	float angleY;
} angles_t;

typedef struct _angSpeeds {
	float angSpeedX;
	float angSpeedY;
	float angSpeedZ;
} angSpeeds_t;



#endif /* LIB_MPUINT_MPUINTTYPE_H_ */
