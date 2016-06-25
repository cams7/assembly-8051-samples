;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 43 - Exemplo de programa��o da Serial. 
;   
;  
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
;   Autor: Eng. Wagner Rambo   |   Data: Mar�o de 2016
;
;

; --- Vetor de RESET (Externa - RST) ---
        org     0000h           ;origem no endere�o 00h de mem�ria
        sjmp    main            ;desvia dos vetores de interrup��o


; --- Vetor de Interrup��o Serial (Interna - Perif�rico) ---
        org     0023h           ;interrup��o serial aponta para este endere�o
        sjmp    trata_serial    ;desvia para o endere�o da rotina de interrup��o


; --- Programa Principal ---
main:

        mov     TMOD,#20h       ;Timer1 no modo 2
                                ;Registrador TMOD (Timer Mode) - Seleciona o Modo de Opera��o dos Timers
                                ;Timer 1        Timer 0
                                ;Gate C/T M1 M0 Gate C/T M1 M0
                                ;0    0   1  0  0    0   0  0

                                ;C/T = 0 �> Incremento do Timer pelo clock do microcontrolador
                                ;C/T = 1 �> Incremento do Timer por evento externo (pino T0 do PORT P3 para o Timer0 e pino T1 do PORT P3 para o Timer1)
                                ;Gate = 0 � Ativa a contagem em conjunto com o bit TR de TCON
                                ;Gate = 1 � Contagem condicionado aos pinos INT0 para o Timer0 ou INT1 para o Timer1, ambos presentes no barramento do PORT P3

                                ;Modo M1 M0 Defini��o
                                ;0 -  0  0  Contador de 32 bits
                                ;1 -  0  1  Contador de 16 bits
                                ;2 -  1  0  Contador de 8 bits com auto-reload
                                ;3 -  1  1  Time misto

        mov     TH1,#0F4h       ;Timer1 configurado para gerar baud rate de 2400
                                ;F4(244)
                                ;2^8-244=12us
                                
        setb    TR1             ;Liga Timer1

        mov     IE,#90h         ;Habilita interrup��o Serial
                                ;Registrador IE (Interrupt Enable) - Habilita Interrup��o
                                ;EA .. ES ET1 EX1 ET0 EX0
                                ;1  00 1  0   0   0   0
                             
                                ;EA (Enable All) � habilita todas interrup��es
                                ;ES (Enable Serial) � habilita interrup��o serial
                                ;ET1 (Enable Timer1) � habilita interrup��o do Timer1
                                ;EX1 (Enable external1) � habilita interrup��o externa INT1
                                ;ET0 (Enable Timer0) � habilita interrup��o do Timer0
                                ;EX0 (Enable external0) � habilita interrup��o externa INT0

        mov     SCON,#50h       ;Serial no Modo 1, liberando o bit REN
                                ;Registrador SCON (Serial Control) - Controle da serial
                                ;SM0 SM1 SM2 REN TB8 RB8 TI RI
                                ;0   1   0   1   0   0   0  0
                                
                                ;SM0 � Combinado com SM1, configura um dos 4 modos de opera��o
                                ;SM1 � Combinado com SM0, configura um dos 4 modos de opera��o
                                ;SM2 � Utilizado para multiprocessamento para os modos 2 e 3
                                ;REN � Inicia a recep��o de dados
                                ;TB8 � Transmiss�o de um nono bit junto com cada byte transmitido
                                ;RB8 � Recep��o de um novo bit junto com cada byte transmitido
                                ;TI � Flag de interrup��o para transmiss�o
                                ;RI � Flag de interrup��o para recep��o

                                ;Modo SM0 SM1 Comunica��o Tamanho Baud-Rate
                                ;0 -  0   0   S�ncrona    8bits   Fclock/12
                                ;1 -  0   1   Ass�ncrona  8bits   Dado por Timer1
                                ;2 -  1   0   Ass�ncrona  9bits   Fclock/32 ou /64
                                ;3 -  1   1   Ass�ncrona  9bits   Dado por Timer1

        sjmp    $               ;Loop infinito


; --- Rotina de tratamento da Interrup��o ---
trata_serial:
        mov     a,SBUF          ;L� o conte�do de SBUF e carrega em acc
        clr     RI              ;limpa bit de interrup��o

exit_trata_seral:
        reti                    ;retorna da rotina de interrup��o


        end                     ;Final do programa

















