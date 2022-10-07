*=$A000

; The game uses a board that is 16x16 fields. When designing a level there
; are certain rules that must be followed.
; 1: First byte in a level is the par (=minimum number of moves to solve level)
; 2: Tiles in column 0 (Y=0) can only be of the Input type, either on or off
; 3: There can only be a single tile in column F (Y=F).
; 4: The tile in column F can only be output so the type is not defined in
;    the level
; 5: All inputs and outputs must be connected.
; 6: Levels must be designed so no wires cross
; 7: Coordinates for the Output tile in column F must be the last in a level

;   Representation of the game board
;     0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; 0 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; 1 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; 2 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; 3 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; 4 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; 5 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; 6 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; 7 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; 8 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; 9 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; A |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; B |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; C |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; D |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; E |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
; F |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
;   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+

;   List of tile types
;	$00 - Input, OFF
;	$02 - Input, ON
;	$04 - AND gate
;	$06 - AND gate inverted top input
;	$08 - AND gate inverted botoom input
;	$0A - AND gate both inputs inverted
;	$0C - NAND gate
;	$0E - NAND gate inverted top input
;	$10 - NAND gate inverted bottom input
;	$12 - NAND gate both inputs inverted
;	$14 - OR gate
;	$16 - OR gate inverted top input
;	$18 - OR gate inverted bottom input
;	$1A - OR gate both inputs inverted
;	$1C - NOR gate
;	$1E - NOR gate inverted top input
;	$20 - NOR gate inverted bottom input
;	$22 - NOR gate both inputs inverted
;	$24 - XOR gate
;	$26 - XOR gate inverted top input
;	$28 - XOR gate inverted bottom input
;	$2A - XOR gate both inputs inverted
;	$2C - XNOR gate
;	$2E - XNOR gate inverted top input
;	$30 - XNOR gate inverted bottom input
;	$32 - XNOR gate both inputs inverted
;	$34 - NOT gate (inverter)
;	$36 - Output

;   List of tile input placements
;	0 - Top
;	1 - Middle
;	2 - Bottom

; When defining a level for the games, it is done be defining tiles and their
; placement on the board, but first defining par (=minimum number of moves).
; For each tile, the following information must be defined.
; * X coordinate of tile on game board (0-F)
; * Y coordinate of tile on game board (0-F)
; * Tile type
; * X coordinate of tile that has an input connected to this tile-output
; * Y coordinate of tile that has an input connected to this tile-output
; * Input placment on tile connected to this tile-output

;   Example level with two inputs, 1 On and 1 off, an AND gate and an output
;	!byte	$01	; 1 move can solve this level
	; First Input
;	!byte	$00	; X coordinate of tile
;	!byte	$05	; Y coordinate of tile
;	!byte	$00	; Tile-type = Input, Off
;	!byte	$07	; X coordinate of next tile
;	!byte	$06	; Y coordinate of next tile
;	!byte	$00	; Output of this tile goes to top input of next tile
	; Second Input
;	!byte	$00	; X coordinate of tile
;	!byte	$07	; Y coordinate of tile
;	!byte	$01	; Tile-type = Input, On
;	!byte	$07	; X coordinate of next tile
;	!byte	$06	; Y coordinate of next tile
;	!byte	$02	; Output of this tile goes to bottom input of next tile
	; AND gate
;	!byte	$07	; X coordinate of tile
;	!byte	$06	; Y coordinate of tile
;	!byte	$04	; Tile-Type = AND gate
;	!byte	$0F	; X coordinate of next tile
;	!byte	$06	; Y coordinate of next tile
;	!byte	$01	; Output of this tile goes to middle input of next tile
	; OUTPUT
;	!byte	$0F	; X coordinate of tile
;	!byte	$06	; Y coordinate of tile
;	***** Since this tile is placed in column F, it can only be of output
;       ***** type and does not have any more information associated with it.
;	***** This is the end of a level
Levels:
	; AND gate - Outputs true (1), only when all inputs are true (1)
	; Truthtable:
	;  B  A | Y
	; ------+---
	;  0  0 | 0
	;  0  1 | 0
	;  1  0 | 0
	;  1  1 | 1

	; Level 1
	; 2 off inputs, 1 AND gate
	!byte	$02	; moves to solve level
 ;		 X   Y  Type X   Y  Input
	!byte	$00,$05,$00,$07,$06,$00		; Input OFF
	!byte	$00,$07,$00,$07,$06,$02		; Input OFF
	!byte	$07,$06,$04,$0F,$06,$01		; AND gate
	!byte	$0F,$06				; Output

	; Level 2
	; 3 off inputs, 2 AND gates
	!byte	$03	; moves to solve level
;		 X   Y  Type X   Y  Input
	!byte	$00,$01,$00,$06,$06,$00		; Input OFF
	!byte	$00,$07,$00,$06,$06,$02		; Input OFF
	!byte	$00,$0C,$00,$08,$07,$02		; Input OFF
	!byte	$06,$06,$04,$08,$07,$00		; AND gate
	!byte	$08,$07,$04,$0F,$07,$01		; AND gate
	!byte	$0F,$07				; Output

	; Level 3
	; 4 off inputs, 3 AND gates
	!byte	$04	; moves to solve level
;		 X   Y  Type X   Y  Input
	!byte	$00,$01,$00,$06,$06,$00		; Input OFF
	!byte	$00,$07,$00,$06,$06,$02		; Input OFF
	!byte	$00,$08,$00,$06,$09,$00		; Input OFF
	!byte	$00,$0C,$00,$06,$09,$02		; Input OFF
	!byte	$06,$06,$04,$08,$07,$00		; AND gate
	!byte	$06,$09,$04,$08,$07,$02		; AND gate
	!byte	$08,$07,$04,$0F,$07,$01		; AND gate
	!byte	$0F,$07				; Output

	; Level 4
	; 5 off inputs, 4 AND gates
	!byte	$05	; moves to solve level
;		 X   Y  Type X   Y  Input
	!byte	$00,$01,$00,$06,$06,$00		; Input OFF
	!byte	$00,$07,$00,$06,$06,$02		; Input OFF
	!byte	$00,$08,$00,$06,$09,$00		; Input OFF
	!byte	$00,$0C,$00,$06,$09,$02		; Input OFF
	!byte	$00,$0D,$00,$0A,$08,$02		; Input OFF
	!byte	$06,$06,$04,$08,$07,$00		; AND gate
	!byte	$06,$09,$04,$08,$07,$02		; AND gate
	!byte	$08,$07,$04,$0A,$08,$00		; AND gate
	!byte	$0A,$08,$04,$0F,$08,$01		; AND gate
	!byte	$0F,$08				; Output

	; Level 5
	; 6 off inputs, 5 AND gates
	!byte	$06	; moves to solve level
;		 X   Y  Type X   Y  Input
	!byte	$00,$01,$00,$06,$06,$00		; Input OFF
	!byte	$00,$07,$00,$06,$06,$02		; Input OFF
	!byte	$00,$08,$00,$06,$09,$00		; Input OFF
	!byte	$00,$0C,$00,$06,$09,$02		; Input OFF
	!byte	$00,$0D,$00,$06,$0E,$00		; Input OFF
	!byte	$00,$0F,$00,$06,$0E,$02		; Input OFF
	!byte	$06,$06,$04,$08,$07,$00		; AND gate
	!byte	$06,$09,$04,$08,$07,$02		; AND gate
	!byte	$06,$0E,$04,$0A,$08,$02
	!byte	$08,$07,$04,$0A,$08,$00		; AND gate
	!byte	$0A,$08,$04,$0F,$08,$01		; AND gate
	!byte	$0F,$08				; Output

	; NOT gate - Outputs the opposite of it's input, it is also called an inverter
	; Truthtable:
	;  A | Y
	; ---+---
	;  0 | 1
	;  1 | 0

	; Level 6
	; 1 on input, 1 NOT gate
	!byte	$01	; 1 moves to solve level
;		 X   Y  Type X   Y  Input
	!byte	$00,$07,$02,$07,$07,$01		; Input ON
	!byte	$07,$07,$34,$0F,$07,$01		; NOT gate
	!byte	$0F,$07				; Output

	; Level 7
	; 1 off input, 2 NOT gates
	!byte	$01	; 1 moves to solve level
;		 X   Y  Type X   Y  Input
	!byte	$00,$07,$00,$05,$07,$01		; Input OFF
	!byte	$05,$07,$34,$0A,$07,$01		; NOT gate
	!byte	$0A,$07,$34,$0F,$07,$01		; NOT gate
	!byte	$0F,$07				; Output

	; Level 8
	; 1 on input, 3 NOT gates
	!byte	$01	; moves to solve level
;		 X   Y  Type X   Y  Input
	!byte	$00,$07,$02,$03,$07,$01		; Input ON
	!byte	$03,$07,$34,$07,$03,$01		; NOT gate
	!byte	$07,$03,$34,$0A,$0A,$01		; NOT gate
	!byte	$0A,$0A,$34,$0F,$07,$01		; NOT gate
	!byte	$0F,$07				; Output

	; Level 9
	; 1 off input, 4 NOT gates
	!byte	$01	; moves to solve level
;		 X   Y  Type X   Y  Input
	!byte	$00,$07,$00,$02,$0E,$01		; Input OFF
	!byte	$02,$0E,$34,$04,$02,$01		; NOT gate
	!byte	$04,$02,$34,$06,$05,$01		; NOT gate
	!byte	$06,$05,$34,$08,$09,$01		; NOT gate
	!byte	$08,$09,$34,$0F,$07,$01		; NOT gate
	!byte	$0F,$07				; Output

	; Level 10
	; 1 on input, 5 NOT gates
	!byte	$01	; moves to solve level
;		 X   Y  Type X   Y  Input
	!byte	$00,$07,$02,$02,$0E,$01		; Input ON
	!byte	$02,$0E,$34,$04,$02,$01		; NOT gate
	!byte	$04,$02,$34,$06,$05,$01		; NOT gate
	!byte	$06,$05,$34,$08,$09,$01		; NOT gate
	!byte	$08,$09,$34,$0B,$0C,$01		; NOT gate
	!byte	$0B,$0C,$34,$0F,$07,$01
	!byte	$0F,$07				; Output

	; Level 11
	; 2 on inputs, 1 AND, 1 NOT gate
	!byte	$01	; moves to solve level
 ;		 X   Y  Type X   Y  Input
	!byte	$00,$05,$02,$07,$06,$00		; Input ON
	!byte	$00,$07,$02,$07,$06,$02		; Input ON
	!byte	$07,$06,$04,$09,$06,$01		; AND gate
	!byte	$09,$06,$34,$0F,$06,$01		; NOT gate
	!byte	$0F,$06				; Output

	; Level 12
	; 2 on inputs, 1 AND, 1 NOT gate
	!byte	$01	; moves to solve level
 ;		 X   Y  Type X   Y  Input
	!byte	$00,$05,$00,$03,$05,$01		; Input OFF
	!byte	$00,$07,$00,$07,$06,$02		; Input OFF
	!byte	$03,$05,$34,$07,$06,$00		; NOT gate
	!byte	$07,$06,$04,$0F,$06,$01		; AND gate
	!byte	$0F,$06				; Output

	; Level 13
	; 2 on inputs, 1 AND, 1 NOT gate
	!byte	$01	; moves to solve level
 ;		 X   Y  Type X   Y  Input
	!byte	$00,$05,$00,$07,$06,$00		; Input OFF
	!byte	$00,$07,$00,$03,$07,$01		; Input OFF
	!byte	$03,$07,$34,$07,$06,$02		; NOT gate
	!byte	$07,$06,$04,$0F,$06,$01		; AND gate
	!byte	$0F,$06				; Output

	; Level 14
	; 2 on inputs, 1 AND, 2 NOT gate
	!byte	$02	; moves to solve level
 ;		 X   Y  Type X   Y  Input
	!byte	$00,$05,$02,$03,$05,$01		; Input ON
	!byte	$00,$07,$02,$03,$07,$01		; Input ON
	!byte	$03,$05,$34,$07,$06,$00		; NOT gate
	!byte	$03,$07,$34,$07,$06,$02		; NOT gate
	!byte	$07,$06,$04,$0F,$06,$01		; AND gate
	!byte	$0F,$06				; Output

	; Level 15
	; 2 on inputs, 1 AND, 3 NOT gate
	!byte	$01	; moves to solve level
 ;		 X   Y  Type X   Y  Input
	!byte	$00,$05,$00,$03,$05,$01		; Input OFF
	!byte	$00,$07,$00,$03,$07,$01		; Input OFF
	!byte	$03,$05,$34,$07,$06,$00		; NOT gate
	!byte	$03,$07,$34,$07,$06,$02		; NOT gate
	!byte	$07,$06,$04,$09,$06,$01		; AND gate
	!byte	$09,$06,$34,$0F,$06,$01		; NOT gate
	!byte	$0F,$06				; Output

	; NAND gate - The same as an AND gate, but with a NOT on the output.
	;             This means that it will output true (1) except when
	;             both inputs are true (1)
	; Truthtable:
	;  B  A | Y
	; ------+---
	;  0  0 | 1
	;  0  1 | 1
	;  1  0 | 1
	;  1  1 | 0

	; Level 16
	; 2 inputs, 1 NAND gate
	!byte	$01	; moves to solve level
 ;		 X   Y  Type X   Y  Input
	!byte	$00,$05,$02,$07,$06,$00		; Input ON
	!byte	$00,$07,$02,$07,$06,$02		; Input ON
	!byte	$07,$06,$0C,$0F,$06,$01		; NAND gate
	!byte	$0F,$06				; Output

	; Level 17
	; 3 inputs, 2 NAND gates
	!byte	$01	; moves to solve level
;		 X   Y  Type X   Y  Input
	!byte	$00,$01,$00,$06,$06,$00		; Input OFF
	!byte	$00,$07,$00,$06,$06,$02		; Input OFF
	!byte	$00,$0C,$02,$08,$07,$02		; Input ON
	!byte	$06,$06,$0C,$08,$07,$00		; NAND gate
	!byte	$08,$07,$0C,$0F,$07,$01		; NAND gate
	!byte	$0F,$07				; Output

	; Level 18
	; 4 inputs, 3 NAND gates
	!byte	$02	; moves to solve level
;		 X   Y  Type X   Y  Input
	!byte	$00,$01,$00,$06,$06,$00		; Input OFF
	!byte	$00,$07,$00,$06,$06,$02		; Input OFF
	!byte	$00,$08,$00,$06,$09,$00		; Input OFF
	!byte	$00,$0C,$00,$06,$09,$02		; Input OFF
	!byte	$06,$06,$0C,$08,$07,$00		; NAND gate
	!byte	$06,$09,$0C,$08,$07,$02		; NAND gate
	!byte	$08,$07,$0C,$0F,$07,$01		; NAND gate
	!byte	$0F,$07				; Output

	; Level 19
	; 5 inputs, 4 NAND gates
	!byte	$01	; moves to solve level
;		 X   Y  Type X   Y  Input
	!byte	$00,$01,$02,$06,$06,$00		; Input ON
	!byte	$00,$07,$02,$06,$06,$02		; Input ON
	!byte	$00,$08,$02,$06,$09,$00		; Input ON
	!byte	$00,$0C,$02,$06,$09,$02		; Input ON
	!byte	$00,$0D,$02,$0A,$08,$02		; Input ON
	!byte	$06,$06,$0C,$08,$07,$00		; NAND gate
	!byte	$06,$09,$0C,$08,$07,$02		; NAND gate
	!byte	$08,$07,$0C,$0A,$08,$00		; NAND gate
	!byte	$0A,$08,$0C,$0F,$08,$01		; NAND gate
	!byte	$0F,$08				; Output

	; Level 20
	; 6 inputs, 5 NAND gates
	!byte	$01	; moves to solve level
;		 X   Y  Type X   Y  Input
	!byte	$00,$01,$00,$06,$06,$00		; Input OFF
	!byte	$00,$07,$00,$06,$06,$02		; Input OFF
	!byte	$00,$08,$02,$06,$09,$00		; Input ON
	!byte	$00,$0C,$02,$06,$09,$02		; Input ON
	!byte	$00,$0D,$00,$06,$0E,$00		; Input OFF
	!byte	$00,$0F,$00,$06,$0E,$02		; Input OFF
	!byte	$06,$06,$0C,$08,$07,$00		; NAND gate
	!byte	$06,$09,$0C,$08,$07,$02		; NAND gate
	!byte	$06,$0E,$0C,$0A,$08,$02		; NAND gate
	!byte	$08,$07,$0C,$0A,$08,$00		; NAND gate
	!byte	$0A,$08,$0C,$0F,$08,$01		; NAND gate
	!byte	$0F,$08				; Output


End_of_levels:
	!byte	$FF,$FF
