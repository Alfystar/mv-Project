#ifndef _MPUINT_H_
#define _MPUINT_H_

#include <Arduino.h>
#include <util/atomic.h>
#include "../nI2C/nI2C.h"
#include "MpuINTtype.h"

#define accSens 1 			// 0=+-2g 1=+-4g 2=+-8g 3=+-16g
#define gySens 1 			// 0=+-250°/s 1=+-500°/s 2=+-1000°/s 3=+-2000°/s
#define digitalFilter 5		// 5= 10Hz , 13.8ms

extern CI2C::Handle g_i2c_handle;
extern rawData_t rD;
extern floatData_t fD;
extern angles_t armAngles;

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
void iT2F_acc(void);
void iT2F_tmp(void);
void iT2F_gyro(void);
void i2FDatas(void);		 //we have a preallocated space, to increase efficiency
void updateArmAngles(void); // it requires all rA*, and calculate through atan2
void mpuDebug();
void mpuDebugRaw();
void mpuDebugAngle();


#endif //_MPUINT_H_
