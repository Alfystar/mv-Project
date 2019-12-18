#include "Arduino.h"
#include "lib/MpuINT/MpuINT.h"

// Callback function prototype
void RxCallback(const uint8_t error);

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
		mpuDebug();
	}
}


