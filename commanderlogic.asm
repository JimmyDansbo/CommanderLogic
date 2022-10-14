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
histbg_palette:
	!word $0100,$0210,$0211,$0410,$0510,$0710,$0321,$0C20
	!word $0532,$0732,$0A21,$0E41,$0E71,$0C95,$0FB1,$0FE2


;******************************************************************************
; Use PETSCII codes to set foreground and background color
;******************************************************************************
!macro SET_COLOR .fg, .bg {
	lda #.bg
	jsr CHROUT
	lda #PET_SWAP_FGBG
	jsr CHROUT
	lda #.fg
	jsr CHROUT
}

;******************************************************************************
; Load a binary file directly into VRAM.
; If address is not specified as parameter, it must be present in header of file
;******************************************************************************
; .name_start:	The label at the start of the filename
; .name_end:	The label at the end of the filename (used for computing length)
; .bank:		Load to Bank 0 or 1 in VRAM
; [.addr]:		Optional address to load file to
;******************************************************************************
!macro VLOAD .name_start, .name_end, .bank {
	lda	#1							; Logical file number (must be unique)
	ldx	#8							; Device number (8 local filesystem)
	ldy	#1							; Secondary command 1 = use addr in file
	jsr	SETLFS
	lda	#(.name_end-.name_start)	; Length of filename
	ldx	#<.name_start				; Address of filename
	ldy	#>.name_start
	jsr	SETNAM
	lda	#.bank+2					; 0=load, 1=verify, 2=VRAM,0xxxx, 3=VRAM,1xxxx
	jsr	LOAD
}
!macro VLOAD .name_start, .name_end, .bank, .addr {
	lda	#1							; Logical file number (must be unique)
	ldx	#8							; Device number (8 local filesystem)
	ldy	#0							; Secondary command 0 = use addr provided to LOAD
	jsr	SETLFS
	lda	#(.name_end-.name_start)	; Length of filename
	ldx	#<.name_start				; Address of filename
	ldy	#>.name_start
	jsr	SETNAM
	lda	#.bank+2					; 0=load, 1=verify, 2=VRAM,0xxxx, 3=VRAM,1xxxx
	ldx #<.addr
	ldy #>.addr
	jsr	LOAD
}

;******************************************************************************
; Entry point of the program
;******************************************************************************
main:
	+VLOAD font_name, font_name_end, 1

	+SET_COLOR PET_WHITE, PET_BLACK
	lda #SCR_MOD_40x30
	jsr Screen_set_mode

	jsr load_img

	rts

;******************************************************************************
; Load image into video RAM, set palette and set layer0 to display it
;******************************************************************************
load_img:
	+VLOAD histbg_name, histbg_name_end, 0

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
