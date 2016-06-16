;
 ;  Curso de Assembly para 8051 WR Kits
 ;
 ;  Aula 15 - Registrador PSW (Program Status Word)
 ;            Sele��o de bancos de Registradores
 ;
 ; Exerc�cio Proposto: 
 ;
 ; Somar o conte�do dos registradores R1 e R2 do primeiro banco
 ; com o conte�do de uma posi��o de mem�ria (endere�o 52h).
 ; Armazenar o resultado no registrador R6 do segundo banco de registradores.
 ;
 ; O conte�do de R1 � 05h
 ; O conte�do de R2 � 02h
 ; O conte�do do endere�o 52h � 04h
 ;
 ; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
 ;
 ; Autor: Eng. Wagner Rambo   |   Data: Setembro de 2015
 ;
 
        org     0000h                   ;origem no endere�o 0000h de mem�ria
init:
        mov     R1,#05h                 ;carrega o valor 05h em R1
        mov     R2,#02h                 ;carrega o valor 02h em R2
        mov     52h,#04h                ;carrega o valor 04h no endere�o 52h
 
main:
        mov     a,R1                    ;move o conte�do de R1 para acc
        add     a,R2                    ; acc = acc + R2
        add     a,52h                   ; acc = acc + M(52h)
        mov     PSW,#08h                ; PSW = 0000 1000b, seleciona o banco 1 de registradores (segundo banco)
        mov     R3,a                    ;move para R6 o valor do acumulador
        ajmp    $                       ;segura o programa nesta linha
 
        end                             ;Final do programa