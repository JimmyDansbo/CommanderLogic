!ifdef CX16_INC !eof
CX16_INC=1

KERNALVER	= $FF80
VIA1		= $9F00
VIA1PA		= VIA1+1
VIA1PB		= VIA1+0
VIA2		= $9F10
VIA2PA		= VIA2+1
VIA2PB		= VIA2+0

RAM_BANK_START	= $A000
ROM_BANK_START	= $C000

; RAM/ROM bank control for PRE_RELEASE_VERSION=39+
RAM_BANK	= $00
ROM_BANK	= $01

; Emulator
GIFCTRL		= $9FB5
WAVCTRL		= $9FB6

; IRQ
IRQVECTOR	= $0314

; Text mode ports (not supported and changes between ROM releases)
COLORPORT	= $0376
NUMCOLS		= $0386
NUMLINES	= $0387

; ROM Bank allocations
KERNAL_BANK	= 0
KEYBD_BANK	= 1
CBDOS_BANK	= 2
GEOS_BANK	= 3
BASIC_BANK	= 4
MONITOR_BANK	= 5
CHARSET_BANK	= 6
CODEX_BANK	= 7

; ZeroPage variables/pointers
TMP0		= $30
TMP1		= $31
TMP2		= $32
TMP3		= $33
TMP4		= $34
TMP5		= $35
TMP6		= $36
TMP7		= $37
TMP8		= $38
TMP9		= $39
TMPa		= $3A
TMPb		= $3B
TMPc		= $3C
TMPd		= $3D
TMPe		= $3E
TMPf		= $3F
TMP_PTR0	= TMP0
TMP_PTR1	= TMP2
TMP_PTR2	= TMP4
TMP_PTR3	= TMP6
TMP_PTR4	= TMP8
TMP_PTR5	= TMPa
TMP_PTR6	= TMPc
TMP_PTR7	= TMPe


; PETSCII color codes
PET_BLACK	= $90
PET_WHITE	= $05
PET_RED		= $1C
PET_CYAN	= $9F
PET_PURPLE	= $9C
PET_GREEN	= $1E
PET_BLUE	= $1F
PET_YELLOW	= $9E
PET_ORANGE	= $81
PET_BROWN	= $95
PET_LIGHTRED	= $96
PET_DARKGRAY	= $97
PET_MIDGRAY	= $98
PET_LIGHTGREEN	= $99
PET_LIGHTBLUE	= $9A
PET_LIGHTGRAY	= $9B

; PETSCII control codes
PET_SWAP_FGBG	= $01	; Swap foregound- & background- color
PET_STOP	= $03
PET_UNDERLINE	= $04	; only works in graphics text mode
PET_BOLD	= $06	; only works in graphics text mode
PET_BELL	= $07	; not yet implemented 27/01 2021
PET_BACKSPACE	= $08	; not yet implemented 27/01 2021
PET_TAB		= $09	; not yet implemented 27/01 2021
PET_LINEFEED	= $0A	; not yet implemented 27/01 2021
PET_ITALICS	= $0B	; only works in graphics text mode
PET_OUTLINE	= $0C	; only works in graphics text mode
PET_RETURN	= $0D
PET_CHR_LO_UP	= $0E	; Switch between lower and upper character set
PET_ISO_ON	= $0F	; Enable ISO mode
PET_CSR_DOWN	= $11	; Move cursor down
PET_REVERSE	= $12
PET_HOME	= $13
PET_DELETE	= $14
PET_SHIFT_TAB	= $18	; not yet implemented 27/01 2021
PET_CSR_RIGHT	= $1D	; Move cursor right
PET_RUN		= $83
PET_HELP	= $84
PET_SHIFT_RET	= $8D	; Shift+Return
PET_UP_GFX_CHAR	= $8E
PET_ISO_OFF	= $8F	; Disable ISO mode
PET_CSR_UP	= $91	; Move cursor up
PET_REVERSE_OFF	= $92
PET_CLEAR	= $93	; Clear screen
PET_INSERT	= $94
PET_CSR_LEFT	= $9D	; Move cursor left

; Color values
BLACK		= 0
WHITE		= 1
RED		= 2
CYAN		= 3
PURPLE		= 4
GREEN		= 5
BLUE		= 6
YELLOW		= 7
ORANGE		= 8
BROWN		= 9
LIGHTRED	= 10
DARKGRAY	= 11
MIDGRAY		= 12
LIGHTGREEEN	= 13
LIGHTBLUE	= 14
LIGHTGRAY	= 15

; VERA screen modes
SCR_MOD_80x60	= $00
SCR_MOD_80x30	= $01
SCR_MOD_40x60	= $02
SCR_MOD_40x30	= $03
SCR_MOD_40x15	= $04
SCR_MOD_20x30	= $05
SCR_MOD_20x15	= $06
SCR_GFX_320x200	= $80	; 320x200@256c - 40x25 text
SCR_GFX_640x400 = $81	; 640x400@16c (unsupported)
SCR_MOD_TOGGLE	= $FF	; Toggle between $00 and $03

; Joystick button values
SNES_B		= $80
SNES_Y		= $40
SNES_SEL	= $20
SNES_STA	= $10
SNES_UP		= $08
SNES_DN		= $04
SNES_LT		= $02
SNES_RT		= $01
SNES_A		= $80
SNES_X		= $40
SNES_L		= $20
SNES_R		= $10

; "ABI" registers in ZeroPage
r0		= $02
r0l		= r0
r0h		= r0+1
r1		= $04
r1l		= r1
r1h		= r1+1
r2		= $06
r2l		= r2
r2h		= r2+1
r3		= $08
r3l		= r3
r3h		= r3+1
r4		= $0A
r4l		= r4
r4h		= r4+1
r5		= $0C
r5l		= r5
r5h		= r5+1
r6		= $0E
r6l		= r6
r6h		= r6+1
r7		= $10
r7l		= r7
r7h		= r7+1
r8		= $12
r8l		= r8
r8h		= r8+1
r9		= $14
r9l		= r9
r9h		= r9+1
r10		= $16
r10l		= r10
r10h		= r10+1
r11		= $18
r11l		= r11
r11h		= r11+1
r12		= $1A
r12l		= r12
r12h		= r12+1
r13		= $1C
r13l		= r13
r13h		= r13+1
r14		= $1E
r14l		= r14
r14h		= r14+1
r15		= $20
r15l		= r15
r15h		= r15+1

; extra registers in ZeroPage - not used by CX16 kernal, but shown in debugger
x16		= $22
x16l		= x16
x16h		= x16+1
x17		= $24
x17l		= x17
x17h		= x17+1
x18		= $26
x18l		= x18
x18h		= x18+1
x19		= $28
x19l		= x19
x19h		= x19+1

; extra registers in ZeroPage - not used by CX16 at all
z20		= $2A
z20l		= z20
z20h		= z20+1
z21		= $2C
z21l		= z21
z21h		= z21+1
z22		= $2E
z22l		= z22
z22h		= z22+1

; Commodore 64 API - see https://cx16.dk/c64-kernal-routines/
ACPTR		= $FFA5
IECIN		= $FFA5
CHKIN		= $FFC6
CHKOUT		= $FFC9
CHRIN		= $FFCF
BASIN		= $FFCF
CHROUT		= $FFD2
BSOUT		= $FFD2
CIOUT		= $FFA8
IECOUT		= $FFA8
CINT		= $FF81
CLALL		= $FFE7
CLOSE		= $FFC3
CLRCHN		= $FFCC
GETIN		= $FFE4
IOBASE		= $FFF3
IOINIT		= $FF84
LISTEN		= $FFB1
LOAD		= $FFD5
MEMBOT		= $FF9C
MEMTOP		= $FF99
OPEN		= $FFC0
PLOT		= $FFF0
RAMTAS		= $FF87
RDTIM		= $FFDE
READST		= $FFB7
RESTOR		= $FF8A
SAVE		= $FFD8
SCNKEY		= $FF9F
SCREEN		= $FFED
SECOND		= $FF93
SETLFS		= $FFBA
SETMSG		= $FF90
SETNAM		= $FFBD
SETTIM		= $FFDB
SETTMO		= $FFA2
STOP		= $FFE1
TALK		= $FFB4
TKSA		= $FF96
UDTIM		= $FFEA
UNLSN		= $FFAE
UNTLK		= $FFAB
VECTOR		= $FF8D

; Commodore 128 API
CLOSE_ALL	= $FF4A
LKUPLA		= $FF8D
LKUPSA		= $FF8A
DLCHR		= $FF62
PFKEY		= $FF65
FETCH		= $FF74
STASH		= $FF77
CMPARE		= $FF7A
PRIMM		= $FF7D

; Commander X16 API
;clock
Clock_set_data_time	= $FF4D
Clock_get_date_time	= $FF50
;mouse
Mouse_config		= $FF68
Mouse_scan		= $FF71
Mouse_get		= $FF6B
;joystick
Joystick_scan		= $FF53
Joystick_get		= $FF56
;sprites
Sprite_set_image	= $FEF0
Sprite_set_position	= $FEF3
;framebuffer
FB_init			= $FEF6
FB_get_info		= $FEF9
FB_set_palette		= $FEFC
FB_cursor_position	= $FEFF
FB_cursor_next_line	= $FF02
FB_get_pixel		= $FF05
FB_get_pixels		= $FF08
FB_set_pixel		= $FF0B
FB_set_pixels		= $FF0E
FB_set_8_pixels		= $FF11
FB_set_8_pixels_opaque	= $FF14
FB_fill_pixels		= $FF17
FB_filter_pixels	= $FF1A
FB_move_pixels		= $FF1D
;graphics
Graph_init		= $FF20
Graph_clear		= $FF23
Graph_set_window	= $FF26
Graph_set_colors	= $FF29
Graph_draw_line		= $FF2C
Graph_draw_rect		= $FF2F
Graph_move_rect		= $FF32
Graph_draw_oval		= $FF35
Graph_draw_image	= $FF38
Graph_set_font		= $FF3B
Graph_get_char_size	= $FF3E
Graph_put_char		= $FF41
;console
Console_init		= $FEDB
Console_put_char	= $FEDE
Console_put_image	= $FED8
Console_get_char	= $FEE1
Console_set_paging_message	= $FED5
;other
Memory_fill		= $FEE4
Memory_copy		= $FEE7
Memory_crc		= $FEEA
Memory_decompress	= $FEED
Entropy_get		= $FECF
Monitor			= $FF44
Enter_basic		= $FF47
Screen_set_mode		= $FF5F
Screen_set_charset	= $FF62
JSRFAR			= $FF6E

; *****************************************************************************
; Save the address of the original interrupt handler
; *****************************************************************************
; USES:		.A
; OUTPUTS:	Address of old handler will be passed back in .old_handler
; *****************************************************************************
!macro SAVE_INT_VECTOR .old_handler {
	lda	IRQVECTOR
	sta	.old_handler
	lda	IRQVECTOR+1
	sta	.old_handler+1
}

; *****************************************************************************
; Install new interrupt handler
; *****************************************************************************
; INPUTS:	.handler = address of new interrupt handler
; USES:		.A
; *****************************************************************************
!macro INSTALL_INT_HANDLER .handler {
	sei			; Disable interrupts
	lda	#1		; Tell VERA that we want interrupts
	sta	VERA_IEN	; on each VSYNC
	lda	#<.handler	; Write address of local interrupt
	sta	IRQVECTOR	; handler to the interrupt
	lda	#>.handler	; vector address ($0314)
	sta	IRQVECTOR+1
	cli			; Enable interrupts
}

;******************************************************************************
; Code to enable program to be startet with the RUN command
;******************************************************************************
; INPUT:	[.main] = address of main function. This way it is possible
;		to jump over variables and code that is placed before the
;		main function
;******************************************************************************
!macro SYS_LINE .main {
*=$801
	!word	.next_line		; Pointer to next BASIC line
	!word	$000A			; Line number $000A = 10
	!byte	$9E			; SYS BASIC token
	!byte	48+(.main/1000)%10	; Address where ASM starts in PETSCII
	!byte	48+(.main/100)%10
	!byte	48+(.main/10)%10
	!byte	48+(.main/1)%10
	!byte	$00			; End of BASIC line
.next_line:
	!word	$0000			; End of BASIC program
}
!macro SYS_LINE {
*=$801
	!word	.next_line		; Pointer to next BASIC line
	!word	$000A			; Line number $000A = 10
	!byte	$9E			; SYS BASIC token
	!byte	48+(.entry/1000)%10	; Address where ASM starts in PETSCII
	!byte	48+(.entry/100)%10
	!byte	48+(.entry/10)%10
	!byte	48+(.entry/1)%10
	!byte	$00			; End of BASIC line
.next_line:
	!word	$0000			; End of BASIC program
.entry:
}

;******************************************************************************
; Get KERNAL version and convert it from 2's compliment number if it is a
; pre-release
;******************************************************************************
; USES:		.Y
; RETURNS:	.A contains the KERNAL version
;		.C cleared if pre-release version
;******************************************************************************
!macro GET_KERNAL_VER {
	ldy	ROM_BANK		; Save current ROM bank
	lda	#KERNAL_BANK		; Set ROM bank to 0
	sta	ROM_BANK
	lda	KERNALVER		; Read KERNAL version
	sty	ROM_BANK		; Restore ROM bank
	sec				; Set carry to show it is release-version
	bpl	.done			; If positive, we are done
	eor	#$FF			; Invert and add 1 to convert the 2's
	clc				; compliment number to the KERNAL version
	adc	#1
	clc				; Clear carry to show it is pre-release
.done:
}
