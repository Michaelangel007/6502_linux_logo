; 6502 Linux Logo
; Michaelangel007
; https://github.com/Michaelangel007/6502_linux_logo

; Zero Page ROM vars
zCursorX    = $24 ; CH
zCursorY    = $25 ; CH
zHgrPtr     = $26 ; GBASL = Dst
zTxtPtr     = $28 ; BASL  = Dst

zSaveX      = $F9
zSaveY      = $FA
zMask       = $FB ; 16-bit but Acc has low
zSrcShift   = $FC ; i mod 8
zDstShift   = $FD ; i mod 7
zUnpackBits = $FE ; 16-bit unpack

; ROM
HOME        = $FC58
IB_HGR      = $D000 ; Integer   BASIC ][ only
AS_HGR      = $F3E2 ; Applesoft BASIC ][+ or newer
BASCALC     = $FBC1 ; A=Row, Calculate BASL,BASH text address

;Bank Addr --  Addr Bank Read ---   Write -------
; 2  $C080 == $C088  1   Read RAM   Write protect
; 2  $C081 == $C089  1   Read ROM   Write enabled
; 2  $C082 == $C08A  1   Read ROM   Write protect
; 2  $C083 == $C08B  1   Read RAM   Write enabled
RAMIN       = $C080
ROMIN       = $C081

MACHINEID1  = $FBB3
MACHINEID2  = $FBC0
MACHINEID3  = $FBBF ; //c version

; Config
UnpackAddr  = $3FD0 ; Y=191, $28 bytes at Keyboard buffer
CONFIG_PROBE_CPUINFO = 1
CONFIG_PRINT_CPUINFO = 1

; ========================================================================

        ORG $900
Main
        jsr HOME

; ------------------------------------------------------------------------
    DO CONFIG_PROBE_CPUINFO
DetectCPU

; Apple II Technical Note #7
; https://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Computers/Apple%20II/Apple%20II/Documentation/Misc%20%23007%20Apple%20II%20Family%20ID.pdf
;
; Machine               $FBB3 $FBC0 $FBBE
; Apple ][              $38
; Apple ][+             $EA
; Apple ///             $EA
; Apple //e             $06   $EA
; Apple //e+            $06   $E0
; Apple //e Option Card $06   $E0
; Apple //c             $06   $00   $FF
; Apple //c 3.5         $06   $00   $00
; Apple //c Org Mem XP  $06   $00   $03
; Apple //c Rev Mem XP  $06   $00   $04
; Apple //c+            $06   $00   $05
; Apple IIgs
detect_ram
        lda MACHINEID1      ; FBB3: $38 = ][, $EA = ][+, $06 = //e //c IIgs
        pha
        cmp #$38            ;
        bne apple_iiplus

apple_ii
        pla
        jsr IB_HGR          ; HGR on ][, ends with BNE $D01B
        beq apple_ii_normal

apple_iiplus
        jsr AS_HGR         ; ][ = $D000, Only on Apple ][+


        pla
        cmp  #$EA           ;  apple ][+?
        bne apple_iie       ; if so keep going

        lda #"+"
        bne set_apple_ii

; if we get here we're a ii+ or iii in emulation mode
apple_ii_normal
        lda #" "            ; $A0
set_apple_ii
        ldx #"]"
        ldy #"["
        stx ModType-2
        sty ModType-1
        sta ModType         ; erase last 'e' in 'Apple IIe'

;        ldx #3-1
;SetCpu6502
;        lda CpuTye6502,X
;        sta CpuType,X
;        dex
;        bne SetCpu6502

        lda #" "            ; $A0
        sta CpuType         ; '_6502'
        ldx #"6"
        ldy #"5"
        stx CpuType+1
        sty CpuType+2

detect_langcard
        sta RAMIN           ; Detect 16K RAM / Language Card
        sta RAMIN           ; Read RAM

        lda $D000
        eor #$FF
        sta $D000
        cmp $D000
        bne apple_ii_48K
        eor #$FF
        sta $D000

RAM_64K
        ldx #"6"
        ldy #"4"
        bne RAM_size
apple_ii_48K
        ldx #"4"
        ldy #"8"
RAM_size
        lda #" "
        sta RamSize         ; erase '1' in '128'
        stx RamSize+1
        sty RamSize+2
        bne done_detecting

; Detect //e //e+ //c
apple_iie
        lda MACHINEID2      ; FBC0: $00 = //c, $EA = //e, E0 = //e+
        beq apple_iic       ; check for apple //c
        cmp #$E0            ; if we're an Apple IIe (original)
        bne RAM_64K         ; then use 64K and finish
        beq apple_iie_enhanced
apple_iic
        lda #"c"
        sta CpuType+1
        lda MACHINEID3
        cmp #$05            ; //c+
        bne done_detecting
apple_iie_enhanced          ; //c+
        ldx #1              ; //e+
        jsr ModelPlus       ;    ^
done_detecting
        sta ROMIN           ; Turn off Language Card
        sta ROMIN           ; if it was probed
    FIN

; ------------------------------------------------------------------------
; Unpack 2 bits/color -> $28 bytes/scanline
;
; Unpack one line to $200
; Copy to 8 scanlines
Unpack

    DO 1-CONFIG_PROBE_CPUINFO
        jsr AS_HGR ; *** DEBUG ***
    FIN

        lda #7          ; will INC, $0428 (Text) + $1C00 => $2028 (HGR)
        sta zCursorY    ; Start Row=8
DrawRow
        lda #0
        tay   
        tax                 ; DstOffset within page
        sta zDstShift

        lda PackedBits
        sta zUnpackBits+0

NextSrcShift
        lda PackedBits+1,Y
        sta zUnpackBits+1
        lda #0
UpdateSrcShift
        sta zSrcShift

        jsr Unpack2Bits     ; hhggffee C=? ddccbbaa 
        bcs UnpackDone

        lsr zUnpackBits+1   ; 0hhggffe C=e ddccbbaa
        ror zUnpackBits+0   ; 0hhggffe C=e eddccbba
        lsr zUnpackBits+1   ; 00hhggff C=e eddccbba
        ror zUnpackBits+0   ; 00hhggff c=e eeddccbb 

        lda zSrcShift
        clc
        adc #2
        cmp #8              ; have 8 input bits?
        bne UpdateSrcShift
        iny                 ; src++
        bne NextSrcShift
UnpackDone


; ------------------------------------------------------------------------

    DO CONFIG_PRINT_CPUINFO

        ldx #0
PrintText
        jsr BASCALC         ; 
        ldy #0
CopyTextLine
        lda TextLine,X
        sta (zTxtPtr),Y
        inx                 ; 3*40 = 120 chars max
        iny
        cpy #40
        bne CopyTextLine

        inc zCursorY
        lda zCursorY
        cmp #$17            ; Rows $14..$16 (inclusive)
        bne PrintText

        dec zCursorY

; End of String offse for Model
; IN: X = 0 II+
;             ^
;         1 //e+
;              ^
ModelPlus
        lda #"+"
        sta ModType,x
    FIN

        rts

; ------------------------------------------------------------------------
; Expand 1 pixel  (2 bits) via
; Output 2 pixels (4 bits)
Unpack2Bits

; DoublePixel
        stx zSaveX
        sty zSaveY
        
        lda zUnpackBits
        asl                 ; A=?????ba0
        asl                 ; A=????ba00
        eor zUnpackBits     ; A=????xxyy
        and #%00001100      ; A=????xx00
        eor zUnpackBits     ; A=????baba
        and #%00001111      ; A=0000baba

        ldx #0
        stx zMask

        ldx zDstShift
        beq NoShiftSherlock
MakeShiftMask
        asl
        rol zMask
        dex
        bne MakeShiftMask
NoShiftSherlock

        asl                 ; msb of byte0 set?
        rol zMask           ; shift in to lsb of byte1

        sec                 ; MSB=1 color=blue/orange
        ror

        ldy zDstShift       ; x={0,1,2} + 4 < 7
        cpy #3              ; all bits fit into dest byte?

        ldx zSaveX
        ora UnpackAddr,X    ; do all bits that fit
        sta UnpackAddr,X
        bcc UpdateDestOffset

; Update partial next byte of dest
        inx
        stx zSaveX
        cpx #$28            ; C = x < 28

        lda zMask
        ora #$80
        ora UnpackAddr,X
        sta UnpackAddr,X

        ; x = x + 4 - 7
        ; x = x - 3
        ldy zDstShift
        dey
        dey
        dey
        bcc LineNotDone     ; C = x < 28

; ------------------------------------------------------------------------
; Copy Buffer to HGR

        inc zCursorY

; ------------------------------------------------------------------------
; Udpate the Text Address
; Update the HGR scanline Address
        lda zCursorY
        jsr BASCALC

        lda zTxtPtr+0   ; every 8 HGR scanline address
        sta zHgrPtr+0   ; is exactly same as Text low byte

        lda zTxtPtr+1   
        clc             ; every 8 HGR scanline address
        adc #$1c        ; is Text Page $04 + $1C = HGR Page $20
        sta zHgrPtr+1
; ------------------------------------------------------------------------

        ldx #7              ; Repeat each scanline 8 times
Draw8Rows
        ldy #39             ; 280/7 = 40 bytes/scanline
CopyScanLine
        lda UnpackAddr,Y      
        sta (zHgrPtr),Y

        txa                 ; Clear source on last scanline copy
        bne CopyNextByte
        sta UnpackAddr,Y
CopyNextByte
        dey
        bpl CopyScanLine

        clc                 ; y = y+1
        lda zHgrPtr+1       ; HGR addr_y+1 = addr_y + $0400
        adc #$04
        sta zHgrPtr+1

        stx zSaveX          ; X=0 last loop iteration
        dex
        bpl Draw8Rows

        iny                 ; Y=0 -> zDstShift
               
        lda zCursorY
        cmp #$14            ; Y=$40 .. $A0, Rows $8..$13 (inclusive)
        bcs OuputDone
        bcc LineNotDone     ; Next Scan Line, start at dst bit 0

UpdateDestOffset            ; C=0 from NoShiftSherlock 
        iny
        iny
        iny
        iny
LineNotDone
        sty zDstShift
        ldx zSaveX          ; NOTE: C=0 from CMPs above
        ldy zSaveY
OuputDone
        rts


; ------------------------------------------------------------------------

CpuType = * + 13 + 40
RamSize = * + 30 + 40
ModType = * + 24 + 40*2

; Uppercase in case of Apple ][ without lowercase support
            ;          1         2         3
TextLine    ;0123456789012345678901234567890123456789
        ASC "  LINUX VERSION 2.6.22.6, COMPILED 2007 " ; Row $14
        ASC " ONE 1.02MHZ 65C02 PROCESSOR, 128KB RAM " ; Row $15
        ASC "                APPLE //e               " ; Row $16
;                         ^          ^     ^
;                         CPUTYPE    MOD   RAM

; ------------------------------------------------------------------------

;"__________________________________________________________@@@@@_______"
;"_________________________________________________________@@@@@@@______"
;"______________A__________________________________________@@_@_@@______"
;"@@@@@@_______AA@_________________________________________@BBBBB@______"
;"__@@__________@________________________________________@@__BBB__@@____"
;"__@@_______AAA__@@@_@@@@___@@@____@@@__@@@@@_@@@@@____@__________@@___"
;"__@@______A__A@__@@@____@@__@@_____@@____@@___@@_____@____________@@__"
;"__@@_____A___A@__@@_____@@__@@_____@@_____@@_@@______@____________@@@_"
;"__@@________AA@__@@_____@@__@@_____@@______@@@______BB@___________@@B_"
;"__@@_____@_AA@___@@_____@@__@@_____@@_____@@_@@____BBBBB@_______@BBBBB"
;"__@@____@@_AA@_@_@@_____@@__@@@___@@@____@@___@@___BBBBBB@_____@BBBBBB"
;"@@@@@@@@@@__@@@_@@@@___@@@@___@@@@_@@@_@@@@@_@@@@@__BBBBB@@@@@@@BBBBB_"
; Char &3 Color
;  @   00 Black
;  A   01 Blue
;  B   10 Orange
;  _   11 White

; NOTE: Generated by ascii2hgr2bit
; ASCII: 70*12 = 840 chars
; Packed 2bits/2pixel: 70 chars * 2 bits/char / 8 bits/byte = 140 bits / 8 = 17.5 bytes
; 840 chars * 2 bits/color / 8 bits/byte = 210 bytes

    PUT packedlogo.s

