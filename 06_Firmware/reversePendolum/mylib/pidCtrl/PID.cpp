//
// Created by alfy on 02/05/19.
//

#include "PID.h"

PID::PID(float kp, float ki, float kd, int MdeadZone, bool posDir) {
	PID(kp, ki, kd, MdeadZone, posDir, 1.0, 0.0);
}

PID::PID(float kp, float ki, float kd, int MdeadZone, bool posDir, float cSat,
		float cDead) {

	/*pid general*/
	this->Kp = kp;
	this->Ki = ki;
	this->Kd = kd;
	this->MOTOR_DEADZONE = MdeadZone;
	this->posDir = posDir;
	this->CONTROL_SATURATION = cSat;   //100% dell'uscita possibile
	this->CONTROL_DEADZONE = cDead; //se per muovermi devo spostarmi di meno freno

	/*Variabili del pid comp*/
	memset(this->mystack, 0, sizeof(this->mystack));
	this->x_i = 0.0;
	this->y_d = 0.0;

	/*pid relativi*/
	this->result = this->oldTemp = this->temp = micros();
	//printf("kp=%e, ki=%e, kd=%e\n", kp, ki, kd);

}

float fmap(float x, float in_min, float in_max, float out_min, float out_max) {
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

int ts;    //tempo da ultima chiamata micro secondi
short PID::motVal(int ref, int en) {
	this->oldTemp = this->temp;
	this->temp = micros();
	this->pid2PWM(ref, en, this->temp - this->oldTemp);
}

short PID::pid2PWM(int ref, int feeback, int dt) {

	float vOut = purePid(ref, feeback, dt);
	//printf("vOut=%f\n", vOut);
	if (fabsf(vOut) < this->CONTROL_DEADZONE) {
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
float PID::purePid(int ref, int feeback, int dt){
	int er = (ref - feeback) * (1 - (2 * this->posDir)); //per allineare verso dei pwm a incremento degli encoder
	return this->PIDComp(er, dt);
}

short PID::pid2notLin(int ref, int feeback, int dt, externConvFunx funx) {
	return funx(purePid(ref, feeback, dt));
}



float PID::UpdateSat(float x, float dx, float a, float k, float s, float S) {
	/* Evaluate the suitable increment dxsat from dx of a variable x such that
	 % the saturation constraint |a+k(x+dxsat)| <= S is as much as possibile satisfied
	 % otherwise if |x+dx| is less than s return 0
	 % with |dxsat| <= |dx| and dxsat*dx>=0.
	 % x: the variable to be updated
	 % dx: the incremental value for x
	 % a,k,s and S: the parameter of the saturation function s <=|a+k(x+dxsat)| <= S
	 */

	float xhat = x + dx;
	if (fabsf(xhat) <= s) //saturazione di rumore
		return 0.0;
	float temp = S - fabsf(a + k * xhat);
	if (temp <= 0) //saturazione superiore
			{
		if (fabsf(a + k * xhat) < fabsf(a + k * x)) //sta decrementando
			return (dx);
		else
			//da 0 incremento o quello che manca a saturare
			return ((dx >= 0 ? 1 : -1) * fmaxf(0, (S - fabsf(a + k * x)) / k));
	} else
		return (dx);
}

float PID::PIDComp(int error, long Ts) {
	/*Il pid calcola un valore in uscita tra -1.0 e 1.0 che è -100% to 100% della pot di uscita del motore*/
	//TS tempo campione in micro secondi
	//stack update, the higher the newer
	long sum = 0;
	for (short int i = 0; i < 7; i++) {
		sum += this->mystack[i].time;
		this->mystack[i] = this->mystack[i + 1];
	}
	this->mystack[7].er = error;
	this->mystack[7].time = Ts;

	//7 è la distanza tra i 2 campioni
	this->y_d = this->Kd * (this->mystack[7].er - this->mystack[0].er) / sum;
	this->x_i += this->UpdateSat(this->x_i, this->Ki * Ts * this->mystack[7].er,
			this->Kp * error + this->y_d, 1, this->CONTROL_DEADZONE,
			this->CONTROL_SATURATION);

	return (min(this->CONTROL_SATURATION,
			max(-this->CONTROL_SATURATION, this->Kp * error + this->x_i + this->y_d)));
}
