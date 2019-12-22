#ifndef _MPUINT_H_
#define _MPUINT_H_

#include <Arduino.h>
#include <util/atomic.h>
#include "nI2C/nI2C.h"
#include "MpuINTtype.h"

#define accSens 1 			// 0=+-2g 1=+-4g 2=+-8g 3=+-16g
#define gySens 3 			// 0=+-250°/s 1=+-500°/s 2=+-1000°/s 3=+-2000°/s
#define digitalFilter 4		// 4=20HZ, 8.5ms  5= 10Hz , 13.8ms

extern CI2C::Handle g_i2c_handle;
extern rawData_t rD;
extern floatData_t fD;
extern armState_t arm;

//###################################################//
              // I2C COMMUNICATION //
//###################################################//
void initi2c(byte intPin);
void writeReg(CI2C::Handle *handler ,byte reg, byte val);

//###################################################//
              // INTERRUPT FUNCTION //
//###################################################//
void MPUUpdate();
void readInt();
void RxCallback(const uint8_t status);

//###################################################//
            // COMPUTATIONAL FUNCTIONS //
//###################################################//

void i2FDatas(void); 		//we have a preallocated space, to increase efficiency
void i2F_acc(void);
void i2F_tmp(void);
void i2F_gyro(void);
void i2FDatas(void);		 //we have a preallocated space, to increase efficiency
void updateArmAngles(void);  //MUST BE CALL with same delta T (for the derivate)
void mpuDebug(bool plot);
void mpuDebugRaw(bool plot);
void mpuDebugAngle(bool plot);


#endif //_MPUINT_H_
