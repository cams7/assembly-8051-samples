;
;  Curso de Assembly para 8051 WR Kits
;
;  Aula 31 - Habilitando a Interrup��o de um Timer atrav�s de bot�es
;
; Microcontrolador AT89S51:
;
; - Timer no modo 2 (contador de 8 bits com auto-reload);
; - Timer0 com baixa prioridade de interrup��o;
; - Configurar o estouro de T0 para ocorrer a cada 2,4 segundos
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
; Autor: Eng. Wagner Rambo   |   Data: Janeiro de 2016
;

; --- Constantes ---
        bt1             equ     P3.2            ;Bot�o 1 ligado em P3.2
        bt2             equ     P3.3            ;Bot�o 2 ligado em P3.3
 

; --- Vetor de RESET (Externa - RST) ---
        org             0000h                   ;Origem no endere�o 00h de mem�ria
        ajmp            principal               ;Desvia das rotinas de interrup��o


; --- Rotinas de Interrup��o ---

; -- Vetor de Interrup��o Timer0 (Interna - Perif�rico) --

        org             000Bh                   ;A interrup��o do Timer0 aponta para este endere�o
        djnz            R7,exit_int             ;Decrementa R7. R7 igual a zero? N�o, desvia para sair da interrup��o
        mov             R7,#250d                ;Sim, recarrega R7 com 250d
        djnz            R6,exit_int             ;Decrementa R6. R6 igual a zero? N�o, desvia para sair da interrup��o
        mov             R6,#80d                 ;Sim, recarrega R6 com 2d

        cpl             P0.6                    ;Inverte o estado de P0.6


exit_int:
        reti                                    ;Retorna da interrup��o

; --- Programa Principal ---
principal:
        mov             R7,#250d                ;Carrega o valor 250d para R7
        mov             R6,#80d                 ;Carrega o valor 2d para R6

        mov             a,#00h                  ;Move constante 00h para acc
        mov             P0,a                    ;PORT P0 configurado como sa�da

        mov             IE,#82h                 ;Habilita a interrup��o do Timer0 e a global
                                                ;IE - Interrupt Enable
                                                ;EA .. ES ET1 EX1 ET0 EX0
                                                ;1  00 0  0   0   1   0

        mov             IP,#00h                 ;Segue a prioridade relativa de interrup��o
                                                ;IP - Interrupt Priority
                                                ;... PS PT1 PX1 PT0 PX0
                                                ;000 0  0   0   0   0

        mov             TCON,#00h               ;Timer0 inicia desligado
                                                ;TCON - Timer Control
                                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                                ;0   0   0   0   0   0   0   0
                                                 
                                                ;TRx = 1 -> Liga a contagem
                                                ;TRx = 0 -> Desliga a contagem          (x) 
                                                ;TFx = 1 -> Ocorreu overflow
                                                ;TFx = 0 -> N�o ocorreu overflow        (x)
												;IEx = 0 -> Flag de indica��o: n�o houve interrup��o externa 
												;IEx = 1 �> Flag de indica��o: houve interrup��o externa
												;ITx = 0 �> Interrup��o externa sens�vel a n�vel
												;ITx = 1 �> Interrup��o externa sens�vel � borda 

        mov             TMOD,#02h               ;Configura o Timer0 para incrementar com ciclo de m�quina
                                                ;Configura o Timer0 no modo 2 (8 bits com auto-reload)
                                                ;TMOD � Timer Mode
                                                ;Timer 1        Timer 0
                                                ;Gate C/T M1 M0 Gate C/T M1 M0
                                                ;0    0   0  0  0    0   1  0
 
                                                ;Modo M1 M0 Defini��o
                                                ;0 -  0  0  Contador de 32 bits
                                                ;1 -  0  1  Contador de 16 bits
                                                ;2 -  1  0  Contador de 8 bits com auto-reload  (x)
                                                ;3 -  1  1  Time misto

        mov             TH0,#136d               ;Inicializa TH0 em 136d (256 - 136 = 120)
        mov             TL0,#136d               ;Inicializa TL0 em 136d (256 - 136 = 120)
                                                ;2^8(256) - 136 = 120
                                                ;120 * 1e-6 = 0,00012s = 120us
                                                ;2,4/0,00012 = 20000
                                                ;20000/250(R7) = 80(R6)

        mov             a,#0FFh                 ;Move constante FFh para acc
        mov             P0,a                    ;Apaga todos LEDs onboard (PARADOXUS 8051)
 
 
teste_bt1:        
        jb              bt1,teste_bt2           ;Bot�o 1 pressionado? N�o, desvia para teste_bt2
        setb            B.0                     ;Sim, seta flag0 do registrador B
        sjmp            trata_bt1               ;Desvia para trata_bt1

teste_bt2:
        jb              bt2,teste_bt1           ;Bot�o 2 pressionado? N�o, desvia para teste_bt1
        setb            B.1                     ;Sim, seta flag1 do registrador B
        sjmp            trata_bt2               ;desvia para trata_bt2

trata_bt1:
        jnb             bt1,$                   ;Bot�o 1 solto? N�o, aguarda soltar...
        clr             B.0                     ;Sim, limpa flag0 do registrador B

        mov             TCON,#10h               ;Ativa Timer0
                                                ;TCON - Timer Control
                                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                                ;0   0   0   1   0   0   0   0

        ajmp            teste_bt1               ;Desvia para label teste_bt1

trata_bt2:
        jnb             bt2,$                   ;Bot�o 2 solto? N�o, aguarda soltar...
        clr             B.1                     ;Sim, limpa flag1 do registrador B

        mov             TCON,#00h               ;Desativa Timer0
                                                ;TCON - Timer Control
                                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                                ;0   0   0   0   0   0   0   0

        ajmp            teste_bt1               ;Desvia para label teste_bt1
 
 
        end                                     ;Final do programa