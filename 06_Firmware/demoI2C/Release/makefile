################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir.mk
-include lib/nI2C/examples/slave_sender/subdir.mk
-include lib/nI2C/examples/slave_receiver/subdir.mk
-include lib/nI2C/examples/master_writer/subdir.mk
-include lib/nI2C/examples/master_reader/subdir.mk
-include lib/nI2C/examples/master_advanced/subdir.mk
-include lib/nI2C/examples/RTC_reader/subdir.mk
-include lib/nI2C/examples/Nonblocking_Read_RTC/subdir.mk
-include lib/nI2C/subdir.mk
-include lib/MpuINT/subdir.mk
-include MpuINT/subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(INO_DEPS)),)
-include $(INO_DEPS)
endif
ifneq ($(strip $(PDE_DEPS)),)
-include $(PDE_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
AR += \
/home/alfyhack/Documenti/mv-Project/06_Firmware/demoI2C/Release/arduino.ar \

ELF += \
demoI2C.elf \

HEX += \
demoI2C.hex \


# All Target
all: demoI2C

# Tool invocations
demoI2C: $(HEX)
	@echo 'Building target: $@'
	@echo 'Report dimensioni:'
	"C:\sloeber\arduinoPlugin\packages\arduino\tools\avr-gcc\7.3.0-atmel3.6.1-arduino5/bin/avr-size" -A "/home/alfyhack/Documenti/mv-Project/06_Firmware/demoI2C/Release/demoI2C.elf"
	@echo 'Finished building target: $@'
	@echo ' '

/home/alfyhack/Documenti/mv-Project/06_Firmware/demoI2C/Release/arduino.ar: $(AR_OBJ)
	@echo 'Avvio archiviazione'
	"C:\sloeber\arduinoPlugin\packages\arduino\tools\avr-gcc\7.3.0-atmel3.6.1-arduino5/bin/avr-gcc-ar" rcs     /home/alfyhack/Documenti/mv-Project/06_Firmware/demoI2C/Release/arduino.ar $(AR_OBJ)
	@echo 'Finished building: $@'
	@echo ' '

demoI2C.elf: $(LINK_OBJ) $(AR)
	@echo 'Avvio del combviner'
	"C:\sloeber\arduinoPlugin\packages\arduino\tools\avr-gcc\7.3.0-atmel3.6.1-arduino5/bin/avr-gcc" -Wall -Wextra -Os -g -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=atmega168  -o "/home/alfyhack/Documenti/mv-Project/06_Firmware/demoI2C/Release/demoI2C.elf"   $(LINK_OBJ)   /home/alfyhack/Documenti/mv-Project/06_Firmware/demoI2C/Release/arduino.ar  "-L/home/alfyhack/Documenti/mv-Project/06_Firmware/demoI2C/Release" -lm
	@echo 'Finished building: $@'
	@echo ' '

demoI2C.hex: $(ELF)
	@echo 'Esecuzione dei comandi objcopy'
	${A.RECIPE.OBJCOPY.EEP.PATTERN}
	${A.RECIPE.OBJCOPY.HEX.PATTERN}
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(C_UPPER_DEPS)$(PDE_DEPS)$(C_DEPS)$(AR)$(CC_DEPS)$(AR_OBJ)$(C++_DEPS)$(LINK_OBJ)$(CXX_DEPS)$(ASM_DEPS)$(HEX)$(INO_DEPS)$(SIZEDUMMY)$(S_UPPER_DEPS)$(ELF)$(CPP_DEPS)
	-@echo ' '

.PHONY: all clean dependents

-include ../makefile.targets
