/*
 * msEnlib.h
 *	Libreria di lettura e elaborazione dei passi encoder
 *	e dei micro switch dello scorebot
 *  Created on: 25 mar 2019
 *      Author: alfy
 */

#ifndef PROJECT_LIB_MSENLIB_H_
#define PROJECT_LIB_MSENLIB_H_

#include "Arduino.h"
#include "wiring_private.h"    //work on bit
#include <stdlib.h>
#include "../globalDef.h"

#define sizeMem 255    //numero di celle (di int [2 byte])nel buffer circolare
//One of this 2
#define PCINT_EN 1
//#define TIMER5OVF_EN 1

class MotFeed {
	public:
		MotFeed();                	//Imposta i pin di uscita e registri
		void isrFunxEN();
		void periodicRecalc();	  	//Funzione da chiamare esattamente con lo stesso periodo per avere Vel e Acc coerenti
		void resetState();

		void setStep(long st);
		long getStep();
		long getVel();				//Ritorna la sola sottrazione senza divisione
		float getVel(int dt);
		long getAcc();
		float getAcc(int dt);		//Ritorna la sola sottrazione senza divisione

		byte getEnPin();

		void printSteps();
		void debugState(bool plot);
	private:
		byte en, oldEn;
		long step, oldStep;
		long vel, oldVel;
		long acc;
		void calcStep(byte oldEn, byte newEn);
};

#ifndef __IN_ECLIPSE__

#include "msEnlib.cpp"

#endif
#endif /* PROJECT_LIB_MSENLIB_H_ */
