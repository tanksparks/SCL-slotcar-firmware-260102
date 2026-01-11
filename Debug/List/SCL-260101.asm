
;CodeVisionAVR C Compiler V3.51 Standard
;(C) Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega328
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : long, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPMCSR=0x37
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40
	.EQU __EEPROM_PAGE_SIZE=0x04

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_sensor_port_index_G003:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x1
_sensor_bit_mask_G003:
	.DB  0x1,0x2,0x4,0x8,0x10,0x20,0x40,0x80

_0x0:
	.DB  0xD,0xA,0x25,0x70,0x20,0x76,0x25,0x70
	.DB  0x20,0x28,0x62,0x75,0x69,0x6C,0x64,0x20
	.DB  0x25,0x70,0x29,0x20,0x25,0x70,0x20,0x25
	.DB  0x70,0xD,0xA,0x0,0x53,0x6C,0x6F,0x74
	.DB  0x46,0x57,0x0,0x30,0x2E,0x31,0x2E,0x30
	.DB  0x0,0x30,0x30,0x30,0x31,0x0,0x4A,0x61
	.DB  0x6E,0x20,0x31,0x30,0x20,0x32,0x30,0x32
	.DB  0x36,0x0,0x31,0x34,0x3A,0x35,0x33,0x3A
	.DB  0x34,0x38,0x0,0x40,0x25,0x63,0x2C,0x25
	.DB  0x6C,0x75,0x2C,0xD,0xA,0x0
_0x80003:
	.DB  0x1
_0x80004:
	.DB  0x1
_0x80000:
	.DB  0x40,0x54,0x2C,0x25,0x6C,0x75,0x2C,0x25
	.DB  0x6C,0x75,0x2C,0xD,0xA,0x0
_0xC0000:
	.DB  0x40,0x44,0x2C,0x25,0x73,0xD,0xA,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _last_raw_S0040001000
	.DW  _0x80003*2

	.DW  0x01
	.DW  _stable_state_S0040001000
	.DW  _0x80004*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x300

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;void led_poweron_blink(void)
; 0000 0046 {

	.CSEG
_led_poweron_blink:
; .FSTART _led_poweron_blink
; 0000 0047 unsigned char i;
; 0000 0048 for (i = 0; i < 4; i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x4:
	CPI  R17,4
	BRSH _0x5
; 0000 0049 {
; 0000 004A LED1_ON();   delay_ms(150);    LED1_OFF();   delay_ms(150);
	SBI  0xB,2
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
	CBI  0xB,2
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
; 0000 004B }
	SUBI R17,-1
	RJMP _0x4
_0x5:
; 0000 004C }
	RJMP _0x2060003
; .FEND
;static void print_startup_banner(void)
; 0000 004F {
_print_startup_banner_G000:
; .FSTART _print_startup_banner_G000
; 0000 0050 // %p = FLASH string in CodeVision
; 0000 0051 printf("\r\n%p v%p (build %p) %p %p\r\n",
; 0000 0052 FW_NAME, FW_VERSION, FW_BUILD_NUM, FW_BUILD_DATE, FW_BUILD_TIME);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,28
	CALL SUBOPT_0x0
	__POINTW1FN _0x0,35
	CALL SUBOPT_0x0
	__POINTW1FN _0x0,41
	CALL SUBOPT_0x0
	__POINTW1FN _0x0,46
	CALL SUBOPT_0x0
	__POINTW1FN _0x0,58
	CALL SUBOPT_0x0
	LDI  R24,20
	CALL _printf
	ADIW R28,22
; 0000 0053 }
	RET
; .FEND
;static void protocol_on_cmd(char cmd, const char* args)
; 0000 0059 {
_protocol_on_cmd_G000:
; .FSTART _protocol_on_cmd_G000
; 0000 005A switch (cmd)
	CALL __SAVELOCR4
	MOVW R16,R26
	LDD  R19,Y+4
;	cmd -> R19
;	*args -> R16,R17
	MOV  R30,R19
	LDI  R31,0
; 0000 005B {
; 0000 005C case 'P':
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0x9
; 0000 005D if (args && args[0] == '1')
	MOV  R0,R16
	OR   R0,R17
	BREQ _0xB
	MOVW R26,R16
	LD   R26,X
	CPI  R26,LOW(0x31)
	BREQ _0xC
_0xB:
	RJMP _0xA
_0xC:
; 0000 005E track_power_on();
	CALL _track_power_on
; 0000 005F else
	RJMP _0xD
_0xA:
; 0000 0060 track_power_off();
	CALL _track_power_off
; 0000 0061 break;
_0xD:
	RJMP _0x8
; 0000 0062 
; 0000 0063 case 'S':
_0x9:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BREQ _0x8
; 0000 0064 // start_lights_sequence();
; 0000 0065 break;
; 0000 0066 
; 0000 0067 case 'X':
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x8
; 0000 0068 track_power_off();
	CALL _track_power_off
; 0000 0069 //   lights_off();
; 0000 006A break;
; 0000 006B }
_0x8:
; 0000 006C 
; 0000 006D }
	JMP  _0x2060002
; .FEND
;void main(void)
; 0000 0072 {
_main:
; .FSTART _main
; 0000 0073 unsigned char lane;
; 0000 0074 char lane_char;
; 0000 0075 setup();
;	lane -> R17
;	lane_char -> R16
	CALL _setup
; 0000 0076 uart_init(9600);
	__GETD2N 0x2580
	RCALL _uart_init
; 0000 0077 switches_init();
	CALL _switches_init
; 0000 0078 led_poweron_blink();
	RCALL _led_poweron_blink
; 0000 0079 print_startup_banner();
	RCALL _print_startup_banner_G000
; 0000 007A protocol_init(protocol_on_cmd); // pass function
	LDI  R26,LOW(_protocol_on_cmd_G000)
	LDI  R27,HIGH(_protocol_on_cmd_G000)
	CALL _protocol_init
; 0000 007B while (1)
_0x10:
; 0000 007C {
; 0000 007D // no delays allowed in while loop
; 0000 007E // We need to send data to PC as soon as possible
; 0000 007F for (lane = 0; lane < 8; lane++)
	LDI  R17,LOW(0)
_0x14:
	CPI  R17,8
	BRSH _0x15
; 0000 0080 {
; 0000 0081 if (lane_event_pending[lane])
	CALL SUBOPT_0x1
	LD   R30,Z
	CPI  R30,0
	BREQ _0x16
; 0000 0082 {
; 0000 0083 unsigned long t = lane_event_time[lane];
; 0000 0084 lane_event_pending[lane] = 0;
	SBIW R28,4
;	t -> Y+0
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
	CALL SUBOPT_0x1
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0085 
; 0000 0086 lane_char = 'A' + lane;
	MOV  R30,R17
	SUBI R30,-LOW(65)
	MOV  R16,R30
; 0000 0087 
; 0000 0088 // NOW with trailing comma after timestamp
; 0000 0089 // Format: @A,<timestamp>,\r\n
; 0000 008A // Lane 1 to 8 is A to H
; 0000 008B printf("@%c,%lu,\r\n", lane_char, t);
	__POINTW1FN _0x0,67
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x5
; 0000 008C }
	ADIW R28,4
; 0000 008D }
_0x16:
	SUBI R17,-1
	RJMP _0x14
_0x15:
; 0000 008E 
; 0000 008F switch1_poll(); // it will send data to PC
	CALL _switch1_poll
; 0000 0090 }
	RJMP _0x10
; 0000 0091 }
_0x17:
	RJMP _0x17
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;interrupt [19] void usart_rx_isr(void)
; 0001 0026 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	CALL SUBOPT_0x6
; 0001 0027 unsigned char status;
; 0001 0028 char data;
; 0001 0029 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0001 002A data=UDR0;
	LDS  R16,198
; 0001 002B if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x20003
; 0001 002C {
; 0001 002D rx_buffer0[rx_wr_index0++]=data;
	LDS  R30,_rx_wr_index0
	SUBI R30,-LOW(1)
	STS  _rx_wr_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0001 002E #if RX_BUFFER_SIZE0 == 256
; 0001 002F // special case for receiver buffer size=256
; 0001 0030 if (++rx_counter0 == 0) rx_buffer_overflow0=1;
	LDI  R26,LOW(_rx_counter0)
	LDI  R27,HIGH(_rx_counter0)
	CALL SUBOPT_0x7
	SBIW R30,0
	BRNE _0x20004
	SBI  0x1E,0
; 0001 0031 #else
; 0001 0032 if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
; 0001 0033 if (++rx_counter0 == RX_BUFFER_SIZE0)
; 0001 0034 {
; 0001 0035 rx_counter0=0;
; 0001 0036 rx_buffer_overflow0=1;
; 0001 0037 }
; 0001 0038 #endif
; 0001 0039 }
_0x20004:
; 0001 003A }
_0x20003:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x20013
; .FEND
;char getchar(void)
; 0001 0040 {
; 0001 0041 char data;
; 0001 0042 while (rx_counter0==0);
;	data -> R17
; 0001 0043 data=rx_buffer0[rx_rd_index0++];
; 0001 0044 #if RX_BUFFER_SIZE0 != 256
; 0001 0045 if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0001 0046 #endif
; 0001 0047 #asm("cli")
; 0001 0048 --rx_counter0;
; 0001 0049 #asm("sei")
; 0001 004A return data;
; 0001 004B }
;interrupt [21] void usart_tx_isr(void)
; 0001 0060 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	CALL SUBOPT_0x6
; 0001 0061 if (tx_counter0)
	LDS  R30,_tx_counter0
	LDS  R31,_tx_counter0+1
	SBIW R30,0
	BREQ _0x2000A
; 0001 0062 {
; 0001 0063 --tx_counter0;
	LDI  R26,LOW(_tx_counter0)
	LDI  R27,HIGH(_tx_counter0)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0001 0064 UDR0=tx_buffer0[tx_rd_index0++];
	LDS  R30,_tx_rd_index0
	SUBI R30,-LOW(1)
	STS  _tx_rd_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	STS  198,R30
; 0001 0065 #if TX_BUFFER_SIZE0 != 256
; 0001 0066 if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
; 0001 0067 #endif
; 0001 0068 }
; 0001 0069 }
_0x2000A:
_0x20013:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;void putchar(char c)
; 0001 006F {
_putchar:
; .FSTART _putchar
; 0001 0070 while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R17
	MOV  R17,R26
;	c -> R17
_0x2000B:
	LDS  R26,_tx_counter0
	LDS  R27,_tx_counter0+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BREQ _0x2000B
; 0001 0071 #asm("cli")
	CLI
; 0001 0072 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter0
	LDS  R31,_tx_counter0+1
	SBIW R30,0
	BRNE _0x2000F
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BRNE _0x2000E
_0x2000F:
; 0001 0073 {
; 0001 0074 tx_buffer0[tx_wr_index0++]=c;
	LDS  R30,_tx_wr_index0
	SUBI R30,-LOW(1)
	STS  _tx_wr_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	ST   Z,R17
; 0001 0075 #if TX_BUFFER_SIZE0 != 256
; 0001 0076 if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
; 0001 0077 #endif
; 0001 0078 ++tx_counter0;
	LDI  R26,LOW(_tx_counter0)
	LDI  R27,HIGH(_tx_counter0)
	CALL SUBOPT_0x7
; 0001 0079 }
; 0001 007A else
	RJMP _0x20011
_0x2000E:
; 0001 007B UDR0=c;
	STS  198,R17
; 0001 007C #asm("sei")
_0x20011:
	SEI
; 0001 007D }
_0x2060003:
	LD   R17,Y+
	RET
; .FEND
;void uart_init_codeVision_Wizzard(void)
; 0001 0080 {
; 0001 0081 
; 0001 0082 // USART initialization
; 0001 0083 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 0084 // USART Receiver: On
; 0001 0085 // USART Transmitter: On
; 0001 0086 // USART Mode: Asynchronous
; 0001 0087 // USART Baud Rate: 9600
; 0001 0088 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
; 0001 0089 UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
; 0001 008A UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
; 0001 008B UBRR0H=0x00;
; 0001 008C UBRR0L=0x67;
; 0001 008D }
;void uart_init(unsigned long baud)
; 0001 0090 {
_uart_init:
; .FSTART _uart_init
; 0001 0091 unsigned long ubrr;
; 0001 0092 
; 0001 0093 // Calculate UBRR value
; 0001 0094 // UBRR = (F_CPU / (16 * baud)) - 1
; 0001 0095 ubrr = (F_CPU / (16UL * baud)) - 1UL;
	CALL __PUTPARD2
	SBIW R28,4
;	baud -> Y+4
;	ubrr -> Y+0
	__GETD1S 4
	__GETD2N 0x10
	CALL __MULD12U
	__GETD2N 0xF42400
	CALL __DIVD21U
	__SUBD1N 1
	CALL SUBOPT_0x4
; 0001 0096 
; 0001 0097 // Set baud rate
; 0001 0098 UBRR0H = (unsigned char)(ubrr >> 8);
	__GETD2S 0
	LDI  R30,LOW(8)
	CALL __LSRD12
	STS  197,R30
; 0001 0099 UBRR0L = (unsigned char)(ubrr & 0xFF);
	LD   R30,Y
	STS  196,R30
; 0001 009A 
; 0001 009B // USART initialization
; 0001 009C // 8 data bits, 1 stop bit, no parity, async
; 0001 009D UCSR0A = 0;
	LDI  R30,LOW(0)
	STS  192,R30
; 0001 009E UCSR0B = (1<<RXCIE0) | (1<<TXCIE0) | (1<<RXEN0) | (1<<TXEN0);
	LDI  R30,LOW(216)
	STS  193,R30
; 0001 009F UCSR0C = (1<<UCSZ01) | (1<<UCSZ00);
	LDI  R30,LOW(6)
	STS  194,R30
; 0001 00A0 }
	ADIW R28,8
	RET
; .FEND
;char uart_try_getchar(char* out)
; 0001 00A3 {
; 0001 00A4 if (rx_counter0 == 0)
;	*out -> R16,R17
; 0001 00A5 return 0; // no data available
; 0001 00A6 
; 0001 00A7 *out = rx_buffer0[rx_rd_index0++];
; 0001 00A8 
; 0001 00A9 #if RX_BUFFER_SIZE0 != 256
; 0001 00AA if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0 = 0;
; 0001 00AB #endif
; 0001 00AC 
; 0001 00AD #asm("cli")
; 0001 00AE --rx_counter0;
; 0001 00AF #asm("sei")
; 0001 00B0 
; 0001 00B1 return 1; // got a byte
; 0001 00B2 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;void setup (void)
; 0002 000D {

	.CSEG
_setup:
; .FSTART _setup
; 0002 000E 
; 0002 000F // Crystal Oscillator division factor: 1
; 0002 0010 #pragma optsize-
; 0002 0011 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0002 0012 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0002 0013 #ifdef _OPTIMIZE_SIZE_
; 0002 0014 #pragma optsize+
; 0002 0015 #endif
; 0002 0016 
; 0002 0017 // Input/Output Ports initialization
; 0002 0018 // Port B initialization
; 0002 0019 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0002 001A DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x4,R30
; 0002 001B // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0002 001C PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x5,R30
; 0002 001D 
; 0002 001E // Port C initialization
; 0002 001F // Function: Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0002 0020 DDRC=(0<<DDC6) | (0<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(31)
	OUT  0x7,R30
; 0002 0021 // State: Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0002 0022 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0002 0023 
; 0002 0024 // Port D initialization
; 0002 0025 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=In
; 0002 0026 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (1<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(6)
	OUT  0xA,R30
; 0002 0027 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=P
; 0002 0028 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (1<<PORTD0);
	LDI  R30,LOW(1)
	OUT  0xB,R30
; 0002 0029 
; 0002 002A // Timer/Counter 0 initialization
; 0002 002B // Clock source: System Clock
; 0002 002C // Clock value: Timer 0 Stopped
; 0002 002D // Mode: Normal top=0xFF
; 0002 002E // OC0A output: Disconnected
; 0002 002F // OC0B output: Disconnected
; 0002 0030 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0002 0031 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x25,R30
; 0002 0032 TCNT0=0x00;
	OUT  0x26,R30
; 0002 0033 OCR0A=0x00;
	OUT  0x27,R30
; 0002 0034 OCR0B=0x00;
	OUT  0x28,R30
; 0002 0035 
; 0002 0036 // Timer/Counter 1 initialization
; 0002 0037 // Clock source: System Clock
; 0002 0038 // Clock value: 16000.000 kHz
; 0002 0039 // Mode: Normal top=0xFFFF
; 0002 003A // OC1A output: Disconnected
; 0002 003B // OC1B output: Disconnected
; 0002 003C // Noise Canceler: Off
; 0002 003D // Input Capture on Falling Edge
; 0002 003E // Timer Period: 0.1 ms
; 0002 003F // Timer1 Overflow Interrupt: On
; 0002 0040 // Input Capture Interrupt: Off
; 0002 0041 // Compare A Match Interrupt: Off
; 0002 0042 // Compare B Match Interrupt: Off
; 0002 0043 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0002 0044 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	STS  129,R30
; 0002 0045 TCNT1H=0xF9;
	CALL SUBOPT_0x8
; 0002 0046 TCNT1L=0xC0;
; 0002 0047 ICR1H=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
; 0002 0048 ICR1L=0x00;
	STS  134,R30
; 0002 0049 OCR1AH=0x00;
	STS  137,R30
; 0002 004A OCR1AL=0x00;
	STS  136,R30
; 0002 004B OCR1BH=0x00;
	STS  139,R30
; 0002 004C OCR1BL=0x00;
	STS  138,R30
; 0002 004D 
; 0002 004E // Timer/Counter 2 initialization
; 0002 004F // Clock source: System Clock
; 0002 0050 // Clock value: Timer2 Stopped
; 0002 0051 // Mode: Normal top=0xFF
; 0002 0052 // OC2A output: Disconnected
; 0002 0053 // OC2B output: Disconnected
; 0002 0054 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0002 0055 TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0002 0056 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0002 0057 TCNT2=0x00;
	STS  178,R30
; 0002 0058 OCR2A=0x00;
	STS  179,R30
; 0002 0059 OCR2B=0x00;
	STS  180,R30
; 0002 005A 
; 0002 005B // Timer/Counter 0 Interrupt(s) initialization
; 0002 005C TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0002 005D 
; 0002 005E // Timer/Counter 1 Interrupt(s) initialization
; 0002 005F TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (1<<TOIE1);
	LDI  R30,LOW(1)
	STS  111,R30
; 0002 0060 
; 0002 0061 // Timer/Counter 2 Interrupt(s) initialization
; 0002 0062 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	LDI  R30,LOW(0)
	STS  112,R30
; 0002 0063 
; 0002 0064 // External Interrupt(s) initialization
; 0002 0065 // INT0: Off
; 0002 0066 // INT1: Off
; 0002 0067 // Interrupt on any change on pins PCINT0-7: Off
; 0002 0068 // Interrupt on any change on pins PCINT8-14: Off
; 0002 0069 // Interrupt on any change on pins PCINT16-23: Off
; 0002 006A EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0002 006B EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0002 006C PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0002 006D //------   UART -----------
; 0002 006E 
; 0002 006F // Analog Comparator initialization
; 0002 0070 // Analog Comparator: Off
; 0002 0071 // The Analog Comparator's positive input is
; 0002 0072 // connected to the AIN0 pin
; 0002 0073 // The Analog Comparator's negative input is
; 0002 0074 // connected to the AIN1 pin
; 0002 0075 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0002 0076 ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	STS  123,R30
; 0002 0077 // Digital input buffer on AIN0: On
; 0002 0078 // Digital input buffer on AIN1: On
; 0002 0079 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0002 007A 
; 0002 007B // ADC initialization
; 0002 007C // ADC disabled
; 0002 007D ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	STS  122,R30
; 0002 007E 
; 0002 007F // SPI initialization
; 0002 0080 // SPI disabled
; 0002 0081 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0002 0082 
; 0002 0083 // TWI initialization
; 0002 0084 // TWI disabled
; 0002 0085 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0002 0086 
; 0002 0087 // Globally enable interrupts
; 0002 0088 #asm("sei")
	SEI
; 0002 0089 
; 0002 008A }
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;interrupt [14] void timer1_ovf_isr(void)
; 0003 0035 {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0003 0036 unsigned long now;
; 0003 0037 unsigned char i;
; 0003 0038 unsigned char pinb;
; 0003 0039 unsigned char pind;
; 0003 003A unsigned char is_low;
; 0003 003B 
; 0003 003C // Reinitialize Timer1 value (adjust 0xF9C0 if you change tick rate)
; 0003 003D TCNT1H = 0xF9C0 >> 8;
	SBIW R28,4
	CALL __SAVELOCR4
;	now -> Y+4
;	i -> R17
;	pinb -> R16
;	pind -> R19
;	is_low -> R18
	CALL SUBOPT_0x8
; 0003 003E TCNT1L = 0xF9C0 & 0xFF;
; 0003 003F 
; 0003 0040 // Global time tick (overflow rate defines resolution)
; 0003 0041 g_time_ticks++;
	LDI  R26,LOW(_g_time_ticks)
	LDI  R27,HIGH(_g_time_ticks)
	__GETD1P_INC
	__SUBD1N -1
	__PUTDP1_DEC
; 0003 0042 now = g_time_ticks;
	CALL SUBOPT_0x9
	__PUTD1S 4
; 0003 0043 
; 0003 0044 // Read ports once per ISR
; 0003 0045 pinb = PINB;
	IN   R16,3
; 0003 0046 pind = PIND;
	IN   R19,9
; 0003 0047 
; 0003 0048 // Process all 8 lanes
; 0003 0049 for (i = 0; i < 8; i++)
	LDI  R17,LOW(0)
_0x60004:
	CPI  R17,8
	BRLO PC+2
	RJMP _0x60005
; 0003 004A {
; 0003 004B unsigned char raw;
; 0003 004C 
; 0003 004D // Select raw port value for this lane
; 0003 004E if (sensor_port_index[i] == 0)
	SBIW R28,1
;	now -> Y+5
;	raw -> Y+0
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_port_index_G003*2)
	SBCI R31,HIGH(-_sensor_port_index_G003*2)
	LPM  R30,Z
	CPI  R30,0
	BRNE _0x60006
; 0003 004F {
; 0003 0050 // lane on PINB
; 0003 0051 raw = pinb;
	__PUTBSR 16,0
; 0003 0052 }
; 0003 0053 else
	RJMP _0x60007
_0x60006:
; 0003 0054 {
; 0003 0055 // lane on PIND
; 0003 0056 raw = pind;
	__PUTBSR 19,0
; 0003 0057 }
_0x60007:
; 0003 0058 
; 0003 0059 // Active-low: sensor "on" when pin reads 0
; 0003 005A is_low = ((raw & sensor_bit_mask[i]) == 0);
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_bit_mask_G003*2)
	SBCI R31,HIGH(-_sensor_bit_mask_G003*2)
	LPM  R30,Z
	LD   R26,Y
	AND  R30,R26
	LDI  R26,LOW(0)
	__EQB12
	MOV  R18,R30
; 0003 005B 
; 0003 005C // Debounce / glitch filter: consecutive low samples
; 0003 005D if (is_low)
	CPI  R18,0
	BREQ _0x60008
; 0003 005E {
; 0003 005F if (low_count[i] < 255)
	CALL SUBOPT_0xA
	LD   R26,Z
	CPI  R26,LOW(0xFF)
	BRSH _0x60009
; 0003 0060 low_count[i]++;
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_low_count_G003)
	SBCI R27,HIGH(-_low_count_G003)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0003 0061 }
_0x60009:
; 0003 0062 else
	RJMP _0x6000A
_0x60008:
; 0003 0063 {
; 0003 0064 low_count[i] = 0;
	CALL SUBOPT_0xA
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0003 0065 }
_0x6000A:
; 0003 0066 
; 0003 0067 // Enough consecutive lows? (3 samples in a row)
; 0003 0068 if (low_count[i] == 3)
	CALL SUBOPT_0xA
	LD   R26,Z
	CPI  R26,LOW(0x3)
	BRNE _0x6000B
; 0003 0069 {
; 0003 006A // Min time gap filter (ignore double triggers/glitches)
; 0003 006B if (now - lane_last_time[i] >= MIN_GAP_TICKS)
	CALL SUBOPT_0xB
	CALL SUBOPT_0x3
	CALL SUBOPT_0xC
	__SUBD21
	__CPD2N 0x32
	BRLO _0x6000C
; 0003 006C {
; 0003 006D lane_last_time[i]      = now;
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
; 0003 006E lane_event_time[i]     = now;
	CALL SUBOPT_0x2
	CALL SUBOPT_0xD
; 0003 006F lane_event_pending[i]  = 1;
	CALL SUBOPT_0x1
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0003 0070 }
; 0003 0071 }
_0x6000C:
; 0003 0072 }
_0x6000B:
	ADIW R28,1
	SUBI R17,-1
	RJMP _0x60004
_0x60005:
; 0003 0073 }
	CALL __LOADLOCR4
	ADIW R28,8
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;void switches_init(void)
; 0004 000E {

	.CSEG
_switches_init:
; .FSTART _switches_init
; 0004 000F // PD5 input + pull-up
; 0004 0010 DDRD  &= ~SWITCH1_MASK;
	CBI  0xA,5
; 0004 0011 PORTD |=  SWITCH1_MASK;
	SBI  0xB,5
; 0004 0012 }
	RET
; .FEND
;void switch1_poll(void)
; 0004 0015 {
_switch1_poll:
; .FSTART _switch1_poll
; 0004 0016 unsigned char raw;
; 0004 0017 static unsigned long last_sample_tick = 0;
; 0004 0018 static unsigned char last_raw = 1;

	.DSEG

	.CSEG
; 0004 0019 static unsigned char stable_state = 1;

	.DSEG

	.CSEG
; 0004 001A static unsigned char stable_count = 0;
; 0004 001B static unsigned long press_start_tick = 0;
; 0004 001C 
; 0004 001D unsigned long now = g_time_ticks;
; 0004 001E 
; 0004 001F // non-blocking time-based sampling
; 0004 0020 if ((unsigned long)(now - last_sample_tick) < SWITCH_SAMPLE_TICKS)
	SBIW R28,4
	ST   -Y,R17
;	raw -> R17
;	now -> Y+1
	CALL SUBOPT_0x9
	__PUTD1S 1
	LDS  R26,_last_sample_tick_S0040001000
	LDS  R27,_last_sample_tick_S0040001000+1
	LDS  R24,_last_sample_tick_S0040001000+2
	LDS  R25,_last_sample_tick_S0040001000+3
	CALL SUBOPT_0xE
	__SUBD12
	__CPD1N 0xA
	BRSH _0x80005
; 0004 0021 return;
	LDD  R17,Y+0
	JMP  _0x2060001
; 0004 0022 
; 0004 0023 last_sample_tick = now;
_0x80005:
	CALL SUBOPT_0xE
	STS  _last_sample_tick_S0040001000,R30
	STS  _last_sample_tick_S0040001000+1,R31
	STS  _last_sample_tick_S0040001000+2,R22
	STS  _last_sample_tick_S0040001000+3,R23
; 0004 0024 
; 0004 0025 raw = (PIND & SWITCH1_MASK) ? 1 : 0;
	SBIS 0x9,5
	RJMP _0x80006
	LDI  R30,LOW(1)
	RJMP _0x80007
_0x80006:
	LDI  R30,LOW(0)
_0x80007:
	MOV  R17,R30
; 0004 0026 
; 0004 0027 if (raw == last_raw)
	LDS  R30,_last_raw_S0040001000
	CP   R30,R17
	BRNE _0x80009
; 0004 0028 {
; 0004 0029 if (stable_count < SWITCH_STABLE_COUNT)
	LDS  R26,_stable_count_S0040001000
	CPI  R26,LOW(0x3)
	BRSH _0x8000A
; 0004 002A stable_count++;
	LDS  R30,_stable_count_S0040001000
	SUBI R30,-LOW(1)
	STS  _stable_count_S0040001000,R30
; 0004 002B }
_0x8000A:
; 0004 002C else
	RJMP _0x8000B
_0x80009:
; 0004 002D {
; 0004 002E stable_count = 0;
	LDI  R30,LOW(0)
	STS  _stable_count_S0040001000,R30
; 0004 002F last_raw = raw;
	STS  _last_raw_S0040001000,R17
; 0004 0030 }
_0x8000B:
; 0004 0031 
; 0004 0032 if (stable_count == SWITCH_STABLE_COUNT && raw != stable_state)
	LDS  R26,_stable_count_S0040001000
	CPI  R26,LOW(0x3)
	BRNE _0x8000D
	LDS  R30,_stable_state_S0040001000
	CP   R30,R17
	BRNE _0x8000E
_0x8000D:
	RJMP _0x8000C
_0x8000E:
; 0004 0033 {
; 0004 0034 stable_state = raw;
	STS  _stable_state_S0040001000,R17
; 0004 0035 
; 0004 0036 // PRESS
; 0004 0037 if (stable_state == 0)
	LDS  R30,_stable_state_S0040001000
	CPI  R30,0
	BRNE _0x8000F
; 0004 0038 {
; 0004 0039 press_start_tick = now;
	CALL SUBOPT_0xE
	STS  _press_start_tick_S0040001000,R30
	STS  _press_start_tick_S0040001000+1,R31
	STS  _press_start_tick_S0040001000+2,R22
	STS  _press_start_tick_S0040001000+3,R23
; 0004 003A }
; 0004 003B // RELEASE
; 0004 003C else
	RJMP _0x80010
_0x8000F:
; 0004 003D {
; 0004 003E unsigned long duration_ticks = now - press_start_tick;
; 0004 003F unsigned long duration_ms = duration_ticks / 10;
; 0004 0040 
; 0004 0041 // @T,<start>,<duration>,
; 0004 0042 printf("@T,%lu,%lu,\r\n", press_start_tick, duration_ms);
	SBIW R28,8
;	now -> Y+9
;	duration_ticks -> Y+4
;	duration_ms -> Y+0
	LDS  R26,_press_start_tick_S0040001000
	LDS  R27,_press_start_tick_S0040001000+1
	LDS  R24,_press_start_tick_S0040001000+2
	LDS  R25,_press_start_tick_S0040001000+3
	__GETD1S 9
	__SUBD12
	__PUTD1S 4
	__GETD2S 4
	__GETD1N 0xA
	CALL __DIVD21U
	CALL SUBOPT_0x4
	__POINTW1FN _0x80000,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_press_start_tick_S0040001000
	LDS  R31,_press_start_tick_S0040001000+1
	LDS  R22,_press_start_tick_S0040001000+2
	LDS  R23,_press_start_tick_S0040001000+3
	CALL SUBOPT_0x5
; 0004 0043 
; 0004 0044 // optional classification
; 0004 0045 if (duration_ticks >= LONG_PRESS_TICKS)
; 0004 0046 {
; 0004 0047 // printf("@T,LONG,%lu,\r\n", duration_ms);
; 0004 0048 }
; 0004 0049 }
	ADIW R28,8
_0x80010:
; 0004 004A }
; 0004 004B }
_0x8000C:
	LDD  R17,Y+0
	JMP  _0x2060001
; .FEND
;void protocol_init(protocol_handler_fn handler)
; 0005 001B {

	.CSEG
_protocol_init:
; .FSTART _protocol_init
; 0005 001C g_handler = handler;
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*handler -> R16,R17
	__PUTWMRN _g_handler_G005,0,16,17
; 0005 001D idx = 0;
	LDI  R30,LOW(0)
	STS  _idx_G005,R30
; 0005 001E }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;static void handle_line(char* s)
; 0005 0021 {
; 0005 0022 char cmd;
; 0005 0023 const char* args = 0;   // NULL = no args
; 0005 0024 
; 0005 0025 if (s[0] != '@' || s[1] == 0)
;	*s -> R20,R21
;	cmd -> R17
;	*args -> R18,R19
; 0005 0026 return;
; 0005 0027 
; 0005 0028 cmd = s[1];
; 0005 0029 
; 0005 002A if (s[2] == ',')
; 0005 002B args = &s[3];       // points into RAM buffer
; 0005 002C else if (s[2] != 0)
; 0005 002D args = &s[2];
; 0005 002E 
; 0005 002F if (g_handler)
; 0005 0030 g_handler(cmd, args);
; 0005 0031 }
;void protocol_feed(uint8_t b)
; 0005 0035 {
; 0005 0036 if (b == '\r') return;
;	b -> R17
; 0005 0037 
; 0005 0038 if (b == '\n')
; 0005 0039 {
; 0005 003A linebuf[idx] = 0;
; 0005 003B if (idx > 0)
; 0005 003C handle_line(linebuf);
; 0005 003D idx = 0;
; 0005 003E return;
; 0005 003F }
; 0005 0040 
; 0005 0041 if (idx < (LINE_MAX - 1))
; 0005 0042 linebuf[idx++] = (char)b;
; 0005 0043 else
; 0005 0044 idx = 0; // overflow -> reset
; 0005 0045 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;static void q_push_line(const char* s)
; 0006 0019 {

	.CSEG
; 0006 001A if (q_count >= SNIFF_Q_LINES) return; // drop if full (sniffer shouldn't break timing)
;	*s -> R16,R17
; 0006 001B strncpy(q[q_wr], s, SNIFF_LINE_MAX - 1);
; 0006 001C q[q_wr][SNIFF_LINE_MAX - 1] = 0;
; 0006 001D q_wr = (uint8_t)((q_wr + 1) % SNIFF_Q_LINES);
; 0006 001E q_count++;
; 0006 001F }
;static uint8_t q_pop_line(char* out)
; 0006 0022 {
; 0006 0023 if (q_count == 0) return 0;
;	*out -> R16,R17
; 0006 0024 strcpy(out, q[q_rd]);
; 0006 0025 q_rd = (uint8_t)((q_rd + 1) % SNIFF_Q_LINES);
; 0006 0026 #asm("cli")
; 0006 0027 q_count--;
; 0006 0028 #asm("sei")
; 0006 0029 return 1;
; 0006 002A }
;void sniffer_init(void)
; 0006 002D {
; 0006 002E idx = 0;
; 0006 002F q_wr = q_rd = q_count = 0;
; 0006 0030 }
;void sniffer_feed(uint8_t b)
; 0006 0034 {
; 0006 0035 if (b == '\r') return; // ignore CR
;	b -> R17
; 0006 0036 
; 0006 0037 if (b == '\n')
; 0006 0038 {
; 0006 0039 line[idx] = 0;
; 0006 003A if (idx > 0) q_push_line(line);
; 0006 003B idx = 0;
; 0006 003C return;
; 0006 003D }
; 0006 003E 
; 0006 003F if (idx < (SNIFF_LINE_MAX - 1))
; 0006 0040 line[idx++] = (char)b;
; 0006 0041 else
; 0006 0042 idx = 0; // overflow: reset
; 0006 0043 }
;void sniffer_poll(void)
; 0006 0047 {
; 0006 0048 char tmp[SNIFF_LINE_MAX];
; 0006 0049 if (q_pop_line(tmp))
;	tmp -> Y+0
; 0006 004A {
; 0006 004B // Prefix so you can distinguish sniffer output from normal messages
; 0006 004C printf("@D,%s\r\n", tmp);
; 0006 004D }
; 0006 004E }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;void track_power_on(void)
; 0007 000B {

	.CSEG
_track_power_on:
; .FSTART _track_power_on
; 0007 000C TRACK_POWER_DDR |= (1 << TRACK_POWER_PIN);   // ensure output
	SBI  0x4,2
; 0007 000D TRACK_POWER_PORT |= (1 << TRACK_POWER_PIN);  // relay ON
	SBI  0x5,2
; 0007 000E }
	RET
; .FEND
;void track_power_off(void)
; 0007 0011 {
_track_power_off:
; .FSTART _track_power_off
; 0007 0012 TRACK_POWER_DDR |= (1 << TRACK_POWER_PIN);
	SBI  0x4,2
; 0007 0013 TRACK_POWER_PORT &= ~(1 << TRACK_POWER_PIN); // relay OFF
	CBI  0x5,2
; 0007 0014 }
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_put_usart_G100:
; .FSTART _put_usart_G100
	CALL __SAVELOCR4
	MOVW R16,R26
	LDD  R19,Y+4
	MOV  R26,R19
	CALL _putchar
	MOVW R26,R16
	CALL SUBOPT_0x7
_0x2060002:
	CALL __LOADLOCR4
_0x2060001:
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,12
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	ADIW R30,1
	STD  Y+24,R30
	STD  Y+24+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0xF
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0xF
	RJMP _0x20000E7
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+17,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R30,LOW(43)
	STD  Y+17,R30
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R30,LOW(32)
	STD  Y+17,R30
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BRNE _0x2000028
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x200002C
	LDI  R17,LOW(4)
	RJMP _0x200001B
_0x200002C:
	RJMP _0x200002D
_0x2000028:
	CPI  R30,LOW(0x4)
	BRNE _0x200002F
	CPI  R18,48
	BRLO _0x2000031
	CPI  R18,58
	BRLO _0x2000032
_0x2000031:
	RJMP _0x2000030
_0x2000032:
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x200001B
_0x2000030:
_0x200002D:
	CPI  R18,108
	BRNE _0x2000033
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x200001B
_0x2000033:
	RJMP _0x2000034
_0x200002F:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x200001B
_0x2000034:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000039
	CALL SUBOPT_0x10
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x11
	RJMP _0x200003A
_0x2000039:
	CPI  R30,LOW(0x73)
	BRNE _0x200003C
	CALL SUBOPT_0x10
	CALL SUBOPT_0x12
	CALL _strlen
	MOV  R17,R30
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x70)
	BRNE _0x200003F
	CALL SUBOPT_0x10
	CALL SUBOPT_0x12
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x200003D:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x2000041
	CP   R20,R17
	BRLO _0x2000042
_0x2000041:
	RJMP _0x2000040
_0x2000042:
	MOV  R17,R20
_0x2000040:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R19,LOW(0)
	RJMP _0x2000043
_0x200003F:
	CPI  R30,LOW(0x64)
	BREQ _0x2000046
	CPI  R30,LOW(0x69)
	BRNE _0x2000047
_0x2000046:
	ORI  R16,LOW(4)
	RJMP _0x2000048
_0x2000047:
	CPI  R30,LOW(0x75)
	BRNE _0x2000049
_0x2000048:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x200004A
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x13
	LDI  R17,LOW(10)
	RJMP _0x200004B
_0x200004A:
	__GETD1N 0x2710
	CALL SUBOPT_0x13
	LDI  R17,LOW(5)
	RJMP _0x200004B
_0x2000049:
	CPI  R30,LOW(0x58)
	BRNE _0x200004D
	ORI  R16,LOW(8)
	RJMP _0x200004E
_0x200004D:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x200008C
_0x200004E:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2000050
	__GETD1N 0x10000000
	CALL SUBOPT_0x13
	LDI  R17,LOW(8)
	RJMP _0x200004B
_0x2000050:
	__GETD1N 0x1000
	CALL SUBOPT_0x13
	LDI  R17,LOW(4)
_0x200004B:
	CPI  R20,0
	BREQ _0x2000051
	ANDI R16,LOW(127)
	RJMP _0x2000052
_0x2000051:
	LDI  R20,LOW(1)
_0x2000052:
	SBRS R16,1
	RJMP _0x2000053
	CALL SUBOPT_0x10
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x20000E8
_0x2000053:
	SBRS R16,2
	RJMP _0x2000055
	CALL SUBOPT_0x10
	CALL SUBOPT_0x14
	__CWD1
	RJMP _0x20000E8
_0x2000055:
	CALL SUBOPT_0x10
	CALL SUBOPT_0x14
	CLR  R22
	CLR  R23
_0x20000E8:
	__PUTD1S 12
	SBRS R16,2
	RJMP _0x2000057
	LDD  R26,Y+15
	TST  R26
	BRPL _0x2000058
	__GETD1S 12
	CALL __ANEGD1
	__PUTD1S 12
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0x2000058:
	LDD  R30,Y+17
	CPI  R30,0
	BREQ _0x2000059
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x200005A
_0x2000059:
	ANDI R16,LOW(251)
_0x200005A:
_0x2000057:
	MOV  R19,R20
_0x2000043:
	SBRC R16,0
	RJMP _0x200005B
_0x200005C:
	CP   R17,R21
	BRSH _0x200005F
	CP   R19,R21
	BRLO _0x2000060
_0x200005F:
	RJMP _0x200005E
_0x2000060:
	SBRS R16,7
	RJMP _0x2000061
	SBRS R16,2
	RJMP _0x2000062
	ANDI R16,LOW(251)
	LDD  R18,Y+17
	SUBI R17,LOW(1)
	RJMP _0x2000063
_0x2000062:
	LDI  R18,LOW(48)
_0x2000063:
	RJMP _0x2000064
_0x2000061:
	LDI  R18,LOW(32)
_0x2000064:
	CALL SUBOPT_0xF
	SUBI R21,LOW(1)
	RJMP _0x200005C
_0x200005E:
_0x200005B:
_0x2000065:
	CP   R17,R20
	BRSH _0x2000067
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000068
	ANDI R16,LOW(251)
	LDD  R30,Y+17
	ST   -Y,R30
	CALL SUBOPT_0x11
	CPI  R21,0
	BREQ _0x2000069
	SUBI R21,LOW(1)
_0x2000069:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000068:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x11
	CPI  R21,0
	BREQ _0x200006A
	SUBI R21,LOW(1)
_0x200006A:
	SUBI R20,LOW(1)
	RJMP _0x2000065
_0x2000067:
	MOV  R19,R17
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x200006B
_0x200006C:
	CPI  R19,0
	BREQ _0x200006E
	SBRS R16,3
	RJMP _0x200006F
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000070
_0x200006F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000070:
	CALL SUBOPT_0xF
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
	SUBI R19,LOW(1)
	RJMP _0x200006C
_0x200006E:
	RJMP _0x2000072
_0x200006B:
_0x2000074:
	CALL SUBOPT_0x15
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x2000076
	SBRS R16,3
	RJMP _0x2000077
	SUBI R18,-LOW(55)
	RJMP _0x2000078
_0x2000077:
	SUBI R18,-LOW(87)
_0x2000078:
	RJMP _0x2000079
_0x2000076:
	SUBI R18,-LOW(48)
_0x2000079:
	SBRC R16,4
	RJMP _0x200007B
	CPI  R18,49
	BRSH _0x200007D
	__GETD2S 8
	__CPD2N 0x1
	BRNE _0x200007C
_0x200007D:
	RJMP _0x200007F
_0x200007C:
	CP   R20,R19
	BRSH _0x20000E9
	CP   R21,R19
	BRLO _0x2000082
	SBRS R16,0
	RJMP _0x2000083
_0x2000082:
	RJMP _0x2000081
_0x2000083:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000084
_0x20000E9:
	LDI  R18,LOW(48)
_0x200007F:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000085
	ANDI R16,LOW(251)
	LDD  R30,Y+17
	ST   -Y,R30
	CALL SUBOPT_0x11
	CPI  R21,0
	BREQ _0x2000086
	SUBI R21,LOW(1)
_0x2000086:
_0x2000085:
_0x2000084:
_0x200007B:
	CALL SUBOPT_0xF
	CPI  R21,0
	BREQ _0x2000087
	SUBI R21,LOW(1)
_0x2000087:
_0x2000081:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x15
	CALL __MODD21U
	__PUTD1S 12
	LDD  R30,Y+16
	__GETD2S 8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x13
	__GETD1S 8
	__CPD10
	BREQ _0x2000075
	RJMP _0x2000074
_0x2000075:
_0x2000072:
	SBRS R16,0
	RJMP _0x2000088
_0x2000089:
	CPI  R21,0
	BREQ _0x200008B
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x11
	RJMP _0x2000089
_0x200008B:
_0x2000088:
_0x200008C:
_0x200003A:
_0x20000E7:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LD   R30,X+
	LD   R31,X+
	CALL __LOADLOCR6
	ADIW R28,26
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	__ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	__ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG
_g_time_ticks:
	.BYTE 0x4
_lane_event_pending:
	.BYTE 0x8
_lane_event_time:
	.BYTE 0x20
_rx_buffer0:
	.BYTE 0x100
_rx_wr_index0:
	.BYTE 0x1
_rx_rd_index0:
	.BYTE 0x1
_rx_counter0:
	.BYTE 0x2
_tx_buffer0:
	.BYTE 0x100
_tx_wr_index0:
	.BYTE 0x1
_tx_rd_index0:
	.BYTE 0x1
_tx_counter0:
	.BYTE 0x2
_lane_last_time:
	.BYTE 0x20
_low_count_G003:
	.BYTE 0x8
_last_sample_tick_S0040001000:
	.BYTE 0x4
_last_raw_S0040001000:
	.BYTE 0x1
_stable_state_S0040001000:
	.BYTE 0x1
_stable_count_S0040001000:
	.BYTE 0x1
_press_start_tick_S0040001000:
	.BYTE 0x4
_g_handler_G005:
	.BYTE 0x2
_linebuf_G005:
	.BYTE 0x50
_idx_G005:
	.BYTE 0x1
_line_G006:
	.BYTE 0x50
_idx_G006:
	.BYTE 0x1
_q_G006:
	.BYTE 0x140
_q_wr_G006:
	.BYTE 0x1
_q_rd_G006:
	.BYTE 0x1
_q_count_G006:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_lane_event_pending)
	SBCI R31,HIGH(-_lane_event_pending)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	MOV  R30,R17
	LDI  R26,LOW(_lane_event_time)
	LDI  R27,HIGH(_lane_event_time)
	LDI  R31,0
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ADD  R26,R30
	ADC  R27,R31
	__GETD1P_INC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	CALL __PUTPARD1
	__GETD1S 6
	CALL __PUTPARD1
	LDI  R24,8
	CALL _printf
	ADIW R28,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(249)
	STS  133,R30
	LDI  R30,LOW(192)
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDS  R30,_g_time_ticks
	LDS  R31,_g_time_ticks+1
	LDS  R22,_g_time_ticks+2
	LDS  R23,_g_time_ticks+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_low_count_G003)
	SBCI R31,HIGH(-_low_count_G003)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	MOV  R30,R17
	LDI  R26,LOW(_lane_last_time)
	LDI  R27,HIGH(_lane_last_time)
	LDI  R31,0
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0xC
	__PUTDZ2 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xF:
	ST   -Y,R18
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x10:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SBIW R30,4
	STD  Y+22,R30
	STD  Y+22+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	__GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	__GETD1S 8
	__GETD2S 12
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12S8:
	CP   R0,R1
	BRLO __LSRD12L
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	LDI  R23,0
	SUB  R0,R1
	BRNE __LSRD12S8
	RET
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	MOVW R20,R0
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
