;
;  Curso de Assembly para 8051 WR Kits
;
;  Aula 21 - Programando Interrup��es 
;
; Deseja-se programar as interrup��es para o microcontrolador AT89S51 da seguinte forma:
;
; - INT1 seja em m�xima prioridade, sens�vel a n�vel
; - TIMER1 seja em segunda prioridade
; - INT0 seja em terceira prioridade, sens�vel � borda
; - Serial e TIMER0 desabilitados         
;
;
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
; Autor: Eng. Wagner Rambo   |   Data: Outubro de 2015
;

; --- Vetor da RESET (Externa - RST) ---
        org     0000h           ;origem no endere�o 0000h de mem�ria
        ajmp    inicio          ;desvia das interrup��es

; --- Rotina de Interrup��o INT0 (Externa - P3.2) ---
        org     0003h           ;endere�o da interrup��o do INT0
        reti                    ;retorna da interrup��o

; --- Rotina de Interrup��o INT1 (Externa - P3.3) ---
        org     0013h           ;endere�o da interrup��o do INT1
        reti                    ;retorna da interrup��o

; --- Rotina de Interrup��o do TIMER0 (Interna - Perif�rico) ---
;       org     000Bh           ;endere�o da interrup��o do TIMER0
;       reti                    ;retorna da interrup��o

; --- Rotina de Interrup��o do TIMER1 (Interna - Perif�rico) ---
        org     001Bh           ;endere�o da interrup��o do TIMER1
        reti                    ;retorna da interrup��o

; --- Rotina de Interrup��o do SERIAL (Interna - Perif�rico) ---
;       org     0023h           ;endere�o da interrup��o da SERIAL
;       reti                    ;retorna da interrup��o

; --- Final das Rotinas de Interrup��o ---


; --- Configura��es Iniciais ---
inicio:

        mov     a,#10001101b    ;move a constante 10001101b para acc
        mov     IE,a            ;Habilita todas as interrup��es, habilita INT0, INT1 e TIMER1
                                ;IE - Interrupt Enable
                                ;EA .. ES ET1 EX1 ET0 EX0
                                ;1  00 0  1   1   0   1
                                
        mov     a,#00001100b    ;move a constante 00001100b para acc
        mov     IP,a            ;TIMER1 e INT1 como alta prioridade, INT0 como baixa prioridade
                                ;IP - Interrupt Priority
                                ;... PS PT1 PX1 PT0 PX0
                                ;000 0  1   1   0   0

        mov     a,#00000001b    ;move a constante 00000001b para acc
        mov     TCON,a          ;Config INT1 como sens�vel a n�vel, INT0 como sens�vel � borda
                                ;TCON - Timer Control
                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                ;0   0   0   0   0   0   0   1 

        end                     ;Final do programa