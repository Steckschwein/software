.include "system.inc"

; TODO FIXME replace with errno.inc from cc65 api
fat_bad_block_signature      = $01
fat_invalid_sector_size      = $03
fat_invalid_num_fats      = $04
fat_open_error         = $05
fat_file_not_open      = $08
fat_file_not_dir      = $10
fat_file_too_large      = $11


;--------------------------------------------------------------------------------------
; partition entry
;--------------------------------------------------------------------------------------
.struct PartitionEntry
    Bootflag    .byte
    CHSBegin    .byte 3
    TypeCode    .byte
    CHSEnd      .byte 3
    LBABegin    .dword
    NumSectors  .dword
.endstruct

PartType_FAT32        = $0b
PartType_FAT32_LBA    = $0c

;--------------------------------------------------------------------------------------
; FAT bootsector and partition table
;--------------------------------------------------------------------------------------
.struct PartTable
   Partition_0   .tag PartitionEntry
   Partition_1   .tag PartitionEntry
   Partition_2   .tag PartitionEntry
   Partition_3   .tag PartitionEntry
.endstruct

.struct BootSector
   Bootcode    .byte 446
   Partitions  .tag PartTable
   Signature   .word
.endstruct

;BS_VolLab2      = 71
.struct BPB
   BytsPerSec  .word ; 11-12  ; 512 usually
   SecPerClus  .byte ; 13     ; Sectors per Cluster as power of 2. valid are: 1,2,4,8,16,32,64,128
   RsvdSecCnt  .word ; 14-15  ; number of reserved sectors
   NumFATs     .byte ; 16     ; usually 2
   Reserved    .byte 4 ; 17-20 (max root entries, total logical sectors skipped)
   Media       .byte   ; 21 ; For removable media, 0xF0 is frequently used.
               ; The legal values for this field are
               ; 0xF0, 0xF8, 0xF9, 0xFA, 0xFB, 0xFC, 0xFD, 0xFE, and 0xFF.
   SectsPerFAT .word   ; 22-23 ; Number of sectors per FAT. 0 for fat32

   SectsPerTrack .word;    // 24-25 ; Number of sectors per track
   NumHeads    .word; // 26
   SectsHidden .dword; // 28
   TotalSects  .dword; // 32 Number of sectors

   FATSz32     .dword  ; 36-39 ; sectors per FAT
   MirrorFlags .word   ; 40-41; Bits 0-3: number of active FAT (if bit 7 is 1)
                  ; Bits 4-6: reserved
                  ; Bit 7: one: single active FAT; zero: all FATs are updated at runtime
                  ; Bits 8-15: reserved
                  ; https://www.win.tue.nl/~aeb/linux/fs/fat/fat-1.html

   Version     .word    ; 42-43
   RootClus    .dword   ; 44-47
   FSInfoSec   .word    ; 48-49  ;
   BootSectCpy .word    ; 50-51
   Reserved3   .byte 12 ; 52-63
   PhysDrvNum  .byte    ; 64
   Reserved4   .byte    ; 65/$41 - bit 7-2 0, bit 0 "dirty flag"
   ExtBootSig  .byte    ; 66
   VolumeID    .dword   ; 67-70
   VolumeLabel .byte 11 ; 71-82
   FSType      .byte 8  ; 83-90
.endstruct

; struct VolumeID like found on FAT-media (bootsector)
.struct F32_VolumeID
   JmpToBoot    .byte 3     ; JMP command to bootstrap code ( in x86-world )
   OEMName      .byte 8     ; OEM name/version (E.g. "IBM  3.3", "IBM 20.0", "MSDOS5.0", "MSWIN4.0".
                       ; Various format utilities leave their own name, like "CH-FOR18".
                       ; Sometimes just garbage. Microsoft recommends "MSWIN4.1".)
                     ; https://www.win.tue.nl/~aeb/linux/fs/fat/fat-1.html

   ; FAT32 BIOS Parameter Block begins here
   BPB         .tag BPB
.endstruct

; struct VolumeID like we keep it in memory
.struct VolumeID
  BPB_SecPerClus      .byte
  BPB_SecPerClusMask  .byte   ; BPB_SecPerClus-1
  BPB_SecPerClusCount .byte   ; pre calculated counter from BPB_SecPerClus bit set - e.g. $00 => 0, $01 => 1, $02 => 2, $04 => 3 ...
  BPB_RootClus        .dword
  BPB_FATSz32         .dword  ; sectors per fat
  lba_data            .dword
  lba_fat             .dword  ;
  lba_fat2            .dword  ; mirror fat lba
  lba_fsinfo          .dword
  cluster             .dword  ; mirror of fsinfo LastClus - used for free cluster search
  cluster_seek_cnt    .dword
  fat_cluster_add     .byte     ; cluster reservation addend
  fat_tmp_0           .byte     ; temp variable
  fat_tmp_1           .byte     ; temp variable
  fat_filename        .byte 8+3 ; 11 byte fat file name used in open to match given filename
.endstruct

;--------------------------------------------------------------------------------------
; FAT32 FSInfo Sector Offsets
;--------------------------------------------------------------------------------------
.struct F32FSInfo
   Signature1     .byte 4
   Reserved1      .byte $1e0
   Signature2     .byte 4
   FreeClus       .dword    ; amount of free clusters
   LastClus       .dword    ; last known cluster number
   Reserved2      .byte 12
   Signature      .byte 4
.endstruct
;--------------------------------------------------------------------------------------
; FAT32 Directory Entry
;--------------------------------------------------------------------------------------
.struct F32DirEntry      ; https://en.wikipedia.org/wiki/Design_of_the_FAT_file_system
   Name            .byte 8
   Ext             .byte 3
   Attr            .byte
   Reserved        .byte
   CrtTimeMillis   .byte   ;
   CrtTime         .word   ; hours as 0-23 bit 15-11, minutes as 0-59 bit 10-5, seconds/2 as 0-29 bit 4-0
   CrtDate         .word   ; year 0-119 (0=1980...127=2107) bit 15-9, month 1-12 bit 8-5, day 1-31 bit 4-0
   LstModDate      .word   ; -""-
   FstClusHI       .word
   WrtTime         .word   ; hours as 0-23 bit 15-11, minutes as 0-59 bit 10-5, seconds/2 as 0-29 bit 4-0
   WrtDate         .word   ; year 0-119 (0=1980...127=2107) bit 15-9, month 1-12 bit 8-5, day 1-31 bit 4-0
   FstClusLO       .word
   FileSize        .dword
.endstruct

DIR_Attr_Mask_ReadOnly  = 1<<0;
DIR_Attr_Mask_Hidden    = 1<<1;
DIR_Attr_Mask_System    = 1<<2;
DIR_Attr_Mask_Volume    = 1<<3;
DIR_Attr_Mask_Dir       = 1<<4;
DIR_Attr_Mask_Archive   = 1<<5;

DIR_Attr_Mask_LongFilename   = DIR_Attr_Mask_ReadOnly | DIR_Attr_Mask_Hidden | DIR_Attr_Mask_System | DIR_Attr_Mask_Volume

DIR_Entry_Size               = .sizeof(F32DirEntry)
DIR_Entry_Deleted            = $e5

;--------------------------------------------------------------------------------------
; File descriptor struct
;--------------------------------------------------------------------------------------
.struct Seek
    ; see fcntl.inc (cc65)
    Whence  .byte   ; SEEK_CUR (0) - OFFSET is relative to the current file position.  OFFSET can meaningfully be either positive or negative.
                    ; SEEK_END (1) - OFFSET is relative to the current end of file.  OFFSET can meaningfully be either positive (to increase the size of the file) or negative.
                    ; SEEK_SET (2) - OFFSET is the absolute file position (an offset from the beginning of the file) desired.  OFFSET must be positive.
    Offset  .dword
.endstruct

.struct F32_fd
   StartCluster     .dword  ; start cluster of the file (mirror of dir entry)
   CurrentCluster   .dword  ;
   FileSize         .dword  ;
   Attr             .byte   ; file attributes (mirror of attributes from dir entry)
   DirEntryLBA      .dword  ; LBA of the block where the dir entry of the file is located
   DirEntryPos      .byte   ; block offset "n" where n * DIR_Entry_Size/2 within the block - as an optimization we store the position as half of DIR_Entry_Size
   SeekPos          .dword  ; seek position within the opened file
                            ;    O_RDONLY  = $01
                            ;    O_WRONLY  = $02
                            ;    O_RDWR    = $03
                            ;    O_CREAT    = $10
                            ;    O_TRUNC    = $20
                            ;    O_APPEND  = $40
                            ;    O_EXCL    = $80
   flags            .byte   ; file open flags
   status           .byte   ; status - reserved (bit 7), next clnr (bit 6)
.endstruct

FD_STATUS_FILE_OPEN   = 1<<7    ; if set the file is open, closed otherwise
FD_STATUS_DIRTY       = 1<<6    ; if set dirty from seek() operation

FD_Entry_Size         = .sizeof(F32_fd)
FD_Entries_Max        = (fd_area_end - fd_area) / FD_Entry_Size
FD_INDEX_CURRENT_DIR  = 0*FD_Entry_Size     ; current dir always go to fd #0
FD_INDEX_TEMP_FILE     = 1*FD_Entry_Size     ; temp dir always go to fd #1

; TODO: do we need these?
;BS_BootSig      = 38
;BS_VolID      = 39
;BS_VolLab      = 43
;BS_FilSysType   = 54   ; One of the strings “FAT12 ”, “FAT16 ”, or “FAT ”.

FAT_EOC  = $0fffffff   ; end of cluster chain marker

; memory locations for fat32 driver
volumeID              = $0300 ; address of VolumeID (@see rtc.inc)

fd_area               = volumeID+.sizeof(VolumeID) ; File descriptor area until $0400
fd_area_end           = $0400
.assert fd_area+3*FD_Entry_Size <= fd_area_end, error, "fat metadata overflow! at least one FD is needed."

sd_blocksize          = $200  ; block size
block_data            = BUFFER_0 ; $0400-$5ff
block_fat             = BUFFER_2 ; $0600-$07ff

; macros
.macro _is_file_open
   bit fd_area + F32_fd::status,x ; is open
   bmi :++
:  lda #EBADF
   sec
   rts
:  cpx #FD_INDEX_CURRENT_DIR
   beq :--
.endmacro

.macro _is_file_dir
   pha
   lda fd_area+F32_fd::Attr, x
   and #DIR_Attr_Mask_Dir		; is directory?
   beq :+
   pla
   lda #EISDIR
   sec
   rts
:  pla
.endmacro