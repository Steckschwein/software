; MIT License
;
; Copyright (c) 2018 Thomas Woinke, Marko Lauke, www.steckschwein.de
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

.ifdef DEBUG_BLKLAYER ; debug switch for this module
  debug_enabled=1
.endif

.include "common.inc"
.include "errno.inc"
.include "blklayer.inc"

.include "debug.inc"

.export blklayer_init
.export blklayer_read_block;
.export blklayer_write_block;
.export blklayer_write_block_buffered;
.export blklayer_flush;

; .autoimport
.import lba_addr
.import blklayer_store
.import dev_read_block, dev_write_block
.importzp sd_blkptr




blklayer_init:
            m_memset blklayer_store+_blkl_state::blk_lba, $ff, 4
            stz blklayer_store+_blkl_state::status
            rts

blklayer_read_block:
;          debug32 "bl r lba", lba_addr
 ;         debug32 "bl r lba last", blklayer_store+_blkl_state::blk_lba
;          debug16 "bl r lba blkptr", blklayer_store+_blkl_state::blk_ptr
            ldx #0
            _block_loaded @l_read
            clc
@l_exit:    rts

@l_read:  debug32 "bl r miss >", lba_addr
            jsr blklayer_flush
            bcs @l_exit
            debug32 "bl r sdpt", sd_blkptr
            jsr dev_read_block
            bcs blkl_exit
__blkl_save_lba_addr:
            stz blklayer_store+_blkl_state::status

            m_memcpy lba_addr, blklayer_store+_blkl_state::blk_lba, 4
            lda sd_blkptr
            sta blklayer_store+_blkl_state::blk_ptr
            lda sd_blkptr+1
            sta blklayer_store+_blkl_state::blk_ptr+1
            rts

blklayer_write_block:
            debug32 "bl w rlba", lba_addr
            jsr dev_write_block
            bcc __blkl_save_lba_addr
blkl_exit:  rts

blklayer_flush:
            clc
            bit blklayer_store+_blkl_state::status ; ? pending write
            bpl @l_exit
            debug32 "bl fl l >", blklayer_store+_blkl_state::blk_lba
            debug16 "bl fl r", sd_blkptr
            debug16 "bl fl l", blklayer_store+_blkl_state::blk_ptr

            m_memcpy lba_addr, blklayer_store+_blkl_state::tmp_lba, 4
            lda sd_blkptr
            sta blklayer_store+_blkl_state::tmp_ptr
            lda sd_blkptr+1
            sta blklayer_store+_blkl_state::tmp_ptr+1

            m_memcpy blklayer_store+_blkl_state::blk_lba, lba_addr, 4
            lda blklayer_store+_blkl_state::blk_ptr
            sta sd_blkptr
            lda blklayer_store+_blkl_state::blk_ptr+1
            sta sd_blkptr+1
            jsr dev_write_block
            pha
            m_memcpy blklayer_store+_blkl_state::tmp_lba, lba_addr, 4
            lda blklayer_store+_blkl_state::tmp_ptr
            sta sd_blkptr
            lda blklayer_store+_blkl_state::tmp_ptr+1
            sta sd_blkptr+1
            pla
@l_exit:    rts

blklayer_write_block_buffered:
            ;debug32 "bl wb rlba", lba_addr
            ;debug32 "bl wb l", blklayer_store+_blkl_state::blk_lba
            ;debug16 "bl fl r", sd_blkptr
            ;debug16 "bl wb l", blklayer_store+_blkl_state::blk_ptr
            ;cmp32 blklayer_store+_blkl_state::blk_lba, lba_addr, @l_err
            ;cmp16 blklayer_store+_blkl_state::blk_ptr, sd_blkptr, @l_err
            lda #BLKL_WRITE_PENDING
            sta blklayer_store+_blkl_state::status
            clc
            rts


