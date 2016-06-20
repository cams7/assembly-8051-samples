;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 37 - Programando o Timer0 no Modo 3 (8 bits misto)
;
;
;   Programar o Timer0 no Modo 3. 
;   
;   TL0 dever� ser respons�vel por gerar uma frequ�ncia aproximada de 2kHz em P2.0 _ T = 500�s, ton = toff = 250�s
;
;   TH0 dever� ser respons�vel por gerar uma frequ�ncia aproximada de 10kHz em P2.7 _ T = 100�s, ton = toff = 50�s
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
;   Autor: Eng. Wagner Rambo   |   Data: Fevereiro de 2016
;
;

; --- Constantes ---
        FREQ1   equ     P2.0    ;cria uma constante para o pino P2.0
        FREQ2   equ     P2.7    ;cria uma constante para o pino P2.7


; --- Vetor de RESET (Externa - RST) ---
        org     0000h           ;origem no endere�o 00h de mem�ria
        ajmp    main            ;desvia das rotinas de interrup��o


; --- Vetor de Interrup��o ---

; -- Vetor de Interrup��o do TL0 (Modo 3) (Interna - Perif�rico) --
        org     000Bh           ;aponta para o endere�o do Timer0 (TL0 em modo 3)
        mov     TL0,#06h        ;inicia o TL0 em 06h(6d)
                                ;2^8-6     = 250us * 2 = 500us => 1/(500 * 1e-6) = 2e3 => f=2KHz
                               
        cpl     FREQ1           ;inverte o estado de FREQ1 a cada interrup��o

exit_timer0:
        reti                    ;retorna da interrup��o


; -- Vetor de Interrup��o do TH0 (Modo 3) (Interna - Perif�rico) --
        org     001Bh           ;aponta para o endere�o do Timer1 (TH0 no modo 3)
        mov     TH0,#0CEh       ;inicia o TH0 em CEh(206d)
                                ;2^8-206   = 50us  * 2 = 100us => 1/(100 * 1e-6) = 1e4 => f=10KHz
                               
        cpl     FREQ2           ;inverte o estado de FREQ2 a cada interrup��o

exit_timer1:
        reti                    ;retorna da interrup��o


; --- Programa Principal ---
main:        
        mov     a,#00h          ;move a constante 00h no acc
        mov     P2,a            ;inicia P2 todo low (configura como sa�da)

        mov     IE,#8Ah         ;habilita interrup��o do Timer0 e do Timer1
                                ;Registrador IE (Interrupt Enable) - Habilita Interrup��o
                                ;EA .. ES ET1 EX1 ET0 EX0
                                ;1  00 0  1   0   1   0
                                    
                                ;EA (Enable All) � habilita todas interrup��es
                                ;ES (Enable Serial) � habilita interrup��o serial
                                ;ET1 (Enable Timer1) � habilita interrup��o do Timer1
                                ;EX1 (Enable external1) � habilita interrup��o externa INT1
                                ;ET0 (Enable Timer0) � habilita interrup��o do Timer0
                                ;EX0 (Enable external0) � habilita interrup��o externa INT0

        mov     IP,#00h         ;sem prioridade de interrup��o
                                ;Registrador IP (Interrupt Priority) - Seleciona prioridade de interrup��o
                                ;... PS PT1 PX1 PT0 PX0
                                ;000 0  0   0   0   0

                                ;PS (Priority Serial) � prioridade da serial
                                ;PT1 (Priority Timer1) � prioridade do Timer1
                                ;PX1 (Priority External1) � prioridade INT1
                                ;PT0 (Priority Timer0) � prioridade Timer0
                                ;PX0 (Priority External0) � prioridade INT0

        mov     TCON,#50h       ;habilita contagem de TH0 e TL0 (Modo3)
                                ;Registrador TCON (Timer Control) - Configura os tipos de interrup��o e cont�m as flags de indica��o
                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                ;0   1   0   1   0   0   0   0

                                ;TRx = 1 -> Liga a contagem
                                ;TRx = 0 -> Desliga a contagem
                                ;TFx = 1 -> Flag de indica��o: ocorreu overflow
                                ;TFx = 0 -> Flag de indica��o: n�o ocorreu overflow
                                ;IEx = 0 -> Flag de indica��o: n�o houve interrup��o externa
                                ;IEx = 1 �> Flag de indica��o: houve interrup��o externa
                                ;ITx = 0 �> Interrup��o externa sens�vel a n�vel
                                ;ITx = 1 �> Interrup��o externa sens�vel � borda

        mov     TMOD,#03h       ;Configura modo 3 para o Timer0
                                ;Registrador TMOD (Timer Mode) - Seleciona o Modo de Opera��o dos Timers
                                ;Timer 1        Timer 0
                                ;Gate C/T M1 M0 Gate C/T M1 M0
                                ;0    0   0  0  0    0   1  1

                                ;C/T = 0 �> Incremento do Timer pelo clock do microcontrolador
                                ;C/T = 1 �> Incremento do Timer por evento externo (pino T0 do PORT P3 para o Timer0 e pino T1 do PORT P3 para o Timer1)
                                ;Gate = 0 � Ativa a contagem em conjunto com o bit TR de TCON
                                ;Gate = 1 � Contagem condicionado aos pinos INT0 para o Timer0 ou INT1 para o Timer1, ambos presentes no barramento do PORT P3

                                ;Modo M1 M0 Defini��o
                                ;0 -  0  0  Contador de 32 bits
                                ;1 -  0  1  Contador de 16 bits
                                ;2 -  1  0  Contador de 8 bits com auto-reload
                                ;3 -  1  1  Time misto

        mov     TL0,#06h        ;inicia o TL0 em 06h(6d)
        mov     TH0,#0CEh       ;inicia o TH0 em CEh(206d)
                                ;06 = 6(TL0), CE = 206(TH0)
                                ;2^8-6     = 250us * 2 = 500us => 1/(500 * 1e-6) = 2e3 => f=2KHz
                                ;2^8-206   = 50us  * 2 = 100us => 1/(100 * 1e-6) = 1e4 => f=10KHz                                                      
                                
        ajmp    $               ;Loop Infinito. Aguarda a interrup��o...


        end                     ;Final do Programa