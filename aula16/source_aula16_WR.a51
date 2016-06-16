;
; Curso de Assembly para 8051 WR Kits Channel
;
; Utilizando bot�es para acionar sa�das
;
; MCU: AT89S51   Clock: 12MHz   Ciclo de M�quina: 1us
;
; Autor: Eng. Wagner Rambo    Data: Setembro de 2015
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits


        org     0000h                   ;Origem no endere�o 0000h de mem�ria

init:
        mov     A,#0Fh                  ;Move a constante 0Fh para acc  0000 1111b
        mov     P2,a                    ;Configura P2<0..3> como entrada
        ajmp    main                    ;Desvia para inicio

main:
        mov     a,#0FFh                 ;Move a constante FFh para acc
        mov     P2,a                    ;Inicializa PORTA P2 (LEDs desligados)

verifica_botao1:
        jb      P2.0,verifica_botao2    ;Bot�o 1 pressionado? N�o, pula para "verifica_botao2"
        setb    B.0                     ;Sim, seta flag0
        sjmp    acende_led1             ;Desvia para "acende_led1"

verifica_botao2:
        jb      P2.1,verifica_botao3    ;Bot�o 2 pressionado? N�o, pula para "verifica_botao3"
        setb    B.1                     ;Sim, seta flag1
        sjmp    acende_led2             ;Desvia para "acende_led2"

verifica_botao3:
        jb      P2.2,verifica_botao4    ;Bot�o 3 pressionado? N�o, pula para "verifica_botao4"
        setb    B.2                     ;Sim, seta flag2
        sjmp    acende_led3             ;Desvia para "acende_led3"

verifica_botao4:
        jb      P2.3,verifica_botao1    ;Bot�o 4 pressionado? N�o, pula para "verifica_botao1"
        setb    B.3                     ;Sim, seta flag3
        sjmp    acende_led4             ;Desvia para "acende_led4"

acende_led1:
        jnb     P2.0,$                  ;Bot�o 1 solto? N�o, aguarda soltar... 
        clr     B.0                     ;Sim, limpa flag0
        mov     a,#0EFh                 ;Move constante EFh para acc  1110 1111b
        mov     P2,a                    ;Liga LED1
        sjmp    verifica_botao1         ;Volta para "verifica_botao1"

acende_led2:
        jnb     P2.1,$                  ;Bot�o 2 solto? N�o, aguarda soltar...
        clr     B.1                     ;Sim, limpa flag1
        mov     a,#0DFh                 ;Move constante DFh para acc
        mov     P2,a                    ;Liga LED2
        sjmp    verifica_botao1         ;Volta para "verifica_botao1"

acende_led3:
        jnb     P2.2,$                  ;Bot�o 3 solto? N�o, aguarda soltar...
        clr     B.2                     ;Sim, limpa flag2
        mov     a,#0BFh                 ;Move constante BFh para acc
        mov     P2,a                    ;Liga LED3
        sjmp    verifica_botao1         ;Volta para "verifica_botao1"

acende_led4:
        jnb     P2.3,$                  ;Bot�o 4 solto? N�o, aguarda soltar...
        clr     B.3                     ;Sim, limpa flag3
        mov     a,#7Fh                  ;Move constante 7Fh para acc
        mov     P2,a                    ;Liga LED4
        sjmp    verifica_botao1         ;Volta para "verifica_botao1"
       

        end                             ;Final do programa

















