;
; Curso de 8051 em Assembly
;
; Exemplo de direcionamento direto
;
; Wagner Rambo Julho de 2015
;

                org             0000h                   ;Origem no endere�o 00h de mem�ria

ini:
                mov             20h,#0bbh               ;Move o valor constante para o endere�o 20h de mem�ria
                mov             23h,20h                 ;Move o conte�do do endere�o 20h de mem�ria p/ 23h
                mov             a,P2                    ;Move o conte�do do port2 para o acumulador
                add             a,23h                   ; a = a + M23 

                end                                     ;Final do programa