#include "Arduino.h"
#include "mylib/myLibInclude.h"

MotFeed *mEn;
DCdriver *mot;
PID *mPid, *wPi;
PIDMot *mPidMot;
void setup() {
	Serial.begin(115200);
	Serial.println("Pendolo inverso attivazione");
	
	//Button active
	pinMode(startStop, INPUT);
	digitalWrite(startStop, 1); //Pull up
	pinMode(taratura, INPUT);
	digitalWrite(taratura, 1);  //Pull up
			
	//Motori
	mot = new DCdriver(enPwm, inA, inB);
	//Encoder
	mEn = new MotFeed();

	//MPU6050
	initi2c(wakeUpPin);

	//Controll
	initCtrl();

	//Global interrupt enable
	sei();
}

// The loop function is called in an endless loop
unsigned long timer = 0;
bool sSPush, tPush;
bool ctrlON = true;

int testBaseSpeed = 15;
byte iTest = 0;
byte bTest = 0;
int pwm = 0;

void loop() {
	//if possible, MPU update
	MPUUpdate();
	//Button read
	if (!digitalRead(taratura) && !tPush) {
		//Serial.println("Taratura Push");
		ctrlON=!ctrlON;
		tPush = true;
	} else if (digitalRead(taratura)) {
		tPush = false;
		delay(1); //anti rimbalzo
	}

	if (!digitalRead(startStop) && !sSPush) {
		//Serial.println("startStop Push");
		ctrlON=!ctrlON;
		sSPush = true;
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

ISR(TIMER2_COMPA_vect) {
	mEn->periodicRecalc();
	updateArmAngles();
	if(ctrlON)
		ctrlFunx();
	else
		mot->freeRun();
}

ISR(PCINT1_vect) {
	mEn->isrFunxEN();
}
