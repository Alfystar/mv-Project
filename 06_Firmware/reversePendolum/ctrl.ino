// Matlab per capire meglio
#define ctrlTime 10 //ms

#define vFin 30
#define MOTOR_DEADZONE 30

#define mCm	220		// Massa centro di massa (braccio + disco) [g]
#define g	9.81	// Forza di gravità [mm/s^2]
#define Lcm	100		// Distanza cm da perno [mm]
#define It	1		// Inerzia Totale risp perno [g*mm^2]
#define Id 431200
#define rhoInd 1.7989
#define rhoMec 0.1098
#define rhoTot 1.9087 //rhoInd+rhoMec
#define Kmgl 1.2949e+09

#define kMot 128.2386 // Accelerazione massima motore

extern MotFeed *mEn;
extern DCdriver *mot;
extern PID *mPid, *wPi;
extern PIDMot *mPidMot;

float Mg, tauMot;

float angleRef, mWant;
short pwmSend;

void initCtrl() {
	//Controll Pid class create
	wPi = new PID(0, 0, 0);
	mPid = new PID(170, 0.000000, 100, 0, 1300);
	//mPidMot = new PIDMot(-0.15, 0.0000001, -0.9, 0.2, 1, MOTOR_DEADZONE, true);
	mPidMot = new PIDMot(-0.0008, 0, -10, 0.05, 1, MOTOR_DEADZONE, true);
	periodicTask(ctrlTime);
}
short pwmSendOld = 0;
short deltaV;
float rhoMom, armMom;
void ctrlFunx() {

	Serial.print(mEn->getVel());
	Serial.print('\t');
	Serial.print(arm.angle);
	Serial.print('\t');
	Serial.print(arm.wZ);
	Serial.print('\t');
	Serial.print(arm.wDotZ);
	Serial.print(" |\t");

	//First pid Wpi (look matlab symulink)
	angleRef = wPi->purePid(vFin, mEn->getVel(), ctrlTime * 1000);
	Serial.print(angleRef);

	//Second pid Mpid (look matlab symulink)
	mWant = mPid->purePid(angleRef, arm.angle, ctrlTime);
	Serial.print('\t');
	Serial.print(mWant);

	rhoMom = 1 * rhoTot * mEn->getVel();
	armMom = 1 * arm.wZ * sin(arm.angle * DEG_TO_RAD);

	Serial.print(" |\t");
	Serial.print(rhoMom);
	Serial.print('\t');
	Serial.print(armMom);

	pwmSend = mPidMot->pid2PWM(mWant + rhoMom + armMom - arm.wDotZ, 0, ctrlTime);

	//pwmSend = moment2torcue(mWant);

	Serial.print('\t');
	Serial.println(pwmSend);
	mot->drive_motor(pwmSend);
}

float fmap(float x, float in_min, float in_max, float out_min, float out_max) {
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

short moment2torcue(float mTotDes) {
	//todo tutto sbagliato, da rifare guardando con matlab
	// Calcoli notevoli:
	float d2x1 = rhoTot * mEn->getVel();

	//tauMot = -mTotDes + d2x1 + Kmgl*sin(x(4)) - D1*x(3);
	tauMot = -mTotDes + d2x1 + 120 * sin(arm.angle * DEG_TO_RAD);
	tauMot = tauMot / kMot;

	if (fabsf(tauMot) < 0.2) {
		//return softStop; //soft stop
		return specialPwmCode::freeRun;
	} else {
		if (tauMot > 0)
			return short(fmap(tauMot, 0.0, 1.0, MOTOR_DEADZONE, 255) + 0.5);
		else {
			return short(-fmap(-tauMot, 0.0, 1.0, MOTOR_DEADZONE, 255) - 0.5);
		}
	}
}
