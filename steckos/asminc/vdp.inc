.ifndef _VDP_INC_
  _VDP_INC_ = 1

.include "system.inc"

a_vdp    = $0220 ;
a_vram    = a_vdp
a_vreg    = a_vdp+1
a_vregpal = a_vdp+2
a_vregi   = a_vdp+3

s_reg0_F      = 1<<7  ; Frame Flag, interrupt flag
s_reg0_5S     = 1<<6  ; 5/9th sprite on scan line bit
s_reg0_C      = 1<<5  ; sprite collision bit


v_reg0_extV     = 1<<0
v_reg0_DG       = 1<<6  ; Digitize mode: sets the color bus to the input or output mode
v_reg0_IE2      = 1<<5  ; light pen interrupt
v_reg0_IE1      = 1<<4  ; h-blank interrupt
v_reg0_m5       = 1<<3
v_reg0_m4       = 1<<2
v_reg0_m3       = 1<<1


v_reg1_16k        = 1<<7
v_reg1_display_on = 1<<6
v_reg1_int        = 1<<5

v_reg1_m1         = 1<<4
v_reg1_m2         = 1<<3
v_reg1_spr_size   = 1<<1 ; 1: sprite size 16x16, 0: 8x8 sprite
v_reg1_spr_mag    = 1<<0 ; 1: scale (magnify) sprite double size

v_reg8_BW         = 1<<0  ; 0/1 grayscale off/on
v_reg8_SPD        = 1<<1  ; 0/1 sprites enabled/disabled
v_reg8_VR         = 1<<3  ; 0/1 16k/64k video ram
v_reg8_TP         = 1<<5  ; 0/1 transparent (TP) or color code 0 of palette (1)

v_reg9_ln         = 1<<7  ; lines - 0 - 192 lines, 1 - 212 lines
v_reg9_il         = 1<<3  ; interlace
v_reg9_nt         = 1<<1  ; ntsc - 0 / pal - 1

v_reg17_aii       = 1<<7  ; auto increment

v_reg25_sp2       = 1<<0  ; 0:Sets the horizontal screen size to 1 page, 1:Sets the horizontal screen size to two pages.
v_reg25_msk       = 1<<1  ; 1:The left 8 dots are masked and the border color is output.
v_reg25_wait      = 1<<2
v_reg25_yjk       = 1<<3  ; YJK (YUV) mode
v_reg25_yae       = 1<<4  ; yae yjk with attributes
v_reg25_cmd       = 1<<6  ; enables the command function in all display modes.

v_reg45_mxc = 1<<6
v_reg45_mxd = 1<<5
v_reg45_mxs = 1<<4
v_reg45_diy = 1<<3
v_reg45_dix = 1<<2
v_reg45_maj = 1<<0

v_reg0    = $80
v_reg1    = $81
v_reg2    = $82
v_reg3    = $83
v_reg4    = $84
v_reg5    = $80 +  5
v_reg6    = $80  + 6
v_reg7    = $80  + 7
; start of V9938/V9958 register set
v_reg8    = $80  + 8
v_reg9    = $80  + 9
v_reg11   = $80 + 11

v_reg12   = $80 + 12   ; blink color
v_reg13   = $80 + 13   ; on time / off time

v_reg14   = $80 + 14
v_reg15   = $80 + 15
v_reg16   = $80 + 16  ; color palette index register
v_reg17   = $80 + 17
v_reg18   = $80 + 18  ; display adjust
v_reg19   = $80 + 19  ; h-blank irq scanline
v_reg23   = $80 + 23  ; screen ram vertical offset

; V9958 specific
v_reg25 = $80 + 25  ; bit 0 - 0/1 - 1/2 page per screen, bit 1 - 8px border
v_reg26 = $80 + 26  ; horizontal scroll register, bit 5-0, scroll 8 dot units (character)
v_reg27 = $80 + 27  ; horizontal scroll register bit 2-0, scroll dot units

v_reg34 = $80 + 34  ;
v_reg35 = $80 + 35  ;
v_reg36 = $80 + 36
v_reg37 = $80 + 37
v_reg38 = $80 + 38
v_reg39 = $80 + 39
v_reg40 = $80 + 40
v_reg41 = $80 + 41
v_reg42 = $80 + 42
v_reg43 = $80 + 43
v_reg44 = $80 + 44
v_reg45 = $80 + 45
v_reg46 = $80 + 46


; VDP command opcodes
; high speed move
v_cmd_hmmc   = %11110000
v_cmd_ymmm   = %11100000
v_cmd_hmmm   = %11010000
v_cmd_hmmv   = %11000000

; logical move
v_cmd_lmmc   = %10110000
v_cmd_lmcm   = %10100000
v_cmd_lmmm   = %10010000
v_cmd_lmmv   = %10000000

v_cmd_line   = %01110000
v_cmd_srch   = %01100000
v_cmd_pset   = %01010000
v_cmd_point = %01000000
v_cmd_stop  = %00000000

; VDP command logical operations
; SC = source color code
; DC = destination color code

v_log_imp  = %00000000 ; DC=SC
v_log_and  = %00000001  ; DC AND SC
v_log_or  = %00000010 ; DC OR SC
v_log_eor  = %00000011 ; DC=/SC AND DC OR SC AND /DC
v_log_not  = %00000100 ; DC=/SC

v_log_timp  = %00001000 ; if SC=0 then DC=DC else DC=SC
v_log_tand  = %00001001 ; if SC=0 then DC=DC else DC=SC AND DC
v_log_tor  = %00001010 ; if SC=0 then DC=DC else DC=SC OR DC
v_log_teor  = %00001011 ; if SC=0 then DC=DC else DC=/SC AND DC OR SC AND /DC
v_log_tnot  = %00001100 ; if SC=0 then DC=DC else DC=/SC

SPRITE_Y=0
SPRITE_X=1
SPRITE_N=2
SPRITE_C=3

SPRITE_INVISIBLE=$bf
SPRITE_OFF=$d0   ; in 192 line mode +8 ($d8) in 212 line mode

SPRITE_EC=1<<7  ; early clock bit
SPRITE_CC=1<<6  ; priority control, 1 - disable
SPRITE_IC=1<<5  ; line collision detect, 1 - disable

Transparent     =$00
Black           =$01  ;0  0  0    "black"
Medium_Green    =$02 ;35  203  50    "23
Light_Green     =$03  ;96  221  108
Dark_Blue       =$04 ;84  78  255    "544EFF"
Light_Blue      =$05 ;125 112 255  "7D70FF"
Dark_Red        =$06 ;210 84  66    "D25442"
Cyan            =$07 ;69 232  255    (Aqua Blue)
Medium_Red      =$08 ;250 89  72     "FA5948"
Light_Red       =$09 ;255 124 108  "FF7C6C"
Dark_Yellow     =$0a ;211 198 60    "D3C63C"
Light_Yellow    =$0b ;229 210 109  "E5D26D"
Dark_Green      =$0c ;35 178  44
Magenta         =$0d ;200 90  198   "C85AC6" (Purple)
Gray            =$0e ;204 204 204  "CCCCCC"
White           =$0f ;255 255 255  "white"

GFX7_Black        =$00
GFX7_Blue         =$01
GFX7_Red          =$02
GFX7_Magenta      =$03
GFX7_Green        =$04
GFX7_Cyan         =$05
GFX7_Yellow       =$06
GFX7_Gray         =$07
GFX7_Orange       =$08
GFX7_LightBlue    =$09
GFX7_LightRed     =$0a
GFX7_LightMagenta =$0b
GFX7_LightGreen   =$0c
GFX7_LightCyan    =$0d
GFX7_LightYellow  =$0e
GFX7_White        =$0f

WRITE_ADDRESS=$40

; MSX SCREEN Mode / VDP Graphics Mode
SCREEN1 = 1
SCREEN2 = 2
SCREEN3 = 3
SCREEN4 = 3
SCREEN5 = 4
SCREEN6 = 5
SCREEN7 = 6
SCREEN8 = 7

ADDRESS_GFX_SPRITE            = $1e00
ADDRESS_GFX_SPRITE_PATTERN    = $2800

ADDRESS_TEXT_SCREEN           = $0000      ; name table (pattern layout)
ADDRESS_TEXT_PATTERN          = $1000      ; pattern table
ADDRESS_TEXT_COLOR            = $2000      ; color table, v9938/58 "blink" color code vram

ADDRESS_GFX1_SCREEN           = $1800      ; name table
ADDRESS_GFX1_PATTERN          = $0000
ADDRESS_GFX1_COLOR            = $2000
ADDRESS_GFX1_SPRITE           = ADDRESS_GFX_SPRITE
ADDRESS_GFX1_SPRITE_PATTERN   = $3800;

ADDRESS_GFX2_SCREEN           = $1800    ; name table (pattern layout)
ADDRESS_GFX2_PATTERN          = $0000    ; pattern generator
ADDRESS_GFX2_COLOR            = $2000    ; pattern colors
ADDRESS_GFX2_SPRITE           = ADDRESS_GFX_SPRITE
ADDRESS_GFX2_SPRITE_PATTERN   = ADDRESS_GFX1_SPRITE_PATTERN

ADDRESS_GFX_MC_SCREEN         = $0800  ; name table
ADDRESS_GFX_MC_PATTERN        = $0000  ; pattern table
ADDRESS_GFX_MC_SPRITE         = ADDRESS_GFX_SPRITE    ; sprite attributes
ADDRESS_GFX_MC_SPRITE_PATTERN = ADDRESS_GFX_SPRITE_PATTERN  ; sprite pattern

ADDRESS_GFX3_SCREEN           = ADDRESS_GFX2_SCREEN
ADDRESS_GFX3_PATTERN          = ADDRESS_GFX2_PATTERN
ADDRESS_GFX3_COLOR            = ADDRESS_GFX2_COLOR
ADDRESS_GFX3_SPRITE_PATTERN   = ADDRESS_GFX2_SPRITE_PATTERN
ADDRESS_GFX3_SPRITE           = ADDRESS_GFX_SPRITE
ADDRESS_GFX3_SPRITE_COLOR     = ADDRESS_GFX3_SPRITE-$0200  ; sprite color table address (“strictly below the sprite attribute table -$200)

ADDRESS_GFX4_SCREEN           = $10000
ADDRESS_GFX4_SPRITE_PATTERN   = $7800
ADDRESS_GFX4_SPRITE           = $7600
ADDRESS_GFX4_SPRITE_COLOR     = ADDRESS_GFX4_SPRITE-$0200  ; sprite color table address (“strictly below the sprite attribute table -$200)

ADDRESS_GFX6_SCREEN           = $10000 ; screen
ADDRESS_GFX6_SPRITE_PATTERN   = $f000    ;
ADDRESS_GFX6_SPRITE           = $fa00    ;
ADDRESS_GFX6_SPRITE_COLOR     = ADDRESS_GFX6_SPRITE-$0200  ; sprite color table address (“strictly below the sprite attribute table -$200)

ADDRESS_GFX7_SCREEN           = $10000  ; 64k RAM, 2nd page
ADDRESS_GFX7_SPRITE_PATTERN   = $f000   ; sprite pattern table
ADDRESS_GFX7_SPRITE           = $fa00   ; sprite attribute table address
ADDRESS_GFX7_SPRITE_COLOR     = ADDRESS_GFX7_SPRITE-$0200  ; sprite color table address (“strictly below the sprite attribute table -$200)

; long delay with 6+2 = 8µs wait
Cycles_8_Micros = 8 * clockspeed ; eg. 8Mhz, means 125ns per cycle. so wait 8µs = 8000ns => 8000ns / 125ns = 64cl / 2 => 32 NOP
; short delay with 2µs wait
Cycles_2_Micros = 2 * clockspeed;

.macro m_vdp_nopslide
; NOTE!!!
; - TMS9929 and V9938/V9958 wait 2µs between 2 byte writes and 8µs for the 3rd and n'th byte read/write
vdp_nopslide_8m:
    .repeat ((Cycles_8_Micros-Cycles_2_Micros) >>1 ) ; long delay with 8µs wait (8µs=6µs+2µs below)
    nop
    .endrepeat
vdp_nopslide_2m:
    .repeat (Cycles_2_Micros >> 1)
    nop
    .endrepeat
vdp_nopslide_end:
    rts
.endmacro

.macro vnops
  .warning "# DEPRECATED - macro 'vnops' is deprectaed, please use vdp_wait_s/vdp_wait_l instead"
  vdp_wait_l
.endmacro


.macro vdp_delay _wasted_cycles, _wait_cycles
  .local _wasted_cycles
  .if ((_wasted_cycles+1) >= _wait_cycles) ; +1 (opcode fetch)
    ; nothing, already enough delay
  .else
    ; -12 => jsr/rts = 2*6cl = 12cl to substract
    .assert _wasted_cycles >= 0 && (_wasted_cycles+1) < _wait_cycles, error, .concat("parameter <wasted cycles> must be 0<=", .string(_wasted_cycles), "<=", .sprintf ("%d", _wait_cycles))
    .if ((_wait_cycles - (_wasted_cycles+1)) = 12) ; jsr/rts => 12cl
      jsr vdp_nopslide_end ; direct to rts if we have <=12cl to wait
    .else
      .if ((_wait_cycles - (_wasted_cycles+1)) < 12) ; less then jsr/rts => 12cl
          .repeat ((_wait_cycles-_wasted_cycles) >> 1) ; 2cl / NOP
          nop
          .endrepeat
      .else
        .if (_wait_cycles = Cycles_2_Micros)
          jsr vdp_nopslide_2m + ((_wasted_cycles+12+1) >> 1) ; +12 jsr/rts + 1cl opcode fetch
        .else
          jsr vdp_nopslide_8m + ((_wasted_cycles+12+1) >> 1)
        .endif
      .endif
    .endif
  .endif
.endmacro

; short wait between register setup
.macro vdp_wait_s _wasted_cycles
    .local _wasted_cycles
    .ifndef vdp_nopslide_2m
      .import vdp_nopslide_2m
      .import vdp_nopslide_end
    .endif
    .if(.paramcount > 0)
      vdp_delay _wasted_cycles, Cycles_2_Micros
    .else
      vdp_delay 0, Cycles_2_Micros
    .endif
.endmacro

; long wait between VRAM access
.macro vdp_wait_l _wasted_cycles  ; amount of cycles already wasted in range [0..n]
    .local _wasted_cycles
    .ifndef vdp_nopslide_8m
      .import vdp_nopslide_8m
      .import vdp_nopslide_end
    .endif
    .if(.paramcount > 0)
      vdp_delay _wasted_cycles, Cycles_8_Micros
    .else
      vdp_delay 0, Cycles_8_Micros
    .endif
.endmacro

.macro vdp_sreg _1st, _2nd
    .if(.paramcount <> 2)  ;no macro args, use the A/Y parameter call
      vdp_wait_s
      sta a_vreg
      vdp_wait_s
      sty a_vreg
    .else              ; otherwise use the new api call, with fewer nops for register writes
      lda #_1st
      vdp_wait_s 2
      sta a_vreg
      lda #_2nd
      vdp_wait_s 2
      sta a_vreg
    .endif
.endmacro

.macro vdp_reg reg, val
      lda #val
      vdp_wait_s 2
      sta a_vreg
      lda #$80 + reg
      vdp_wait_s 2
      sta a_vreg
.endmacro

.macro vdp_vram_w _24bit
   vdp_sreg <.HIWORD(_24bit<<2), v_reg14
   vdp_sreg <.LOWORD(_24bit), WRITE_ADDRESS | (>.LOWORD(_24bit) & $3f)
.endmacro

.macro vdp_vram_r _24bit
   vdp_sreg <.HIWORD(_24bit<<2), v_reg14
   vdp_sreg <.LOWORD(_24bit), (>.LOWORD(_24bit) & $3f)
.endmacro

.macro lda_vdp_rgb _r, _g, _b
    lda #(_g & $e0 | (_r & $e0)>>3 | _b>>6)
.endmacro

; creates VDP GRB byte (mode 7) from 24Bit RGB
.macro vdp_rgb _r, _g, _b
   .byte _g & $e0 | (_r & $e0)>>3 | _b>>6
.endmacro

; creates a 2 byte vdp compatible color palette value from 3 single r, g, b bytes
.macro vdp_pal _r, _g, _b
  .byte ((_r>>1) & $70) | _b>>5
  .byte _g>>5
.endmacro

; creates a 2 byte vdp compatible color palette value from 3 byte rgb value
.macro vdp_pal_rgb _rgb ; _rgb 3 byte tupel rgb
   vdp_pal _rgb>>16, (_rgb>>8 & $ff), (_rgb & $ff)
.endmacro

.macro SyncBlank
@l:
   vdp_wait_s
   bit a_vreg  ; wait until blank - irq flag set?
  bpl @l
.endmacro

.macro InBlank
@l:
  vdp_wait_s
  bit  a_vreg
  bpl @l    ; wait until blank - irq flag set?
.endmacro


VIDEO_MODE_PAL      = 1<<7
VIDEO_MODE_80_COLS  = 1<<6
VIDEO_COLOR=Gray<<4|Black  ; gray text, black backdrop/border
ROWS=24
COLS=80

.endif ;_VDP_INC_
