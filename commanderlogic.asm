!cpu w65c02

!src "cx16.inc"
+SYS_LINE
!src "vera0.9.inc"
!src "macros.inc"

	jmp	main

ZSTART			= $8000
ZSTOP			= $8003
ZSET_CALLBACK		= $8006
ZCLEAR_CALLBACK		= $8009
ZFORCE_LOOP		= $800C
ZDISABLE_LOOP		= $800F
ZSET_MUSIC_SPEED	= $8012
HEADERLESS		= 1

histbg_palette:
	!word $0100,$0210,$0211,$0410,$0510,$0710,$0321,$0C20
	!word $0532,$0732,$0A21,$0E41,$0E71,$0C95,$0FB1,$0FE2

old_int:!word $0000

delay_preset=1
color_delay_preset=70

delay_counter:
	!byte 0

color_delay_cnt:
	!byte 0
color_change:
	!byte 0
cur_col:
	!byte 0
colors:
	!byte WHITE,LIGHTGRAY,YELLOW,RED,DARKGRAY,ORANGE,BROWN,0


;******************************************************************************
; Entry point of the program
;******************************************************************************
main:
	+SAVE_INT_VECTOR old_int
	+INSTALL_INT_HANDLER my_int_routine

	+WRITE "LOADING IMAGE...", 13
	+VLOAD "HISTBG.BIN", 0
	+WRITE "LOADING FONT...", 13
	+VLOAD "PARTFONT.BIN", 1
	+WRITE "LOADING ZSOUND...", 13
	+SLOAD "ZSBG.BIN"
	+WRITE "LOADING MUSIC...", 13
	+SET_RAM_BANK 2
	+SLOAD "HISTMUSIC.ZSM", RAM_BANK_START, HEADERLESS
	+SET_RAM_BANK 3
	+SLOAD "GLOOMY.ZSM", RAM_BANK_START, HEADERLESS
	+SET_RAM_BANK 4
	+SLOAD "UPBEAT.ZSM", RAM_BANK_START, HEADERLESS

	+SET_RAM_BANK 2
	jsr	ZSTART
	jsr	show_intro

;	jsr	CHRIN
	ldx	#<wait_for_end
	ldy	#>wait_for_end
	jsr	ZSET_CALLBACK

	jsr	CHRIN

	+RESTORE_INT_VECTOR old_int
	jsr	CHRIN

	rts
mahh	!byte	0
wait_for_end:
	inc	mahh
	lda	mahh
	cmp	#1
	bne	+
	jsr	ZSTOP
	+SET_RAM_BANK 3
	jsr	ZSTART
	ldx	#<wait_for_end
	ldy	#>wait_for_end
	jsr	ZSET_CALLBACK
	rts
+	cmp	#4
	bne	+
	jsr	ZSTOP
	+SET_RAM_BANK 4
	jsr	ZSTART
	ldx	#<wait_for_end
	ldy	#>wait_for_end
	jsr	ZSET_CALLBACK
	rts
+	cmp	#7
	bne	+
	jsr	ZSTOP
	+SET_RAM_BANK 2
	jsr	ZSTART
	ldx	#<wait_for_end
	ldy	#>wait_for_end
	jsr	ZSET_CALLBACK
	rts
+	cmp	#8
	bne	+
	stz	mahh
+	rts

my_int_routine:
	lda	VERA_ISR
	and	#$01
	beq	@end

	lda	delay_counter
	beq	+
	dec	delay_counter

+	lda	color_change
	beq	@end

	lda	color_delay_cnt
	beq	+
	dec	color_delay_cnt
	bra	@end
+	jsr	change_color
	lda	#color_delay_preset
	sta	color_delay_cnt
@end:	lda	#$01
	sta	VERA_ISR
	jmp	(old_int)

change_color:
	lda	VERA_CTRL
	ora	#$01
	sta	VERA_CTRL
	lda	#$21
	sta	VERA_ADDR_H
	+VERA_GOXY 14, 5
	inc	VERA_ADDR_L
	inc	cur_col
	ldx	cur_col
	lda	colors, x
	bne	+
	stz	color_change
	bra	@end
+	ldx	#13
-	sta	VERA_DATA1
	dex
	bne	-
@end:	lda	VERA_CTRL
	and	#$FE
	sta	VERA_CTRL
	rts

;******************************************************************************
; Show the background image and the intro screen with the game story
;******************************************************************************
show_intro:
	+SET_COLOR PET_WHITE, PET_BLACK
	lda	#SCR_MOD_40x30
	jsr	Screen_set_mode
	jsr	show_img
	+SET_COLOR PET_MIDGRAY
	+WRITE_XY 3, 1,   "THE YEAR IS 2525. HUMANKIND HAS"
	+WRITE_XY 2, 2,   "SCORCHED THE SKY AND DESTROYED THE"
	+WRITE_XY 2, 3,   "EARTHS SURFACE, MAKING IT ALL BUT"
	+SET_COLOR PET_WHITE
	+WRITE_XY 14, 5,  "UNINHABITABLE"
	lda	#color_delay_preset
	sta	color_delay_cnt
	sta	color_change
	+SET_COLOR PET_MIDGRAY
	+WRITE_XY 3, 7,   "YOU FIND YOURSELF IN ONE OF THE"
	+WRITE_XY 2, 8,   "LAST LIVEABLE PLACES. TOGETHER WITH"
	+WRITE_XY 2, 9,   "OTHER SURVIVORS, YOU FIGHT FOR YOUR"
	+SET_COLOR PET_DARKGRAY
	+WRITE_XY 15, 11, "EXISTENCE"
	+SET_COLOR PET_WHITE
	+WRITE_XY 2, 13,  "TO REBUILD SOCIETY, ELECTRONICS AND"
	+WRITE_XY 4, 14,  "COMPUTERS WILL BE NECESSARY."
	+WRITE_XY 2, 16,  "YOU ALONE HAVE THE ABILITY TO SAVE"
	+WRITE_XY 4, 17,  "SOCIETY BY DESIGNING A CPU AND"
	+WRITE_XY 4, 18,  "ENABLE A NEW BEGINNING FOR THE"
	+WRITE_XY 13, 19, "DIGITAL AGE."
	+WRITE_XY 2, 21,  "YOUR FELLOW SURVIVORS HAVE FOUND A"
	+WRITE_XY 2, 22,  "STOCK OF OLD, BUT SEEMINGLY WORKING"
	+WRITE_XY 11, 23, "ELECTRONIC PARTS."
	+WRITE_XY 3, 25,  "YOUR TASK:  IDENTIFY THE FUNCTION"
	+WRITE_XY 2, 26,  "OF THE DIFFERENT COMPONENTS AND USE"
	+WRITE_XY 2, 27,  "THEM TO BUILD THE NEW WORLDS FIRST"
	+WRITE_XY 7, 28,  "CENTRAL PROCESSING UNIT"
	rts

;******************************************************************************
; Print at string to screen using kernal function, but with a delay between
; each character
; TMP_PTR0 must point to the beginning of the zero-terminated string
;******************************************************************************
print_delayed_str:
	ldy	#0
@loop:	lda	(TMP_PTR0), y
	beq	@end
	jsr	CHROUT
-	lda	delay_counter
	bne	-
	lda	#delay_preset
	sta	delay_counter
	iny
	bra	@loop
@end:	rts

;******************************************************************************
; Print at string to screen using kernal function
; TMP_PTR0 must point to the beginning of the zero-terminated string
;******************************************************************************
print_str:
	ldy	#0
@loop:	lda	(TMP_PTR0), y
	beq	@end
	jsr	CHROUT
	iny
	bra	@loop
@end:	rts

;******************************************************************************
; Set palette and set layer0 to display it background image
;******************************************************************************
show_img:
	; Overwrite palette starting at offset 16, but do it backwards for ease of
	; checking the number of bytes written.
	+VERA_SET_ADDR $1FA3F, -1
	ldx	#31
-	lda	histbg_palette, X
	sta	VERA_DATA0
	dex
	bne	-

	; Display the image that has just been loaded to VRAM
	lda	#%00000110	; Configure bitmap width & 4bit colordepth
	sta	VERA_L0_CONFIG

	lda	#$00		; BMP start=$0000, Width=320
	sta	VERA_L0_TILEBASE

	lda	#$01		; Set palette offset
	sta	VERA_L0_HSCROLL_H

	+VERA_SET_L0 1		; Enable layer 0
	rts
