	jmp	SIMFUNCS_END

;******************************************************************************
; Function to draw a gate-tile at specific coordinates.
; Color of the gate is read from the global variable gate_color
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

@input:
	inc	VERA_ADDR_M
	inc	VERA_ADDR_L
	inc	VERA_ADDR_L
	ldx	#$FF
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$43
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@and_gate:
	ldx	#$DD		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E2		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E4		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$DF		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$E6		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$E0		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E3		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E5		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@and_top_inv:
	ldx	#$DE		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E2		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E4		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$DF		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$E6		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$E0		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E3		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E5		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@and_bot_inv:
	ldx	#$DD		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E2		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E4		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$DF		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$E6		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$E1		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E3		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E5		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@and_both_inv:
	ldx	#$DE		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E2		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E4		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$DF		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$E6		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$E1		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E3		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E5		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@nand_gate:
	ldx	#$DD		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E2		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E4		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$DF		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$E7		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$E0		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E3		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E5		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@nand_top_inv:
	ldx	#$DE		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E2		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E4		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$DF		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$E7		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$E0		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E3		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E5		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@nand_bot_inv:
	ldx	#$DD		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E2		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E4		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$DF		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$E7		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$E1		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E3		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E5		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@nand_both_inv:
	ldx	#$DE		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E2		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E4		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$DF		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$E7		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$E1		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E3		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$E5		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@or_gate:
	ldx	#$E8		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$ED		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$F1		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EB		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EE		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@or_top_inv:
	ldx	#$E9		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$ED		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$F1		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EB		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EE		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@or_bot_inv:
	ldx	#$E8		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$ED		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$F1		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EC		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EE		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@or_both_inv:
	ldx	#$E9		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$ED		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$F1		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EC		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EE		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@nor_gate:
	ldx	#$E8		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$ED		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$F2		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EB		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EE		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@nor_top_inv:
	ldx	#$E9		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$ED		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$F2		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EB		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EE		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@nor_bot_inv:
	ldx	#$E8		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$ED		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$F2		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EC		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EE		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@nor_both_inv:
	ldx	#$E9		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$ED		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	VERA_DATA0
	ldx	VERA_DATA0
	ldx	#$F2		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EC		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EE		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@xor_gate:
	ldx	#$F3		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F7		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F9
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F1		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$F5		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F8		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@xor_top_inv:
	ldx	#$F4		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F7		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F9
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F1		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$F5		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F8		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@xor_bot_inv:
	ldx	#$F3		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F7		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F9
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F1		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$F6		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F8		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@xor_both_inv:
	ldx	#$F4		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F7		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F9
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F1		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$F6		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F8		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@xnor_gate:
	ldx	#$F3		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F7		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F9
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F2		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$F5		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F8		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@xnor_top_inv:
	ldx	#$F4		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F7		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F9
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F2		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$F5		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F8		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@xnor_bot_inv:
	ldx	#$F3		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F7		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F9
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F2		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$F6		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F8		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@xnor_both_inv:
	ldx	#$F4		; Top Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F7		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$EF		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$EA		; Middle left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F9
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F2		; Middle right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$F6		; Bottom Left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F8		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$F0		; Bottom Right
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@not_gate:
	ldx	#$FA
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$FC
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$FE
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$43
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$FB
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@output:
	inc	VERA_ADDR_M
	ldx	#$43
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$FF
	stx	VERA_DATA0
	sta	VERA_DATA0
	rts
@unknown:
	ldx	#$DD		; Top left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$45		; Top middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$6E		; Top right
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$DF		; Left middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#'?'		; Center
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$6B		; Right middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	inc	VERA_ADDR_M
	sty	VERA_ADDR_L
	ldx	#$E0		; Bottom left
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$52		; Bottom middle
	stx	VERA_DATA0
	sta	VERA_DATA0
	ldx	#$7D		; Bottom right
	stx	VERA_DATA0
	sta	VERA_DATA0
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
	rts
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

SIMFUNCS_END:
