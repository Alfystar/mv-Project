#ifndef _MPUINT_H_
#define _MPUINT_H_

#include <Arduino.h>
#include <util/atomic.h>
#include "../nI2C/nI2C.h"
#include "MpuINTtype.h"

extern CI2C::Handle g_i2c_handle;
extern readRawData_t rawData;
extern processedData_t procData;
extern angles_t armAngles;
extern angSpeeds_t angSpeeds;

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

void intToFloatDatas(void); //we have a preallocated space, to increase efficiency 
void updateArmSpeeds(void);
void updateArmAngles(void); // it requires all rA*, and calculate through atan2
void mpuDebug();


#endif //_MPUINT_H_
