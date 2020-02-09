//
// Created by alfy on 02/05/19.
//

#include "PID.h"

PID::PID(float kp, float ki, float kd) :
		PID(kp, ki, kd, 0, noSat) { // @suppress("Class members should be properly initialized")
}

PID::PID(float kp, float ki, float kd, float cDead, float cSat) {
	Kp = kp;
	Ki = ki;
	Kd = kd;
	this->cSat = cSat;
	this->cDead = cDead;

	/*Variabili del pid comp*/
	memset(this->erStack, 0, sizeof(this->erStack));
	this->x_i = 0.0;
	this->y_d = 0.0;

	/*pid relativi*/
	this->result = this->oldTemp = this->temp = micros();
}

float PID::fmap(float x, float in_min, float in_max, float out_min,
		float out_max) {
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

float PID::purePid(float ref, float feeback, int dt) {
	float er = (ref - feeback);
	return this->PIDComp(er, dt);
}

void PID::resetState(){
	x_i = y_d = 0.0;	//valore dell'integrale e derivata a 0
}

float PID::PIDComp(float er, long Ts) {
	//Il pid calcola un valore in uscita tra -1.0 e 1.0 che è -100% to 100% della pot di uscita del motore
	//TS tempo campione in micro secondi
	//stack update, the higher the newer

	// Derivative calc
	if (this->Kd != 0) {
		long dt = 0;
		for (short int i = 0; i < 7; i++) {
			dt += this->erStack[i].time;
			this->erStack[i] = this->erStack[i + 1];
		}
		this->erStack[7].er = er;
		this->erStack[7].time = Ts;

		//7 è la distanza tra i 2 campioni
		this->y_d = this->Kd * (this->erStack[7].er - this->erStack[0].er) / dt;
	} else
		x_i = 0;
	// Integral calc
	if (this->Ki != 0) {
		if (cSat != noSat)
			x_i += this->UpdateSat(x_i, Ki * Ts * erStack[7].er, Kp * er + y_d,
					1, cDead, cSat);
		else
			this->x_i += Ki * Ts * erStack[7].er;
	} else
		y_d = 0;

	if (cSat != noSat)
		return (min(cSat, max(-cSat, Kp * er + x_i + y_d)));
	else
		return Kp * er + x_i + y_d;
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
