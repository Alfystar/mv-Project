################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
..\lib\nI2C\nI2C.cpp \
..\lib\nI2C\nTWI.cpp \
..\lib\nI2C\queue.cpp 

LINK_OBJ += \
.\lib\nI2C\nI2C.cpp.o \
.\lib\nI2C\nTWI.cpp.o \
.\lib\nI2C\queue.cpp.o 

CPP_DEPS += \
.\lib\nI2C\nI2C.cpp.d \
.\lib\nI2C\nTWI.cpp.d \
.\lib\nI2C\queue.cpp.d 


# Each subdirectory must supply rules for building sources it contributes
lib\nI2C\nI2C.cpp.o: ..\lib\nI2C\nI2C.cpp
	@echo 'Building file: $<'
	@echo 'Avvio compilazione C++'
	"C:\sloeber\arduinoPlugin\packages\arduino\tools\avr-gcc\7.3.0-atmel3.6.1-arduino5/bin/avr-g++" -c -g -Os -Wall -Wextra -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -MMD -flto -mmcu=atmega168 -DF_CPU=16000000L -DARDUINO=10802 -DARDUINO_AVR_NANO -DARDUINO_ARCH_AVR     -I"C:\sloeber\arduinoPlugin\packages\arduino\hardware\avr\1.8.2\cores\arduino" -I"C:\sloeber\arduinoPlugin\packages\arduino\hardware\avr\1.8.2\variants\eightanaloginputs" -I"C:\Users\Filippo Badalamenti\Desktop\Uni\Meccanica delle Vibrazioni\mv-Project\06_Firmware\demoI2C\lib\MpuINT" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -D__IN_ECLIPSE__=1 -x c++ "$<"  -o  "$@"
	@echo 'Finished building: $<'
	@echo ' '

lib\nI2C\nTWI.cpp.o: ..\lib\nI2C\nTWI.cpp
	@echo 'Building file: $<'
	@echo 'Avvio compilazione C++'
	"C:\sloeber\arduinoPlugin\packages\arduino\tools\avr-gcc\7.3.0-atmel3.6.1-arduino5/bin/avr-g++" -c -g -Os -Wall -Wextra -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -MMD -flto -mmcu=atmega168 -DF_CPU=16000000L -DARDUINO=10802 -DARDUINO_AVR_NANO -DARDUINO_ARCH_AVR     -I"C:\sloeber\arduinoPlugin\packages\arduino\hardware\avr\1.8.2\cores\arduino" -I"C:\sloeber\arduinoPlugin\packages\arduino\hardware\avr\1.8.2\variants\eightanaloginputs" -I"C:\Users\Filippo Badalamenti\Desktop\Uni\Meccanica delle Vibrazioni\mv-Project\06_Firmware\demoI2C\lib\MpuINT" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -D__IN_ECLIPSE__=1 -x c++ "$<"  -o  "$@"
	@echo 'Finished building: $<'
	@echo ' '

lib\nI2C\queue.cpp.o: ..\lib\nI2C\queue.cpp
	@echo 'Building file: $<'
	@echo 'Avvio compilazione C++'
	"C:\sloeber\arduinoPlugin\packages\arduino\tools\avr-gcc\7.3.0-atmel3.6.1-arduino5/bin/avr-g++" -c -g -Os -Wall -Wextra -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -MMD -flto -mmcu=atmega168 -DF_CPU=16000000L -DARDUINO=10802 -DARDUINO_AVR_NANO -DARDUINO_ARCH_AVR     -I"C:\sloeber\arduinoPlugin\packages\arduino\hardware\avr\1.8.2\cores\arduino" -I"C:\sloeber\arduinoPlugin\packages\arduino\hardware\avr\1.8.2\variants\eightanaloginputs" -I"C:\Users\Filippo Badalamenti\Desktop\Uni\Meccanica delle Vibrazioni\mv-Project\06_Firmware\demoI2C\lib\MpuINT" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -D__IN_ECLIPSE__=1 -x c++ "$<"  -o  "$@"
	@echo 'Finished building: $<'
	@echo ' '


