;
; Display de 7 segmentos
;
; C�sar Magalh�es
;
; Junho de 2016

; --- Vetor de RESET ---
        org             0000h                   ;Origem no endere�o 00h de mem�ria       
        mov             DPTR,#display7          ;Move um dos dados do display para DPTR

init:
        mov             R0,#00h                 ;Inicializa o contador (R0)

; --- Rotina Principal ---
main:
        mov             a,R0                    ;Move o conte�do do contador (R0) para o acc
        movc            a,@a+DPTR               ;Move o byte relativo de DPTR somado com o valor de acc para o acc
        mov             P0,a                    ;Move o conte�do de acc para a porta 0
        call            delay1segundo           ;Atraza em um segundo
        inc             R0                      ;Incrementa o contador (R0)
        cjne            R0,#0Ah,main            ;Verifica se o valor do contador(R0) � igual a 10, caso contr�rio, volta para o inicio
        ajmp            init                    ;Loop infinito

; --- Banco ---
display7:
        db              40h                     ;01000000b - N�mero 0 no display
        db              79h                     ;01111001b - N�mero 1 no display
        db              24h                     ;00100100b - N�mero 2 no display
        db              30h                     ;00110000b - N�mero 3 no display
        db              19h                     ;00011001b - N�mero 4 no display
        db              12h                     ;00010010b - N�mero 5 no display
        db              02h                     ;00000010b - N�mero 6 no display
        db              78h                     ;01111000b - N�mero 7 no display
        db              00h                     ;00000000b - N�mero 8 no display
        db              10h                     ;00010000b - N�mero 9 no display

delay1segundo:
        call            delay500ms              ;Chama a rotina de temporiza��o
        call            delay500ms
        ret
               
delay500ms:                                     ;2 | Ciclos de maquina do mnem�nico call
        mov             R1,#0FAh                ;1 | Move o valor FAh (250) para R1

aux1:
        mov             R2,#0F9h                ;1 x 250 | Move o valor F9h (249) para R2
        nop                                     ;1 x 250 | Atraza um ciclo de maquina
        nop                                     ;1 x 250
        nop                                     ;1 x 250
        nop                                     ;1 x 250
        nop                                     ;1 x 250

aux2:
        nop                                     ;1 x 250 x 249
        nop                                     ;1 x 250 x 249
        nop                                     ;1 x 250 x 249
        nop                                     ;1 x 250 x 249
        nop                                     ;1 x 250 x 249
        nop                                     ;1 x 250 x 249
        djnz            R2,aux2                 ;2 x 250 x 249 | Decrementa o R2 at� chegar a 0  
        djnz            R1,aux1                 ;2 x 250       | Decrementa o R1 at� chegar a 0
              
        ret                                     ; 2 | Retorna para fun��o principal

        end                                     ;Final do Programa