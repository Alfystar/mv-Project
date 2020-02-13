#include "Arduino.h"
#include "mylib/myLibInclude.h"
#define debouncing() delay(1) //anti rimbalzo


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
	//initi2c(wakeUpPin);

	//Global interrupt enable
	sei();

	pinMode(12, OUTPUT);
	digitalWrite(12, 0);

	///Print in serial order of coulums
	Serial.print("PWM");
	Serial.print("\tmStep");
	Serial.print("\tmVel");
	Serial.println("\tmAcc");
	delay(500);
}

// The loop function is called in an endless loop
unsigned long timer = 0;
bool sSPush, tPush;

int testBaseSpeed = 15;
byte iTest = 0;
byte bTest = 0;
int pwm = 0;
bool brake = true;
bool freeBrake = true;
byte testMode = 0;	// 0=col potenziometro, 1= pulsante taratura

#define delayInput 500
long timeInput = 0;
void loop() {
	//if possible, MPU update
	MPUUpdate();
	//Button read
	if (!digitalRead(taratura) && !tPush && millis() > timeInput + delayInput) {
		//Serial.println("Taratura Push");
		tPush = true;
		timeInput = millis();
		switch (bTest) {
			case 0:
				pwm = 255;
				brake = false;
				freeBrake = false;
				testMode = 1;
			break;
			case 1:
				pwm = 0;
				brake = false;
				freeBrake = true;
			break;
			case 2:
				pwm = -255;
				brake = false;
				freeBrake = false;
			break;
			case 3:
				pwm = 0;
				brake = false;
				freeBrake = true;
			break;
			case 4:
				pwm = 255;
				brake = false;
				freeBrake = false;
			break;
			case 5:
				pwm = 0;
				brake = true;
				freeBrake = false;
			break;
			case 6:
				pwm = -255;
				brake = false;
				freeBrake = false;
			break;
			case 7:
				pwm = 0;
				brake = true;
				freeBrake = false;
			break;
			case 8:
				testMode = 0;
			break;
		}
		bTest = (bTest + 1) % 9;
	} else if (digitalRead(taratura)) {
		tPush = false;
		debouncing(); //anti rimbalzo
	}
	
	if (testMode == 0) {
		brake = false;
		if (!digitalRead(startStop) && !sSPush && millis()>timeInput+delayInput) {
			//Serial.println("startStop Push");
			sSPush = true;
			timeInput = millis();
			freeBrake = !freeBrake;
		} else if (digitalRead(startStop)) {
			sSPush = false;
			debouncing(); //anti rimbalzo
		}

		//Timed task
		if (millis() - timer > 5) {
			timer = millis();
			pwm = map(analogRead(pot) >> 2, 1023 >> 2, 0, -255, 255);
			if (abs(pwm) < 6)
				pwm = 0;
		}
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
	Serial.print("(dt=");
	Serial.print(time);
	Serial.print(", OCR2A=");
	Serial.print(OCR2A);
	Serial.println(", Prescaler=1024)");
}

ISR(TIMER2_COMPA_vect) {

	digitalWrite(12, 1);
	mEn->periodicRecalc();
	//updateArmAngles();
	Serial.print(pwm * !freeBrake * !brake + 1000 * brake);
	Serial.print("\t");
	mEn->debugState(true);

	//mpuDebugAngle(true);

	digitalWrite(12, 0);
	if (brake) {
		mot->soft_stop();
	} else if (freeBrake) {
		mot->drive_motor(0);
	} else {
		mot->drive_motor(pwm);
	}
}

ISR(PCINT1_vect) {
	mEn->isrFunxEN();
}
