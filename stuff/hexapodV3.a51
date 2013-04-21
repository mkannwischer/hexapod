;Benutze Register: r3/r4/r5 für die Warteschleife am Anfang
;Im Interupt r1/r2 für 800 mikosekunden verzögerung 
;Im Interupt: a für Impulsbreitenmodulation (Akku wird vorher gerettet)
;im Interupt: r0/r1 für anpassung von istPos an sollPos
;r7 steuert die Geschwindigkeit (für schnelle Geschwindigkeiten)
;r6 steuert die Geschwindigkeit  (für langsame Bewegungen) ;notimplemented 


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
call setzeGrundpos
call setzeIstPosGleichSollPos
posFlag BIT P2.0           ; ist posFlag=0 so ist istPos != sollPos ... ist posFlag=1 so ist istPos=sollPos
clr posFlag
mov r7,#1d          ;r7 steuert 1: normale Geschwindigkeit 2: doppelteGeschwindigkeit, usw 3-4 dürfte maximaler wert sein
mov r6,#0d          ;muss 0 sein, wenn geschwindigkeit >= normal sein soll. wenn != 0 wird r7 als zählvariable verwendet und muss somit am anfang auf 0 gesetzt werden!; notimplemented
call wait3s
hauptprog:
call vorLaufen
jmp hauptprog

vorLaufen:
call Bein0hoch
call Bein3hoch
call Bein4hoch
call Bein2gegen
call wartenAufPos

call Bein1hinter
call Bein5hinter
call Bein2hinter
call Bein0vor
call Bein3vor
call Bein4vor
call wartenAufPos

call Bein0runter
call Bein3runter
call Bein4runter
call Bein2runter ;war vorher im gegendings und muss wieder in normale stellung
call wartenAufPos

call Bein1hoch
call Bein2hoch
call Bein5hoch
call Bein3gegen
call wartenAufPos

call Bein0hinter
call Bein3hinter
call Bein4hinter
call Bein1vor
call Bein5vor
call Bein2vor
call wartenAufPos

call Bein1runter
call Bein2runter
call Bein5runter
call wartenAufPos
ret

zurueckLaufen:

vorLaufen:
call Bein0hoch
call Bein3hoch
call Bein4hoch
call Bein2gegen
call wartenAufPos

call Bein1vor
call Bein5vor
call Bein2vor
call Bein0hinter
call Bein3hinter
call Bein4hinter
call wartenAufPos

call Bein0runter
call Bein3runter
call Bein4runter
call Bein2runter ;war vorher im gegendings und muss wieder in normale stellung
call wartenAufPos

call Bein1hoch
call Bein2hoch
call Bein5hoch
call Bein3gegen
call wartenAufPos

call Bein0vor
call Bein3vor
call Bein4vor
call Bein1hinter
call Bein5hinter
call Bein2hinter
call wartenAufPos

call Bein1runter
call Bein2runter
call Bein5runter
call Bein3runter ; war vorher im gegendings und muss wieder in normale stellung
call wartenAufPos
ret

rechtsDrehen:
call Bein0hoch
call Bein5hoch
call wartenAufPos

call Bein0hinter
call Bein5vor
call wartenAufPos

call Bein0runter
call Bein5runter
call wartenAufPos

call Bein2hoch 
call Bein3hoch
call wartenaufPos

call Bein2hinter
call Bein3vor
call wartenAufPos

call Bein3runter
call Bein3runter
call wartenAufPos

call Bein4hoch
call Bein1hoch
call wartenAufPos

call Bein4hinter
call Bein1vor
call wartenAufPos

call Bein0vor
call Bein1hinter
call Bein2vor
call Bein3hinter
call Bein4vor 
call bein5hinter 
ret

linksDrehen:
call Bein0hoch
call Bein5hoch
call wartenAufPos

call Bein0vor
call Bein5hinter
call wartenAufPos

call Bein0runter
call Bein5runter
call wartenAufPos

call Bein2hoch 
call Bein3hoch
call wartenaufPos

call Bein2vor
call Bein3hinter
call wartenAufPos

call Bein3runter
call Bein3runter
call wartenAufPos

call Bein4hoch
call Bein1hoch
call wartenAufPos

call Bein4vor
call Bein1hinter
call wartenAufPos

call Bein0hinter
call Bein1vor
call Bein2hinter
call Bein3vor
call Bein4hinter 
call bein5vor 
call wartenAufPos

ret




setzeGrundposition:
call Bein0start
call Bein1start
call Bein2start
call Bein3start
call Bein4start
call Bein5start
ret

Bein0start:
mov 20h, #125d    ;Startposition Servo0   v:110t  
mov 21h, #130d    ;Startposition Servo1   v:110t 
mov 22h, #150d    ;Startposition Servo2  v:125k
ret

Bein1start:
mov 23h, #45d    ;Startposition Servo3   k
mov 24h, #60d    ;Startposition Servo4   k
mov 25h, #40d    ;Startposition Servo5   k
ret

Bein2start:
mov 26h, #125d    ;Startposition Servo6   t
mov 27h, #130d    ;Startposition Servo7   t
mov 28h, #150d    ;Startposition Servo8  k
ret


Bein3start:
mov 29h, #45d    ;Startposition Servo9   k
mov 2Ah, #60d    ;Startposition Servo10  k
mov 2Bh, #40d    ;Startposition Servo11  k
ret


Bein4start:
mov 2Ch, #125d    ;Startposition Servo12  t
mov 2Dh, #130d    ;Startposition Servo13  t
mov 2Eh, #150d    ;Startposition Servo14 k
ret


Bein5start:
mov 2Fh, #60d    ;Startposition Servo15  k
mov 30h, #60d    ;Startposition Servo16  k
mov 31h, #40d    ;Startposition Servo17  k
ret

setzeIstPosGleichSollPos:
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

wartenAufPos:
clr posFlag
wartenAufPosFlagMarke:
jnb posFlag,wartenAufPosFlagMarke
ret

Bein0hoch:
mov 21h, #150d ;Bein0
mov 22h, #135d 
ret

Bein1hoch:
mov 24h, #35d    ;Bein1
mov 25h, #50d
ret

Bein2hoch:
mov 27h, #150d    ;Bein2
mov 28h, #135d
ret

Bein3hoch:
mov 2Ah, #40d  ;Bein3
mov 2Bh, #50d
ret

Bein4hoch:
mov 2Dh, #150d ;Bein4
mov 2Eh, #135d 
ret


Bein5hoch:
mov 30h, #35d    ;Bein5
mov 31h, #50d
ret

Bein0runter:
mov 21h, #130d    ;Bein0
mov 22h, #150d 
ret

Bein1runter:
mov 24h, #60d    ;Bein1
mov 25h, #40d
ret

Bein2runter:
mov 27h, #130d    ;Bein2
mov 28h, #150d
ret

Bein3runter:
mov 2Ah, #60d    ;Bein3
mov 2Bh, #40d  
ret

Bein4runter:
mov 2Dh, #130d    ;Bein4
mov 2Eh, #150d  
ret

Bein5runter:
mov 30h, #60d    ;Bein5
mov 31h, #40d

ret

Bein0vor:
mov 20h,#120d ;Bein0
ret

Bein1vor:
mov 23h,#60d ;Bein1
ret

Bein2vor:
mov 26h,#125d ;Bein2
ret

Bein3vor:
mov 29h,#60d ;Bein3    
ret

Bein4vor:
mov 2Ch,#115d ;Bein4
ret


Bein5vor:
mov 2Fh,#70d ;Bein5
ret

Bein0hinter:
mov 20h, #145d ;Bein0
ret

Bein1hinter:
mov 23h,#35d ;Bein1
ret

Bein2hinter:
mov 26h,#135d ;Bein2
ret

Bein3hinter:
mov 29h, #50d  ;Bein3
ret

Bein4hinter:
mov 2Ch, #125d ;Bein4
ret

Bein5hinter:
mov 2Fh,#55d ;Bein5
ret

Bein2gegen:
mov 27h, #125d  ;bein2
ret

Bein3gegen:
mov 2Ah, #65d    ;Bein3
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



pause800mikroSekunden: ;Ist mit absicht nicht 800 mikrosekunden lang, da bei 800 die servos noch nicht am anschlag waren!
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
jnz loop0    
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



setb posFlag

; das hier wird nur ausgeführt, wenn r6=0
push 07h ;r7 auf Stack legen
marke2:
call istPosSollPosanpasen
djnz r7,marke2
pop 07h ;r7 zurückholen 



pop 0E0h ;Akku zurückholen
ret 

istPosSollPosanpassen:
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

ret

end


