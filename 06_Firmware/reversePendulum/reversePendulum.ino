#include "Arduino.h"
#include "mylib/myLibInclude.h"

MotFeed *mEn;
DCdriver *mot;

void setup() {
	Serial.begin(57600);
	Serial.println("Pendolo inverso attivazione");
	delay(500);
	
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

	//Global interrupt enable
	sei();
	mot->drive_motor(100);
}

//Timer 2 libero e utilizzabile

// The loop function is called in an endless loop
unsigned long timer = 0;
void loop() {
	if (!digitalRead(taratura)) {
		Serial.println("Taratura Push");
		
	}
	if (!digitalRead(startStop)) {
		Serial.println("startStop Push");
		
	}
	
	if (millis() > timer + 10) {
		timer = millis();

	}

	Serial.print("mStep:");
	Serial.print(mEn->getStep());
	Serial.print("\tmVel:");
	Serial.print(mEn->getVel());
	Serial.print("\tmAcc:");
	Serial.println(mEn->getAcc());
}

void periodicTask(int time) {
	//time in Milli secondi!!!!
	//Tempo massimo con prescaler a 1024 16,32, definizione 0.064ms
	// Initial TIMER2 Fast PWM
	TCCR2A = (0x0 << COM2A0) | (0x0 << COM2B0) | (0x2 << WGM20); //non collegato pin pwm, motalità CTC
	TCCR2B = (0 << WGM22) | (0x7 << CS20);	// Modalità CTC, Prescalere 1024
	//T_cklock * Twant / Prescaler = valore Registro
	OCR2A = (int)(16000UL*time/1024);
	TIMSK2 = (1 << OCIE2A); //attivo solo l'interrupt di OC2A

}

ISR(TIMER2_COMPA_vect) {
	mEn->periodicRecalc();
}

ISR(PCINT1_vect) {
	mEn->isrFunxEN();
}
