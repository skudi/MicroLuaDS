# makefile for Microlua
# HISTORY
# ??/??/??  risike, init.  from palib most likely.
# 12/08/09 motopic, jmr, added export changes to path for linux
# 08/08/12 Reylak removed obsolete versions (.ds.gba, etc.)

#---------------------------------------------------------------------------------
PROGNAME	:= Micro Lua DS
OFILES		+=
ADD_LIBS	+=
#---------------------------------------------------------------------------------

ifeq ($(findstring Windows,$(OS)),Windows)
WINDOWS		:= 1
endif

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

PATH 		:= $(DEVKITARM)/bin:$(PATH)

#---------------------------------------------------------------------------------
# ARM7BIN is the path to an arm7 binary other than the default
#	usage: ARM7BIN := -7 binaryName.bin
#---------------------------------------------------------------------------------
ARM7BIN		:= -7 $(DEVKITPRO)/libnds/default.elf

include $(DEVKITARM)/base_rules
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# EFS is the path to the EFS binary
# EFSROOT is the path to the folder to the included as the filesystem
#	Leave empty to disable EFS
#---------------------------------------------------------------------------------
EFS 		:= $(CURDIR)/../efs
ifeq ($(WINDOWS),1)
EFS 		:= $(CURDIR)/../efs.exe
endif
EFSROOT 	:= 
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
TEXT1 		:= Micro Lua DS
TEXT2 		:= By Risike and Community
TEXT3 		:= microlua.xooit.fr/
ICON 		:= -b $(CURDIR)/../logo.bmp
LOGO		:= -o $(CURDIR)/../logo_wifi.bmp
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# TARGET is the name of the output, if this ends with _mb generates a multiboot image
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing extra header files
# EXPORT_DIR is the folder where to copy the output file when asked 'make export'
#---------------------------------------------------------------------------------
TARGET		:= MicroLua
BUILD		:= build
SOURCES		:= gfx source data
INCLUDES	:= include build
EXPORT_DIR	:= 
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# Options for code generation
#---------------------------------------------------------------------------------
ARCH		:= -mthumb -mthumb-interwork

# note: arm9tdmi isn't the correct CPU arch, but anything newer and LD
# *insists* it has a FPU or VFP, and it won't take no for an answer!
CFLAGS		:= -g -Wall -O2 \
 		-mcpu=arm9tdmi -mtune=arm9tdmi -fomit-frame-pointer\
		-ffast-math \
		$(ARCH) \
		$(INCLUDE) -DARM9
ifneq ($(strip $(EFSROOT)),)
CFLAGS		:= $(CFLAGS) -DEFS
NDSFLAGS 	:= -d ../$(EFSROOT)
endif
CXXFLAGS	:= $(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS		:= -g $(ARCH)
LDFLAGS		:= -specs=ds_arm9.specs -g $(ARCH) -Wl,-Map,$(notdir $*.map)
 
#---------------------------------------------------------------------------------
# Any extra libraries we wish to link with the project
#---------------------------------------------------------------------------------
LIBS		:= -llua -lul -lpng -lz -lfat -ldswifi9 -lmm9 -lnds9

#---------------------------------------------------------------------------------
# List of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
LIBDIRS		:= $(DEVKITPRO)/libnds
 
#---------------------------------------------------------------------------------
# No real need to edit anything past this point unless you need to add additional
# rules for different file extensions
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))

export OUTPUT	:= $(CURDIR)/$(TARGET)
export VPATH	:= $(foreach dir,$(SOURCES),$(CURDIR)/$(dir))
export DEPSDIR  := $(CURDIR)/$(BUILD)

#---------------------------------------------------------------------------------
# Use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
export LD	:= $(CXX)
 
CFILES		:= $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES	:= $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
 
export OFILES	:= $(CPPFILES:.cpp=.o) $(CFILES:.c=.o)
 
export INCLUDE	:= $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
		$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
		$(foreach dir,$(LIBDIRS),-I$(dir)/include/nds) \
		-I$(CURDIR)/$(BUILD)
export LIBPATHS	:= $(foreach dir,$(LIBDIRS),-L$(dir)/lib)
#---------------------------------------------------------------------------------
 
#---------------------------------------------------------------------------------
.PHONY: $(BUILD) all clean cleanall export
#---------------------------------------------------------------------------------
 
#---------------------------------------------------------------------------------
$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@make --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

all:
	@make clean				# Clean MicroLua so we are sure it is rebuilt with the newest liblua
	@make -C lua
	@make install -C lua
	@make

clean:
	@echo Cleaning MicroLua...
	@rm -fr $(BUILD) *.elf *.bin

cleanall: clean
	make clean -C lua
 
export:
	@echo Exporting...
	@[ -z $(EXPORT_DIR) ] && echo 'Please set EXPORT_DIR in the Makefile before trying to export.' || cp $(TARGET).nds $(EXPORT_DIR)/
#---------------------------------------------------------------------------------

else
 
DEPENDS		:= $(OFILES:.o=.d)
 
#---------------------------------------------------------------------------------
# Main targets
#---------------------------------------------------------------------------------
$(OUTPUT).nds	: $(OUTPUT).bin
$(OUTPUT).bin	: $(OUTPUT).elf
$(OUTPUT).elf	: $(OFILES)

#---------------------------------------------------------------------------------
%.o: %.bin
	@echo $(notdir $<)
	$(bin2o)
#---------------------------------------------------------------------------------------

-include $(DEPENDS) 

endif
#---------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
%.nds: %.arm9
	ndstool -c $@ $(NDSFLAGS) -9 $< $(ARM7BIN) $(LOGO) $(ICON) "$(TEXT1);$(TEXT2);$(TEXT3)"
	@if [ ! -z $(EFSROOT) ]; then $(EFS) $@; fi
	@echo Built $(notdir $@)!
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
%.arm9: %.elf
	@$(OBJCOPY) -O binary $< $@
	@echo Built $(notdir $@)...
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
%.arm7: %.elf
	@$(OBJCOPY) -O binary $< $@
	@echo Built $(notdir $@)...
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
%.elf:
	@$(LD) $(LDFLAGS) $(OFILES) $(LIBPATHS) $(LIBS) -o $@
	@echo Linked $(notdir $@)...
#---------------------------------------------------------------------------------
