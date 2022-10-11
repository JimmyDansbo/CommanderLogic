!cpu w65c02

!src "cx16.inc"
+SYS_LINE
!src "vera0.9.inc"
	jmp	main

font_name:
	!text "PARTFONT.BIN"
font_name_end:

;******************************************************************************
; Entry point of the program
;******************************************************************************
main:
	jsr	load_font
	rts

;******************************************************************************
; Load partial font directly in to VRAM
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
