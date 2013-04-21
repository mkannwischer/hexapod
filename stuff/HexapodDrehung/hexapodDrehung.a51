include reg8252.inc 
 org 0h 
jmp init
org 0Bh
call interupt0  ;20msinterupt
reti
init:
setb EA
setb ET0
mov TMOD, #1b ; Timer0im 16-Bit Modus
mov TH0, #0B1h     ;2^16 = 65536 - 20000 = 25536d --> B1E0h 
mov TL0, #0E0h
setb TR0
call zustand0
posFlag BIT P2.0           ; ist posFlag=0 so ist istPos != sollPos ... ist posFlag=1 so ist istPos=sollPos
clr posFlag
call wait3s
hauptprog:
clr posFlag
call zustand1
nZustand1:
jnb posFlag, nZustand1
clr posFlag
call zustand2  ;2+3 und 6+7 gleichzeitig
;nZustand2:
;jnb posFlag, nZustand2
;clr posFlag
call zustand3
nZustand3:
jnb posFlag, nZustand3
clr posFlag
call zustand4
nZustand4:
jnb posFlag,nZustand4
clr posFlag
call zustand5
nZustand5:
jnb posFlag,nZustand5
clr posFlag
call zustand6      ;2+3 und 6+7 gleichzeitig
;nZustand6:
;jnb posFlag,nZustand6
;clr posFlag
call zustand7
nZustand7:
jnb posFlag,nZustand7
clr posFlag
call zustand8  
nZustand8:
jnb posFlag, nZustand8      

jmp hauptprog

zustand0:

mov 20h, #125d    ;Startposition Servo0   v:110t  ; StartPos: Bein 0,3,4 hinten oben, 1,2,5 vorne unten
mov 21h, #130d    ;Startposition Servo1   v:110t 
mov 22h, #150d    ;Startposition Servo2  v:125k
mov 23h, #45d    ;Startposition Servo3   k
mov 24h, #60d    ;Startposition Servo4   k
mov 25h, #40d    ;Startposition Servo5   k
mov 26h, #125d    ;Startposition Servo6   t
mov 27h, #130d    ;Startposition Servo7   t
mov 28h, #150d    ;Startposition Servo8  k
mov 29h, #45d    ;Startposition Servo9   k
mov 2Ah, #60d    ;Startposition Servo10  k
mov 2Bh, #40d    ;Startposition Servo11  k
mov 2Ch, #125d    ;Startposition Servo12  t
mov 2Dh, #130d    ;Startposition Servo13  t
mov 2Eh, #150d    ;Startposition Servo14 k
mov 2Fh, #60d    ;Startposition Servo15  k
mov 30h, #60d    ;Startposition Servo16  k
mov 31h, #40d    ;Startposition Servo17  k
mov 40h, 20h
mov 41h, 21h
mov 42h, 22h
mov 43h, 23h
mov 44h, 24h
mov 45h, 25h
mov 46h, 26h
mov 47h, 27h
mov 48h, 28h
mov 49h, 29h
mov 4Ah, 2Ah
mov 4Bh, 2Bh
mov 4Ch, 2Ch
mov 4Dh, 2Dh
mov 4Eh, 2Eh
mov 4Fh, 2Fh
mov 50h, 30h
mov 51h, 31h


ret

zustand1:   ;Bein0,Bein3,Bein4 nach oben; Bein2 gegendings
mov 21h, #150d ;Bein0
mov 22h, #135d 
mov 2Ah, #40d  ;Bein3
mov 2Bh, #50d
mov 2Dh, #150d ;Bein4
mov 2Eh, #135d 
mov 27h, #125d  ;bein2
ret

zustand2:
;Bein1,Bein2,Bein5 nach hinten 
mov 23h,#35d ;Bein1
mov 2Fh,#55d ;Bein5
mov 26h,#135d ;Bein2
ret




zustand3:
;Bein0,Bein3,Bein4 nach vorne
mov 20h,#120d ;Bein0
mov 2Ch,#115d ;Bein4
mov 29h,#60d ;Bein3    
ret

zustand4: ; Bein0,Bein3,Bein4 nach unten ; Bein2 normal
mov 21h, #130d    ;Bein0
mov 22h, #150d 
mov 2Ah, #60d    ;Bein3
mov 2Bh, #40d  
mov 2Dh, #130d    ;Bein4
mov 2Eh, #150d  
mov 27h, #130d
ret

zustand5: ;Bein1,2,5 nach oben Bein, Bein 3 ausgleichsdings
mov 24h, #35d    ;Bein1
mov 25h, #50d

mov 30h, #35d    ;Bein5
mov 31h, #50d

mov 27h, #150d    ;Bein2
mov 28h, #135d

mov 2Ah, #65d    ;Bein3
ret

zustand6:  ;Bein0,3,4 nach hinten
mov 20h, #145d ;Bein0
mov 2Ch, #125d ;Bein4
mov 29h, #50d  ;Bein3
ret

zustand7: ;Bein1,2,5 nach vorne
mov 23h,#60d ;Bein1
mov 2Fh,#70d ;Bein5
mov 26h,#125d ;Bein2
ret

zustand8:  ;Bein1,2,5 nach unten
mov 24h, #60d    ;Bein1
mov 25h, #40d

mov 30h, #60d    ;Bein5
mov 31h, #40d

mov 27h, #130d    ;Bein2
mov 28h, #150d

mov 2Ah, #60d   ;Bein3
ret

ret




wait3s:
mov r3,#10d
waitmarke0:
mov r4, #200d
waitmarke1:
mov r5,#250d
waitmarke2:
djnz r5, waitmarke2
djnz r4, waitmarke1
djnz r3, waitmarke0


ret



pause800mikroSekunden:
mov r1, #2d
p800aussen:
mov r2, #175d
p800innen:
djnz r2, p800innen           ;2MZ x 200 x 2 = 800 mikroSek
djnz r1, p800aussen
ret


interupt0:
clr TR0
push 0E0h ;Akku retten
mov TH0, #0B1h     ;2^16 = 65536 - 20000 = 25536d --> B1E0h 
mov TL0, #0E0h
setb TR0
mov a, #150d ;register zum runterzählen
mov P1, #255d ;Servo0-Servo5 pin an       
call pause800mikroSekunden 
loop0:
cjne a, 40h, weiter0    ;Servo0
clr P1.2                 
weiter0:
cjne a, 41h, weiter1    ;
clr P1.3
weiter1:
cjne a, 42h, weiter2
clr P1.4
weiter2:
cjne a, 43h, weiter3
clr P1.5
weiter3:
cjne a, 44h, weiter4
clr P1.6
weiter4:
cjne a, 45h, weiter5
clr P1.7
weiter5:
dec a
jnz loop0    ;Ein Schleifendurchlauf benötigt etwa 14 MZ; bei einer zeit von 2,5ms werden also etwa 121 durchläufe benötigt
mov P1,#0d
mov a, #150d
mov P2, #255d  ;Servo6-Servo11 an
call pause800mikroSekunden
loop1:
cjne a, 46h, weiter6
clr P2.2
weiter6:
cjne a, 47h, weiter7
clr P2.3
weiter7:
cjne a, 48h, weiter8
clr P2.4
weiter8:
cjne a, 49h, weiter9
clr P2.5
weiter9:
cjne a, 4Ah, weiter10
clr P2.6
weiter10:
cjne a, 4Bh, weiter11
clr P2.7
weiter11:
dec a
jnz loop1
mov P2,#0d
mov a, #150d
mov P3, #255d
call pause800mikrosekunden
loop2:
cjne a, 4Ch, weiter12
clr P3.2
weiter12:
cjne a, 4Dh, weiter13
clr P3.3
weiter13:
cjne a, 4Eh, weiter14
clr P3.4
weiter14:
cjne a, 4Fh, weiter15
clr P3.5
weiter15:
cjne a, 50h, weiter16
clr P3.6
weiter16:
cjne a, 51h, weiter17
clr P3.7
weiter17:                 
dec a
jnz loop2 
mov P3,#0d
pop 0E0h


setb posFlag


;mov r7, #2d ;wie oft soll anpassung durchgeführt werden ?
marke2:
mov r0, #20h   
mov r1, #40h
marke:

mov a, @r1    ;istPos in akku
clr c
subb a,@r0    ; istPos - sollPos
jz next0
clr posFlag
jc negativ0
mov a,@r1
dec a
mov @r1, a ;neue istPos von akku in @r0
jmp next0
negativ0:
mov a,@r1
inc a
mov @r1, a
next0:
inc r0
inc r1
cjne r0,#32h,marke
;djnz r7,marke2

ret 
end



ret
end
