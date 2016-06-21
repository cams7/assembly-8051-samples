;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 33 - Display de 7 segmentos. Contagem de 9 a 1 com display onBoard
;
;   OBS.: Display de Anodo Comum. Acende o segmento com n�vel low
;         Colocar jumper JS1 na posi��o "disp"
;
;   MCU: AT89S51    Clock: 12MHz    Ciclo de M�quina: 1�s
;
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
;   Autor: Eng. Wagner Rambo   |   Data: Janeiro de 2016
;

; --- Constantes ---
        P_DISPLAY       equ             P0                      ;Portas do display de 7 segmentos
        S_DISPLAY       equ             B.0                     ;Status da contagem do display
       
; --- Vetor de RESET (Externa - RST) ---
        org             0000h                                   ;Origem no endere�o 00h de mem�ria
        ajmp            main                                    ;Desvia das rotinas de interrup��o

; --- Vetor de Interrup��o INT0 (Externa - P3.2) ---
        org             0003h                                   ;Endere�o da interrup��o do INT0
        cpl             S_DISPLAY                               ;Inverte o status da contagem do display      

exit_int0:
        reti                                                    ;Retorna da interrup��o        

; --- Vetor de Interrup��o Timer0 (Interna - Perif�rico) --
        org             000Bh                                   ;A interrup��o do Timer0 aponta para este endere�o
        acall           reinicia_cont_timer0                    ;Chama a subrotina "reinicia_cont_timer0"
        djnz            R0, exit_timer0                         ;Decrementa o contador (R0). R0 � igual a zero? N�o, desvia.
        acall           altera_display7                         ;Chama a subrotina "altera_display7"

exit_timer0:
        reti                                                    ;Retorna da interrup��o

; --- Rotina Principal ---
main:
        mov             dptr,#display7                          ;dptr aponta para o endere�o do banco "display7"

        acall           inicializa_max_display7                 ;Chama a subrotina "inicializa_max_display7"
        acall           inicializa_cont_timer0                  ;Chama a subrotina "inicializa_cont_timer0"
        
        mov             IE,#83h                                 ;Habilita a interrup��o do Timer0 e a global
                                                                ;Registrador IE (Interrupt Enable) - Habilita Interrup��o
                                                                ;EA .. ES ET1 EX1 ET0 EX0
                                                                ;1  00 0  0   0   1   1
                                                 
                                                                ;EA (Enable All) � habilita todas interrup��es
                                                                ;ES (Enable Serial) � habilita interrup��o serial
                                                                ;ET1 (Enable Timer1) � habilita interrup��o do Timer1
                                                                ;EX1 (Enable external1) � habilita interrup��o externa INT1
                                                                ;ET0 (Enable Timer0) � habilita interrup��o do Timer0
                                                                ;EX0 (Enable external0) � habilita interrup��o externa INT0

        mov             IP,#03h                                 ;Configura timer0 com alta prioridade de interrup��o
                                                                ;Registrador IP (Interrupt Priority) - Seleciona prioridade de interrup��o
                                                                ;... PS PT1 PX1 PT0 PX0
                                                                ;000 0  0   0   1   1
                                                 
                                                                ;PS (Priority Serial) � prioridade da serial
                                                                ;PT1 (Priority Timer1) � prioridade do Timer1
                                                                ;PX1 (Priority External1) � prioridade INT1
                                                                ;PT0 (Priority Timer0) � prioridade Timer0
                                                                ;PX0 (Priority External0) � prioridade INT0
        
        mov             TCON,#11h                               ;Habilita a contagem do Timer0
                                                                ;Registrador TCON (Timer Control) - Configura os tipos de interrup��o e cont�m as flags de indica��o
                                                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                                                ;0   0   0   1   0   0   0   1
                                                   
                                                                ;TRx = 1 -> Liga a contagem
                                                                ;TRx = 0 -> Desliga a contagem
                                                                ;TFx = 1 -> Flag de indica��o: ocorreu overflow
                                                                ;TFx = 0 -> Flag de indica��o: n�o ocorreu overflow
                                                                ;IEx = 0 -> Flag de indica��o: n�o houve interrup��o externa
                                                                ;IEx = 1 �> Flag de indica��o: houve interrup��o externa
                                                                ;ITx = 0 �> Interrup��o externa sens�vel a n�vel
                                                                ;ITx = 1 �> Interrup��o externa sens�vel � borda
        
        mov             TMOD,#01h                               ;Configura o Timer0 para incrementar com ciclo de m�quina
                                                                ;Registrador TMOD (Timer Mode) - Seleciona o Modo de Opera��o dos Timers
                                                                ;Timer 1        Timer 0
                                                                ;Gate C/T M1 M0 Gate C/T M1 M0
                                                                ;0    0   0  0  0    0   0  1
 
                                                                ;C/T = 0 �> Incremento do Timer pelo clock do microcontrolador
                                                                ;C/T = 1 �> Incremento do Timer por evento externo (pino T0 do PORT P3 para o Timer0 e pino T1 do PORT P3 para o Timer1)
                                                                ;Gate = 0 � Ativa a contagem em conjunto com o bit TR de TCON
                                                                ;Gate = 1 � Contagem condicionado aos pinos INT0 para o Timer0 ou INT1 para o Timer1, ambos presentes no barramento do PORT P3
   
                                                                ;Modo M1 M0 Defini��o
                                                                ;0 -  0  0  Contador de 32 bits
                                                                ;1 -  0  1  Contador de 16 bits
                                                                ;2 -  1  0  Contador de 8 bits com auto-reload
                                                                ;3 -  1  1  Time misto

        acall           reinicia_cont_timer0                    ;Chama a subrotina "reinicia_cont_timer0" 
  
  
        ajmp            $                                       ;Aguarda a interrup��o...

inicializa_cont_timer0:                                         ;Inicializa a contagem do timer 0
         mov            R0,#10h                                 ;Move o valor 10h(16) para o contador (R0)
         ret                                                    ;Retorna        
 
reinicia_cont_timer0:                                           ;Reinicia a contagem ap�s 62,5 ms 
         mov            TH0,#0Bh                                ;Inicializa TH0 em 0Bh
         mov            TL0,#0DCh                               ;Inicializa TL0 em DCh
                                                                ;1/(2^16*1e-6) = 15,258... => "R0 = 16"
                                                                ;1/(x*1e-6)=16 => x=1/(16*1e-6) => x=62500
                                                                ;2^16-62500 = 3036 = 0BDC => "TH1=0B, TL1=DC"                                        
         ret

inicializa_min_display7:                                        ;Inicializa o valor minimo do display
        mov             R1,#01h                                 ;Move a constante 01h (1d) para R1
        ret                                                     ;Retorna

inicializa_max_display7:                                        ;Inicializa o valor m�ximo do display
        mov             R1,#0Ah                                 ;Move a constante 0Ah (10d) para R1
        ret                                                     ;Retorna

altera_display7:                                                ;Altera os valores no display
        acall           inicializa_cont_timer0                  ;Chama a subrotina "inicializa_cont_timer0"
        mov             a,R1                                    ;Move o conte�do do contador (R1) para acc
        movc            a,@a+dptr                               ;Move o byte relativo de dptr, somado com o valor de acc para acc
        mov             P_DISPLAY,a                             ;Move o conte�do de acc para P0
        jb              S_DISPLAY,inc_cont_display7             ;Se o status for 1, chama a subrotina "inc_cont_display7" 
  
dec_cont_display7:                                              ;Decrementa a contagem no display
        djnz            R1,exit_dec_cont                        ;Decrementa o contador (R1). R1 igual a zero? N�o, desvia para a subrotina "exit_dec_cont"
        acall           inicializa_max_display7                 ;Chama a subrotina "inicializa_max_display7"
 
exit_dec_cont:                                                  ;Sai da subrotina "dec_cont_display7"
        ret                                                     ;Retorna

inc_cont_display7:                                              ;Incrementa a contagem no display
        inc             R1                                      ;Incrementa o contador (R1)
        cjne            R1,#0Bh,exit_inc_cont                   ;Verifica se o valor do contador(R0) � igual a 11, caso contr�rio, desvia para a subrotina "exit_inc_cont"
        acall           inicializa_min_display7                 ;Chama a subrotina "inicializa_min_display7"

exit_inc_cont:                                                  ;Sai da subrotina "inc_cont_display7"
        ret                                                     ;Retorna

; --- Tabela de dados ---
display7:
        db              0FFh                                    ;BCD 'Apagado'
        db              0C0h                                    ;BCD '0'
        db              0F9h                                    ;BCD '1'
        db              0A4h                                    ;BCD '2'
        db              0B0h                                    ;BCD '3'
        db              99h                                     ;BCD '4'
        db              92h                                     ;BCD '5'
        db              82h                                     ;BCD '6'
        db              0F8h                                    ;BCD '7'
        db              80h                                     ;BCD '8'
        db              90h                                     ;BCD '9'

        end                                                     ;Final do programa