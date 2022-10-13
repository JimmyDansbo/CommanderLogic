!cpu w65c02

!src "cx16.inc"
+SYS_LINE
!src "vera0.9.inc"
	jmp	main

font_name:
	!text "PARTFONT.BIN"
font_name_end:
histbg_name:
	!text "HISTBG.BIN"
histbg_name_end:
histbg_pal:
	!word $0100,$0210,$0211,$0410,$0510,$0710,$0321,$0C20
	!word $0532,$0732,$0A21,$0E41,$0E71,$0C95,$0FB1,$0FE2


!macro SET_COLOR .fg, .bg {
	lda #.bg
	jsr CHROUT
	lda #PET_SWAP_FGBG
	jsr CHROUT
	lda #.fg
	jsr CHROUT
}

;******************************************************************************
; Entry point of the program
;******************************************************************************
main:
	jsr	load_font

	+SET_COLOR PET_WHITE, PET_BLACK
	lda #SCR_MOD_40x30
	jsr Screen_set_mode

	jsr load_img

	rts

;******************************************************************************
; Load image into video RAM, set palette and set layer0 to display it
;******************************************************************************
load_img:
	lda	#1								; Logical file number (must be unique)
	ldx	#8								; Device number (8 local filesystem)
	ldy	#1								; Secondary command 1 = use addr in file
	jsr	SETLFS
	lda	#(histbg_name_end-histbg_name)	; Length of filename
	ldx	#<histbg_name					; Address of filename
	ldy	#>histbg_name
	jsr	SETNAM
	lda	#2								; 0=load, 1=verify, 2=VRAM,0xxxx, 3=VRAM,1xxxx
	jsr	LOAD

	; Overwrite palette starting at offset 16
	+VERA_SET_ADDR $1FA3F, -1
	ldx #31
-	lda	histbg_pal, X
	sta VERA_DATA0
	dex
	bne -

	; Display the image that has just been loaded to VRAM
	lda #%00000110						; Configure bitmap with 4bit color depth
	sta VERA_L0_CONFIG

	lda #$00							; BMP start=$0000, Width=320
	sta VERA_L0_TILEBASE

	lda #$01							; Set palette offset
	sta VERA_L0_HSCROLL_H

	lda #$10							; Enable Layer 0
	ora VERA_DC_VIDEO
	sta VERA_DC_VIDEO
	rts
	
;******************************************************************************
; Load partial font directly in to VRAM
; Uses font_name and font_name_end
;******************************************************************************
load_font:
	lda	#1							; Logical file number (must be unique)
	ldx	#8							; Device number (8 local filesystem)
	ldy	#1							; Secondary command 1 = use addr in file
	jsr	SETLFS
	lda	#(font_name_end-font_name)	; Length of filename
	ldx	#<font_name					; Address of filename
	ldy	#>font_name
	jsr	SETNAM
	lda	#3							; 0=load, 1=verify, 2=VRAM,0xxxx, 3=VRAM,1xxxx
	jsr	LOAD
	rts
