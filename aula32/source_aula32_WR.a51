;
;  Curso de Assembly para 8051 WR Kits
;
;  Aula 32 - Programando o Timer 1 no modo 16 Bits
;
; Microcontrolador AT89S51:
;
; - Timer no modo 1 (contador de 16 bits);
; - Timer1 com baixa prioridade de interrup��o;
; - Configurar o estouro de T1 para ocorrer a cada 5 ms
; - Carregar o dado 01111111b inicialmente no acumulador
; - Rotacionar os LEDs do PORT P0 para esquerda a cada 500 ms
; - LEDs est�o no modo current sinking
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
; Autor: Eng. Wagner Rambo   |   Data: Janeiro de 2016
;

; --- Vetor de RESET (Externa - RST) ---
        org             0000h                   ;Origem no endere�o 000h de mem�ria
        mov             a,#00h                  ;Move o valor 00h para acc
        mov             P0,a                    ;Configura-lo como sa�da
        mov             a,#7Fh                  ;Move o valor constante 01111111b para acc
        ajmp            inicio                  ;Desvia para a label inicio

; --- Vetor de Interrup��o do TIMER1 (Interna - Perif�rico) ---
        org             001Bh                   ;Endere�o para o qual aponta a interrup��o do Timer1
        mov             TH1,#0Bh                ;Recarrega o byte mais significativo do Timer1
        mov             TL1,#0DCh               ;Recarrega o byte menos significativo do Timer1

        djnz            R0,sai_int              ;R0 igual a zero? N�o, desvia para a label sai_int
        mov             R0,#08h                 ;Sim, recarrega R0

        rl              a                       ;Rotaciona para esquerda os bits do acc
        mov             P0,a                    ;Carrega o valor do acc em PORT0

sai_int:        
        reti                                    ;Retornar da interrup��o

inicio:
        mov             R0,#08h                 ;Carrega o valor D'8' do R0

        mov             IE,#88h                 ;Habilita a interrup��o do Timer1
                                                ;Registrador IE (Interrupt Enable) - Habilita Interrup��o
                                                ;EA .. ES ET1 EX1 ET0 EX0
                                                ;1  00 0  1   0   0   0
                                                
                                                ;EA (Enable All) � habilita todas interrup��es
                                                ;ES (Enable Serial) � habilita interrup��o serial
                                                ;ET1 (Enable Timer1) � habilita interrup��o do Timer1
                                                ;EX1 (Enable external1) � habilita interrup��o externa INT1
                                                ;ET0 (Enable Timer0) � habilita interrup��o do Timer0
                                                ;EX0 (Enable external0) � habilita interrup��o externa INT0

        mov             IP,#00h                 ;Segue a prioridade relativa de interrup��es
                                                ;Registrador IP (Interrupt Priority) - Seleciona prioridade de interrup��o
                                                ;... PS PT1 PX1 PT0 PX0
                                                ;000 0  0   0   0   0
                                                
                                                ;PS (Priority Serial) � prioridade da serial
                                                ;PT1 (Priority Timer1) � prioridade do Timer1
                                                ;PX1 (Priority External1) � prioridade INT1
                                                ;PT0 (Priority Timer0) � prioridade Timer0
                                                ;PX0 (Priority External0) � prioridade INT0

        mov             TCON,#40h               ;Habilita a contagem do Timer1
                                                ;Registrador TCON (Timer Control) - Configura os tipos de interrup��o e cont�m as flags de indica��o
                                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                                ;0   1   0   0   0   0   0   0
                                                  
                                                ;TRx = 1 -> Liga a contagem
                                                ;TRx = 0 -> Desliga a contagem
                                                ;TFx = 1 -> Flag de indica��o: ocorreu overflow
                                                ;TFx = 0 -> Flag de indica��o: n�o ocorreu overflow
                                                ;IEx = 0 -> Flag de indica��o: n�o houve interrup��o externa
                                                ;IEx = 1 �> Flag de indica��o: houve interrup��o externa
                                                ;ITx = 0 �> Interrup��o externa sens�vel a n�vel
                                                ;ITx = 1 �> Interrup��o externa sens�vel � borda

        mov             TMOD,#10h               ;Habilita o timer1 no modo1 (16 bits)
                                                ;Configura o Timer0 no modo 2 (8 bits com auto-reload)
                                                ;Registrador TMOD (Timer Mode) - Seleciona o Modo de Opera��o dos Timers
                                                ;Timer 1        Timer 0
                                                ;Gate C/T M1 M0 Gate C/T M1 M0
                                                ;0    0   0  1  0    0   0  0

                                                ;C/T = 0 �> Incremento do Timer pelo clock do microcontrolador
                                                ;C/T = 1 �> Incremento do Timer por evento externo (pino T0 do PORT P3 para o Timer0 e pino T1 do PORT P3 para o Timer1)
                                                ;Gate = 0 � Ativa a contagem em conjunto com o bit TR de TCON
                                                ;Gate = 1 � Contagem condicionado aos pinos INT0 para o Timer0 ou INT1 para o Timer1, ambos presentes no barramento do PORT P3
  
                                                ;Modo M1 M0 Defini��o
                                                ;0 -  0  0  Contador de 32 bits
                                                ;1 -  0  1  Contador de 16 bits
                                                ;2 -  1  0  Contador de 8 bits com auto-reload
                                                ;3 -  1  1  Time misto

        mov             TH1,#0Bh                ;Carrega o byte mais significativo do Timer1
        mov             TL1,#0DCh               ;Carrega o byte menos significativo do Timer1                                                
                                                ;0,5/(2^16*1e-6) = 7,629... => R0 = 8
                                                ;0,5/(x*1e-6)=8 => x=0,5/(8*1e-6) => x=62500
                                                ;2^16-62500 = 3036 = 0BDC => TH1=0B, TL1=DC                                         
                                                
                                                ;T0 (16 Bits)   T1 (16 Bits)
                                                ;TH0 (8 bits)   TH1 (8 bits)    - Byte Alto
                                                ;TL0 (8 bits)   TL1 (8 bits)    - Byte Baixo

        ajmp            $                       ;Aguardando a interrup��o

        end                                     ;Final do programa