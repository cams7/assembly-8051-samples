;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 48 - Interrup��o Serial. 
;
;   Exemplo de programa para ler dados do Port P2 e escrever no Port P1 e copiar para interface serial,
;   utilizando interrup��o serial
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
;   Autor: Eng. Wagner Rambo   |   Data: Maio de 2016
;
;

; --- Vetor de RESET ---
        org     0000h                           ;Origem no endere�o 00h de mem�ria
        sjmp    init                            ;Desvia dos vetores de interrup��o

; --- Vetor de Interrup��o Serial ---
        org     0023h                           ;Interrup��o serial aponta para este endere�o
        sjmp    trata_serial                    ;Desvia para o endere�o da rotina de interrup��o

; --- Programa Principal ---
;        org     0030h                           ;Especifica este endere�o espec�fico na mem�ria de programa para rotina principal
init:
        mov     P2,#0FFh                        ;Port P2 configura como entrada de dados

        mov     TMOD,#20h                       ;Timer1 no modo 2
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

        mov     TH1,#0FDh                       ;Timer1 configurado para gerar baud rate de 9600
                                                ;"Cristal"/12*(1/("Baud Rate"/(2^"SMOD"/32)))
                                                ;Cristal: 11,059MHz, Baud Rate: 9600, SMOD:0
                                                ;11059000/12*(1/(9600/(2^0/32))) = 2,9999457... = 3
                                                ;2^8-3 = 253 = FD

        mov     SCON,#50h                       ;8 bits, 1 stop bit, REN habilitado
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

        setb    TR1                             ;Liga Timer1
                                                ;TR1 = 1 -> Liga a contagem do Timer1
                                                ;TR1 = 0 -> Desliga a contagem do Timer1

        mov     IE,#90h                         ;Habilita interrup��o Serial
                                                ;Registrador IE (Interrupt Enable) - Habilita Interrup��o
                                                ;EA .. ES ET1 EX1 ET0 EX0
                                                ;1  00 1  0   0   0   0
                
                                                ;EA (Enable All) � habilita todas interrup��es
                                                ;ES (Enable Serial) � habilita interrup��o serial
                                                ;ET1 (Enable Timer1) � habilita interrup��o do Timer1
                                                ;EX1 (Enable external1) � habilita interrup��o externa INT1
                                                ;ET0 (Enable Timer0) � habilita interrup��o do Timer0
                                                ;EX0 (Enable external0) � habilita interrup��o externa INT0

main:                                           ;Loop infinito
        mov     a,P2                            ;L� Port P2
        mov     SBUF,a                          ;Escreve valor atual em SBUF
        acall   delay20ms                       ;Delay de 20ms
        sjmp    main                            ;Desvia de volta para main
        

; --- Rotina de tratamento da Interrup��o ---
;        org     0100h                           ;Determina este ponto espec�fico na mem�ria de programa para tratar a serial
trata_serial:
        jb      TI,limpa_transmissao            ;Desvia para label verifica_transmissao se TI for HIGH
        mov     a,SBUF                          ;Move o conte�do de SBUF para acc
        mov     P1,a                            ;Escreve valor atual no Port P1
        clr     RI                              ;Limpa flag RI

sai_trata_serial:
        reti                                    ;Retorna da interrup��o

limpa_transmissao:
        clr     TI                              ;Limpa flag TI        
        reti                                    ;Retorna da interrup��o

; --- Subrotina de delay ---
delay20ms:                                      ;sub rotina para o tempo de 20ms
 
                                                ; 2 ciclos da instru��o acall
        mov     R1,#32h                         ; 1 ciclo | move 50d para R1
 
 aux1:
        mov     R0,#32h                         ; 1 x 50 | move 50d para R0
 
 aux2:
        nop                                     ; 1 x 50 x 50 | no operation
        nop                                     ; 1 x 50 x 50 | no operation
        nop                                     ; 1 x 50 x 50 | no operation
        nop                                     ; 1 x 50 x 50 | no operation
        nop                                     ; 1 x 50 x 50 | no operation
        nop                                     ; 1 x 50 x 50 | no operation
         
        djnz    R0,aux2                         ; 2 x 50 x 50 | decrementa R0
                                                ;R0 igual a zero?
                                                ;n�o, desvia para aux2       
 
        djnz    R1,aux1                         ; 2 x 50 | decrementa R0
                                                ;R1 igual a zero?
                                                ;n�o, desvia para aux1
 
        ret                                     ; 2 ciclos | sim, retorna

        end                                     ;Final do programa