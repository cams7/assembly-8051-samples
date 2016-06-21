;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 34 - Controle de Display 7 Segmentos com Timer
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
;


; --- Vetor de RESET ---
        org     0000h           ;origem no endere�o 00h de mem�ria
        mov     a,#00h          ;move constante 00h para acc
        mov     P0,a            ;configura PORT P0 como sa�da
        mov     P3,a            ;configura PORT P3 como sa�da
        mov     R1,#00h         ;inicializa R1 em 00h
        mov     dptr,#tabela    ;dptr aponta para o endere�o incial
                                ;da tabela
        ajmp    inicio          ;desvia das interrup��es

 
; --- Rotina da Interrup��o do Timer 1 ---
        org     001Bh           ;endere�o da interrup��o do Timer1
        mov     TH1,#3Ch        ;carrega 3Ch em TH0
        mov     TL1,#0AFh       ;carrega AFh em TL0
        djnz    R0,endInt       ;R0 igual a zero? N�o, desvia para endInt
        mov     R0,#10d         ;Sim, recarrega R0 com 10d
        inc     R1              ;Incrementa R1
        mov     a,R1            ;move conte�do de R1 para acc
        movc    a,@a+dptr       ;move o byte relativo de dptr
                                ;somado com o valor de acc para acc
        mov     P0,a            ;envia o conte�do de acc para P0
        cpl     P3.0            ;complementa P2.0 (pino para teste do tempo)
        cjne    R1,#9d,endInt   ;compara R1 com 9 e desvia enquanto
                                ;for diferente

recharg:
        mov     R1,#00h         ;reinializa R1
        reti                    ;retorna da interrup��o
         
endInt:
        reti                    ;retorna da interrup��o


 
 
; --- Rotina Principal ---
inicio:
        mov     R0,#10d         ;move 20d para R0
        mov     a,#0FFh         ;move FFh para acc
        mov     P0,a            ;inicializa P0

        mov     IE,#88h         ;habilita interrup��o do Timer1
        mov     IP,#08h         ;Timer1 com alta prioridade
        setb    TR1             ;habilita contagem do Timer1
        mov     TMOD,#10h       ;Timer1 no modo timer de 16 bits
                                ;controlado pelo ciclo de m�quina
        mov     TH1,#3Ch        ;carrega 3Ch em TH0
        mov     TL1,#0AFh       ;carrega AFh em TL0
                                ;Timer1 contar� at� 50000�s = 50ms

        ajmp    $               ;fica aguardando interrup��o


; --- Tabela de dados ---
tabela:
        db      0C0h            ;BCD '0'
        db      0F9h            ;BCD '1'
        db      0A4h            ;BCD '2'
        db      0B0h            ;BCD '3'
        db      99h             ;BCD '4'
        db      92h             ;BCD '5'
        db      82h             ;BCD '6'
        db      0F8h            ;BCD '7'
        db      80h             ;BCD '8'
        db      90h             ;BCD '9'
 
  
        end                     ;Final do programa
         
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
           
   