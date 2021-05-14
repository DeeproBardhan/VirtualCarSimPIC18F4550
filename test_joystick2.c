                //MAPPING DIGITAL PORTS
#define A_button PORTB.B0
#define B_button PORTB.B1
#define X_button PORTB.B2
#define Y_button PORTB.B3
#define RB_button PORTB.B4
#define LB_button PORTB.B5
#define RTB_button PORTB.B6
#define LTB_button PORTB.B7
#define PAUSE_button PORTC.B0
#define START_button PORTC.B1
#define EXTRA_button PORTC.B2
#define REV_button PORTD.B0
#define G1_button PORTD.B1
#define G2_button PORTD.B2
#define G3_button PORTD.B3
#define G4_button PORTD.B4
#define G5_button PORTD.B5
#define G6_button PORTD.B6
#define LED PORTD.B7
#define HAT_UP PORTA.B3
#define HAT_RIGHT PORTA.B4
#define HAT_DOWN PORTA.B5
#define HAT_LEFT PORTE.B0
#define CLUTCH PORTE.B1
#define FBRAKE PORTE.B2
                       //MAPPING ANALOG CHANNELS
#define STEER_CH 0
#define THROTTLE_CH 1
#define BRAKE_CH 2



unsigned char readbuff[64] absolute 0x500;      //readbuffer should be in RAM  (MCU specific)
unsigned char writebuff[64] absolute 0x540;     //writebuffer should be in RAM (MCU specific)
unsigned short STEER_value = 0;
unsigned short THROTTLE_value = 0;
unsigned short BRAKE_value = 0;
volatile char precision =10;

void interrupt()
{
     USB_Interrupt_Proc();        // USB servicing inside the interrupt
}

void led2()
{
      LED= 1;
      delay_ms(15);
}

char map(short x, short in_min, short in_max, char out_min, char out_max) {
  char a= ((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min)& 0xfe;

  //a=precision*floor(a/precision);
  return a;
}

void main() {
            //Initialize ports
        ADCON1 = 0x0C;  // Configure all PORT pins as digital  except AN0 ,AN1,AN2

        TRISA = 0X3F;   //input at AN0,AN1,AN2,RA3,RA4,RA5
        //TRISB = 0xFF;   // all portB pins input
        TRISB = 0x00;   // all portB pins output
        TRISC = 0X07;          //INPUT IN RC0,RC1,RC2
        TRISD = 0X7F; //INPUT ALL PORTD PINS   EXCEPT RD7 OUTPUT
        TRISE = 0X07;        // INPUT IN RE0,RE1,RE2
        
        PORTA = 0;
        PORTB = 0;
        PORTC = 0;
        PORTD = 0;
        PORTE = 0;


        HID_Enable(readbuff,writebuff);    //HID Init
        led2();
        //ADC_Init();  // Initialize ADC module with default settings
        ADC_Init_Advanced(_ADC_INTERNAL_REF);

           while(1)
           {
                   writebuff[0]=127;            //STEERING LOWERBYTE
                   writebuff[1]=0;            //STEERING HIGHERBYTE
                   writebuff[2]=127;            //THROTTLE LOWERBYTE
                   writebuff[3]=0;            //THROTTLE HIGHERBYTE
                   writebuff[4]=127;            //BRAKE LOWERBYTE
                   writebuff[5]=0;            //BRAKE HIGHERBYTE

                   writebuff[6]=15;            //BUTTON AND HAT
                   writebuff[7]=0;            //BUTTON
                   writebuff[8]=0;            //CLUTCH,FBRAKE,BUTTONS
                   
                   
                   STEER_value = ADC_Read(STEER_CH);          //get analog value at channel 0  AN0

                   Delay_ms(2);
                   THROTTLE_value = ADC_Read(THROTTLE_CH);          //get analog value at channel 0  AN0
                   Delay_ms(2);
                   BRAKE_value = ADC_Read(BRAKE_CH);          //get analog value at channel 0  AN0
                   Delay_ms(2);
                   writebuff[0] = map(STEER_value,0,1023,0,255)   ;          // convert 10bit to 8bit value
                   PORTB= writebuff[0];
                   writebuff[2] = map(THROTTLE_value,0,1023,0,255)   ;          // convert 10bit to 8bit value
                   writebuff[4] = map(BRAKE_value,0,1023,0,255)   ;          // convert 10bit to 8bit value
                  
                   

                   if(HAT_UP==1)
                      writebuff[6] =0;            //up

                   if(HAT_RIGHT==1)
                      writebuff[6]  =4;            //right

                   if(HAT_DOWN==1)
                      writebuff[6] =8;            // down
                   if(HAT_LEFT==1)
                      writebuff[6] =12;            //left
                   
                   if(HAT_RIGHT==1 && HAT_UP==1)
                      writebuff[6]  =2;            //right up
                   if(HAT_RIGHT==1 && HAT_DOWN==1)
                      writebuff[6]  =6;             //RIGHT DOWN
                   if(HAT_DOWN==1 && HAT_LEFT==1)
                      writebuff[6]  =10;            //LEFT DOWN

                   if(HAT_LEFT==1 && HAT_UP==1)
                      writebuff[6]  =14;                //LEFT UP

                   // writebuff[4] =16;
                   if(A_button==1)
                      writebuff[6].B4=1;
                    if(B_button==1)
                      writebuff[6].B5=1;
                    if(X_button==1)
                      writebuff[6].B6=1;
                    if(Y_button==1)
                      writebuff[6].B7=1;

                    if(RB_button==1)
                      writebuff[7].B0=1;
                    if(LB_button==1)
                      writebuff[7].B1=1;
                    if(RTB_button==1)
                      writebuff[7].B2=1;
                    if(LTB_button==1)
                      writebuff[7].B3=1;
                    if(PAUSE_button==1)
                      writebuff[7].B4=1;
                    if(START_button==1)
                      writebuff[7].B5=1;
                    if(EXTRA_button==1)
                      writebuff[7].B6=1;
                    if(REV_button==1)
                      writebuff[7].B7=1;

                    if(G1_button==1)
                      writebuff[8].B0=1;
                    if(G2_button==1)
                      writebuff[8].B1=1;
                    if(G3_button==1)
                      writebuff[8].B2=1;
                    if(G4_button==1)
                      writebuff[8].B3=1;
                    if(G5_button==1)
                      writebuff[8].B4=1;
                    if(G6_button==1)
                      writebuff[8].B5=1;
                    if(CLUTCH==1)
                      writebuff[8].B6=1;
                    if(FBRAKE==1)
                      writebuff[8].B7=1;

                   while(!HID_Write(writebuff,9));
                   Delay_ms(10);

            }
}




/*
struct
{
       char throttle;
       char x;
       char y;
       struct
       {
             char hat1 : 1;
             char hat2 : 1;
             char hat3 : 1;
             char hat4 : 1;
             char but1 : 1;
             char but2 : 1;
             char but3 : 1;
             char but4 : 1;

       }BUTTON;

}REPORT;
 */