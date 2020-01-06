/*
 * PIDMot.h
 *
 *  Created on: 06 gen 2020
 *      Author: alfyhack
 */

#ifndef MYLIB_PIDCTRL_PIDMOT_H_
#define MYLIB_PIDCTRL_PIDMOT_H_

#include "PID.h"

class PIDMot: public PID {
	public:
		PIDMot(float kp, float ki, float kd, int MdeadZone, bool posDir);
		PIDMot(float kp, float ki, float kd, float cDead, float cSat, int MdeadZone, bool posDir);
		short pid2PWM(int ref, int feeback, int dt);
	private:
		int MOTOR_DEADZONE;
		bool posDir = false; //per allineare verso dei pwm a incremento degli encoder
							 // false= concordi, true= discordi
};

#endif /* MYLIB_PIDCTRL_PIDMOT_H_ */
