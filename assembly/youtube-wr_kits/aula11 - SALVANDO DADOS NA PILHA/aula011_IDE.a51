;
;  Curso de Assembly para 8051 WR Kits
;
;  Aula 011 - Salvando dados na pilha
;
;  Instru��es: "push" "pop"
;
;  Autor: Eng. Wagner Rambo
;
;  Data: Agosto de 2015
;

        org     0000h           ;origem no endere�o 0000h de mem�ria

main:
        mov     a,#0E9h         ;move o valor E9h (233) para acc
        mov     b,#04Dh         ;move o valor 4Dh (77) para b
        acall   soma                    ;chama a sub rotina de soma
        acall   subtrai         ;chama a sub rotina de subtra��o
        acall   multiplica      ;chama a sub rotina de multiplica��o
        acall   divide          ;chama a sub rotina de divis�o
        ajmp    $               ;segura o programa nesta linha
               
soma:
        push    acc             ;envia o valor de acc na pilha
        push    b               ;envia o valor de b na pilha
        add     a,b             ;soma a com b
        mov     24h,a           ;move o conte�do de acc para o endere�o 24h
        mov     25h,b           ;move o conte�do de b para o endere�o 25h
        pop     b               ;pega o valor antigo de b da pilha
        pop     acc             ;pega o valor antigo de a da pilha
        ret                     ;retorna
               
subtrai:
        push    acc             ;envia o valor de acc na pilha
        push    b               ;envia o valor de b na pilha
        subb   a,b              ;subtrai a por b
        mov     26h,a           ;move o conte�do de acc para o endere�o 26h
        mov     27h,b           ;move o conte�do de b para o endere�o 27h
        pop     b               ;pega o valor antigo de b da pilha
        pop     acc             ;pega o valor antigo de a da pilha
        ret                     ;retorna

multiplica:
        push    acc             ;envia o valor de acc na pilha
        push    b               ;envia o valor de b na pilha
        mul     ab              ;multiplica a por b
        mov     20h,a           ;move o conte�do de acc para o endere�o 20h
        mov     21h,b           ;move o conte�do de b para o endere�o 21h
        pop     b               ;pega o valor antigo de b da pilha
        pop     acc             ;pega o valor antigo de a da pilha
        ret                     ;retorna

divide:
        push    acc             ;envia o valor de acc na pilha
        push    b               ;envia o valor de b na pilha
        div     ab              ;divide a por b
        mov     22h,a           ;move o conte�do de acc para o endere�o 22h
        mov     23h,b           ;move o conte�do de b para o endere�o 23h
        pop     b               ;pega o valor antigo de b da pilha
        pop     acc             ;pega o valor antigo de a da pilha
        ret                     ;retorna

        end                     ;Final do programa











