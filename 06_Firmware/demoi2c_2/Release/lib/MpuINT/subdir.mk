################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../lib/MpuINT/MpuINT.cpp 

LINK_OBJ += \
./lib/MpuINT/MpuINT.cpp.o 

CPP_DEPS += \
./lib/MpuINT/MpuINT.cpp.d 


# Each subdirectory must supply rules for building sources it contributes
lib/MpuINT/MpuINT.cpp.o: ../lib/MpuINT/MpuINT.cpp
	@echo 'Building file: $<'
	@echo 'Avvio compilazione C++'
	"/opt/sloeber//arduinoPlugin/packages/arduino/tools/avr-gcc/5.4.0-atmel3.6.1-arduino2/bin/avr-g++" -c -g -Os -Wall -Wextra -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -MMD -flto -mmcu=atmega168 -DF_CPU=16000000L -DARDUINO=10802 -DARDUINO_AVR_NANO -DARDUINO_ARCH_AVR     -I"/opt/sloeber/arduinoPlugin/packages/arduino/hardware/avr/1.6.23/cores/arduino" -I"/opt/sloeber/arduinoPlugin/packages/arduino/hardware/avr/1.6.23/variants/eightanaloginputs" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -D__IN_ECLIPSE__=1 -x c++ "$<"  -o  "$@"
	@echo 'Finished building: $<'
	@echo ' '


