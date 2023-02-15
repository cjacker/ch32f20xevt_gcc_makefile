######################################
# target
######################################
TARGET = ch32f203c8t6


######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization for size
OPT = -Os


#######################################
# paths
#######################################
# Build path
BUILD_DIR = build

######################################
# source
######################################
# C sources
C_SOURCES = \
CH32F_firmware_library/CMSIS/core_cm3.c \
CH32F_firmware_library/Debug/debug.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_dvp.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_dbgmcu.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_sdio.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_dac.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_wwdg.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_rng.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_usart.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_flash.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_dma.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_bkp.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_exti.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_opa.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_crc.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_eth.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_fsmc.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_pwr.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_rcc.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_iwdg.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_spi.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_rtc.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_adc.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_can.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_i2c.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_gpio.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_misc.c \
CH32F_firmware_library/StdPeriphDriver/src/ch32f20x_tim.c \
User/ch32f20x_it.c \
User/system_ch32f20x.c \
User/Main.c \


# ASM sources
ASM_SOURCES =  \
CH32F_firmware_library/Startup/startup_ch32f20x_D6.S \


#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-

CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size

HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m3

# fpu
# NONE for Cortex-M0/M0+/M3

# float-abi

# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

AS_DEFS =

# C defines
C_DEFS = 

# AS includes
AS_INCLUDES = 

# C includes
C_INCLUDES =  \
-ICH32F_firmware_library/CMSIS \
-ICH32F_firmware_library/Debug \
-ICH32F_firmware_library/StdPeriphDriver/inc \
-IUser

# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"


#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = CH32F_firmware_library/Ld/Link.ld 

# libraries
LIBS = -lc -lm -lnosys
LIBDIR = 
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.S=.o)))
vpath %.S $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.S Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@
#$(LUAOBJECTS) $(OBJECTS)
$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@		

#######################################
# clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)
  
#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***
