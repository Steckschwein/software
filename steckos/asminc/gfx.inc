.ifndef _GFX_INC_
  _GFX_INC_ = 1

; DC = destination color - the color we want to set
; SC = source color - the source color currently set at the target position
GFX_OP_IMP = 0    ; DC = SC
GFX_OP_AND = 1    ; DC = SC & DC
GFX_OP_OR  = 2    ; DC = SC | DC
GFX_OP_XOR = 3    ; DC = SC ^ DC
GFX_OP_NOT = 4    ; DC = !SC

GFX_OP_TIMP = 8   ; SC = 0 => DC = DC; DC = SC otherwise
GFX_OP_TAND = 9   ; SC = 0 => DC = DC; DC = SC & DC otherwise
GFX_OP_TOR  = 10  ; SC = 0 => DC = DC; DC = SC | DC otherwise
GFX_OP_TXOR = 11  ; SC = 0 => DC = DC; DC = SC ^ DC otherwise
GFX_OP_TNOT = 12  ; SC = 0 => DC = DC; DC = !SC otherwise

; !!! NOTE !!! do not use x or y as identifier, will not assemble
.struct point_t
   x1 .word ; 0..511 - depends on active screen mode
   y1 .byte ; 0..211
.endstruct

.struct plot_t
   x1 .word ; 0..511 - depends on active screen mode
   y1 .byte ; 0..211
   color .byte ; color - depends on mode
   operator .byte ; one of IMP, AND, OR, XOR, NOT - use GFX_OP_xxx
.endstruct

.struct line_t
   x1 .word ; 0..511 - depends on active screen mode
   y1 .byte ; 0..211
   color .byte ; color - depends on mode
   operator .byte ; one of IMP, AND, OR, XOR, NOT - use GFX_OP_xxx
   x2 .word ;
   y2 .byte ;
.endstruct

.struct circle_t
   x1 .word ; 0..511 - depends on active screen mode
   y1 .byte ; 0..211
   color .byte ; color - depends on mode
   operator .byte ; one of IMP, AND, OR, XOR, NOT - use GFX_OP_xxx
   radius .byte ; 0..211
.endstruct

.struct rectangle_t
   x1 .word ; 0..511 - depends on active screen mode
   y1 .byte ; 0..211
   color .byte ; color - depends on mode
   operator .byte ; one of IMP, AND, OR, XOR, NOT - use GFX_OP_xxx
   x2 .word ;
   y2 .byte ;
.endstruct

.endif ;_GFX_INC_
