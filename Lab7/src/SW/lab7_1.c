#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"

typedef         signed char         sint8;              // signed 8 bit values
typedef         unsigned char       uint8;              // unsigned 8 bit values
typedef         signed short        sint16;             // signed 16 bit values
typedef         unsigned short      uint16;             // unsigned 16 bit values
typedef         signed long         sint32;             // signed 32 bit values
typedef         unsigned long       uint32;             // unsigned 32 bit values
typedef         float               real32;             // 32 bit real values

#define     ram_size    0x4000
#define     data_32     0xABCDEF09
#define     data_16     0xDCBA
#define     data_8      0xFE
#define     KEY_0_1     0x02

uint32 * Key_0_ptr             = (uint32*) KEY_0_BASE; //retrieved from system.h
uint32 * Key_0_Mask_Ptr        = (uint32*) IOADDR_ALTERA_AVALON_PIO_IRQ_MASK(KEY_0_BASE); //retrieved from system.h
uint32 * Key_0_Egde_Ptr        = (uint32*) IOADDR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_0_BASE); //retrieved from system.h
uint32 * Led_0_ptr             = (uint32*) LED_0_BASE; //retrieved from system.h
uint32 * Inferred_ram_be_ptr   = (uint32*) INFERRED_RAM_BE_0_BASE; //retrieved from system.h

void key_0_isr(void *context);
void uint32_ram_test(uint32 * start ,uint32 size, uint32 data);
void uint16_ram_test(uint16 * start ,uint32 size, uint16 data);
void uint8_ram_test (uint8 *  start ,uint32 size, uint8 data);
void jtag_display   (uint8* prompt, uint32 count);

int main(void)
{
    *Led_0_ptr = 0x00; //leds off
    uint32  key_0_isr_flag  = 0; //flag off

    alt_ic_isr_register(KEY_0_IRQ_INTERRUPT_CONTROLLER_ID,
                        KEY_0_IRQ,
                        key_0_isr,
                        (void*)&key_0_isr_flag,
                        0);
    *Key_0_Mask_Ptr |= KEY_0_1;

    while(KEY_0_1 != (KEY_0_1 & key_0_isr_flag)) //while the interrupt is inactive, execute each ram size test
    {
        uint32_ram_test((uint32*)Inferred_ram_be_ptr,(uint32)ram_size,(uint32)data_32);
        uint16_ram_test((uint16*)Inferred_ram_be_ptr,(uint32)ram_size,(uint16)data_16);
        uint8_ram_test ((uint8 *)Inferred_ram_be_ptr,(uint32)ram_size,(uint8 )data_8);
    }

    *Led_0_ptr = 0xAA;

    while(1);

    return 0;
}

void uint32_ram_test(uint32 * start_ptr ,uint32 size, uint32 data)
{

     size = size/4; //size is a quarter of ram size
     *Led_0_ptr = 0x00; //reset led lights
     
     for(int i = 0; i< size ;i++)
     {
        start_ptr[i] = data; //give the memory the data we want in it
     }
     
    for(int i = 0; i< size ;i++)
    {
        if (start_ptr[i] != data)
        {
            printf("ERROR : Address : %08lx : Read : %08lx : Expected : %08lx \n",(void*)&start_ptr[i], start_ptr[i],data);
            *Led_0_ptr |= 0xFF; //leds are all lit to show error
        };
    }
}

void uint16_ram_test(uint16 * start_ptr ,uint32 size, uint16 data)
{

    size = size/2; //size is half of ram size
    *Led_0_ptr = 0x00; //reset led lights
    
    for(int i = 0; i< size ;i++)
    {
        start_ptr[i] = data; //give the memory the data we want in it
    }
    
    for(int i = 0; i< size ;i++)
    {
        if (start_ptr[i] != data)
        {
            printf("ERROR : Address : %08lx : Read : %04x : Expected : %04x \n",(void*)&start_ptr[i], start_ptr[i],data);
            *Led_0_ptr |= 0xFF; //leds are all lit to show error
        };
    }
}

void uint8_ram_test(uint8 * start_ptr ,uint32 size, uint8 data)
{
    *Led_0_ptr = 0x00; //reset led lights

    for(int i = 0; i< size ;i++)
    {
        start_ptr[i] = data; //give the memory the data we want in it
    }
  
    for(int i = 0; i< size ;i++)
    {
        if (start_ptr[i] != data)
        {
            printf("ERROR : Address : %08lx : Read : %02x : Expected : %02x \n",(void*)&start_ptr[i], start_ptr[i],data);
            *Led_0_ptr = 0xFF; //leds are all lit to show error
        };
    }
}

void key_0_isr(void *context) //interrupt for key0 
{
    uint32 *key_0_isr_flag = (uint32*)context;
    uint32  current_value = *Key_0_Egde_Ptr;
    
    if(KEY_0_1 == (KEY_0_1 & current_value))
    {
        *key_0_isr_flag |= KEY_0_1; //put flag up!
    }
    
    *Key_0_Egde_Ptr = 0;
};
