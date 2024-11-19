//*****************************************************************************
//*********  Copyright 2018, Rochester Institute of Technology  ***************
//*****************************************************************************
//
//      NAME: Arbitration Part1 Test Program
//
//  FILENAME: Arbitration_part1.c
//
//   CREATED:  10/16/2018
//
// ============================================================================
//
//   DESCRIPTION:
//    The following program loads data into an external RAM and then reads it back
//    for verification.  If the written data does not match the read data, LEDs
//    are turned on to notify the user.
//*****************************************************************************
//*****************************************************************************


//*****************************************************************************
//                    Include Files
//*****************************************************************************
#include "system.h"                 // for QSYS parameters
#include "sys/alt_irq.h"            // for IRQ support


//*****************************************************************************
//                  Define symbolic constants
//*****************************************************************************



// create standard embedded type definitions
typedef   signed char   sint8;        // signed 8 bit values
typedef unsigned char   uint8;        // unsigned 8 bit values
typedef   signed short  sint16;       // signed 16 bit values
typedef unsigned short  uint16;       // unsigned 16 bit values
typedef   signed long   sint32;       // signed 32 bit values
typedef unsigned long   uint32;       // unsigned 32 bit values
typedef         float   real32;       // 32 bit real values




//*****************************************************************************
//                     Define private data
//*****************************************************************************


uint8* BridgePtr = (uint8*)AVALON_BRIDGE_BASE;  //allow byte writes
uint32* JtagUartPtr = (uint32*)JTAG_UART_0_BASE;
uint16* LEDPtr = (uint16*)LEDR_BASE;


//*****************************************************************************
//                     Define private functions
//*****************************************************************************



//*****************************************************************************
// NAME: Send String to JTAG UART
//
// DESCRIPTION:
//    This function displays to the JTAG_UART like a printf
//
// INPUTS:
//    prompt - pointer to string to display
//    count  - number of characters
// OUTPUTS:
//    none
// RETURN:
//    none
//*****************************************************************************
void jtag_display (uint8* prompt, uint32 count)
{
  uint32 i;

  for (i = 0; i < count; i++)
  {
    *JtagUartPtr = prompt[i];
  } /* for */
} /* jtag_display */




//*****************************************************************************
//                              MAIN
//*****************************************************************************

int main(void)
{

  uint32 i;
  uint8 fail = 0;
  uint16 readback;

  *LEDPtr = 0x000;
  for (i = 0; i < 2047; i++)  //allow for byte writes
	{
		*(BridgePtr + i) = 0xAA;
	} /* for */
  for (i = 0; i < 2047; i++)  //allow for byte writes
	{
		readback = *(BridgePtr + i);
		if (readback != 0xAA) 
		{
			*LEDPtr = 0x3FF;
			break;
		}
	} /* for */
 
  while (1);
  return 0;
} /* main */
