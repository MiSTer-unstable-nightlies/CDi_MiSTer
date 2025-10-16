	section .text

    org $400000

vector:
	dc.l $1234
    dc.l main

main:
	move.l #cdicirq,$200
	move #$2000,SR  

	move.w #$2480,$303FFC ; IRQ vector

	move.w #$0023,$303C00 ; Command Register = Reset Mode 1
	move.w #$8000,$303FFE ; Data buffer

	move.w #$2480,$303FFC ; Interrupt Vector
	move.w #$0029,$303C00 ; Read Mode 1
	move.l #$0021600,$303C02 ; Time Register
	move.w #$C000,$303FFE ; Start the Read

	move.l #$2000,A3
	move.b #'A',$80002019

	jsr waitforirq

	move.b #'B',$80002019

	jsr waitforirq

	move.b #'C',$80002019

	move.w #$0000,$303FFE ; Stop the Read
	move.w #$C000,$303FFE ; Start the Read

	jsr waitforirq
	jsr waitforirq

endless:
	bra endless

wait:
	add #-1,d0
	bne wait
	rts


waitforirq:
	move #0,d0
waitforirqloop:
	cmp #0,d0
	beq waitforirqloop
	move.b #'O',$80002019
	rts

cdicirq:
	move.b #'I',$80002019
	move.w $303FF4,d0 ; clear flags on ABUFD
	move.w $303FF6,d0 ; clear flags on XBUF
	;move.b #$92,$80004005

	move #1,d0
	rte
