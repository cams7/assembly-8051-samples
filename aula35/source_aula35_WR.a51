;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 35 - Controle de Servo Motores
;
;   Utilizando as fontes de interrup��o externa INT0 e INT1 para o controle de dire��o de um servo motor
;
;   MCU: AT89S51    Clock: 12MHz    Ciclo de M�quina: 1�s
;
;  
;   Sistema Sugerido: PARADOXUS 8051
;
;   Dispon�vel a venda em https://wrkits.com.br/catalog/show/140
;
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
;   Autor: Eng. Wagner Rambo   |   Data: Janeiro de 2016
;
;
; --- Constantes ---
        P_SERVO equ     P1.0    ;Porta do servo motor

; --- Vetor de RESET ---
        org     0000h           ;origem no endere�o 00h de mem�ria
        ajmp    init            ;desvia das interrup��es

 
; --- Rotina de Interrup��o INT0 ---
                                ;Rotaciona o eixo do servo em 90� no sentido anti-hor�rio   
        org     0003h           ;endere�o da interrup��o do INT0
        setb    P_SERVO         ;seta a "porta do servo"
        acall   delay600us      ;chama subrotina de 0,6ms
        clr     P_SERVO         ;limpa a "porta do servo"
        acall   delay20ms       ;chama subrotina de 20ms
        reti                    ;retorna da interrup��o
  
; --- Rotina de Interrup��o INT1 ---
                                ;Rotaciona o eixo do servo em 90� no sentido hor�rio
        org     0013h           ;endere�o da interrup��o do INT1                                
        setb    P_SERVO         ;seta a "porta do servo"
        acall   delay600us      ;chama subrotina de 0,6ms
        acall   delay600us      ;chama subrotina de 0,6ms
        acall   delay600us      ;chama subrotina de 0,6ms
        acall   delay600us      ;chama subrotina de 0,6ms
        clr     P_SERVO         ;limpa a "porta do servo"
        acall   delay20ms       ;chama subrotina de 20ms
        reti                    ;retorna da interrup��o
   
    
; --- Final das Rotinas de Interrup��o ---

 
; --- Rotina Principal ---
init:
        mov     IE,#85h         ;habilita interrup��es INT0 e INT1
                                ;Registrador IE (Interrupt Enable) - Habilita Interrup��o
                                ;EA .. ES ET1 EX1 ET0 EX0
                                ;1  00 0  0   1   0   1
                                                  
                                ;EA (Enable All) � habilita todas interrup��es
                                ;ES (Enable Serial) � habilita interrup��o serial
                                ;ET1 (Enable Timer1) � habilita interrup��o do Timer1
                                ;EX1 (Enable external1) � habilita interrup��o externa INT1
                                ;ET0 (Enable Timer0) � habilita interrup��o do Timer0
                                ;EX0 (Enable external0) � habilita interrup��o externa INT0

        mov     IP,#04h         ;INT0 e INT1 em baixa prioridade
                                ;Registrador IP (Interrupt Priority) - Seleciona prioridade de interrup��o
                                ;... PS PT1 PX1 PT0 PX0
                                ;000 0  0   1   0   0
          
                                ;PS (Priority Serial) � prioridade da serial
                                ;PT1 (Priority Timer1) � prioridade do Timer1
                                ;PX1 (Priority External1) � prioridade INT1
                                ;PT0 (Priority Timer0) � prioridade Timer0
                                ;PX0 (Priority External0) � prioridade INT0

        mov     TCON,#00h       ;INT0 e INT1 sens�veis a n�vel
                                ;Registrador TCON (Timer Control) - Configura os tipos de interrup��o e cont�m as flags de indica��o
                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                ;0   0   0   0   0   0   0   0
            
                                ;TRx = 1 -> Liga a contagem
                                ;TRx = 0 -> Desliga a contagem
                                ;TFx = 1 -> Flag de indica��o: ocorreu overflow
                                ;TFx = 0 -> Flag de indica��o: n�o ocorreu overflow
                                ;IEx = 0 -> Flag de indica��o: n�o houve interrup��o externa
                                ;IEx = 1 �> Flag de indica��o: houve interrup��o externa
                                ;ITx = 0 �> Interrup��o externa sens�vel a n�vel
                                ;ITx = 1 �> Interrup��o externa sens�vel � borda 
 
main:                           ;loop infinito
        setb    P_SERVO         ;seta a "porta do servo"
        acall   delay1500us     ;chama subrotina de 1,5ms
        clr     P_SERVO         ;limpa a "porta do servo"
        acall   delay20ms       ;chama subrotina de 20ms
        ajmp    main            ;desvia para "main"
 
 
; --- Sub Rotinas ---
delay20ms:                      ;sub rotina para o tempo de 20ms

                                ; 2 ciclos da instru��o acall
        mov     R1,#32h         ; 1 ciclo | move 50d para R1

aux1:
        mov     R0,#32h         ; 1 x 50 | move 50d para R0

aux2:
        nop                     ; 1 x 50 x 50 | no operation
        nop                     ; 1 x 50 x 50 | no operation
        nop                     ; 1 x 50 x 50 | no operation
        nop                     ; 1 x 50 x 50 | no operation
        nop                     ; 1 x 50 x 50 | no operation
        nop                     ; 1 x 50 x 50 | no operation
        
        djnz    R0,aux2         ; 2 x 50 x 50 | decrementa R0
                                ;R0 igual a zero?
                                ;n�o, desvia para aux2       

        djnz    R1,aux1         ; 2 x 50 | decrementa R0
                                ;R1 igual a zero?
                                ;n�o, desvia para aux1

        ret                     ; 2 ciclos | sim, retorna


delay600us:                     ;sub rotina para o tempo de 600�s

                                ; 2 ciclos da instru��o acall
        mov     R2,#200d        ; 1 ciclo | move 200 para R2

aux3:
        nop                     ; 1 x 200 | no operation
        
        djnz    R2,aux3         ; 2 x 200 | decrementa R2
                                ; R2 igual a zero?
                                ;n�o, desvia para aux3

        ret                     ; 2 ciclos | sim, retorna


delay1500us:                    ;sub rotina para o tempo de 1500�s

                                ; 2 ciclos da instru��o acall
        mov     R3,#250d        ; 1 ciclo | move 250 para R3

aux4:
        nop                     ; 1 x 250 | no operation
        nop                     ; 1 x 250 | no operation
        nop                     ; 1 x 250 | no operation
        nop                     ; 1 x 250 | no operation

        djnz    R3,aux4         ; 2 x 250 | decrementa R3
                                ; R3 igual a zero?
                                ;n�o, desvia para aux4

        ret                     ; 2 ciclos | sim, retorna


        end                     ;Final do programa
         
 