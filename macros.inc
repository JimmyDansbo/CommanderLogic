!ifdef MACROS_INC !eof
MACROS_INC=1

;******************************************************************************
; Use draw_gate function to draw a gate at specified coordinates
;******************************************************************************
; .gate:	ID of the gate that should be drawn - see draw_gate function
; .xc & .yc:	X and Y coordinates for upper left corner of gate
; [.color]:	Set new color in global gate_color variable, if omitted the 
;		existing value will be used.
;******************************************************************************
!macro DRAW_GATE .gate, .xc, .yc, .color {
	lda	#.color
	sta	gate_color
	ldx	#.xc
	ldy	#$B0+.xc
	lda	#.gate
	jsr	draw_gate
}
!macro DRAW_GATE .gate, .xc, .yc {
	ldx	#.xc
	ldy	#$B0+.xc
	lda	#.gate
	jsr	draw_gate
}

;******************************************************************************
; Use PETSCII codes to set foreground and background color
;******************************************************************************
; .fg:		PETSCII code to use for foreground color
; [.bg]:	PETSCII code to use for background color
;******************************************************************************
!macro SET_COLOR .fg, .bg {
	lda	#.bg
	jsr	CHROUT
	lda	#PET_SWAP_FGBG
	jsr	CHROUT
	lda	#.fg
	jsr	CHROUT
}
!macro SET_COLOR .fg {
	lda	#.fg
	jsr	CHROUT
}

;******************************************************************************
; Load a binary file directly into VRAM.
; If address is not specified as parameter, it must be present in header of file
;******************************************************************************
; .name:	Name of the file to load as a text string
; .bank:	Load to Bank 0 or 1 in VRAM
; [.addr]:	Optional address to load file to
;******************************************************************************
!macro VLOAD .name, .bank {
	bra +
.locname:
	!text	.name
.len=*-.locname			; Length of .name
+	lda	#1		; Logical file number (must be unique)
	ldx	#8		; Device number (8 local filesystem)
	ldy	#1		; Secondary command 1 = use addr in file
	jsr	SETLFS
	lda	#.len		; Length of filename
	ldx	#<.locname	; Address of filename
	ldy	#>.locname
	jsr	SETNAM
	lda	#.bank+2	; 0=load, 1=verify, 2=VRAM,0xxxx, 3=VRAM,1xxxx
	jsr	LOAD
}
!macro VLOAD .name, .bank, .addr {
	bra +
.locname:
	!text	.name
.len=*-.locname			; Length of .name
+	lda	#1		; Logical file number (must be unique)
	ldx	#8		; Device number (8 local filesystem)
	ldy	#0		; Secondary command 0 = use addr provided to LOAD
	jsr	SETLFS
	lda	#.len		; Length of filename
	ldx	#<.locname	; Address of filename
	ldy	#>.locname
	jsr	SETNAM
	lda	#.bank+2	; 0=load, 1=verify, 2=VRAM,0xxxx, 3=VRAM,1xxxx
	ldx 	#<.addr
	ldy 	#>.addr
	jsr	LOAD
}


;******************************************************************************
; Load a binary file to normal system RAM.
; If address is not given to macro, it must be present in the 2-byte header of
; the file. If .noheader is set, the file is loaded as headerless
;******************************************************************************
; .name:	Name of the file to load as a text string
; [.addr]:	Address to load the file to
; [.noheader]:	Must be set if the file does not have the 2-byte header
;******************************************************************************
!macro SLOAD .name {
	bra +
.locname:
	!text .name		; Length of .name
.len=*-.locname
+	lda	#1		; Logical file number (must be unique)
	ldx	#8		; Device number (8 local filesystem)
	ldy	#1		; Secondary command 1 = use addr in header of file
	jsr	SETLFS
	lda	#.len		; Length of filename
	ldx	#<.locname	; Address of filename
	ldy	#>.locname
	jsr	SETNAM
	lda	#0		; 0=load, 1=verify, 2=VRAM,0xxxx, 3=VRAM,1xxxx
	jsr	LOAD
}
!macro SLOAD .name, .addr {
	bra +
.locname:
	!text .name
.len=*-.locname			; Length of .name
+	lda	#1		; Logical file number (must be unique)
	ldx	#8		; Device number (8 local filesystem)
	ldy	#0		; Secondary command 0 = use addr provided to LOAD
	jsr	SETLFS
	lda	#.len		; Length of filename
	ldx	#<.locname	; Address of filename
	ldy	#>.locname
	jsr	SETNAM
	lda	#0		; 0=load, 1=verify, 2=VRAM,0xxxx, 3=VRAM,1xxxx
	ldx	#<.addr
	ldy	#>.addr
	jsr	LOAD
}
!macro SLOAD .name, .addr, .noheader {
	bra +
.locname:
	!text .name
.len=*-.locname			; Length of .name
+	lda	#1		; Logical file number (must be unique)
	ldx	#8		; Device number (8 local filesystem)
	ldy	#2		; Secondary command 2 = headerless load
	jsr	SETLFS
	lda	#.len		; Length of filename
	ldx	#<.locname	; Address of filename
	ldy	#>.locname
	jsr	SETNAM
	lda	#0		; 0=load, 1=verify, 2=VRAM,0xxxx, 3=VRAM,1xxxx
	ldx	#<.addr
	ldy	#>.addr
	jsr	LOAD
}

;******************************************************************************
; Write a string at specified coordinates using kernal functions
;******************************************************************************
; .str:		String to to write
; [.chr]:	Extra charater to write after string OR x&y coordinates
; [.xc:		X coordinate - optional
; .yc]:		Y coordinate - optional, but required if .xc present
;******************************************************************************
!macro WRITE .str {
	bra	+
.locstr:!text .str,0
+	lda	#<.locstr
	sta	TMP_PTR0
	lda	#>.locstr
	sta	TMP_PTR0+1
	jsr	print_str
}
!macro WRITE .str, .chr {
	bra	+
.locstr:!text .str,0
+	lda	#<.locstr
	sta	TMP_PTR0
	lda	#>.locstr
	sta	TMP_PTR0+1
	jsr	print_str
	lda	#.chr
	jsr	CHROUT
}
!macro WRITE .str, .xc, .yc {
	bra	+
.locstr:!text	.str,0
+	ldx	#.yc
	ldy	#.xc
	jsr	PLOT
	lda	#<.locstr
	sta	TMP_PTR0
	lda	#>.locstr
	sta	TMP_PTR0+1
	jsr	print_str
}

;******************************************************************************
; Increment a 16 bit value
;******************************************************************************
; .num:		Address of LSB of number to be incremented
;******************************************************************************
!macro INC16 .num {
	inc	.num
	bne	+
	inc	.num+1
+
}

;******************************************************************************
; Set the RAM bank
;******************************************************************************
; .bank:	The bank number to set
;******************************************************************************
!macro SET_RAM_BANK .bank {
	lda	#.bank
	sta	RAM_BANK
}
