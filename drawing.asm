!cpu w65c02

!src "cx16.inc"

+SYS_LINE
!src "vera0.9.inc"

!macro PRINT_STR .str {
	bra	.locend
!ct "asc2vera.ct" {
.locstr	!text	.str
}
.locend:
	ldx	#0
	ldy	#.locend-.locstr
-	lda	.locstr,x
	sta	VERA_DATA0
	inx
	dey
	bne	-
}

main:
	lda	#PET_WHITE
	jsr	CHROUT
	lda	#PET_SWAP_FGBG
	jsr	CHROUT
	lda	#PET_BLACK
	jsr	CHROUT

	lda	#147
	jsr	CHROUT
	jsr	load_font

	+VERA_SET_STRIDE 2

	+VERA_GOXY $01, $02
	lda	#255
	sta	VERA_DATA0
	+PRINT_STR " - $FF INPUT/OUTPUT NODE"

	+VERA_GOXY $01, $04
	lda	#$DD
	sta	VERA_DATA0
	+PRINT_STR " - $DD AND TOP LEFT"

	+VERA_GOXY $01, $06
	lda	#$DE
	sta	VERA_DATA0
	+PRINT_STR " - $DE AND TOP LEFT INVERTED"

	+VERA_GOXY $01, $08
	lda	#$DF
	sta	VERA_DATA0
	+PRINT_STR " - $DF AND MID LEFT"

	+VERA_GOXY $01, $0A
	lda	#$E0
	sta	VERA_DATA0
	+PRINT_STR " - $E0 AND BOTTOM LEFT"

	+VERA_GOXY $01, $0C
	lda	#$E1
	sta	VERA_DATA0
	+PRINT_STR " - $E1 AND BOTTOM LEFT INVERTED"

	+VERA_GOXY $01, $0E
	lda	#$E2
	sta	VERA_DATA0
	+PRINT_STR " - $E2 AND TOP MIDDLE"

	+VERA_GOXY $01, $10
	lda	#$E3
	sta	VERA_DATA0
	+PRINT_STR " - $E3 AND BOTTOM MIDDLE"

	+VERA_GOXY $01, $12
	lda	#$E4
	sta	VERA_DATA0
	+PRINT_STR " - $E4 AND TOP RIGHT"

	+VERA_GOXY $01, $14
	lda	#$E5
	sta	VERA_DATA0
	+PRINT_STR " - $E5 AND BOTTOM RIGHT"

	+VERA_GOXY $01, $16
	lda	#$E6
	sta	VERA_DATA0
	+PRINT_STR " - $E6 AND RIGHT MIDDLE"

	+VERA_GOXY $01, $18
	lda	#$E7
	sta	VERA_DATA0
	+PRINT_STR " - $E7 AND RIGHT MID INVERTED (NAND)"

	+VERA_GOXY $01, $1A
	lda	#$E8
	sta	VERA_DATA0
	+PRINT_STR " - $E8 OR TOP LEFT"

	+VERA_GOXY $01, $1C
	lda	#$E9
	sta	VERA_DATA0
	+PRINT_STR " - $E9 OR TOP LEFT INVERTED"

	+VERA_GOXY $01, $1E
	lda	#$EA
	sta	VERA_DATA0
	+PRINT_STR " - $EA OR LEFT MIDDLE"

	+VERA_GOXY $01, $20
	lda	#$EB
	sta	VERA_DATA0
	+PRINT_STR " - $EB OR BOTTOM LEFT"

	+VERA_GOXY $01, $22
	lda	#$EC
	sta	VERA_DATA0
	+PRINT_STR " - $EC OR BOTTOM LEFT INVERTED"

	+VERA_GOXY $01, $24
	lda	#$ED
	sta	VERA_DATA0
	+PRINT_STR " - $ED OR TOP MIDDLE"

	+VERA_GOXY $01, $26
	lda	#$EE
	sta	VERA_DATA0
	+PRINT_STR " - $EE OR BOTTOM MIDDLE"

	+VERA_GOXY $01, $28
	lda	#$EF
	sta	VERA_DATA0
	+PRINT_STR " - $EF OR TOP RIGHT"

	+VERA_GOXY $01, $2A
	lda	#$F0
	sta	VERA_DATA0
	+PRINT_STR " - $F0 OR BOTTOM RIGHT"

	+VERA_GOXY $01, $2C
	lda	#$F1
	sta	VERA_DATA0
	+PRINT_STR " - $F1 OR RIGHT MIDDLE"

	+VERA_GOXY $01, $2E
	lda	#$F2
	sta	VERA_DATA0
	+PRINT_STR " - $F2 OR RIGHT MID INVERTED (NOR)"

	+VERA_GOXY $28, $02
	lda	#$F3
	sta	VERA_DATA0
	+PRINT_STR " - $F3 XOR TOP LEFT"

	+VERA_GOXY $28, $04
	lda	#$F4
	sta	VERA_DATA0
	+PRINT_STR " - $F4 XOR TOP LEFT INVERTED"

	+VERA_GOXY $28, $06
	lda	#$F5
	sta	VERA_DATA0
	+PRINT_STR " - $F5 XOR BOTTOM LEFT"

	+VERA_GOXY $28, $08
	lda	#$F6
	sta	VERA_DATA0
	+PRINT_STR " - $F6 XOR BOTTOM LEFT INVERTED"

	+VERA_GOXY $28, $0A
	lda	#$F7
	sta	VERA_DATA0
	+PRINT_STR " - $F7 XOR TOP MIDDLE"

	+VERA_GOXY $28, $0C
	lda	#$F8
	sta	VERA_DATA0
	+PRINT_STR " - $F8 XOR BOTTOM MIDDLE"

	+VERA_GOXY $28, $0E
	lda	#$F9
	sta	VERA_DATA0
	+PRINT_STR " - $F9 XOR CENTER"

	+VERA_GOXY $28, $10
	lda	#$FA
	sta	VERA_DATA0
	+PRINT_STR " - $FA INVERTER TOP"

	+VERA_GOXY $28, $12
	lda	#$FB
	sta	VERA_DATA0
	+PRINT_STR " - $FB INVERTER BOTTOM"

	+VERA_GOXY $28, $14
	lda	#$FC
	sta	VERA_DATA0
	+PRINT_STR " - $FC INVERTER LEFT"

	+VERA_GOXY $28, $16
	lda	#$FE
	sta	VERA_DATA0
	+PRINT_STR " - $FE INVERTER RIGHT"

	+VERA_GOXY $28, $18
	lda	#$43
	sta	VERA_DATA0
	+PRINT_STR " - $43 HORIZONTAL WIRE"

	+VERA_GOXY $28, $1A
	lda	#$5D
	sta	VERA_DATA0
	+PRINT_STR " - $5D VERTICAL WIRE"

	+VERA_GOXY $28, $1C
	lda	#$70
	sta	VERA_DATA0
	+PRINT_STR " - $70 TOP LEFT CORNER"

	+VERA_GOXY $28, $1E
	lda	#$6D
	sta	VERA_DATA0
	+PRINT_STR " - $6D BOTTOM LEFT CORNER"

	+VERA_GOXY $28, $20
	lda	#$6E
	sta	VERA_DATA0
	+PRINT_STR " - $6E TOP RIGHT CORNER"

	+VERA_GOXY $28, $22
	lda	#$7D
	sta	VERA_DATA0
	+PRINT_STR " - $7D BOTTOM RIGHT CORNER"

	+VERA_GOXY $28, $24
	lda	#$73
	sta	VERA_DATA0
	+PRINT_STR " - $73 LEFT TEE"

	+VERA_GOXY $28, $26
	lda	#$6B
	sta	VERA_DATA0
	+PRINT_STR " - $6B RIGHT TEE"

	+VERA_GOXY $28, $28
	lda	#$71
	sta	VERA_DATA0
	+PRINT_STR " - $71 TOP TEE"

	+VERA_GOXY $28, $2A
	lda	#$72
	sta	VERA_DATA0
	+PRINT_STR " - $72 BOTTOM TEE"

	jsr	CHRIN

	rts

load_font:
	+VERA_SET_STRIDE 1
	+VERA_SET_ADDR $1F000+($DD*$8) ; = 1F6E8

	lda	#<CHARS		; Save address of CHARS in ZP
	sta	TMP0
	lda	#>CHARS
	sta	TMP0+1

	ldy	#0
	ldx	#35		; number of characters to replace in font
@outloop:
	stx	TMP2		; Save .X in ZP location
	ldx	#8		; Counter for bytes in a character
-	lda	(TMP0),y
	sta	VERA_DATA0
	inc	TMP0		; Add 1 to 16 bit address stored in ZP
	bne	@noinc
	inc	TMP0+1
@noinc:
	dex
	bne	-		; Jump back and do next byte of character
	ldx	TMP2		; Restore .X from ZP
	dex
	bne	@outloop	; While we have not done all chars, jump back

	rts

CHARS
; ******************* AND/NAND *************************
; Top left of AND
	!byte	%........
	!byte	%....####
	!byte	%....####
	!byte	%######..
	!byte	%######..
	!byte	%....##..
	!byte	%....##..
	!byte	%....##..

; Top left of AND inverted input
	!byte	%........
	!byte	%....####
	!byte	%.##.####
	!byte	%#..###..
	!byte	%#..###..
	!byte	%.##.##..
	!byte	%....##..
	!byte	%....##..

; Left mid of AND
	!byte	%....##..
	!byte	%....##..
	!byte	%....##..
	!byte	%....##..
	!byte	%....##..
	!byte	%....##..
	!byte	%....##..
	!byte	%....##..

; Bottom Left of AND
	!byte	%....##..
	!byte	%....##..
	!byte	%....##..
	!byte	%######..
	!byte	%######..
	!byte	%....####
	!byte	%....####
	!byte	%........

; Bottom Left of AND inverted input
	!byte	%....##..
	!byte	%....##..
	!byte	%.##.##..
	!byte	%#..###..
	!byte	%#..###..
	!byte	%.##.####
	!byte	%....####
	!byte	%........

; Top mid of AND
	!byte	%........
	!byte	%######..
	!byte	%########
	!byte	%......##
	!byte	%.......#
	!byte	%........
	!byte	%........
	!byte	%........

; Bottom mid of AND
	!byte	%........
	!byte	%........
	!byte	%........
	!byte	%.......#
	!byte	%......##
	!byte	%########
	!byte	%######..
	!byte	%........

; Top right of AND
	!byte	%........
	!byte	%........
	!byte	%........
	!byte	%........
	!byte	%#.......
	!byte	%##......
	!byte	%.##.....
	!byte	%.##.....

; Bottom right of AND
	!byte	%.##.....
	!byte	%.##.....
	!byte	%##......
	!byte	%#.......
	!byte	%........
	!byte	%........
	!byte	%........
	!byte	%........

; Right mid of AND
	!byte	%..##....
	!byte	%..##....
	!byte	%...#....
	!byte	%...#####
	!byte	%...#####
	!byte	%...#....
	!byte	%..##....
	!byte	%..##....

; Right mid of NAND
	!byte	%..##....
	!byte	%..##....
	!byte	%...#.##.
	!byte	%...##..#
	!byte	%...##..#
	!byte	%...#.##.
	!byte	%..##....
	!byte	%..##....

; ******************* OR/NOR *************************
; Top left OR
	!byte	%........
	!byte	%....####
	!byte	%....####
	!byte	%######..
	!byte	%#######.
	!byte	%.....##.
	!byte	%......##
	!byte	%......##

; Top left OR inverted input
	!byte	%........
	!byte	%....####
	!byte	%.##.####
	!byte	%#..###..
	!byte	%#..####.
	!byte	%.##..##.
	!byte	%......##
	!byte	%......##

; Left mid of OR
	!byte	%......##
	!byte	%......##
	!byte	%......##
	!byte	%......##
	!byte	%......##
	!byte	%......##
	!byte	%......##
	!byte	%......##


; Bottom left OR
	!byte	%......##
	!byte	%......##
	!byte	%.....##.
	!byte	%#######.
	!byte	%######..
	!byte	%....####
	!byte	%....####
	!byte	%........

; Bottom left OR inverted input
	!byte	%......##
	!byte	%......##
	!byte	%.##..##.
	!byte	%#..####.
	!byte	%#..###..
	!byte	%.##.####
	!byte	%....####
	!byte	%........

; Top mid of OR
	!byte	%........
	!byte	%#######.
	!byte	%########
	!byte	%.......#
	!byte	%.......#
	!byte	%........
	!byte	%........
	!byte	%........

; Bottom mid of OR
	!byte	%........
	!byte	%........
	!byte	%........
	!byte	%.......#
	!byte	%.......#
	!byte	%########
	!byte	%#######.
	!byte	%........

; Top right OR
	!byte	%........
	!byte	%........
	!byte	%........
	!byte	%........
	!byte	%#.......
	!byte	%#.......
	!byte	%#.......
	!byte	%##......

; Bottom right OR
	!byte	%##......
	!byte	%#.......
	!byte	%#.......
	!byte	%#.......
	!byte	%........
	!byte	%........
	!byte	%........
	!byte	%........

; Right mid of OR
	!byte	%.#......
	!byte	%.##.....
	!byte	%..#.....
	!byte	%...#####
	!byte	%...#####
	!byte	%..#.....
	!byte	%.##.....
	!byte	%.#......

; Right mid of NOR
	!byte	%.#......
	!byte	%.##.....
	!byte	%..#..##.
	!byte	%...##..#
	!byte	%...##..#
	!byte	%..#..##.
	!byte	%.##.....
	!byte	%.#......

; ******************* XOR ******************************
; Top left of XOR
	!byte	%........
	!byte	%....#..#
	!byte	%....##.#
	!byte	%######..
	!byte	%#######.
	!byte	%.....##.
	!byte	%......##
	!byte	%......##

; Top left of XOR inverted input
	!byte	%........
	!byte	%....#..#
	!byte	%.##.##.#
	!byte	%#..###..
	!byte	%#..####.
	!byte	%.##..##.
	!byte	%......##
	!byte	%......##

; Bottom left of XOR
	!byte	%......##
	!byte	%......##
	!byte	%.....##.
	!byte	%#######.
	!byte	%######..
	!byte	%....##.#
	!byte	%....#..#
	!byte	%........

; Bottom left of XOR inverted input
	!byte	%......##
	!byte	%......##
	!byte	%.##..##.
	!byte	%#..####.
	!byte	%#..###..
	!byte	%.##.##.#
	!byte	%....#..#
	!byte	%........

; Top mid of XOR
	!byte	%........
	!byte	%#######.
	!byte	%########
	!byte	%#......#
	!byte	%##.....#
	!byte	%.#......
	!byte	%.##.....
	!byte	%.##.....

; Bottom mid of XOR
	!byte	%.##.....
	!byte	%.##.....
	!byte	%.#......
	!byte	%##.....#
	!byte	%#......#
	!byte	%########
	!byte	%#######.
	!byte	%........

; Mid of XOR
	!byte	%.##.....
	!byte	%.##.....
	!byte	%.##.....
	!byte	%.##.....
	!byte	%.##.....
	!byte	%.##.....
	!byte	%.##.....
	!byte	%.##.....

; ******************* NOT/BUFFER ******************************
; Top of NOT
	!byte	%........
	!byte	%........
	!byte	%........
	!byte	%........
	!byte	%....#...
	!byte	%....##..
	!byte	%....###.
	!byte	%....####

; Bottom of NOT
	!byte	%....####
	!byte	%....###.
	!byte	%....##..
	!byte	%....#...
	!byte	%........
	!byte	%........
	!byte	%........
	!byte	%........

; Left of NOT
	!byte	%....##.#
	!byte	%....##..
	!byte	%....##..
	!byte	%######..
	!byte	%######..
	!byte	%....##..
	!byte	%....##..
	!byte	%....##.#

; Left of NOT inverted input
	!byte	%....##.#
	!byte	%....##..
	!byte	%.##.##..
	!byte	%#..###..
	!byte	%#..###..
	!byte	%.##.##..
	!byte	%....##..
	!byte	%....##.#

; Right of NOT
	!byte	%#.......
	!byte	%##......
	!byte	%.##..##.
	!byte	%..###..#
	!byte	%..###..#
	!byte	%.##..##.
	!byte	%##......
	!byte	%#.......

; INPUT/BUTTOM
	!byte	%...##...
	!byte	%..####..
	!byte	%.######.
	!byte	%########
	!byte	%########
	!byte	%.######.
	!byte	%..####..
	!byte	%...##...
