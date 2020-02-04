/*
 * globalDef.h
 *
 *  Created on: 06 dic 2019
 *      Author: alfyhack
 */

#ifndef MYLIB_GLOBALDEF_H_
#define MYLIB_GLOBALDEF_H_

// set timer divisor to     1 for PWM frequency of 31372.55 Hz
// set timer divisor to     8 for PWM frequency of  3921.16 Hz
// set timer divisor to    64 for PWM frequency of   490.20 Hz
// set timer divisor to   256 for PWM frequency of   122.55 Hz
// set timer divisor to  1024 for PWM frequency of    30.64 Hz
enum pwmFreq
	: char {
		hz30, hz120, hz490, hz4k, hz30k
};
enum specialPwmCode
	: short {
		freeRun = 300, hardStop = 350, softStop = 400, ignore = 450
};

//Encoder Define
#define enMotA 14 //digitale di A0
#define enMotB 15 //digitale di A1

//Button Define
#define startStop 17 //digitale di A3
#define taratura 4

// Potenziometro
#define pot A2

//Motor Pendolum Define
#define enPwm 9
#define inA 8 //7
#define inB 7 //8

//I2c MPU6050 Define
#define wakeUpPin 2


#endif /* MYLIB_GLOBALDEF_H_ */
