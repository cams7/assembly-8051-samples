;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 51 - Escrita em display LCD modo 8 bits (padr�o Hitachi HD44780U)
;
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


; --- Mapeamento de Hardware (PARADOXUS 8051) ---
         RS      equ     P1.5    ;Reg Select ligado em P1.7
         RW      equ     P1.6    ;Read/Write ligado em P1.6
         EN      equ     P1.7    ;Enable ligado em P1.5
         P_DATA  equ     P2      ;Bits de dados em todo P2


; --- Vetor de RESET ---
        org     0000h           ;origem no endere�o 00h de mem�ria
        acall   delay500ms      ;aguarda 500ms para estabilizar

; --- Programa Principal ---
inicio:

        acall   lcd_init        ;Chama sub rotina de inicializa��o
        
        mov     dptr,#LCD1      ;Move mensagem para DPTR
        acall   send_lcd        ;Chama sub rotina para enviar mensagem para LCD


        ajmp    $               ;Prende programa aqui


; --- Desenvolvimento das Sub Rotinas Auxiliares ---

;================================================================================
lcd_init:                       ;Sub Rotina para Inicializa��o do Display 
;Initialization sequence
;Power on
;Wait for more than 30ms after VDD rises to 4.5V
 
;Function set
;RS R/W DB7 DB6 DB5 DB4 DB3 DB2 DB1 DB0
;0  0   0   0   1   1   N   F   X   X
;       0   0   1   1   1   1   0   0  
 
;N | 1-line mode | 2-line mode
;    0             1
 
;F | display off | display on
;    0             1
 
;Wait for more than 39us      
 
        mov      a,#3Ch         ;Move literal 00111100b para acc
        acall    config         ;Chama sub rotina config
 
;Display ON/OFF Control
;RS R/W DB7 DB6 DB5 DB4 DB3 DB2 DB1 DB0
;0  0   0   0   0   0   1   D   C   B
;       0   0   0   0   1   1   1   0
 
;D | display off | display on
;    0             1
 
;C | cursor off  | cursor on
;    0             1
 
;B | blink  off  | blink  on
;    0             1
 
;Wait for more than 39us   
 
        mov      a,#0Eh         ;Move literal 00001110b para acc
        acall    config         ;Chama sub rotina config
 
;Display Clear
;RS R/W DB7 DB6 DB5 DB4 DB3 DB2 DB1 DB0
;0  0   0   0   0   0   0   0   0   1 
;       0   0   0   0   0   0   0   1
 
;Wait for more than 1.53us
 
        mov      a,#01h         ;Move literal 00000001b para acc
        acall    config         ;Chama sub rotina config
 
;Entry Mode Set
;RS R/W DB7 DB6 DB5 DB4 DB3 DB2 DB1 DB0
;0  0   0   0   0   0   0   1   I/D SH
;       0   0   0   0   0   1   1   0
 
;I/D | decrement mode   | increment mode
;      0                  1
 
;SH  | entire shift off | entire shift on
;      0                  1
 
;initialization end    
 
        mov      a,#06h         ;Move literal 00000110b para acc
        acall    config         ;Chama sub rotina config
        ret                     ;Retorna                     ;retorna

;================================================================================
config:                         ;Sub Rotina de Configura��o
        clr      EN             ;Limpa pino EN
        clr      RS             ;Limpa pino RS
        clr      RW             ;Limpa pino RW
        acall    wait           ;Aguarda 55us
        setb     EN             ;Aciona enable
        acall    wait           ;Aguarda 55us
        mov      P_DATA,a       ;Carrega dados em Port P2
        acall    wait           ;Aguarda 55us com barramento igual ao valor de acc
        clr      EN             ;Limpa pino EN
        acall    wait           ;Aguarda 55us
        ret                     ;Retorna

;================================================================================
send_lcd:                       ;Sub Rotina para Enviar dados ao LCD
        mov      R0,#00h        ;Move valor 00h (0d) para R0

send:
        mov      a,R0           ;Move conte�do de R0 para acc
        inc      R0             ;Incrementa acc
        movc     a,@a+dptr      ;Move o byte relativo de dptr somado com o valor de acc para acc
        acall    write_data     ;Chama sub rotina para escrita de dados
        cjne     R0,#10h,send   ;Compara R0 com valor de colunas e desvia se for diferente
        ret                     ;Retorna

;================================================================================
write_data:                          ;Sub Rotina para preparar para escrita de mensagem
        clr      EN             ;Limpa enable
        setb     RS             ;Seta RS
        clr      RW             ;Limpa RW (escrita)
        acall    wait           ;Aguarda 55us
        setb     EN             ;Seta enable
        acall    wait           ;Sguarda 55us
        mov      P_DATA,a       ;Carrega mensagem
        acall    wait           ;Aguarda 55us
        clr      EN             ;Limpa enable
        acall    wait           ;Aguarda 55us
        ret                     ;Retorna
  
;================================================================================
;write_lcd:                      ;Sub Rotina para Escrita de mensagem  
;        clr      EN             ;Limpa EN
;        mov      rs,c           ;reg dados (1)  control (0)
;        clr      RW
;        setb     EN
;        mov      P_DATA,a
;        clr      EN
;        acall    delay500ms
;        ret

;================================================================================
wait:                           ;Sub Rotina para atraso de 55us

        mov     R5,#055d        ;Carrega 55d em R5
wait_delay:           
        djnz    R5,wait_delay   ;Decrementa R5. R5 igual a zero? N�o, desvia para aux
        ret                     ;Sim, retorna


delay500ms:                     ;Sub Rotina para atraso de 500ms
                                ; 2       | ciclos de m�quina do mnem�nico call
        mov     R1,#0fah        ; 1       | move o valor 250 decimal para o registrador R1
 
delay1:
        mov     R2,#0f9h        ; 1 x 250 | move o valor 249 decimal para o registrador R2
        nop                     ; 1 x 250
        nop                     ; 1 x 250
        nop                     ; 1 x 250
        nop                     ; 1 x 250
        nop                     ; 1 x 250

delay2:
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250

        djnz    R2,delay2       ; 2 x 250 x 249 = 124500     | decrementa o R2 at� chegar a zero
        djnz    R1,delay1       ; 2 x 250                    | decrementa o R1 at� chegar a zero

        ret                     ; 2                          | retorna para a fun��o main
                                ;------------------------------------
                                ; Total = 500005 us ~~ 500 ms = 0,5 seg 


;================================================================================
; Defini��o de Mensagens para Enviar ao LCD
LCD1:
        db      20h             ;1 caracter | Espa�o
        db      'Cesar'         ;5 caracteres        
        db      20h             ;1 caracter | Espa�o        
        db      'Magalhaes'     ;9 caracteres


        end                     ;Final do programa