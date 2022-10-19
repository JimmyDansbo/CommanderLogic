!cpu w65c02

!src "cx16.inc"
+SYS_LINE
!src "vera0.9.inc"
!src "macros.inc"
!src "simfuncs.inc"

	jmp	main

ZINIT_PLAYER		= $8000
ZSTEPMUSIC		= ZINIT_PLAYER	  +3
ZPLAYMUSIC		= ZSTEPMUSIC	  +3
ZPLAYMUSIC_IRQ		= ZPLAYMUSIC	  +3
ZSTARTMUSIC		= ZPLAYMUSIC_IRQ  +3
ZSTOPMUSIC		= ZSTARTMUSIC	  +3
ZSET_MUSIC_SPEED	= ZSTOPMUSIC	  +3
ZFORCE_LOOP		= ZSET_MUSIC_SPEED+3
ZSET_LOOP		= ZFORCE_LOOP	  +3
ZDISABLE_LOOP		= ZSET_LOOP	  +3
ZSET_CALLBACK		= ZDISABLE_LOOP	  +3
ZCLEAR_CALLBACK		= ZSET_CALLBACK	  +3
ZGET_MUSIC_SPEED	= ZCLEAR_CALLBACK +3

HEADERLESS		= 1
DELAY_PRESET		= 1
COLOR_DELAY_PRESET	= 70

gate_color:
	!byte	0
semaphore:
	!byte	0
histbg_palette:
	!word	$0100,$0210,$0211,$0410,$0510,$0710,$0321,$0C20
	!word	$0532,$0732,$0A21,$0E41,$0E71,$0C95,$0FB1,$0FE2
tile_palette:
	!word	$0001,$0111,$0111,$0111,$0211,$0211,$0211,$0211
	!word	$0321,$0321,$0421,$0421,$0532,$0631,$0742,$0742

old_int:!word	$0000		; Hold address of original interrupt handler

delay_counter:
	!byte	0
color_delay_cnt:
	!byte	0
color_change:
	!byte	0
cur_col:!byte	0
colors:	!byte	WHITE,LIGHTGRAY,YELLOW,RED,DARKGRAY,ORANGE,BROWN,0
intro_text:
	!text	3,   1, PET_MIDGRAY,	"THE YEAR IS 2525. HUMANKIND HAS",0
	!text	2,   2, PET_MIDGRAY,	"SCORCHED THE SKY AND DESTROYED THE",0
	!text	2,   3, PET_MIDGRAY,	"EARTHS SURFACE, MAKING IT ALL BUT",0
	!text	14,  5, PET_WHITE,	"UNINHABITABLE",0
	!text	3,   7, PET_MIDGRAY,	"YOU FIND YOURSELF IN ONE OF THE",0
	!text	2,   8, PET_MIDGRAY,	"LAST LIVEABLE PLACES. TOGETHER WITH",0
	!text	2,   9, PET_MIDGRAY,	"OTHER SURVIVORS, YOU FIGHT FOR YOUR",0
	!text	15, 11, PET_DARKGRAY,	"EXISTENCE",0
	!text	2,  13, PET_WHITE,	"TO REBUILD SOCIETY, ELECTRONICS AND",0
	!text	2,  14, PET_WHITE,	"COMPUTERS WILL BE NECESSARY.",0
	!text	2,  16, PET_WHITE,	"YOU ALONE HAVE THE ABILITY TO SAVE",0
	!text	4,  17, PET_WHITE,	"SOCIETY BY DESIGNING A CPU AND",0
	!text	4,  18, PET_WHITE,	"ENABLE A NEW BEGINNING FOR THE",0
	!text	13, 19, PET_WHITE,	"DIGITAL AGE.",0
	!text	2,  21, PET_WHITE,	"YOUR FELLOW SURVIVORS HAVE FOUND A",0
	!text	2,  22, PET_WHITE,	"STOCK OF OLD, BUT SEEMINGLY WORKING",0
	!text	9,  23, PET_WHITE,	"ELECTRONIC COMPONENTS.",0
	!text	3,  25, PET_WHITE,	"YOUR TASK:  IDENTIFY THE FUNCTION",0
	!text	7,  26, PET_WHITE,	"OF THE COMPONENTS AND USE",0
	!text	2,  27, PET_WHITE,	"THEM TO BUILD THE NEW WORLDS FIRST",0
	!text	7,  28, PET_WHITE,	"CENTRAL PROCESSING UNIT",0,0

; STORY:
; IT SEEMS THAT ALL OF THE
; COMPONENTS ARE OF THE
; SAME TYPE, BUT THERE IS NO
; INFORMATION ON WHAT TYPE
; OF COMPONENT IT IS.
; TO HAVE ANY CHANCE OF
; BUILDING A CPU, YOU NEED
; TO IDENTIFY THE FUNCTION
; OF THE COMPONENTS

; TASK:
; IDENTIFY FUNCTION
; OF THE COMPONENT

;******************************************************************************
; Entry point of the program
;******************************************************************************
main:
	jsr	initialize	; Load assets
	jsr	intro		; Show the intro

	; The callback function changes from intro music to game music
	ldx	#<switch_to_game_music
	ldy	#>switch_to_game_music
	jsr	ZSET_CALLBACK

	lda	#SCR_MOD_80x60
	clc
	jsr	Screen_set_mode
	jsr	init_game

@loop:	wai
	lda	semaphore
	bne	@loop		; Check if VSYNC has happened
	inc	semaphore	; Set semaphore to wait for next VSYNC
	jsr	playmusic	; Ensure music is playing
	jsr	GETIN
	beq	@loop

	jsr	ZSTOPMUSIC
	+RESTORE_INT_VECTOR old_int
	rts

init_game:
	jsr	ena_l0_tilemap
	+DRAW_GATE NAND_GATE, 3, 3, (BLUE<<4)+BLACK
	+WRITE "PROGRESS: 00%", 1, 1
	+WRITE "YOUR WORKSPACE", 50, 1
	jsr	draw_board

;******************************************************************************
; Set layer0 to display 4bpp tiles
; Tilemap starts at $09600 where the intro image ends
; Tiles are loaded to $04800 which is the closest address to the end of tilemap
;******************************************************************************
ena_l0_tilemap:
	; Tilemap is 32x32 tiles at 16 colors (4bpp)
	lda	#(TILES32<<6)+(TILES32<<4)+BPP4	
	sta	VERA_L0_CONFIG

	; Set the mapbase (equal to 1B000 for normal textmode)
	lda	#($9600>>9)
	sta	VERA_L0_MAPBASE

	; Set the tilebase (equal to 1F000 for normal textmode)
	lda	#(($A800>>11)<<2)+(PIX16<<1)+PIX16
	sta	VERA_L0_TILEBASE
	
	; No scrolling needeed
	stz	VERA_L0_HSCROLL_L
	stz	VERA_L0_HSCROLL_H
	stz	VERA_L0_VSCROLL_L
	stz	VERA_L0_VSCROLL_H

	; Fill all 32x32 tiles, but do some flipping of the tile
	+VERA_SET_ADDR $09600, 1
	lda	#$20
	ldx	#32
--	ldy	#32
-	stz	VERA_DATA0
	sta	VERA_DATA0
	cmp	#$20		; If .A=#$20 Then set .A=#$28
	bne	+
	lda	#$28		; V-flip set
	bra	@decy
+	cmp	#$28		; If .A=#$28 then set .A=#$24
	bne	+
	lda	#$24		; H-flip set
	bra	@decy
+	cmp	#$24		; If .A=#$24 then set .A=#$20
	bne	@decy
	lda	#$20		; No flip set
@decy	dey
	bne	-
	dex
	bne	--
	+VERA_SET_L0 1		; Enable layer 0
	rts

;******************************************************************************
; Draw the green board/workspace, also used for clearing the board between
; levels
;******************************************************************************
draw_board:
	+VERA_SET_ADDR $1EB9F, -1	; color address of bottom right corner
	lda	#(GREEN<<4)+BLACK	; Green background with black text
	ldx	#' '			; Space character
	ldy	#57
	sty	TMP0			; 3 lines at top of screen for text
--	ldy	#48
-	sta	VERA_DATA0		; Write color information
	stx	VERA_DATA0		; Write character
	dey
	bne	-
	ldy	#$9F			; Reset X coordinate
	sty	VERA_ADDR_L
	dec	VERA_ADDR_M		; Decrement Y coordinate
	dec	TMP0
	bne	--
	rts

;******************************************************************************
; Stop the currently playing music, start the game music and remove the 
; callback function
;******************************************************************************
switch_to_game_music:
	jsr	ZCLEAR_CALLBACK
	lda	#3		; RAM bank with game music
	ldx	#<RAM_BANK_START
	ldy	#>RAM_BANK_START
	jsr	ZSTARTMUSIC
@end:	rts

;******************************************************************************
; Handle the intro screen of the game, making sure that assets are shown and
; music is playing
;******************************************************************************
intro:
	+SET_COLOR PET_MIDGRAY, PET_BLACK
	lda	#SCR_MOD_40x30
	jsr	Screen_set_mode
	jsr	show_img

	lda	#2		; RAM bank with intro music
	ldx	#<RAM_BANK_START
	ldy	#>RAM_BANK_START
	jsr	ZSTARTMUSIC

	; Prepare pointer on ZeroPage to write intro text to screen
	lda	#<intro_text
	sta	TMP_PTR0
	lda	#>intro_text
	sta	TMP_PTR0+1
	lda	(TMP_PTR0)	; Read X coordinate
	tay
	+INC16	TMP_PTR0
	lda	(TMP_PTR0)	; Read Y coordinate
	tax
	clc
	jsr	PLOT		; Place cursor at coordinates
	+INC16	TMP_PTR0	; Read color
	lda	(TMP_PTR0)
	jsr	CHROUT		; Write color
	+INC16	TMP_PTR0	; Prepare for letter

	lda	#DELAY_PRESET
	sta	delay_counter
	stz	color_change
	lda	#COLOR_DELAY_PRESET
	sta	color_delay_cnt

	; This loop runs while text is being written to screen
@loop:	wai
	lda	semaphore
	bne	@loop		; Check if VSYNC has happened
	inc	semaphore	; Set semaphore to wait for next VSYNC
	jsr	playmusic	; Ensure music is playing

	lda	color_change
	beq	+
	; Only do colorchange when the correct word has been written
	dec	color_delay_cnt
	bne	+
	; Change color after delay
	jsr	change_color
+	dec	delay_counter
	beq	+
	bra	@loop
+	lda	#DELAY_PRESET
	sta	delay_counter
	; Write a letter
	jsr	delayed_write
	bcc	@loop		; If Cary Clear, we are still writing text

	; When all text has been written, wait for keypress before continuing
@waitkey:
	wai
	lda	semaphore
	bne	@loop		; Check if VSYNC has happened
	inc	semaphore	; Set semaphore to wait for next VSYNC
	jsr	playmusic	; Ensure music is playing
	jsr	GETIN
	cmp	#0
	beq	@waitkey
	rts

;******************************************************************************
; Change the color of the word UNINHABITABLE
;******************************************************************************
change_color:
	lda	VERA_CTRL
	ora	#$01
	sta	VERA_CTRL	; Set ADDRSEL to use VERA_DATA1 port
	lda	#$21
	sta	VERA_ADDR_H	; Set bank 1 and increment by 2
	+VERA_GOXY 14, 5
	inc	VERA_ADDR_L	; Move to color RAM instead of char RAM
	inc	cur_col
	ldx	cur_col
	lda	colors, x	; Load next color
	bne	+		; If color is 0, we are done changing color
	stz	color_change
	bra	@end
+	ldx	#13		; Change charactercolor of line that says
-	sta	VERA_DATA1	; UNINHABITABLE
	dex
	bne	-
@end:	lda	VERA_CTRL	; Restore ADDRSEL to 0 for normal operation
	and	#$FE
	sta	VERA_CTRL
	lda	#COLOR_DELAY_PRESET
	sta	color_delay_cnt
	rts

;******************************************************************************
; Use ZeroPage pointer to write intro text one character at a time
;******************************************************************************
delayed_write:
	lda	(TMP_PTR0)
	beq	+		; If 0 is read, end of line is reached
	jsr	CHROUT		; Print character and prepare for next char
	+INC16	(TMP_PTR0)
	bra	@end
+	+INC16	(TMP_PTR0)	; Go to next char in text
	lda	(TMP_PTR0)
	bne	+		; If 0 is read, end of text is reached.
	sec			; Set carry and return
	rts
+	tay			; Store X coordinate for PLOT function
	+INC16	TMP_PTR0
	lda	(TMP_PTR0)
	tax			; Store Y coordinate for PLOT function
	cpx	#7		; If Y coordinate is 7, we have just written
	bne	+		; the word UNINHABITABLE and we can start to
	inc	color_change	; change to color of the word
+	clc
	jsr	PLOT		; Move cursor
	+INC16	TMP_PTR0
	lda	(TMP_PTR0)
	jsr	CHROUT
	+INC16	TMP_PTR0	; Prepare for next char
@end	clc			; Ensure carry is cleared before return
	rts

;******************************************************************************
; Ensure that VERA address and control registers are saved and restored
; when calling ZPLAYMUSIC as it clobbers them
;******************************************************************************
playmusic:
	lda	VERA_CTRL
	sta	TMPf
	lda	VERA_ADDR_H
	sta	TMPe
	lda	VERA_ADDR_M
	sta	TMPd
	lda	VERA_ADDR_L
	sta	TMPc
	jsr	ZPLAYMUSIC
	lda	TMPc
	sta	VERA_ADDR_L
	lda	TMPd
	sta	VERA_ADDR_M
	lda	TMPe
	sta	VERA_ADDR_H
	lda	TMPf
	sta	VERA_CTRL
	rts

;******************************************************************************
; Load assets and install interrupt handler
;******************************************************************************
initialize:
	+WRITE "LOADING IMAGES...", 13
	+VLOAD "HISTBG.BIN", 0			; Loads to $00000
	+VLOAD "WALLTILE.BIN", 0		; Loads to $04800
	+WRITE "LOADING FONT...", 13		; Loads to $1
	+VLOAD "PARTFONT.BIN", 1		; Loads to $1F6C0
	+WRITE "LOADING ZSOUND...", 13
	+SLOAD "ZSBG.BIN"			; Loads to $8000
	+WRITE "LOADING MUSIC...", 13
	+SET_RAM_BANK 2
	+SLOAD "HISTMUSIC.ZSM", RAM_BANK_START, HEADERLESS
	+SET_RAM_BANK 3
	+SLOAD "GAMEMUSIC.ZSM", RAM_BANK_START, HEADERLESS

	; Overwrite palette starting at offset 16, but do it backwards for ease of
	; checking the number of bytes written.
	+VERA_SET_ADDR $1FA3F, -1
	ldx	#31
-	lda	histbg_palette, X
	sta	VERA_DATA0
	dex
	bne	-
	; Overwrite palette starting at offset 32, but do it backwards for ease of
	; checking the number of bytes written.
	+VERA_SET_ADDR $1FA5F, -1
	ldx	#31
-	lda	tile_palette, X
	sta	VERA_DATA0
	dex
	bne	-

	jsr	ZINIT_PLAYER

	+SAVE_INT_VECTOR old_int
	+INSTALL_INT_HANDLER irqhandler
	rts

;******************************************************************************
; Function sets the global semaphore variable to zero on each VSYNC interrupt
;******************************************************************************
irqhandler:
	lda	VERA_ISR
	and	#VSYNC_BIT	; Check if this is the VSYNC interrupt
	beq	@end
	sta	VERA_ISR	; Acknowledge VSYNC
	stz	semaphore	; Indicate that VSYNC has happened
@end:	jmp	(old_int)	; Let the KERNAL do its thing

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
; Set layer0 to display the background image
;******************************************************************************
show_img:
	; Display the image that has just been loaded to VRAM
	lda	#%00000110	; Configure bitmap width & 4bit colordepth
	sta	VERA_L0_CONFIG

	lda	#$00		; BMP start=$0000, Width=320
	sta	VERA_L0_TILEBASE

	lda	#$01		; Set palette offset
	sta	VERA_L0_HSCROLL_H

	+VERA_SET_L0 1		; Enable layer 0
	rts
