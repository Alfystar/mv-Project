#include "Arduino.h"
#include "lib/MpuINT/MpuINT.h"

#define wakeUpPin 2
void setup() {
	// Initialize Serial communication
	Serial.begin(115200);
	initi2c(wakeUpPin);
}

// The loop function is called in an endless loop
long timer = 0;
void loop() {
	
	MPUUpdate();
	
	if (millis() - timer > 10) {
		timer=millis();
		//mpuDebugRaw();
		//mpuDebug();
		mpuDebugAngle();
	}
}
