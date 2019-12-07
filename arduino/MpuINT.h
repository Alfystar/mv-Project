#ifndef _MPUINT_H_
#define _MPUINT_H_

#include <avr/sleep.h>
#include <Wire.h>

#include <math.h>

#include <util/atomic.h>


#define PI 3.1415926535897932384626433832795


//Analog port 4 (A4) = SDA (serial data)
//Analog port 5 (A5) = SCL (serial clock)

#define SIGNAL_PATH_RESET   0x68 // reset signal paths (NOT clear sensor registers); bits [2:0] available.
#define INT_PIN_CFG         0x37 // configures the behavior of the interrupt signals at INT pin. See in arduino.ino->setup() 
#define ACCEL_CONFIG        0x1C // trigger accelerometer self-test and configure its full scale range
#define GYRO_CONFIG         0x1B // trigger gyroscope self-test and configure its full scale range.
#define MOT_THR             0x1F // Motion detection threshold bits [7:0]
#define MOT_DUR             0x20 // Duration counter threshold for motion interrupt generation, 1 kHz rate, as b0010 0000
#define MOT_DETECT_CTRL     0x69 // add delay to the accelerometer power on time (TODO: activate gyroscope)
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

#define rAX 0
#define rAY 1
#define rAZ 2
#define rGX 3
#define rGY 4
#define rGZ 5

#define angleAX 0
#define angleAY 1


extern float normData[6];

extern uint16_t volatile readRawData[6];

extern float angles[2];

extern float angSpeeds[3];

//###################################################//
              /* I2C COMMUNICATION */
//###################################################//

void writeByte(uint8_t, uint8_t, uint8_t);

uint8_t readByte(uint8_t, uint8_t);

uint16_t obtain16bitData(uint8_t , uint8_t, uint8_t);

//###################################################//
              /* INTERRUPT FUNCTION */
//###################################################//

void intFunction(void);

//###################################################//
            /* COMPUTATIONAL FUNCTIONS */
//###################################################//

void intToFloatDatas(void); //we have a preallocated space, to increase efficiency 

float* getArmSpeeds(void);

float* getArmAngles(void); // it requires all rA*, and calculate through atan2




#endif
