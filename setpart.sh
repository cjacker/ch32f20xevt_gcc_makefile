#!/bin/bash

# if no Makefile
if [ ! -f Makefile ]; then
	echo "Please run './generate_project_from_evt.sh <part>' first."
  exit
fi 

PART_LIST="./ch32f-parts-list.txt"

# if no arg,
if [ $# -ne 1 ]; then
  echo "Usage: ./setpart.sh <part>"
  echo "Please specify a ch32f part:"
  while IFS= read -r line
  do
    part=$(echo "$line"|awk -F ' ' '{print $1}'| tr '[:upper:]' '[:lower:]')
    echo "$part"
  done < "$PART_LIST"
  exit
fi

# iterate the part list to found part info.
PART=$1
FLASHSIZE=
RAMSIZE=
STARTUP_ASM=                                                                            ZIPFILE=

FOUND="f"

while IFS= read -r line
do
  cur_part=$(echo "$line"|awk -F ' ' '{print $1}'| tr '[:upper:]' '[:lower:]')
  FLASHSIZE=$(echo "$line"|awk -F ' ' '{print $2}')
  RAMSIZE=$(echo "$line"|awk -F ' ' '{print $3}')
  STARTUP_ASM=$(echo "$line"|awk -F ' ' '{print $4}')
  ZIPFILE=$(echo "$line"|awk -F ' ' '{print $5}')
  if [ "$cur_part""x" == "$PART""x" ]; then
    FOUND="t"
    break;
  fi
done < "$PART_LIST"

#if not found
if [ "$FOUND""x" == "f""x" ];then
  echo "Your part is not supported."
  exit
fi

STARTUP_ASM_F=$(basename -s .s $STARTUP_ASM)".S"

if [[ $PART = ch32f1* ]]; then
  if [ -f ./CH32F_firmware_library/StdPeriphDriver/inc/ch32f10x.h ]; then
    sed -i "s/^TARGET = .*/TARGET = $PART/g" Makefile
    rm -rf CH32F_firmware_library/Ld/Link.ld
    cp Link.template.ld CH32F_firmware_library/Ld/Link.ld
    sed -i "s/FLASH_SIZE/$FLASHSIZE/g" CH32F_firmware_library/Ld/Link.ld
    sed -i "s/RAM_SIZE/$RAMSIZE/g" CH32F_firmware_library/Ld/Link.ld
    sed -i "s/^CH32F_firmware_library\/Startup\/startup.*/CH32F_firmware_library\/Startup\/$STARTUP_ASM_F/g" Makefile 
  else
    echo "Not ch32f1 project, can not set part to $PART"
    exit
  fi
fi

if [[ $PART = ch32f2* ]]; then
  if [ -f ./CH32F_firmware_library/StdPeriphDriver/inc/ch32f20x.h ]; then
    rm -rf CH32F_firmware_library/Ld/Link.ld
    cp ./Link.template.ld CH32F_firmware_library/Ld/Link.ld
    sed -i "s/FLASH_SIZE/$FLASHSIZE/g" CH32F_firmware_library/Ld/Link.ld
    sed -i "s/RAM_SIZE/$RAMSIZE/g" CH32F_firmware_library/Ld/Link.ld
    sed -i "s/^TARGET = .*/TARGET = $PART/g" Makefile
    sed -i "s/^CH32F_firmware_library\/Startup\/startup.*/CH32F_firmware_library\/Startup\/$STARTUP_ASM_F/g" Makefile 
  else
    echo "Not ch32f2 project, can not set part to $PART"
    exit
  fi
fi
