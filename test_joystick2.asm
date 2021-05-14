
_interrupt:

;test_joystick2.c,41 :: 		void interrupt()
;test_joystick2.c,43 :: 		USB_Interrupt_Proc();        // USB servicing inside the interrupt
	CALL        _USB_Interrupt_Proc+0, 0
;test_joystick2.c,44 :: 		}
L_end_interrupt:
L__interrupt50:
	RETFIE      1
; end of _interrupt

_led2:

;test_joystick2.c,46 :: 		void led2()
;test_joystick2.c,48 :: 		LED= 1;
	BSF         PORTD+0, 7 
;test_joystick2.c,49 :: 		delay_ms(15);
	MOVLW       156
	MOVWF       R12, 0
	MOVLW       215
	MOVWF       R13, 0
L_led20:
	DECFSZ      R13, 1, 1
	BRA         L_led20
	DECFSZ      R12, 1, 1
	BRA         L_led20
;test_joystick2.c,50 :: 		}
L_end_led2:
	RETURN      0
; end of _led2

_map:

;test_joystick2.c,52 :: 		char map(short x, short in_min, short in_max, char out_min, char out_max) {
;test_joystick2.c,53 :: 		char a= ((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min)& 0xfe;
	MOVF        FARG_map_in_min+0, 0 
	SUBWF       FARG_map_x+0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       FARG_map_x+0, 7 
	MOVLW       255
	MOVWF       R5 
	MOVLW       0
	BTFSC       FARG_map_in_min+0, 7 
	MOVLW       255
	SUBWFB      R5, 1 
	MOVF        FARG_map_out_min+0, 0 
	SUBWF       FARG_map_out_max+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	CALL        _Mul_16X16_U+0, 0
	MOVF        FARG_map_in_min+0, 0 
	SUBWF       FARG_map_in_max+0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       FARG_map_in_max+0, 7 
	MOVLW       255
	MOVWF       R5 
	MOVLW       0
	BTFSC       FARG_map_in_min+0, 7 
	MOVLW       255
	SUBWFB      R5, 1 
	CALL        _Div_16x16_S+0, 0
	MOVF        FARG_map_out_min+0, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       254
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
;test_joystick2.c,56 :: 		return a;
;test_joystick2.c,57 :: 		}
L_end_map:
	RETURN      0
; end of _map

_main:

;test_joystick2.c,59 :: 		void main() {
;test_joystick2.c,61 :: 		ADCON1 = 0x0C;  // Configure all PORT pins as digital  except AN0 ,AN1,AN2
	MOVLW       12
	MOVWF       ADCON1+0 
;test_joystick2.c,63 :: 		TRISA = 0X3F;   //input at AN0,AN1,AN2,RA3,RA4,RA5
	MOVLW       63
	MOVWF       TRISA+0 
;test_joystick2.c,65 :: 		TRISB = 0x00;   // all portB pins output
	CLRF        TRISB+0 
;test_joystick2.c,66 :: 		TRISC = 0X07;          //INPUT IN RC0,RC1,RC2
	MOVLW       7
	MOVWF       TRISC+0 
;test_joystick2.c,67 :: 		TRISD = 0X7F; //INPUT ALL PORTD PINS   EXCEPT RD7 OUTPUT
	MOVLW       127
	MOVWF       TRISD+0 
;test_joystick2.c,68 :: 		TRISE = 0X07;        // INPUT IN RE0,RE1,RE2
	MOVLW       7
	MOVWF       TRISE+0 
;test_joystick2.c,70 :: 		PORTA = 0;
	CLRF        PORTA+0 
;test_joystick2.c,71 :: 		PORTB = 0;
	CLRF        PORTB+0 
;test_joystick2.c,72 :: 		PORTC = 0;
	CLRF        PORTC+0 
;test_joystick2.c,73 :: 		PORTD = 0;
	CLRF        PORTD+0 
;test_joystick2.c,74 :: 		PORTE = 0;
	CLRF        PORTE+0 
;test_joystick2.c,77 :: 		HID_Enable(readbuff,writebuff);    //HID Init
	MOVLW       _readbuff+0
	MOVWF       FARG_HID_Enable_readbuff+0 
	MOVLW       hi_addr(_readbuff+0)
	MOVWF       FARG_HID_Enable_readbuff+1 
	MOVLW       _writebuff+0
	MOVWF       FARG_HID_Enable_writebuff+0 
	MOVLW       hi_addr(_writebuff+0)
	MOVWF       FARG_HID_Enable_writebuff+1 
	CALL        _HID_Enable+0, 0
;test_joystick2.c,78 :: 		led2();
	CALL        _led2+0, 0
;test_joystick2.c,80 :: 		ADC_Init_Advanced(_ADC_INTERNAL_REF);
	CLRF        FARG_ADC_Init_Advanced_reference+0 
	CALL        _ADC_Init_Advanced+0, 0
;test_joystick2.c,82 :: 		while(1)
L_main1:
;test_joystick2.c,84 :: 		writebuff[0]=127;            //STEERING LOWERBYTE
	MOVLW       127
	MOVWF       1344 
;test_joystick2.c,85 :: 		writebuff[1]=0;            //STEERING HIGHERBYTE
	CLRF        1345 
;test_joystick2.c,86 :: 		writebuff[2]=127;            //THROTTLE LOWERBYTE
	MOVLW       127
	MOVWF       1346 
;test_joystick2.c,87 :: 		writebuff[3]=0;            //THROTTLE HIGHERBYTE
	CLRF        1347 
;test_joystick2.c,88 :: 		writebuff[4]=127;            //BRAKE LOWERBYTE
	MOVLW       127
	MOVWF       1348 
;test_joystick2.c,89 :: 		writebuff[5]=0;            //BRAKE HIGHERBYTE
	CLRF        1349 
;test_joystick2.c,91 :: 		writebuff[6]=15;            //BUTTON AND HAT
	MOVLW       15
	MOVWF       1350 
;test_joystick2.c,92 :: 		writebuff[7]=0;            //BUTTON
	CLRF        1351 
;test_joystick2.c,93 :: 		writebuff[8]=0;            //CLUTCH,FBRAKE,BUTTONS
	CLRF        1352 
;test_joystick2.c,96 :: 		STEER_value = ADC_Read(STEER_CH);          //get analog value at channel 0  AN0
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _STEER_value+0 
;test_joystick2.c,98 :: 		Delay_ms(2);
	MOVLW       21
	MOVWF       R12, 0
	MOVLW       198
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	NOP
;test_joystick2.c,99 :: 		THROTTLE_value = ADC_Read(THROTTLE_CH);          //get analog value at channel 0  AN0
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _THROTTLE_value+0 
;test_joystick2.c,100 :: 		Delay_ms(2);
	MOVLW       21
	MOVWF       R12, 0
	MOVLW       198
	MOVWF       R13, 0
L_main4:
	DECFSZ      R13, 1, 1
	BRA         L_main4
	DECFSZ      R12, 1, 1
	BRA         L_main4
	NOP
;test_joystick2.c,101 :: 		BRAKE_value = ADC_Read(BRAKE_CH);          //get analog value at channel 0  AN0
	MOVLW       2
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _BRAKE_value+0 
;test_joystick2.c,102 :: 		Delay_ms(2);
	MOVLW       21
	MOVWF       R12, 0
	MOVLW       198
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	NOP
;test_joystick2.c,103 :: 		writebuff[0] = map(STEER_value,0,1023,0,255)   ;          // convert 10bit to 8bit value
	MOVF        _STEER_value+0, 0 
	MOVWF       FARG_map_x+0 
	CLRF        FARG_map_in_min+0 
	MOVLW       255
	MOVWF       FARG_map_in_max+0 
	CLRF        FARG_map_out_min+0 
	MOVLW       255
	MOVWF       FARG_map_out_max+0 
	CALL        _map+0, 0
	MOVF        R0, 0 
	MOVWF       1344 
;test_joystick2.c,104 :: 		PORTB= writebuff[0];
	MOVF        R0, 0 
	MOVWF       PORTB+0 
;test_joystick2.c,105 :: 		writebuff[2] = map(THROTTLE_value,0,1023,0,255)   ;          // convert 10bit to 8bit value
	MOVF        _THROTTLE_value+0, 0 
	MOVWF       FARG_map_x+0 
	CLRF        FARG_map_in_min+0 
	MOVLW       255
	MOVWF       FARG_map_in_max+0 
	CLRF        FARG_map_out_min+0 
	MOVLW       255
	MOVWF       FARG_map_out_max+0 
	CALL        _map+0, 0
	MOVF        R0, 0 
	MOVWF       1346 
;test_joystick2.c,106 :: 		writebuff[4] = map(BRAKE_value,0,1023,0,255)   ;          // convert 10bit to 8bit value
	MOVF        _BRAKE_value+0, 0 
	MOVWF       FARG_map_x+0 
	CLRF        FARG_map_in_min+0 
	MOVLW       255
	MOVWF       FARG_map_in_max+0 
	CLRF        FARG_map_out_min+0 
	MOVLW       255
	MOVWF       FARG_map_out_max+0 
	CALL        _map+0, 0
	MOVF        R0, 0 
	MOVWF       1348 
;test_joystick2.c,110 :: 		if(HAT_UP==1)
	BTFSS       PORTA+0, 3 
	GOTO        L_main6
;test_joystick2.c,111 :: 		writebuff[6] =0;            //up
	CLRF        1350 
L_main6:
;test_joystick2.c,113 :: 		if(HAT_RIGHT==1)
	BTFSS       PORTA+0, 4 
	GOTO        L_main7
;test_joystick2.c,114 :: 		writebuff[6]  =4;            //right
	MOVLW       4
	MOVWF       1350 
L_main7:
;test_joystick2.c,116 :: 		if(HAT_DOWN==1)
	BTFSS       PORTA+0, 5 
	GOTO        L_main8
;test_joystick2.c,117 :: 		writebuff[6] =8;            // down
	MOVLW       8
	MOVWF       1350 
L_main8:
;test_joystick2.c,118 :: 		if(HAT_LEFT==1)
	BTFSS       PORTE+0, 0 
	GOTO        L_main9
;test_joystick2.c,119 :: 		writebuff[6] =12;            //left
	MOVLW       12
	MOVWF       1350 
L_main9:
;test_joystick2.c,121 :: 		if(HAT_RIGHT==1 && HAT_UP==1)
	BTFSS       PORTA+0, 4 
	GOTO        L_main12
	BTFSS       PORTA+0, 3 
	GOTO        L_main12
L__main48:
;test_joystick2.c,122 :: 		writebuff[6]  =2;            //right up
	MOVLW       2
	MOVWF       1350 
L_main12:
;test_joystick2.c,123 :: 		if(HAT_RIGHT==1 && HAT_DOWN==1)
	BTFSS       PORTA+0, 4 
	GOTO        L_main15
	BTFSS       PORTA+0, 5 
	GOTO        L_main15
L__main47:
;test_joystick2.c,124 :: 		writebuff[6]  =6;             //RIGHT DOWN
	MOVLW       6
	MOVWF       1350 
L_main15:
;test_joystick2.c,125 :: 		if(HAT_DOWN==1 && HAT_LEFT==1)
	BTFSS       PORTA+0, 5 
	GOTO        L_main18
	BTFSS       PORTE+0, 0 
	GOTO        L_main18
L__main46:
;test_joystick2.c,126 :: 		writebuff[6]  =10;            //LEFT DOWN
	MOVLW       10
	MOVWF       1350 
L_main18:
;test_joystick2.c,128 :: 		if(HAT_LEFT==1 && HAT_UP==1)
	BTFSS       PORTE+0, 0 
	GOTO        L_main21
	BTFSS       PORTA+0, 3 
	GOTO        L_main21
L__main45:
;test_joystick2.c,129 :: 		writebuff[6]  =14;                //LEFT UP
	MOVLW       14
	MOVWF       1350 
L_main21:
;test_joystick2.c,132 :: 		if(A_button==1)
	BTFSS       PORTB+0, 0 
	GOTO        L_main22
;test_joystick2.c,133 :: 		writebuff[6].B4=1;
	BSF         1350, 4 
L_main22:
;test_joystick2.c,134 :: 		if(B_button==1)
	BTFSS       PORTB+0, 1 
	GOTO        L_main23
;test_joystick2.c,135 :: 		writebuff[6].B5=1;
	BSF         1350, 5 
L_main23:
;test_joystick2.c,136 :: 		if(X_button==1)
	BTFSS       PORTB+0, 2 
	GOTO        L_main24
;test_joystick2.c,137 :: 		writebuff[6].B6=1;
	BSF         1350, 6 
L_main24:
;test_joystick2.c,138 :: 		if(Y_button==1)
	BTFSS       PORTB+0, 3 
	GOTO        L_main25
;test_joystick2.c,139 :: 		writebuff[6].B7=1;
	BSF         1350, 7 
L_main25:
;test_joystick2.c,141 :: 		if(RB_button==1)
	BTFSS       PORTB+0, 4 
	GOTO        L_main26
;test_joystick2.c,142 :: 		writebuff[7].B0=1;
	BSF         1351, 0 
L_main26:
;test_joystick2.c,143 :: 		if(LB_button==1)
	BTFSS       PORTB+0, 5 
	GOTO        L_main27
;test_joystick2.c,144 :: 		writebuff[7].B1=1;
	BSF         1351, 1 
L_main27:
;test_joystick2.c,145 :: 		if(RTB_button==1)
	BTFSS       PORTB+0, 6 
	GOTO        L_main28
;test_joystick2.c,146 :: 		writebuff[7].B2=1;
	BSF         1351, 2 
L_main28:
;test_joystick2.c,147 :: 		if(LTB_button==1)
	BTFSS       PORTB+0, 7 
	GOTO        L_main29
;test_joystick2.c,148 :: 		writebuff[7].B3=1;
	BSF         1351, 3 
L_main29:
;test_joystick2.c,149 :: 		if(PAUSE_button==1)
	BTFSS       PORTC+0, 0 
	GOTO        L_main30
;test_joystick2.c,150 :: 		writebuff[7].B4=1;
	BSF         1351, 4 
L_main30:
;test_joystick2.c,151 :: 		if(START_button==1)
	BTFSS       PORTC+0, 1 
	GOTO        L_main31
;test_joystick2.c,152 :: 		writebuff[7].B5=1;
	BSF         1351, 5 
L_main31:
;test_joystick2.c,153 :: 		if(EXTRA_button==1)
	BTFSS       PORTC+0, 2 
	GOTO        L_main32
;test_joystick2.c,154 :: 		writebuff[7].B6=1;
	BSF         1351, 6 
L_main32:
;test_joystick2.c,155 :: 		if(REV_button==1)
	BTFSS       PORTD+0, 0 
	GOTO        L_main33
;test_joystick2.c,156 :: 		writebuff[7].B7=1;
	BSF         1351, 7 
L_main33:
;test_joystick2.c,158 :: 		if(G1_button==1)
	BTFSS       PORTD+0, 1 
	GOTO        L_main34
;test_joystick2.c,159 :: 		writebuff[8].B0=1;
	BSF         1352, 0 
L_main34:
;test_joystick2.c,160 :: 		if(G2_button==1)
	BTFSS       PORTD+0, 2 
	GOTO        L_main35
;test_joystick2.c,161 :: 		writebuff[8].B1=1;
	BSF         1352, 1 
L_main35:
;test_joystick2.c,162 :: 		if(G3_button==1)
	BTFSS       PORTD+0, 3 
	GOTO        L_main36
;test_joystick2.c,163 :: 		writebuff[8].B2=1;
	BSF         1352, 2 
L_main36:
;test_joystick2.c,164 :: 		if(G4_button==1)
	BTFSS       PORTD+0, 4 
	GOTO        L_main37
;test_joystick2.c,165 :: 		writebuff[8].B3=1;
	BSF         1352, 3 
L_main37:
;test_joystick2.c,166 :: 		if(G5_button==1)
	BTFSS       PORTD+0, 5 
	GOTO        L_main38
;test_joystick2.c,167 :: 		writebuff[8].B4=1;
	BSF         1352, 4 
L_main38:
;test_joystick2.c,168 :: 		if(G6_button==1)
	BTFSS       PORTD+0, 6 
	GOTO        L_main39
;test_joystick2.c,169 :: 		writebuff[8].B5=1;
	BSF         1352, 5 
L_main39:
;test_joystick2.c,170 :: 		if(CLUTCH==1)
	BTFSS       PORTE+0, 1 
	GOTO        L_main40
;test_joystick2.c,171 :: 		writebuff[8].B6=1;
	BSF         1352, 6 
L_main40:
;test_joystick2.c,172 :: 		if(FBRAKE==1)
	BTFSS       PORTE+0, 2 
	GOTO        L_main41
;test_joystick2.c,173 :: 		writebuff[8].B7=1;
	BSF         1352, 7 
L_main41:
;test_joystick2.c,175 :: 		while(!HID_Write(writebuff,9));
L_main42:
	MOVLW       _writebuff+0
	MOVWF       FARG_HID_Write_writebuff+0 
	MOVLW       hi_addr(_writebuff+0)
	MOVWF       FARG_HID_Write_writebuff+1 
	MOVLW       9
	MOVWF       FARG_HID_Write_len+0 
	CALL        _HID_Write+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main43
	GOTO        L_main42
L_main43:
;test_joystick2.c,176 :: 		Delay_ms(10);
	MOVLW       104
	MOVWF       R12, 0
	MOVLW       228
	MOVWF       R13, 0
L_main44:
	DECFSZ      R13, 1, 1
	BRA         L_main44
	DECFSZ      R12, 1, 1
	BRA         L_main44
	NOP
;test_joystick2.c,178 :: 		}
	GOTO        L_main1
;test_joystick2.c,179 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
