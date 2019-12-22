/*
 * msEnlib.cpp
 *
 *  Created on: 25 mar 2019
 *      Author: alfy
 */
#include "msEnlib.h"

MotFeed::MotFeed() {
	//Memory clean
	en = 0;
	oldEn = 0;
	step = 0;
	oldStep = 0;
	vel = 0;
	oldVel = 0;
	acc = 0;

	//todo: adattare ai nostri pin i registri sotto
	//make input pin
	pinMode(enMotA, INPUT);
	pinMode(enMotB, INPUT);

	//Abilito i pcint degli encoder
	PCMSK1 = 0b11; //Attivo PCINT8 e PCINT9

	//Attivo l'interrupt da pcint per la porta 1
	PCICR |= (1 << PCIE1);

}

//Funzione che deve essere chiamata il più possibile con tempi costanti
void MotFeed::periodicRecalc() {
	vel = step - oldStep;
	acc = vel - oldVel;

	oldStep = step;
	oldVel = vel;

}

byte enNow, enOld;
void MotFeed::isrFunxEN() { //aggiungo solo se diverso e il buffer non vuoto
	this->oldEn = this->en;
	this->en = this->getEnPin();
	this->calcStep(oldEn, en);

}

void MotFeed::resetState() {
	step = 0;
	oldStep = 0;
	vel = 0;
	oldVel = 0;
	acc = 0;
}

void MotFeed::setStep(long st) {
	this->step = st;
}

long MotFeed::getStep() {
	return this->step;
}

long MotFeed::getVel() {
	return this->vel;
}

float MotFeed::getVel(int dt) {
	return this->vel / float(dt);
}

long MotFeed::getAcc() {
	return this->acc;
}

float MotFeed::getAcc(int dt) {
	return this->acc / float(dt);
}

byte MotFeed::getEnPin() {
	//todo implementare la lettura dei pin e metterli all'inizio
	return (PINC & 0b11);
}

void MotFeed::printSteps() {
	Serial.print("\tEn= ");
	Serial.println(this->getStep());
}

void MotFeed::debugState(bool plot) {
	if (plot) {
		Serial.print(this->getStep());
		Serial.print("\t");
		Serial.print(this->getVel());
		Serial.print("\t");
		Serial.println(this->getAcc());
	} else {
		Serial.print("mStep=");
		Serial.print(this->getStep());
		Serial.print("\tmVel=");
		Serial.print(this->getVel());
		Serial.print("\tmAcc=");
		Serial.println(this->getAcc());
	}

}

//VARIABILI PRIVATE DI calcStep
//Dichiarate qui fisse e comuni a tutte le istanze
//per accelerare l'elaborazione(riducendo gli accessi in memoria)
#define im 0 //impossibile
//         						  0   1  2  3   4  5  6    7   8  9  10 11  12  13  14 15
int8_t const enc_states[] = { 0, -1, 1, im, 1, 0, im, -1, -1, im, 0, 1, im, 1,
		-1, 0 }; /*[old]BA-BA[new]*/
byte chAold, chBold, chAnew, chBnew, code;

void MotFeed::calcStep(byte oldEn, byte newEn) {
	//Sia oldEn che newEn sono nella forma BA dei 2 encoder
	//todo Testarla

	code = ((oldEn & 0b11) << 2) | (newEn & 0b11);

	this->step += (enc_states[code]);

}

