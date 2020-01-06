// Matlab per capire meglio
#define ctrlTime 10 //ms


#define mCm	1		// Massa centro di massa (braccio + disco) [g]
#define g	9.81	// Forza di gravità [mm/s^2]
#define Lcm	1		// Distanza cm da perno [mm]
#define It	1		// Inerzia Totale risp perno [g*mm^2]

#define kMot 1		// Accelerazione massima motore

extern MotFeed *mEn;
extern DCdriver *mot;
extern PID *mPid, *wPi;

float Mg, tauMot;

float angleRef, mWant;

void initCtrl() {
	//Controll Pid class create
	mPid = new PID(1.0, 1.0, 1.0);
	wPi = new PID(1.0, 1.0, 0);
	periodicTask(ctrlTime);
}

void ctrlFunx() {
	//First pid Wpi (look matlab symulink)
	angleRef = wPi->purePid(0, mEn->getVel(), ctrlTime * 1000);
	//Second pid Mpid (look matlab symulink)
	mWant = mPid->purePid(angleRef, arm.angle, ctrlTime * 1000);
	moment2torcue(mWant);
}

void moment2torcue(float pidOut) {
	//todo tutto sbagliato, da rifare guardando con matlab
	// Calcoli notevoli:
	Mg = (mCm * g * Lcm / It) * sin(arm.angle * DEG_TO_RAD);
	// tauMot = Mdes- Mattuale
	tauMot = pidOut - (Mg - It * mEn->getAcc());

	mot->drive_motor(tauMot * kMot);
}
