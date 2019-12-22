#include "Arduino.h"
#include "mylib/myLibInclude.h"

MotFeed *mEn;
DCdriver *mot;

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
	periodicTask(10);

	//MPU6050
	initi2c(wakeUpPin);

	//Global interrupt enable
	sei();

	pinMode(12, OUTPUT);
	digitalWrite(12, 0);

	///Print in serial order of coulums
	Serial.print("PWM");
	Serial.print("\tmStep");
	Serial.print("\tmVel=");
	Serial.println("\tmAcc=");
	delay(500);
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

ISR(TIMER2_COMPA_vect) {
	digitalWrite(12, 1);
	mEn->periodicRecalc();
	updateArmAngles();
	Serial.print(vel);
	Serial.print("\t");
	mEn->debugState(true);

	digitalWrite(12, 0);
}

ISR(PCINT1_vect) {
	mEn->isrFunxEN();
}
