; 
;  Aula 006
;
; Registradores de Uso Geral
;
; Eng. Wagner Rambo
;
;

                org             0000h                   ;Origem no endere�o 0h

inicio:

                mov             r1,#0fh                 ;Move a constante 0fh para R1
                mov             a,r1                    ;Move o conte�do de r1 para o acc
                mov             r5,a                    ;Move o conte�do do acumulador para r5
                inc             r5                      ;Incrementa r5 em 1. r5 = r5 + 1, r5++
                inc             r5
                inc             r5

                ajmp            $                       ;Segura o c�digo nesta linha

                end                                     ;Final do programa