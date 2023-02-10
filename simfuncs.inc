
	jmp	SIMFUNCS_END

!macro DG_PUT_CHAR .char {
	ldx	#.char
	stx	VERA_DATA0
	sta	VERA_DATA0
}
!macro DG_PUT_CHAR {
	stx	VERA_DATA0
	sta	VERA_DATA0
}
!macro DG_INC_LINE {
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
}
!macro DG_DEC_LINE {
	dec	VERA_ADDR_M
	sty	VERA_ADDR_L
}


;******************************************************************************
; Function to draw a gate-tile at specific coordinates.
; Color of the gate is read from the global variable gate_color
; The function does not add $B0 to the Y coordinate to make it work in VERA
; For this reason, this function should only be called by the DRAW_GATE macro
; otherwise, user must ensure that Y coordinate has $B0 added to it before call
;******************************************************************************
; INPUTS:	.X & .Y - Coordinates of top left corner of gate-tile
;		.A - Type of Gate
;	$00 - Input
;	$02 - AND gate
;	$04 - AND gate inverted top input
;	$06 - AND gate inverted botoom input
;	$08 - AND gate both inputs inverted
;	$0A - NAND gate
;	$0C - NAND gate inverted top input
;	$0E - NAND gate inverted bottom input
;	$10 - NAND gate both inputs inverted
;	$12 - OR gate
;	$14 - OR gate inverted top input
;	$16 - OR gate inverted bottom input
;	$18 - OR gate both inputs inverted
;	$1A - NOR gate
;	$1C - NOR gate inverted top input
;	$1E - NOR gate inverted bottom input
;	$20 - NOR gate both inputs inverted
;	$22 - XOR gate
;	$24 - XOR gate inverted top input
;	$26 - XOR gate inverted bottom input
;	$28 - XOR gate both inputs inverted
;	$2A - XNOR gate
;	$2C - XNOR gate inverted top input
;	$2E - XNOR gate inverted bottom input
;	$30 - XNOR gate both inputs inverted
;	$32 - NOT gate (inverter)
;	$34 - Output
;	$36 - Unknown gate
;	$38 - Buffer
;	$3A - Buffer inverted input
;******************************************************************************
draw_gate:
	pha				; Save gate type on stack
	lda	#$11			; Set bank and stride = 1
	sta	VERA_ADDR_H
	txa				; Calculate X address from X coordinate
	asl
	sta	VERA_ADDR_L		; Store X address
	sty	VERA_ADDR_M		; Store Y Address
	plx				; Use gate type as index to jmp table
	ldy	VERA_ADDR_L		; Save X address in .Y register
	lda	gate_color
	jmp	(@draw_table,x)
; **** INPUT ****
@input:
	inc	VERA_ADDR_M
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	+DG_PUT_CHAR $FF
	+DG_PUT_CHAR $43
	rts
; **** AND gate ****
@and_bot_inv:
	ldx	#$DD
	bra	+	
@and_both_inv:
	ldx	#$DE		; Top Left
+	+DG_PUT_CHAR
	+DG_INC_LINE
	+DG_PUT_CHAR $DF	; Middle left
	+DG_INC_LINE
	ldx	#$E1		; Bottom Left
	bra	@and_bot_left
@and_top_inv:
	ldx	#$DE		; Top Left
	bra	+
@and_gate:
	ldx	#$DD		; Top Left
+	+DG_PUT_CHAR
	+DG_INC_LINE
	+DG_PUT_CHAR $DF	; Middle left
	+DG_INC_LINE
	ldx	#$E0		; Bottom Left
@and_bot_left:
	+DG_PUT_CHAR
	+DG_PUT_CHAR $E3	; Bottom Middle
	+DG_PUT_CHAR $E5	; Bottom Right
	+DG_DEC_LINE
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	+DG_PUT_CHAR $E6	; Middle right
	+DG_DEC_LINE
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	+DG_PUT_CHAR $E2	; Top middle
	+DG_PUT_CHAR $E4	; Top right
	rts
; **** NAND gate ****
@nand_bot_inv:
	ldx	#$DD
	bra	+	
@nand_both_inv:
	ldx	#$DE		; Top Left
+	+DG_PUT_CHAR
	+DG_INC_LINE
	+DG_PUT_CHAR $DF	; Middle left
	+DG_INC_LINE
	ldx	#$E1		; Bottom Left
	bra	@nand_bot_left
@nand_top_inv:
	ldx	#$DE		; Top Left
	bra	+
@nand_gate:
	ldx	#$DD		; Top Left
+	+DG_PUT_CHAR
	+DG_INC_LINE
	+DG_PUT_CHAR $DF	; Middle left
	+DG_INC_LINE
	ldx	#$E0		; Bottom Left
@nand_bot_left:
	+DG_PUT_CHAR
	+DG_PUT_CHAR $E3	; Bottom Middle
	+DG_PUT_CHAR $E5	; Bottom Right
	+DG_DEC_LINE
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	+DG_PUT_CHAR $E7	; Middle right
	+DG_DEC_LINE
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	+DG_PUT_CHAR $E2	; Top middle
	+DG_PUT_CHAR $E4	; Top right
	rts
; **** OR gate ****
@or_bot_inv:
	ldx	#$E8
	bra	+	
@or_both_inv:
	ldx	#$E9		; Top Left
+	+DG_PUT_CHAR
	+DG_INC_LINE
	+DG_PUT_CHAR $DF	; Middle left
	+DG_INC_LINE
	ldx	#$EC		; Bottom Left
	bra	@or_bot_left
@or_top_inv:
	ldx	#$E9		; Top Left
	bra	+
@or_gate:
	ldx	#$E8		; Top Left
+	+DG_PUT_CHAR
	+DG_INC_LINE
	+DG_PUT_CHAR $EA	; Middle left
	+DG_INC_LINE
	ldx	#$EB		; Bottom Left
@or_bot_left:
	+DG_PUT_CHAR
	+DG_PUT_CHAR $EE	; Bottom Middle
	+DG_PUT_CHAR $F0	; Bottom Right
	+DG_DEC_LINE
	+DG_PUT_CHAR $EA	; Middle Left
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	+DG_PUT_CHAR $F1	; Middle right
	+DG_DEC_LINE
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	+DG_PUT_CHAR $ED	; Top middle
	+DG_PUT_CHAR $EF	; Top right
	rts
; **** NOR gate ****
@nor_bot_inv:
	ldx	#$E8
	bra	+	
@nor_both_inv:
	ldx	#$E9		; Top Left
+	+DG_PUT_CHAR
	+DG_INC_LINE
	+DG_PUT_CHAR $DF	; Middle left
	+DG_INC_LINE
	ldx	#$EC		; Bottom Left
	bra	@nor_bot_left
@nor_top_inv:
	ldx	#$E9		; Top Left
	bra	+
@nor_gate:
	ldx	#$E8		; Top Left
+	+DG_PUT_CHAR
	+DG_INC_LINE
	+DG_PUT_CHAR $EA	; Middle left
	+DG_INC_LINE
	ldx	#$EB		; Bottom Left
@nor_bot_left:
	+DG_PUT_CHAR
	+DG_PUT_CHAR $EE	; Bottom Middle
	+DG_PUT_CHAR $F0	; Bottom Right
	+DG_DEC_LINE
	+DG_PUT_CHAR $EA	; Middle Left
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	+DG_PUT_CHAR $F2	; Middle right
	+DG_DEC_LINE
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	+DG_PUT_CHAR $ED	; Top middle
	+DG_PUT_CHAR $EF	; Top right
	rts
; **** XOR gate ****
@xor_bot_inv:
	ldx	#$F3		; Top Left
	bra	+	
@xor_both_inv:
	ldx	#$F4		; Top Left
+	+DG_PUT_CHAR
	+DG_INC_LINE
	+DG_PUT_CHAR $DF	; Middle left
	+DG_INC_LINE
	ldx	#$EC		; Bottom Left
	bra	@xor_bot_left
@xor_top_inv:
	ldx	#$F4		; Top Left
	bra	+
@xor_gate:
	ldx	#$F3		; Top Left
+	+DG_PUT_CHAR
	+DG_INC_LINE
	+DG_PUT_CHAR $EA	; Middle left
	+DG_INC_LINE
	ldx	#$F5		; Bottom Left
@xor_bot_left:
	+DG_PUT_CHAR
	+DG_PUT_CHAR $F8	; Bottom Middle
	+DG_PUT_CHAR $F0	; Bottom Right
	+DG_DEC_LINE
	+DG_PUT_CHAR $EA	; Middle Left
	+DG_PUT_CHAR $F9	; Middle
	+DG_PUT_CHAR $F1	; Middle right
	+DG_DEC_LINE
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	+DG_PUT_CHAR $F7	; Top middle
	+DG_PUT_CHAR $EF	; Top right
	rts
; **** XNOR gate ****
@xnor_bot_inv:
	ldx	#$F3		; Top Left
	bra	+	
@xnor_both_inv:
	ldx	#$F4		; Top Left
+	+DG_PUT_CHAR
	+DG_INC_LINE
	+DG_PUT_CHAR $DF	; Middle left
	+DG_INC_LINE
	ldx	#$EC		; Bottom Left
	bra	@xnor_bot_left
@xnor_top_inv:
	ldx	#$F4		; Top Left
	bra	+
@xnor_gate:
	ldx	#$F3		; Top Left
+	+DG_PUT_CHAR
	+DG_INC_LINE
	+DG_PUT_CHAR $EA	; Middle left
	+DG_INC_LINE
	ldx	#$F5		; Bottom Left
@xnor_bot_left:
	+DG_PUT_CHAR
	+DG_PUT_CHAR $F8	; Bottom Middle
	+DG_PUT_CHAR $F0	; Bottom Right
	+DG_DEC_LINE
	+DG_PUT_CHAR $EA	; Middle Left
	+DG_PUT_CHAR $F9	; Middle
	+DG_PUT_CHAR $F2	; Middle right
	+DG_DEC_LINE
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	+DG_PUT_CHAR $F7	; Top middle
	+DG_PUT_CHAR $EF	; Top right
	rts
; **** NOT gate ****
@not_gate:
+	+DG_INC_LINE
	+DG_PUT_CHAR $43	; Middle left
	+DG_PUT_CHAR $FC	; Center
	ldx	#$FE		; Middle right
	bra	@buffer_cont
; **** BUFFER inverted input ****
@buffer_inv:
	ldx	#$FD		; Middle left
	bra	+
; **** BUFFER ****
@buffer:
	ldx	#$43		; Middle left
+	+DG_INC_LINE
	+DG_PUT_CHAR
	+DG_PUT_CHAR $FC	; Center
	ldx	#$43		; Middle right
@buffer_cont:
	+DG_PUT_CHAR
	+DG_DEC_LINE
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	+DG_PUT_CHAR $FA	; Top middle
	dec	VERA_ADDR_L
	dec	VERA_ADDR_L
	inc	VERA_ADDR_M
	inc	VERA_ADDR_M
	+DG_PUT_CHAR $FB	; Bottom middle
	rts
; **** OUTPUT ****
@output:
	inc	VERA_ADDR_M
	+DG_PUT_CHAR $43
	+DG_PUT_CHAR $FF
	rts
; **** UNKNOWN gate ****
@unknown:
	+DG_PUT_CHAR $DD	; Top left
	+DG_PUT_CHAR $45	; Top middle
	+DG_PUT_CHAR $6E	; Top right
	+DG_INC_LINE
	+DG_PUT_CHAR $DF	; Left middle
	+DG_PUT_CHAR '?'	; Center
	+DG_PUT_CHAR $6B	; Right middle
	+DG_INC_LINE
	+DG_PUT_CHAR $E0	; Bottom left
	+DG_PUT_CHAR $52	; Bottom middle
	+DG_PUT_CHAR $7D	; Bottom right
	rts

@draw_table:
	!word	@input:
	!word	@and_gate:
	!word	@and_top_inv:
	!word	@and_bot_inv:
	!word	@and_both_inv:
	!word	@nand_gate:
	!word	@nand_top_inv:
	!word	@nand_bot_inv:
	!word	@nand_both_inv:
	!word	@or_gate:
	!word	@or_top_inv:
	!word	@or_bot_inv:
	!word	@or_both_inv:
	!word	@nor_gate:
	!word	@nor_top_inv:
	!word	@nor_bot_inv:
	!word	@nor_both_inv:
	!word	@xor_gate:
	!word	@xor_top_inv:
	!word	@xor_bot_inv:
	!word	@xor_both_inv:
	!word	@xnor_gate:
	!word	@xnor_top_inv:
	!word	@xnor_bot_inv:
	!word	@xnor_both_inv:
	!word	@not_gate:
	!word	@output:
	!word	@unknown:
	!word	@buffer:
	!word	@buffer_inv

INPUT		= $00
AND_GATE	= $02
AND_TOP_INV	= $04
AND_BOT_INV	= $06
AND_BOTH_INV	= $08
NAND_GATE	= $0A
NAND_TOP_INV	= $0C
NAND_BOT_INV	= $0E
NAND_BOTH_INV	= $10
OR_GATE		= $12
OR_TOP_INV	= $14
OR_BOT_INV	= $16
OR_BOTH_INV	= $18
NOR_GATE	= $1A
NOR_TOP_INV	= $1C
NOR_BOT_INV	= $1E
NOR_BOTH_INV	= $20
XOR_GATE	= $22
XOR_TOP_INV	= $24
XOR_BOT_INV	= $26
XOR_BOTH_INV	= $28
XNOR_GATE	= $2A
XNOR_TOP_INV	= $2C
XNOR_BOT_INV	= $2E
XNOR_BOTH_INV	= $30
NOT_GATE	= $32
OUTPUT		= $34
UNKNOWN_GATE	= $36
BUFFER		= $38
BUFFER_INV	= $3A

SIMFUNCS_END:
