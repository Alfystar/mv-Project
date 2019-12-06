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
	
	//Global interrupt enable
	sei();
}

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
		mEn->periodicRecalc();
	}

	Serial.print("mStep:");
	Serial.print(mEn->getStep());
	Serial.print("\tmVel:");
	Serial.print(mEn->getVel());
	Serial.print("\tmAcc:");
	Serial.println(mEn->getAcc());
}

ISR(PCINT1_vect) {
	mEn->isrFunxEN();
}
