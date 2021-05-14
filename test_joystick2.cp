#line 1 "C:/Users/deepr/OneDrive/Documents/MicroC/test_joystick2/test_joystick2.c"
#line 34 "C:/Users/deepr/OneDrive/Documents/MicroC/test_joystick2/test_joystick2.c"
unsigned char readbuff[64] absolute 0x500;
unsigned char writebuff[64] absolute 0x540;
unsigned short STEER_value = 0;
unsigned short THROTTLE_value = 0;
unsigned short BRAKE_value = 0;
volatile char precision =10;

void interrupt()
{
 USB_Interrupt_Proc();
}

void led2()
{
  PORTD.B7 = 1;
 delay_ms(15);
}

char map(short x, short in_min, short in_max, char out_min, char out_max) {
 char a= ((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min)& 0xfe;


 return a;
}

void main() {

 ADCON1 = 0x0C;

 TRISA = 0X3F;

 TRISB = 0x00;
 TRISC = 0X07;
 TRISD = 0X7F;
 TRISE = 0X07;

 PORTA = 0;
 PORTB = 0;
 PORTC = 0;
 PORTD = 0;
 PORTE = 0;


 HID_Enable(readbuff,writebuff);
 led2();

 ADC_Init_Advanced(_ADC_INTERNAL_REF);

 while(1)
 {
 writebuff[0]=127;
 writebuff[1]=0;
 writebuff[2]=127;
 writebuff[3]=0;
 writebuff[4]=127;
 writebuff[5]=0;

 writebuff[6]=15;
 writebuff[7]=0;
 writebuff[8]=0;


 STEER_value = ADC_Read( 0 );

 Delay_ms(2);
 THROTTLE_value = ADC_Read( 1 );
 Delay_ms(2);
 BRAKE_value = ADC_Read( 2 );
 Delay_ms(2);
 writebuff[0] = map(STEER_value,0,1023,0,255) ;
 PORTB= writebuff[0];
 writebuff[2] = map(THROTTLE_value,0,1023,0,255) ;
 writebuff[4] = map(BRAKE_value,0,1023,0,255) ;



 if( PORTA.B3 ==1)
 writebuff[6] =0;

 if( PORTA.B4 ==1)
 writebuff[6] =4;

 if( PORTA.B5 ==1)
 writebuff[6] =8;
 if( PORTE.B0 ==1)
 writebuff[6] =12;

 if( PORTA.B4 ==1 &&  PORTA.B3 ==1)
 writebuff[6] =2;
 if( PORTA.B4 ==1 &&  PORTA.B5 ==1)
 writebuff[6] =6;
 if( PORTA.B5 ==1 &&  PORTE.B0 ==1)
 writebuff[6] =10;

 if( PORTE.B0 ==1 &&  PORTA.B3 ==1)
 writebuff[6] =14;


 if( PORTB.B0 ==1)
 writebuff[6].B4=1;
 if( PORTB.B1 ==1)
 writebuff[6].B5=1;
 if( PORTB.B2 ==1)
 writebuff[6].B6=1;
 if( PORTB.B3 ==1)
 writebuff[6].B7=1;

 if( PORTB.B4 ==1)
 writebuff[7].B0=1;
 if( PORTB.B5 ==1)
 writebuff[7].B1=1;
 if( PORTB.B6 ==1)
 writebuff[7].B2=1;
 if( PORTB.B7 ==1)
 writebuff[7].B3=1;
 if( PORTC.B0 ==1)
 writebuff[7].B4=1;
 if( PORTC.B1 ==1)
 writebuff[7].B5=1;
 if( PORTC.B2 ==1)
 writebuff[7].B6=1;
 if( PORTD.B0 ==1)
 writebuff[7].B7=1;

 if( PORTD.B1 ==1)
 writebuff[8].B0=1;
 if( PORTD.B2 ==1)
 writebuff[8].B1=1;
 if( PORTD.B3 ==1)
 writebuff[8].B2=1;
 if( PORTD.B4 ==1)
 writebuff[8].B3=1;
 if( PORTD.B5 ==1)
 writebuff[8].B4=1;
 if( PORTD.B6 ==1)
 writebuff[8].B5=1;
 if( PORTE.B1 ==1)
 writebuff[8].B6=1;
 if( PORTE.B2 ==1)
 writebuff[8].B7=1;

 while(!HID_Write(writebuff,9));
 Delay_ms(10);

 }
}
