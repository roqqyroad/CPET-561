//Matthew Cells
//Lab_6_p2

#include <stdio.h>
#include "system.h"


// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;             // 32 bit real values

//moves each PIO to a pointer
volatile uint32* PushbuttonPTR	         = (uint32*) PUSHBUTTONS_BASE;
volatile uint32* Ram32bitPTR             = (uint32*) INFERRED_RAM_BASE;
volatile uint16* Ram16bitPTR             = (uint16*) INFERRED_RAM_BASE;
volatile uint8*  Ram8bitPTR              = (uint8*)  INFERRED_RAM_BASE;
uint8* LedPtr     			             = (uint8*)  LEDS_BASE;


//Variables to pass into memory access function
volatile uint32 sAddress;
volatile uint32 Data;
volatile uint32 Num_bytes = 16384; //bytes come from raminfr component

//Variables for Ramp Test
uint32  Ramp32;  
uint16  Ramp16;
uint8   Ramp8; 

//Variables to check the data
volatile uint32 Check32bit;
volatile uint32 Check16bit;
volatile uint32 Check8bit;

//Memory access Function for 8 bits
void Memory_Access_8(uint8 sAddress, uint32 Num_bytes, uint8 Data)
{
//since the Number of btyes is 16384, with 8bit function we can use it without needing to divide it 
    
    for(int i = 0; i<Num_bytes;i++){ //writes the data in each location request
        *(Ram8bitPTR + i) = Data;
    }
    for(int i= 0; i<Num_bytes;i++) //reads the Data in each location to see if it wrote incorrectly
    {
      Check8bit = *(Ram8bitPTR + i);//if data incorrect LEDs turn on
      if(Check8bit != Data){
          *LedPtr |= 0xFF;
      }
    }
}
//Memory Access Function for 16bits
void Memory_Access_16(uint16 sAddress, uint32 Num_bytes, uint16 Data)
{
uint16  Num_bytes_16 = Num_bytes/2;//changes the btyes to accomadate to the 16bits

    for(int i = 0; i<Num_bytes_16;i++){ //writes the data in each location request
        *(Ram16bitPTR + i) = Data;
    }
    for(int i= 0; i<Num_bytes_16;i++)//reads the Data in each location to see if it wrote incorrectly
    {
      Check16bit = *(Ram16bitPTR + i);
      if(Check16bit != Data){//if data incorrect LEDs turn on
          *LedPtr |= 0xFF;
      }

    }
}

//Memory Access Function for 32bits
void Memory_Access_32(uint32 sAddress, uint32 Num_bytes, uint32 Data)
{
uint32  Num_bytes_32 = Num_bytes/4; //changes the btyes to accomadate to the 32bits

    for(int i = 0; i<Num_bytes_32;i++){ //writes the data in each location request
        *(Ram32bitPTR + i) = Data;
    }

    for(int i= 0; i<Num_bytes_32;i++)//reads the Data in each location to see if it wrote incorrectly
    {
      Check32bit = *(Ram32bitPTR + i);
      if(Check32bit != Data){ //if data incorrect LEDs turn on
          *LedPtr |= 0xFF;
      }
    }
}
int main(void){
//Data test Code, and LED start off
*LedPtr = 0x00; 
Ramp32 = 0x12345678;
Ramp16 = 0x8765;
Ramp8  = 0xC;
while(1){//test Ramp pattern for Memory_Access for bits 8,16 and 32bits
	Memory_Access_8(0, Num_bytes , Ramp8);
	*LedPtr = 0x00; //reset the LED after  function
	Memory_Access_16(0,Num_bytes ,Ramp16);
	*LedPtr = 0x00;//reset the LED after  function
	Memory_Access_32(0, Num_bytes,Ramp32);
}

return 0;
}
