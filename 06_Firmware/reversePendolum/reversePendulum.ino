#include "Arduino.h"
#include "mylib/myLibInclude.h"

#define ctrlTime 10 //ms

MotFeed *mEn;
DCdriver *mot;
PID *mPid, *wPi;

void setup() {
	Serial.begin(115200);
	Serial.println("Pendolo inverso attivazione");
	
	//Controll Pid class create
	mPid = new PID(1.0, 1.0, 1.0, 30 , true, 1.0 , 0.1);
	wPi = new PID(1.0, 1.0, 0, 30 , true, 1.0 , 0.1);

	//Button active
	pinMode(startStop, INPUT);
	digitalWrite(startStop, 1); //Pull up
	pinMode(taratura, INPUT);
	digitalWrite(taratura, 1);  //Pull up
			
	//Motori
	mot = new DCdriver(enPwm, inA, inB);
	//Encoder
	mEn = new MotFeed();
	periodicTask(ctrlTime);
	//MPU6050
	initi2c(wakeUpPin);



	//Global interrupt enable
	sei();
}

// The loop function is called in an endless loop
unsigned long timer = 0;
bool sSPush, tPush;

int testBaseSpeed = 15;
byte iTest = 0;
byte bTest = 0;
int vel = 0;

void loop() {
	//if possible, MPU update
	MPUUpdate();
	//Button read
	if (!digitalRead(taratura) && !tPush) {
		//Serial.println("Taratura Push");
		tPush = true;
		switch (bTest) {
			case 0:
				vel=255;
				mot->drive_motor(255);
			break;
			case 1:
				vel=999;
				mot->soft_stop();
			break;
			case 2:
				vel=-255;
				mot->drive_motor(-255);
			break;
			case 3:
				vel=-9999;
				mot->hard_stop(10);
			break;
		}
		bTest = (bTest+1) % 4;
	} else if (digitalRead(taratura)) {
		tPush = false;
		delay(1); //anti rimbalzo
	}

	if (!digitalRead(startStop) && !sSPush) {
		//Serial.println("startStop Push");
		sSPush = true;
		if (iTest > 17 && testBaseSpeed > 0) {
			iTest = 0;
			testBaseSpeed *= -1;
			vel = 999;
			mot->soft_stop();
		} else if (iTest > 17 && testBaseSpeed < 0) {
			iTest = 0;
			testBaseSpeed *= -1;
			vel = 0;
			mot->drive_motor(vel);
		} else {
			vel = testBaseSpeed * iTest++;
			mot->drive_motor(vel);
		}
	} else if (digitalRead(startStop)) {
		sSPush = false;
		delay(1); //anti rimbalzo
	}
	
	//Timed task
	if (millis() - timer > 10) {
		timer = millis();
	}
}


void periodicTask(int time) {
	//time in Milli secondi!!!!
	//Tempo massimo con prescaler a 1024 16,32, definizione 0.064ms
	// Initial TIMER2 Fast PWM
	TCCR2A = (0x0 << COM2A0) | (0x0 << COM2B0) | (0x2 << WGM20); //non collegato pin pwm, motalità CTC
	TCCR2B = (0 << WGM22) | (0x7 << CS20);	// Modalità CTC, Prescalere 1024
	//T_cklock * Twant / Prescaler = valore Registro
	OCR2A = (int) (16000UL * time / 1024);
	TIMSK2 = (1 << OCIE2A); //attivo solo l'interrupt di OC2A

}

float angleRef=0.0;
ISR(TIMER2_COMPA_vect) {
	mEn->periodicRecalc();
	updateArmAngles();

	//First pid Wpi (look matlab symulink)
	angleRef = wPi->purePid(0, mEn->getVel(), ctrlTime * 1000);
	//Second pid Mpid (look matlab symulink)
	mot->drive_motor(mPid->pid2notLin(angleRef, (int)arm.angle, ctrlTime * 1000, moment2torcue));

}
ISR(PCINT1_vect) {
	mEn->isrFunxEN();
}
