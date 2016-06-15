;
; Curso de Assembly para 8051 WR Kits
;
; Aula 10: Acessando Dados de um Banco
;
; Eng. Wagner Rambo
;
; Agosto de 2015
;

; --- Vetor de RESET ---
        org     0000h           ;Origem no endere�o 00h de mem�ria

init:
        mov     r0,#00h         ;Inicializa o contador (r0)
        mov     dptr,#display7  ;Move um dos dados do display para dptr

; --- Rotina Principal ---
main:
        mov     a,r0            ;Move o conte�do do contador (r0) para o acc
        movc    a,@a+dptr       ;Move o byte relativo de dptr somado com o valor de acc para o acc
        mov     p0,a            ;Move o conte�do de acc para Port0
        inc     r0              ;Incrementa o contador (r0)
        cjne    r0,#0Ah,main    ;Verifica se o valor do contador(r0) � igual a 10, caso contr�rio, volta para o inicio
        ajmp    $               ;Segura o c�digo nesta linha

; --- Banco ---
display7:
        db      40h             ;01000000b - N�mero 0 no display
        db      79h             ;01111001b - N�mero 1 no display
        db      24h             ;00100100b - N�mero 2 no display
        db      30h             ;00110000b - N�mero 3 no display
        db      19h             ;00011001b - N�mero 4 no display
        db      12h             ;00010010b - N�mero 5 no display
        db      02h             ;00000010b - N�mero 6 no display
        db      78h             ;01111000b - N�mero 7 no display
        db      00h             ;00000000b - N�mero 8 no display
        db      10h             ;00010000b - N�mero 9 no display

        end                     ;Final do Programa