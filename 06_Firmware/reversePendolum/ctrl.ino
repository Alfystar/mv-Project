// Matlab per capire meglio
#define mCm	1		// Massa centro di massa (braccio + disco) [g]
#define g	9.81	// Forza di gravità [mm/s^2]
#define Lcm	1		// Distanza cm da perno [mm]
#define It	1		// Inerzia Totale risp perno [g*mm^2]

#define kMot 1		// Accelerazione massima motore

extern MotFeed *mEn;
extern DCdriver *mot;
extern PID *mPid, *wPi;

float Mg;
float tauMot;
short moment2torcue (float pidOut){
	// Calcoli notevoli:
	Mg = (mCm*g*Lcm/It)*sin(arm.angle*DEG_TO_RAD);
	// tauMot = Mdes- Mattuale
	tauMot = pidOut-(Mg-It*mEn->getAcc());
	return tauMot * kMot;
}
