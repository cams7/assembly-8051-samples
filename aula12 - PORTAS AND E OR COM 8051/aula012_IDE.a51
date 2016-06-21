;
;  Curso de Assembly para 8051 WR Kits
;
;  Aula 12 - Portas L�gicas com 8051
;
;
  

        org     0000h           ;origem no endere�o 00h de mem�ria
        sjmp    loop            ;desvia para a label loop

loop:

        mov     c,P2.0          ;L� a entrada P2.0 e carrega em carry
        orl     c,P2.1          ;c = c OR P2.1
        orl     c,P2.2          ;c = c OR P2.2
        orl     c,P2.3          ;c = c OR P2.3
        mov     P2.4,c          ;P2.4 = c
        sjmp    loop            ;loop infinito                                 | short jump

        end                     ;Final do programa

















