//
// Created by alfy on 02/05/19.
//

#ifndef PIDCLASSDEMO_PIDSCORBOT_H
#define PIDCLASSDEMO_PIDSCORBOT_H

#include <Arduino.h>
#include <stdlib.h>
#include <string.h>
#include "../globalDef.h"

#define noSat -1

typedef struct data_ {
		int er;     //errore dal riferimento
		long time;  //Tempo dall'ultimo campine
} data;

class PID {
	public:
		PID(float kp, float ki, float kd); 		//Ideal pid without saturation or limit
		PID(float kp, float ki, float kd, float cDead, float cSat);
		float purePid(float ref, float feeback, int dt);
		void resetState();

	protected:
		/*pid general*/
		float Kp, Ki, Kd;
		float cSat;   //100% dell'uscita possibile
		float cDead;   //se per muovermi devo spostarmi di meno freno

		/*Variabili del pid comp*/
		data erStack[8]; 	//data
		float x_i = 0.0;	//valore dell'integrale
		float y_d = 0.0;	//valore della derivata

		/*pid timing*/
		long temp, oldTemp, result;

		float PIDComp(float er, long Ts);  //Ts micro secondi
		float UpdateSat(float x, float dx, float a, float k, float s, float S);
		float fmap(float x, float in_min, float in_max, float out_min,
				float out_max);
};

#endif //PIDCLASSDEMO_PIDSCORBOT_H
