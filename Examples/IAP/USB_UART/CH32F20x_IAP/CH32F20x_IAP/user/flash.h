/********************************** (C) COPYRIGHT  *******************************
* File Name          : falsh.h
* Author             : WCH
* Version            : V1.0.0
* Date               : 2020/12/16
* Description        : 
*********************************************************************************
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* Attention: This software (modified or not) and binary are used for 
* microcontroller manufactured by Nanjing Qinheng Microelectronics.
*******************************************************************************/
#ifndef __FLASH_H
#define __FLASH_H 	

#include "ch32f20x.h"
#include "stdio.h"

u8 CH32_IAP_Verity(u32 adr, u32* buf);
void CH32_IAP_Program(u32 adr, u32* buf);


#endif
