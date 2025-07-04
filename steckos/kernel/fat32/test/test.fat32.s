.include "debug.inc"
.include "test_fat32.inc"

; .autoimport

.zeropage 
sd_blkptr:  .res 2
tmp_ptr:    .res 2
filenameptr:    .res 2
dirptr:     .res 2

.bss 
lba_addr:   .res 4

.exportzp sd_blkptr, tmp_ptr, filenameptr, dirptr
.export lba_addr

.import __calc_lba_addr, __fat_open_rootdir_cwd, __fat_is_cln_zero, __fat_alloc_fd, __fat_init_fdarea
.import fat_fopen, fat_fread_byte

.export dev_read_block=         mock_read_block
.export read_block=             mock_read_block
.export dev_write_block=        mock_not_implemented
.export write_block=            mock_not_implemented
.export write_block_buffered=   mock_not_implemented


.export __rtc_systime_update=   mock_not_implemented
.export rtc_systime_update=   mock_not_implemented

debug_enabled=1

; cluster search will find following clustes
TEST_FILE_CL=$10
TEST_FILE_CL2=$19

.code
; -------------------
    setup "__fat_init_fdarea / isOpen"  ; test init fd area
    jsr __fat_init_fdarea
    ldx #(2*FD_Entry_Size)
:   lda fd_area,x
    assertA $0
    inx
    cpx #(FD_Entry_Size*FD_Entries_Max)
    bne :-

; -------------------
    setup "__fat_alloc_fd"
    jsr __fat_alloc_fd
    assertCarry 0
    assertX (2*FD_Entry_Size); expect x point to first fd entry which is 2*FD_Entry_Size, cause the first 2 entries are reserved
    assert32 0, (2*FD_Entry_Size)+fd_area+F32_fd::CurrentCluster
    assert32 0, (2*FD_Entry_Size)+fd_area+F32_fd::FileSize
    assert32 0, (2*FD_Entry_Size)+fd_area+F32_fd::SeekPos
    assert8 $0, (2*FD_Entry_Size)+fd_area+F32_fd::flags
    assert8 FD_STATUS_FILE_OPEN | FD_STATUS_DIRTY, (2*FD_Entry_Size)+fd_area+F32_fd::status

; -------------------
    setup "__fat_alloc_fd with error"
    ldy #FD_Entries_Max-2 ; -2 => 2 entries for cd and temp dir

:    jsr __fat_alloc_fd
    assertCarry 0
    dey
    bne :-
    jsr __fat_alloc_fd
    assertCarry 1
    assertA EMFILE

; -------------------
    setup "__fat_is_cln_zero"

    set32 fd_area+0*FD_Entry_Size+F32_fd::CurrentCluster, 0
    ldx #(0*FD_Entry_Size)
    jsr __fat_is_cln_zero
    assertZero 1    ; expect fd0 - "is zero" - no cluster reserved yet
    assertX (0*FD_Entry_Size)

    ldx #(1*FD_Entry_Size)
    jsr __fat_is_cln_zero
    assertZero 0    ; expect fd0 - "is not zero" - cluster reserved
    assertX (1*FD_Entry_Size)

; -------------------
    setup "__calc_lba_addr with root"

    set32 fd_area+0*FD_Entry_Size+F32_fd::CurrentCluster, 2
    ldx #(0*FD_Entry_Size)
    jsr __calc_lba_addr
    assertX (0*FD_Entry_Size)
    assert32 LBA_BEGIN - ROOT_CL * SEC_PER_CL + ROOT_CL * SEC_PER_CL, lba_addr

; -------------------
    setup "__calc_lba_addr with some clnr"
    ldx #(1*FD_Entry_Size)
    jsr __calc_lba_addr
    assertX (1*FD_Entry_Size)
    assert32 LBA_BEGIN - ROOT_CL * SEC_PER_CL + test_start_cluster * SEC_PER_CL, lba_addr ; expect $67fe + (clnr * sec/cl) => $67fe + $16a * 1 = $6968

; -------------------
    setup "__calc_lba_addr 8s/cl +10 blocks"
    ldx #(1*FD_Entry_Size)
    init_volume_id 8

    jsr __calc_lba_addr
    assertX (1*FD_Entry_Size)
    assert32 LBA_BEGIN - ROOT_CL * 8 + test_start_cluster * 8 + 0, lba_addr ; expect $68f0 + (clnr * sec/cl) => $67f0 + $16a *8 + 10 = $7340

    lda #$02*7 ; 7 blocks offset
    sta fd_area+F32_fd::SeekPos+1,x
    jsr __calc_lba_addr
    assertX (1*FD_Entry_Size)
    assert32 LBA_BEGIN - ROOT_CL * 8 + test_start_cluster * 8 + 7, lba_addr ; expect $68f0 + (clnr * sec/cl) => $67f0 + $16a *8 + 10 = $7347

    lda #$02*2 ; 2 blocks
    sta fd_area+F32_fd::SeekPos+1,x
    jsr __calc_lba_addr
    assertX (1*FD_Entry_Size)
    assert32 LBA_BEGIN - ROOT_CL * 8 + test_start_cluster * 8 + 2, lba_addr ; expect $68f0 + (clnr * sec/cl) => $67f0 + $16a *8 + 10 = $7342

; -------------------
    setup "fat_fopen O_RDONLY ENOENT"

    ldy #O_RDONLY
    lda #<test_file_name_enoent
    ldx #>test_file_name_enoent
    jsr fat_fopen
    assertC 1
    assertA ENOENT

; -------------------
    setup "fat_fopen O_RDONLY overflow"

    ldy #FD_Entries_Max-2 ; -2 => 2 entries for cwd and temp file
    .assert FD_Entries_Max > 2, error, "too few file descriptors available :/"
:   phy
    ldy #O_RDONLY
    lda #<test_file_name_1
    ldx #>test_file_name_1
    jsr fat_fopen
    ply
    assertCarry 0
    dey
    bne :-

    ldy #O_RDONLY
    lda #<test_file_name_1
    ldx #>test_file_name_1
    jsr fat_fopen
    assertCarry 1
    assertA EMFILE

; -------------------
    setup "fat_fopen O_RDONLY"

    ldy #O_RDONLY
    lda #<test_file_name_1
    ldx #>test_file_name_1
    jsr fat_fopen
    assertCarry 0
    assertX FD_Entry_Size*2
    assertDirEntry block_data+2*DIR_Entry_Size ; offset see below
      fat32_dir_entry_file "FILE01  ", "DAT", 0, 0

; -------------------
    setup "fat_fopen O_WRONLY"

    ldy #O_WRONLY
    lda #<test_file_name_2
    ldx #>test_file_name_2
    jsr fat_fopen
    assertCarry 0
    assertX 2*FD_Entry_Size
    assertFdEntry fd_area + (FD_Entry_Size*2)
      fd_entry_file_all 5, 3*DIR_Entry_Size>>1, LBA_BEGIN, DIR_Attr_Mask_Archive, 12, O_WRONLY, FD_STATUS_FILE_OPEN | FD_STATUS_DIRTY, 0, 5

; -------------------
    setup "fat_fread_byte ebadf"
    ldx #FD_INDEX_CURRENT_DIR
    jsr fat_fread_byte
    assertA EBADF
    assertCarry 1; expect error
    assertX FD_INDEX_CURRENT_DIR

; -------------------
    setup "fat_fread_byte file not open"
    ldx #(2*FD_Entry_Size) ; use fd(2) - i/o error cause not open
    jsr fat_fread_byte
    assertA EBADF
    assertCarry 1; expect error
    assertX (2*FD_Entry_Size); expect X unchanged, and read address still unchanged

; -------------------
    setup "fat_fread_byte empty file"
    ;setup fd2 with test cluster, but 0 filesize
    set8 fd_area+(2*FD_Entry_Size)+F32_fd::status, FD_STATUS_FILE_OPEN
    set32 fd_area+(2*FD_Entry_Size)+F32_fd::CurrentCluster, test_start_cluster
    set8 fd_area+(2*FD_Entry_Size)+F32_fd::Attr, DIR_Attr_Mask_Archive
    set32 fd_area+(2*FD_Entry_Size)+F32_fd::SeekPos, 0
    set32 fd_area+(2*FD_Entry_Size)+F32_fd::FileSize, 0 ; empty file

    ldx #(2*FD_Entry_Size) ; 0 byte file
    jsr fat_fread_byte
    assertCarry 1; expect "error"
    assertA EOK ; EOF
    assertX (2*FD_Entry_Size); expect X unchanged, and read address still unchanged
    assert32 0, fd_area+(2*FD_Entry_Size)+F32_fd::SeekPos
    assert8 FD_STATUS_FILE_OPEN, fd_area+(2*FD_Entry_Size)+F32_fd::status

; -------------------
    setup "fat_fread_byte touched file"
    set8 fd_area+(2*FD_Entry_Size)+F32_fd::status, FD_STATUS_FILE_OPEN
    set32 fd_area+(2*FD_Entry_Size)+F32_fd::CurrentCluster, 0 ; touched file, no cluster reserved
    set8 fd_area+(2*FD_Entry_Size)+F32_fd::Attr, DIR_Attr_Mask_Archive
    set32 fd_area+(2*FD_Entry_Size)+F32_fd::SeekPos, 0
    set32 fd_area+(2*FD_Entry_Size)+F32_fd::FileSize, 0

    ldx #(2*FD_Entry_Size)
    jsr fat_fread_byte
    assertCarry 1; expect "error"
    assertA EOK ; EOF
    assertX (2*FD_Entry_Size); expect X unchanged, and read address still unchanged
    assert32 0, fd_area+(2*FD_Entry_Size)+F32_fd::SeekPos
    assert8 FD_STATUS_FILE_OPEN, fd_area+(2*FD_Entry_Size)+F32_fd::status

; -------------------
    setup "fat_fread_byte 1 byte 4s/cl"
    ldx #(1*FD_Entry_Size)
    jsr fat_fread_byte
    assertCarry 0; ok
    assertA '4' ; see test_block_data_4sec_cl
    assertX (1*FD_Entry_Size)
    assert32 LBA_BEGIN - ROOT_CL * SEC_PER_CL + test_start_cluster * SEC_PER_CL, lba_addr ; expect $67fe + (clnr * sec/cl) => $67fe + $16a * 1 = $6968
    assert32 $16a, fd_area+(1*FD_Entry_Size)+F32_fd::StartCluster
    assert32 $16a, fd_area+(1*FD_Entry_Size)+F32_fd::CurrentCluster
    assert32 1, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos
    assert8 FD_STATUS_FILE_OPEN, fd_area+(1*FD_Entry_Size)+F32_fd::status


; -------------------
    setup "fat open and read 1 byte 4s/cl"

    set32 block_fat_0+(ROOT_CL<<2 & (sd_blocksize-1)), (TEST_FILE_CL) ; the cl chain for root directory - root ($02) => $10
    set32 block_fat_0+(TEST_FILE_CL<<2 & (sd_blocksize-1)), FAT_EOC

    ldy #O_RDONLY
    lda #<test_file_name_2
    ldx #>test_file_name_2
    jsr fat_fopen
    assertCarry 0; ok
    assertX (2*FD_Entry_Size)

    jsr fat_fread_byte
    assertCarry 0; ok
    assertA 'B'
    assertX (2*FD_Entry_Size)
    assert32 LBA_BEGIN - ROOT_CL * SEC_PER_CL + 5 * SEC_PER_CL, lba_addr ; expect $67fe + (clnr * sec/cl) => $67fe + $16a * 1 = $6968
    assert32 5, fd_area+(2*FD_Entry_Size)+F32_fd::StartCluster
    assert32 5, fd_area+(2*FD_Entry_Size)+F32_fd::CurrentCluster
    assert32 1, fd_area+(2*FD_Entry_Size)+F32_fd::SeekPos
    assert8 FD_STATUS_FILE_OPEN, fd_area+(2*FD_Entry_Size)+F32_fd::status

; -------------------
    setup "fat_fread_byte 2 byte 4s/cl"
    ldx #(1*FD_Entry_Size)
    jsr fat_fread_byte
    assertCarry 0; ok
    assertA '4'
    jsr fat_fread_byte
    assertCarry 0; ok
    assertA 's'
    assertX (1*FD_Entry_Size)
    assert32 LBA_BEGIN - ROOT_CL * SEC_PER_CL + test_start_cluster * SEC_PER_CL, lba_addr
    assert32 $16a, fd_area+(1*FD_Entry_Size)+F32_fd::CurrentCluster
    assert32 2, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos
    assert8 FD_STATUS_FILE_OPEN, fd_area+(1*FD_Entry_Size)+F32_fd::status

; -------------------
    setup "fat_fread_byte 4 bytes 4s/cl"
    ldx #(1*FD_Entry_Size)
    jsr fat_fread_byte
    assertCarry 0; ok
    assertA '4'
    jsr fat_fread_byte
    assertCarry 0; ok
    assertA 's'
    jsr fat_fread_byte
    assertCarry 0; ok
    assertA '/'
    jsr fat_fread_byte
    assertCarry 0; ok
    assertA 'c'
    jsr fat_fread_byte
    assertCarry 0; ok
    assertA 'l'
    assertX (1*FD_Entry_Size)
    assert32 LBA_BEGIN - ROOT_CL * SEC_PER_CL + test_start_cluster * SEC_PER_CL, lba_addr
    assert32 $16a, fd_area+(1*FD_Entry_Size)+F32_fd::CurrentCluster
    assert32 5, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos

; -------------------
    setup "fat_fread_byte 2 blocks 2s/cl"
    init_volume_id 2

    ldx #(1*FD_Entry_Size)
    jsr fat_fread_byte
    assertCarry 0; ok
    assertA 'B'
    jsr fat_fread_byte
    assertCarry 0; ok
    assertA '0'
    jsr fat_fread_byte
    assertCarry 0; ok
    assertA '/'
    jsr fat_fread_byte
    assertCarry 0; ok
    assertA 'C'
    jsr fat_fread_byte
    assertCarry 0; ok
    assertA '0'

    assertX (1*FD_Entry_Size)
    assert32 LBA_BEGIN - ROOT_CL * 2 + test_start_cluster * 2, lba_addr
    assert32 test_start_cluster, fd_area+(1*FD_Entry_Size)+F32_fd::CurrentCluster
    assert32 5, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos

    ldy #251
:   jsr fat_fread_byte
    dey
    bne :-
    assertCarry 0; ok
:   jsr fat_fread_byte
    assertCarry 0; ok
    dey
    bne :-

    assertX (1*FD_Entry_Size)
    assert32 LBA_BEGIN - ROOT_CL * 2 + test_start_cluster * 2, lba_addr
    assert32 test_start_cluster, fd_area+(1*FD_Entry_Size)+F32_fd::CurrentCluster ; - no new cluster selected
    assert32 $0200, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos ; seek pos at begin of next block

    jsr fat_fread_byte
    assertCarry 0; ok
    assertX (1*FD_Entry_Size)
    assert32 LBA_BEGIN - ROOT_CL * 2 + test_start_cluster * 2 + 1, lba_addr ; lba +1
    assert32 test_start_cluster, fd_area+(1*FD_Entry_Size)+F32_fd::CurrentCluster ; - no new cluster selected
    assert32 $0201, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos


; -------------------
    setup "fat_fread_byte 3 blocks 2s/cl"
    init_volume_id 2

    set32 fd_area+(1*FD_Entry_Size)+F32_fd::FileSize, (512*2+5) ; setup filesize
    assert32 0, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos

    ldx #(1*FD_Entry_Size)
    jsr fat_fread_byte
    assertCarry 0
    assertA 'B'
    assert32 1, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos
    assertX (1*FD_Entry_Size)
    assert32 LBA_BEGIN - ROOT_CL * 2 + test_start_cluster * 2, lba_addr
    assert32 test_start_cluster, fd_area+(1*FD_Entry_Size)+F32_fd::CurrentCluster ; - no new cluster selected

    jsr fat_fread_byte
    assertCarry 0
    assertA '0'
    assert32 2, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos
    assertX (1*FD_Entry_Size)

    jsr fat_fread_byte
    assertCarry 0
    assertA '/'
    assertX (1*FD_Entry_Size)

    jsr fat_fread_byte
    assertCarry 0
    assertA 'C'
    assertX (1*FD_Entry_Size)

    jsr fat_fread_byte
    assertCarry 0
    assertA '0'
    assertX (1*FD_Entry_Size)

    ldy #251
:   jsr fat_fread_byte
    assertCarry 0
    dey
    bne :-

    jsr fat_fread_byte
    assertCarry 0
    assertA 'A'
    assertX (1*FD_Entry_Size)
    assert32 $101, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos

:   jsr fat_fread_byte
    assertCarry 0
    cmp32_ne fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos, $300, :- ; read until seek pos reached

    jsr fat_fread_byte
    assertCarry 0
    assertA 'B'
    assertX (1*FD_Entry_Size)
    assert32 $301, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos

:   jsr fat_fread_byte
    assertCarry 0
    cmp32_ne fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos, $400, :- ; read until seek pos reached
    assert32 test_start_cluster, fd_area+(1*FD_Entry_Size)+F32_fd::CurrentCluster

    jsr fat_fread_byte
    assertCarry 0
    assertA 'B'
    assert32 $401, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos
    jsr fat_fread_byte
    assertCarry 0
    assertA '0'
    assert32 $402, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos
    jsr fat_fread_byte
    assertCarry 0
    assertA '/'
    assert32 $403, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos
    jsr fat_fread_byte
    assertCarry 0
    assertA 'C'
    assert32 $404, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos
    jsr fat_fread_byte
    assertCarry 0
    assertA '1'
    assert32 $405, fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos

    jsr fat_fread_byte
    assertCarry 1

    assert32 (512*2+5), fd_area+(1*FD_Entry_Size)+F32_fd::FileSize
    assert32 (512*2+5), fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos ; expect position at EOF (filesize)
    assert32 test_start_cluster+3, fd_area+(1*FD_Entry_Size)+F32_fd::CurrentCluster

    jsr fat_fread_byte
    assertCarry 1

test_end

setUp:
    init_volume_id SEC_PER_CL
    jsr __fat_init_fdarea
    ;setup fd0 (cwd) to root cluster
    jsr __fat_open_rootdir_cwd

    ; fill fat block
    m_memset block_fat_0+$000, $ff, $80  ; simulate reserved
    m_memset block_fat_0+$080, $ff, $80
    m_memset block_fat_0+$100, $ff, $80
    m_memset block_fat_0+$180, $ff, $80
    set32 block_fat_0+(TEST_FILE_CL<<2), 0 ; mark TEST_FILE_CL as free
    set32 block_fat_0+(TEST_FILE_CL2<<2), 0 ; mark TEST_FILE_CL2 as free

    init_block block_root_dir_init_00, block_root_dir_00
    init_block block_empty          , block_root_dir_01
    init_block block_empty          , block_root_dir_02
    init_block block_empty          , block_root_dir_03

    ;setup fd1 with test cluster
    set8 fd_area+(1*FD_Entry_Size)+F32_fd::status, FD_STATUS_FILE_OPEN | FD_STATUS_DIRTY
    set32 fd_area+(1*FD_Entry_Size)+F32_fd::StartCluster, test_start_cluster
    set32 fd_area+(1*FD_Entry_Size)+F32_fd::CurrentCluster, test_start_cluster
    set8 fd_area+(1*FD_Entry_Size)+F32_fd::Attr, DIR_Attr_Mask_Archive
    set32 fd_area+(1*FD_Entry_Size)+F32_fd::SeekPos, 0
    set8 fd_area+(1*FD_Entry_Size)+F32_fd::flags, O_RDONLY
    set32 fd_area+(1*FD_Entry_Size)+F32_fd::FileSize, $1000

    rts

data_loader  ; define data loader
data_writer

mock_not_implemented:
    fail "mock was called, not implemented yet!"

mock_read_block:
    debug32 "mock_read_block lba", lba_addr
    ; defaults to dir entry data
    load_block_if (LBA_BEGIN+0), block_root_dir_00, @ok ; load root cl block
    load_block_if (LBA_BEGIN+1), block_root_dir_01, @ok ;


    load_block_if (LBA_BEGIN - ROOT_CL * SEC_PER_CL + 5 * SEC_PER_CL + 0), test_block_data_0_0 , @ok

    ; fat block of test cluster read?
    cmp32_ne lba_addr, (FAT_LBA+(test_start_cluster>>7)), :+
      ; ... simulate fat block read - fill fat values on the fly
      set32 block_fat+((test_start_cluster+0)<<2 & (sd_blocksize-1)), (test_start_cluster+3) ; build a fragmented chain
      set32 block_fat+((test_start_cluster+3)<<2 & (sd_blocksize-1)), (test_start_cluster+7)
      set32 block_fat+((test_start_cluster+7)<<2 & (sd_blocksize-1)), FAT_EOC
      jmp @ok
:
    ; data block read?
    ; - for tests with 2sec/cl
    load_block_if (LBA_BEGIN - ROOT_CL * 2 + (test_start_cluster+0) * 2 + 0), test_block_data_0_0, @ok  ; block 0, cluster 0
    load_block_if (LBA_BEGIN - ROOT_CL * 2 + (test_start_cluster+0) * 2 + 1), test_block_data_0_1, @ok  ; block 1, cluster 0
    load_block_if (LBA_BEGIN - ROOT_CL * 2 + (test_start_cluster+3) * 2 + 0), test_block_data_1_0, @ok  ; block 0, cluster 1
    load_block_if (LBA_BEGIN - ROOT_CL * 2 + (test_start_cluster+3) * 2 + 1), test_block_data_1_1, @ok  ; block 1, cluster 1
;    load_block_if (LBA_BEGIN - ROOT_CL * 2 + (test_start_cluster+6) * 2 + 0), test_block_data_1_0, @ok
;    load_block_if (LBA_BEGIN - ROOT_CL * 2 + (test_start_cluster+6) * 2 + 1), test_block_data_1_1, @ok
    ; - for tests with 4sec/cl
    load_block_if (LBA_BEGIN - ROOT_CL * SEC_PER_CL + test_start_cluster * SEC_PER_CL + 0), test_block_data_4sec_cl, @ok

    fail "read lba not handled!"
@ok:
    clc
    rts

.data
test_file_name_1: .asciiz "file01.dat"
test_file_name_2: .asciiz "file02.txt"
test_file_name_enoent:  .asciiz "enoent.tst"

block_root_dir_init_00:
  fat32_dir_entry_dir  "DIR01   ", "   ", 8
  fat32_dir_entry_dir  "DIR02   ", "   ", 9
  fat32_dir_entry_file "FILE01  ", "DAT", 0, 0 ; 0 - no cluster reserved, 0 size
  fat32_dir_entry_file "FILE02  ", "TXT", 5, 12  ; 5 - 1st cluster nr of file, 12 byte file size
  fat32_dir_entry_dir  ".       ", "   ", 0
  fat32_dir_entry_dir  "..      ", "   ", 0
  .res 10*DIR_Entry_Size, 0

test_block_data_0_0:
  .byte "B0/C0"; block 0, cluster 0
  .res 256-5,0
  .byte "A"
  .res 256-1,0
test_block_data_0_1:
  .byte "B1/C0"; block 1, cluster 0
  .res 256-5,0
  .byte "B"
  .res 256-1,0
test_block_data_1_0:
  .byte "B0/C1"; block 0, cluster 1
  .res 256-5,0
  .byte "C"
  .res 256-1,0
test_block_data_1_1:
  .byte "B1/C1"; block 1, cluster 1
  .res 256-5,0
  .byte "D"
  .res 256-1,0

test_block_data_4sec_cl:
  .byte "4s/cl"
  .res 250,0

block_empty:
  .res 512,0

.bss
block_fsinfo:   .res sd_blocksize

block_fat_0:    .res sd_blocksize
block_fat2_0:   .res sd_blocksize

block_root_dir_00:  .res sd_blocksize
block_root_dir_01:  .res sd_blocksize
block_root_dir_02:  .res sd_blocksize
block_root_dir_03:  .res sd_blocksize

data_read: .res 8*sd_blocksize
