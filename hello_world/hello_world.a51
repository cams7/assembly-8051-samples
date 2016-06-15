; Hello world em 8051 (AT89S8252)
; Clock: 12MHz
; Ciclo de maquina: 1/(12e6/12) = 1e-6 = 1us
; Autor: C�sar Magalh�es
; Data: Junho de 2016

                org             0000h                   ;Origem do endere�o 0000h de mem�ria

main:
                cpl             a                       ;Complementa o acumulador (acc = not acc)
                mov             P2,a                    ;Move o valor de acc para Port 2
                call            delay500ms              ;Chama a rotina de temporazi��o
                ajmp            main                    ;Loop infinito

delay500ms:                                             ;2 | Ciclos de maquina do mnem�nico call
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
                
                end
                