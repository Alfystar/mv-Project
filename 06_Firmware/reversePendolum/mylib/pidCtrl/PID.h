//
// Created by alfy on 02/05/19.
//

#ifndef PIDCLASSDEMO_PIDSCORBOT_H
#define PIDCLASSDEMO_PIDSCORBOT_H

#include <Arduino.h>
#include <stdlib.h>
#include <string.h>
#include "../globalDef.h"

typedef struct data_ {
    int er;     //errore dal riferimento
    long time;  //Tempo dall'ultimo campine
} data;

typedef short (*externConvFunx) (float pidOut); // function recive pid compute, and apply not lin funx to calc PWM

class PID {
public:
    PID(float kp, float ki, float kd, int MdeadZone, bool posDir);
    PID(float kp, float ki, float kd, int MdeadZone, bool posDir, float cSat, float cDead);
    short motVal(int ref, int en);
    short pid2PWM(int ref, int feeback, int dt);
    float purePid(int ref, int feeback, int dt);
    short pid2notLin(int ref, int feeback, int dt, externConvFunx funx); //return the PWM computed by externConvFunx
private:
    /*pid general*/
    float Kp, Ki, Kd;
    float CONTROL_SATURATION;   //100% dell'uscita possibile
    float CONTROL_DEADZONE;    	//se per muovermi devo spostarmi di meno freno
    int MOTOR_DEADZONE;
    bool posDir = false; 		//per allineare verso dei pwm a incremento degli encoder
    							// false= concordi, true= discordi

    /*Variabili del pid comp*/
    data mystack[8]; 	//data
    float x_i = 0.0;	//valore dell'integrale
    float y_d = 0.0;	//valore della derivata

    /*pid timing*/
    long temp, oldTemp, result;

    float PIDComp(int error, long Ts);  //Ts micro secondi
    float UpdateSat(float x, float dx, float a, float k, float s, float S);
protected:

};

#endif //PIDCLASSDEMO_PIDSCORBOT_H
