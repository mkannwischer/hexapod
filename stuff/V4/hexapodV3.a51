;Benutzte Register: r3/r4/r5 für die Warteschleife am Anfang
;Im Interupt r1/r2 für 800 mikosekunden verzögerung 
;Im Interupt: a für Impulsbreitenmodulation (Akku wird vorher gerettet)
;im Interupt: r0/r1 für anpassung von istPos an sollPos
;r7 steuert die Geschwindigkeit 


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
mov P0,#0h  ;alle LEDs aus
call leuchteRot
setb TR0
call setzeGrundposition
call setzeIstPosGleichSollPos
posFlag BIT P2.0           ; ist posFlag=0 so ist istPos != sollPos ... ist posFlag=1 so ist istPos=sollPos
clr posFlag
mov r7,#1d       ;1: normale Geschwindigkeit 2: doppelteGeschwindigkeit, usw 3-4 dürfte maximaler wert sein
hauptprog:
call wait3s
mov r3,#5d   ;5x Vorlaufen
marke:
call vorLaufen
djnz r3,marke

mov r3,#16d  ;16x Drehen
marke2:
call linksDrehen
djnz r3,marke2

call setzeGrundposition
call wartenAufPos

mov r3,#5d ; 5x zurücklaufn
marke3:
call zurueckLaufen
djnz r3,marke3

mov r3,#16d
marke4:
call rechtsDrehen
djnz r3,marke4

call test_1

mov r3,#10d    ;10 x test
marke5:
call test_2
djnz r3,marke5

call setzeGrundposition
call wartenAufPos

call abhotten_1
mov r3,#10d
marke6:
call abhotten_2
djnz r3,marke6

mov a, r7
add a,#1d
mov r7, a

clr EA
call wait3s
setb EA
jmp hauptprog


vorLaufen:
call Bein0runter
call Bein1runter
call Bein2runter
call Bein3runter
call Bein4runter
call Bein5runter
call leuchteGruen
call wartenAufPos

call Bein0hoch
call Bein3hoch
call Bein4hoch
call Bein2gegen
call leuchteRot
call wartenAufPos

call Bein1hinter
call Bein5hinter
call Bein2hinter
call Bein0vor
call Bein3vor
call Bein4vor
call leuchteBlau
call wartenAufPos

call Bein0runter
call Bein3runter
call Bein4runter
call Bein2runter ;war vorher im gegendings und muss wieder in normale stellung
call leuchteWeiss
call wartenAufPos

call Bein1hoch
call Bein2hoch
call Bein5hoch
call Bein3gegen
call leuchteGruen
call wartenAufPos

call Bein0hinter
call Bein3hinter
call Bein4hinter
call Bein1vor
call Bein5vor
call Bein2vor
call leuchteRot
call wartenAufPos

call Bein1runter
call Bein2runter
call Bein5runter
call leuchteBlau
call wartenAufPos
ret

zurueckLaufen:
call Bein0hoch
call Bein3hoch
call Bein4hoch
call Bein2gegen
call leuchteGruen
call wartenAufPos

call Bein1vor
call Bein5vor
call Bein2vor
call Bein0hinter
call Bein3hinter
call Bein4hinter
call leuchteRot
call wartenAufPos

call Bein0runter
call Bein3runter
call Bein4runter
call Bein2runter ;war vorher im gegendings und muss wieder in normale stellung
call leuchteBlau
call wartenAufPos

call Bein1hoch
call Bein2hoch
call Bein5hoch
call Bein3gegen
call leuchteWeiss
call wartenAufPos

call Bein0vor
call Bein3vor
call Bein4vor
call Bein1hinter
call Bein5hinter
call Bein2hinter
call leuchteGruen
call wartenAufPos

call Bein1runter
call Bein2runter
call Bein5runter
call Bein3runter ; war vorher im gegendings und muss wieder in normale stellung
call leuchteRot
call wartenAufPos
ret



rechtsDrehen:

call Bein1runter
call Bein2runter
call Bein5runter
call leuchteGruen
call wartenAufPos


call Bein0hoch
call Bein3hoch
call Bein4hoch
call leuchteRot
call wartenAufPos


call Bein0hinter
call Bein1hinter
call Bein2vor
call Bein3vor
call Bein4hinter
call Bein5hinter
call leuchteBlau
call wartenAufPos

call Bein0runter
call Bein3runter
call Bein4runter
call LeuchteWeiss
call wartenAufPos

call Bein1hoch
call Bein2hoch
call Bein5hoch
call leuchteGruen
call wartenAufPos

call Bein0vor
call Bein1vor
call Bein2hinter
call Bein3hinter
call Bein4vor
call Bein5vor
call leuchteRot
call wartenAufPos

ret

linksDrehen:
call Bein0runter
call Bein1runter
call Bein2runter
call Bein3runter
call Bein4runter
call Bein5runter
call leuchteBlau
call wartenAufPos


call Bein0hoch
call Bein3hoch
call Bein4hoch
call leuchteWeiss
call wartenAufPos


call Bein0vor
call Bein1vor
call Bein2hinter
call Bein3hinter
call Bein4vor
call Bein5vor
call leuchteGruen
call wartenAufPos

call Bein0runter
call Bein3runter
call Bein4runter
call leuchteRot
call wartenAufPos

call Bein1hoch
call Bein2hoch
call Bein5hoch
call leuchteBlau
call wartenAufPos

call Bein0hinter
call Bein1hinter
call Bein2vor
call Bein3vor
call Bein4hinter
call Bein5hinter
call leuchteWeiss
call wartenAufPos

ret

abhotten_1:
call Bein4hoch
call Bein3hoch
call wartenAufPos
;call Bein4hinter
mov 2Ch,#130d
;call Bein3vor
mov 29h,#85d   ;Bein4WeitVor
call wartenAufPos
call Bein4runter
call Bein3runter
call leuchteBlau
call wartenAufPos

call Bein5hoch
call Bein2hoch
call wartenAufPos
call Bein5hinter
;call Bein2vor
mov 26h,#110d ;Bein2WeitVor
call wartenAufPos
call Bein5runter
call Bein2runter
call leuchteGruen
call wartenAufPos

call Bein0hoch
call Bein1hoch
mov 2Dh,#145d          ;Bein4bisschenHoch
mov 2Eh,#150d          ;Bein4bisschenHoch
mov 30h,#45d           ;Bein5bisschenHoch
mov 31h,#40d           ;Bein5bisschenHoch

mov 27h,#110d          ;Bein2bisschenRunter
mov 28h,#120d          ;Bein2bisschenRunter
mov 2Ah,#80d           ;Bein3bisschenRunter
mov 2Bh,#70d           ;Bein3bisschenRunter
call leuchteBlau
call wartenAufPos


;call Bein0vor
mov 20h,#87d  ;Bein0Vor
mov 21h,#120d ;Bein0AusStrecken
mov 22h,#60d ;Bein0AusStrecken

;call Bein1vor
mov 23h,#100d ;Bein1Vor
mov 24h,#65d  ;Bein1Ausstrecken
mov 25h,#120d  ;Bein1AusStrecken
call leuchteGruen
call wartenAufPos
ret

abhotten_2:

mov 22h,#90d
mov 25h,#120d
call leuchteRot
call wartenAufPos

mov 22h,#60d
mov 25h,#90d
call leuchteBlau
call wartenAufPos
ret


test_1:

call setzeGrundposition
call wartenAufPos
call wait3s

call leuchteGruen
call wartenAufPos

call Bein0hoch
call Bein5hoch
call leuchteBlau
call wartenAufPos

call Bein0Vor
call Bein5Hinter
mov 2Fh,#60d
call leuchteRot
call wartenAufPos

call Bein0runter
call Bein5runter
call leuchteGruen
call wartenAufPos

call Bein1hoch
call Bein4hoch
call leuchteBlau
call wartenAufPos

;call Bein1vor
mov 23h,#65d
call Bein4hinter
call leuchteRot
call wartenAufPos

call Bein1runter
call Bein4runter
call leuchteGruen
call wartenAufPos
ret
test_2:
mov 2Dh,#145d          ;Bein4bisschenHoch   ;Hinten unten
mov 2Eh,#148d          ;Bein4bisschenHoch
mov 30h,#45d           ;Bein5bisschenHoch
mov 31h,#33d           ;Bein5bisschenHoch

mov 21h,#110d          ;Bein0BisschenRunter
mov 22h,#125d
mov 24h,#80d       	   ;Bein1BisschenRunter
mov 25h,#65d
call leuchteBlau
call wartenAufPos


mov 21h,#145d          ;Bein0BisschenHoch  ;HintenOben
mov 22h,#145d
mov 24h,#45d           ;Bein1BisschenHoch
mov 25h,#35d

mov 2Dh,#110d			;Bein4Runter
mov 2Eh,#130d
mov 30h,#80d            ;Bein5Runter
mov 31h,#57d
call leuchteRot
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
mov 26h, #127d    ;Startposition Servo6   t
mov 27h, #130d    ;Startposition Servo7   t
mov 28h, #150d    ;Startposition Servo8  k
ret


Bein3start:
mov 29h, #63d    ;Startposition Servo9   k
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


leuchteRot:
setb P3.0   ;blau aus
setb P3.1   ;grün aus
clr  P1.0    ;rot an
ret

leuchteGruen:
setb P3.0    ;blau aus
clr  P3.1     ;grün an
setb P1.0    ;rot aus
ret

leuchteBlau:
clr  P3.0    ;blau an
setb P3.1   ;grün aus
setb P1.0   ;rot aus
ret

leuchteWeiss:
clr  P3.0    ;blau an
clr P3.1   ;grün an
clr P1.0   ;rot an

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
;mov P1, #255d ;Servo0-Servo5 pin an   
orl P1,#11111100b    
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
;mov P1,#0d
anl P1,#00000011b
mov a, #150d
;mov P2, #255d  ;Servo6-Servo11 an
orl P2,#11111100b  
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
;mov P2,#0d
anl P2,#00000011b
mov a, #150d
;mov P3, #255d
orl P3,#11111100b  
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
;mov P3,#0d
anl P3,#00000011b


setb posFlag

; das hier wird nur ausgeführt, wenn r6=0
push 07h ;r7 auf Stack legen
marke2z:
call istPosSollPosanpassen
djnz r7,marke2z
pop 07h ;r7 zurückholen 



pop 0E0h ;Akku zurückholen
ret 

istPosSollPosanpassen:
mov r0, #20h   
mov r1, #40h
markez:
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
cjne r0,#32h,markez

ret

end


