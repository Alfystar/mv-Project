// Matlab per capire meglio
#define ctrlTime 10 //ms


#define mCm	220		// Massa centro di massa (braccio + disco) [g]
#define g	9.81	// Forza di gravità [mm/s^2]
#define Lcm	100		// Distanza cm da perno [mm]
#define It	1		// Inerzia Totale risp perno [g*mm^2]
#define Id 431200
#define rhoInd 1.7989
#define rhoMec 0.1098
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
	mPid = new PID(2418132733, 2565122053, 559751835);
	mPidMot = new PIDMot(-0.1, 0, 0, 100, true);
	wPi = new PID(1, 0, 0);
	periodicTask(ctrlTime);
}

void ctrlFunx() {
	//First pid Wpi (look matlab symulink)
	angleRef = wPi->purePid(0, mEn->getVel(), ctrlTime * 1000);
	Serial.print(angleRef);
	//Second pid Mpid (look matlab symulink)
	//mWant = mPid->purePid(angleRef, arm.angle, ctrlTime * 1000);
	pwmSend = mPidMot->pid2PWM(angleRef, arm.angle, ctrlTime * 1000);
	Serial.print('\t');
	Serial.println(pwmSend);


	mot->drive_motor(pwmSend);
	//moment2torcue(mWant);
}

void moment2torcue(float mTotDes) {
	//todo tutto sbagliato, da rifare guardando con matlab
	// Calcoli notevoli:
	float d2x1 = ((rhoInd+rhoMec))*Id*mEn->getVel();
	// tauMot = Mdes- Mattuale

	//tauMot = -mTotDes + d2x1 + Kmgl*sin(x(4)) - D1*x(3);
	tauMot = -mTotDes + d2x1 + Kmgl*sin(arm.angle * DEG_TO_RAD);


	mot->drive_motor(tauMot * kMot);
}
