/*
 * PIDMot.cpp
 *
 *  Created on: 06 gen 2020
 *      Author: alfyhack
 */

#include "PIDMot.h"

PIDMot::PIDMot(float kp, float ki, float kd, int MdeadZone, bool posDir) :
		PIDMot(kp, ki, kd, 0.0, 1.0, MdeadZone, posDir) { // @suppress("Class members should be properly initialized")
}

PIDMot::PIDMot(float kp, float ki, float kd, float cDead, float cSat,
		int MdeadZone, bool posDir) :
		PID::PID(kp, ki, kd, cDead, cSat) {
	this->MOTOR_DEADZONE = MdeadZone;
	this->posDir = posDir;
}

short PIDMot::pid2PWM(int ref, int feeback, int dt) {

	float vOut = purePid(ref, feeback, dt) * (1 - (2 * this->posDir)); //per allineare verso dei pwm a incremento degli encoder

	if (fabsf(vOut) < this->cDead) {
		return softStop; //soft stop
	} else {
		if (vOut > 0)
			return short(fmap(vOut, 0.0, 1.0, this->MOTOR_DEADZONE, 255) + 0.5);
		else {
			return short(
					-fmap(-vOut, 0.0, 1.0, this->MOTOR_DEADZONE, 255) - 0.5);
		}
	}
}
