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

histbg_palette:
	!word $0100,$0210,$0211,$0410,$0510,$0710,$0321,$0C20
	!word $0532,$0732,$0A21,$0E41,$0E71,$0C95,$0FB1,$0FE2

hist_ln0:
	!text PET_MIDGRAY,"THE YEAR IS 2525. HUMANKIND HAS",0
hist_ln1:
	!text "SCORCHED THE SKY AND DESTROYED THE",0
hist_ln2:
	!text "EARTHS SURFACE, MAKING IT ALL BUT",0
hist_ln3:
	!text PET_WHITE, "UNINHABITABLE",0
hist_ln4:
	!text PET_MIDGRAY,"YOU FIND YOURSELF IN ONE OF THE",0
hist_ln5:
	!text "LAST LIVEABLE PLACES. TOGETHER WITH",0
hist_ln6:
	!text "OTHER SURVIVORS, YOU FIGHT FOR YOUR",0
hist_ln7:
	!text PET_DARKGRAY,"EXISTENCE",0
hist_ln8:
	!text PET_WHITE,"TO REBUILD SOCIETY, ELECTRONICS AND",0
hist_ln9:
	!text "COMPUTERS WILL BE NECESSARY.",0
hist_ln10:
	!text "YOU ALONE HAVE THE ABILITY TO SAVE",0
hist_ln11:
	!text "SOCIETY BY DESIGNING A CPU AND",0
hist_ln12:
	!text "ENABLE A NEW BEGINNING FOR THE",0
hist_ln13:
	!text "DIGITAL AGE.",0
hist_ln14:
	!text "YOUR FELLOW SURVIVORS HAVE FOUND A",0
hist_ln15:
	!text "STOCK OF OLD, BUT SEEMINGLY WORKING",0
hist_ln16:
	!text "ELECTRONIC PARTS.",0
hist_ln17:
	!text "YOUR TASK:  IDENTIFY THE FUNCTION",0
hist_ln18:
	!text "OF THE DIFFERENT COMPONENTS AND USE",0
hist_ln19:
	!text "THEM TO BUILD THE NEW WORLDS FIRST",0
hist_ln20:
	!text "CENTRAL PROCESSING UNIT",0
old_int:
	!word $0000
delay_counter:
	!byte 0
delay_preset=1
color_delay_cnt:
	!byte 0
color_change:
	!byte 0
color_delay_preset=70
colors:
	!byte $01,$0F,$07,$02,$0B,$08,$09,$00
cur_col:
	!byte 0


;******************************************************************************
; Entry point of the program
;******************************************************************************
main:
	+SAVE_INT_VECTOR old_int
	+INSTALL_INT_HANDLER my_int_routine

	+VLOAD "HISTBG.BIN", 0

	+VLOAD "PARTFONT.BIN", 1
	+SLOAD "ZSBG.BIN"
	+SET_RAM_BANK 2
	+SLOAD "HISTMUSIC.ZSM", RAM_BANK_START, 1
	+SET_RAM_BANK 3
	+SLOAD "GLOOMY.ZSM", RAM_BANK_START, 1

	lda #2
	jsr ZSTART
	jsr show_intro

	jsr CHRIN
	jsr ZDISABLE_LOOP
	ldx #<wait_for_end
	ldy #>wait_for_end
	jsr ZSET_CALLBACK

	jsr CHRIN

	+RESTORE_INT_VECTOR old_int
	jsr CHRIN

	rts

wait_for_end:
	jsr ZSTOP
	lda #3
	jsr ZSTART
	rts
	
my_int_routine:
	lda VERA_ISR
	and #$01
	beq @end

	lda delay_counter
	beq +
	dec delay_counter

+	lda color_change
	beq @end

	lda color_delay_cnt
	beq +
	dec color_delay_cnt
	bra @end
+	jsr change_color
	lda #color_delay_preset
	sta color_delay_cnt

@end:
	lda #$01
	sta VERA_ISR
	jmp (old_int)

change_color:
	lda VERA_CTRL
	ora #$01
	sta VERA_CTRL
	lda #$21
	sta VERA_ADDR_H
	+VERA_GOXY 14, 5
	inc VERA_ADDR_L
	inc cur_col
	ldx cur_col
	lda colors, x
	bne +
	stz color_change
	bra @end
+	ldx #13
-	sta VERA_DATA1
	dex
	bne -
@end:
	lda VERA_CTRL
	and #$FE
	sta VERA_CTRL
	rts

;******************************************************************************
; Load the background image and show the intro screen with the game story
;******************************************************************************
show_intro:
	+SET_COLOR PET_WHITE, PET_BLACK
	lda #SCR_MOD_40x30
	jsr Screen_set_mode
	jsr load_img
	+WRITE_XY 3, 1, hist_ln0
	+WRITE_XY 2, 2, hist_ln1
	+WRITE_XY 2, 3, hist_ln2
	+WRITE_XY 14, 5, hist_ln3
	lda #color_delay_preset
	sta color_delay_cnt
	sta color_change
	+WRITE_XY 3, 7, hist_ln4
	+WRITE_XY 2, 8, hist_ln5
	+WRITE_XY 2, 9, hist_ln6
	+WRITE_XY 15, 11, hist_ln7
	+WRITE_XY 2, 13, hist_ln8
	+WRITE_XY 4, 14, hist_ln9
	+WRITE_XY 2, 16, hist_ln10
	+WRITE_XY 4, 17, hist_ln11
	+WRITE_XY 4, 18, hist_ln12
	+WRITE_XY 13, 19, hist_ln13
	+WRITE_XY 2, 21, hist_ln14
	+WRITE_XY 2, 22, hist_ln15
	+WRITE_XY 11, 23, hist_ln16
	+WRITE_XY 3, 25, hist_ln17
	+WRITE_XY 2, 26, hist_ln18
	+WRITE_XY 2, 27, hist_ln19
	+WRITE_XY 7, 28, hist_ln20
	rts

;******************************************************************************
; Print at string to screen using kernal function, but with a delay between
; each character
; TMP_PTR0 must point to the beginning of the zero-terminated string
;******************************************************************************
print_delayed_str:
    ldy #0
@loop:
	lda (TMP_PTR0), y
	beq	@end
	jsr CHROUT
-	lda delay_counter
	bne -
	lda #delay_preset
	sta delay_counter
	iny
	bra @loop
@end:
	rts

;******************************************************************************
; Print at string to screen using kernal function
; TMP_PTR0 must point to the beginning of the zero-terminated string
;******************************************************************************
print_str:
    ldy #0
@loop:
	lda (TMP_PTR0), y
	beq	@end
	jsr CHROUT
	iny
	bra @loop
@end:
	rts

;******************************************************************************
; Load image into video RAM, set palette and set layer0 to display it
;******************************************************************************
load_img:

	; Overwrite palette starting at offset 16, but do it backwards for ease of
	; checking the number of bytes written.
	+VERA_SET_ADDR $1FA3F, -1
	ldx #31
-	lda	histbg_palette, X
	sta VERA_DATA0
	dex
	bne -

	; Display the image that has just been loaded to VRAM
	lda #%00000110				; Configure bitmap width & 4bit colordepth
	sta VERA_L0_CONFIG

	lda #$00					; BMP start=$0000, Width=320
	sta VERA_L0_TILEBASE

	lda #$01					; Set palette offset
	sta VERA_L0_HSCROLL_H

	+VERA_SET_L0 1				; Enable layer 0
	rts
