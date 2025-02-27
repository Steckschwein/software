; adapted from ca65 errno.inc and extended

; Variables and functions

		  ;.global			___errno, ___oserror
		  ;.global			__osmaperrno
		  ;.global			__seterrno
		  ;.global			___directerrno, ___mappederrno

; Error codes, must match the values in the C headers

.ifndef __ERRNO_INC
	__ERRNO_INC=1
.enum
			EOK							  ; No error
			ENOENT						; No such file or directory
			ENOMEM						; Out of memory
			EACCES						; Permission denied
			ENODEV						; No such device
			EMFILE						; Too many open files
			EBUSY					 		; Device or resource busy
			EINVAL						; Invalid argument (0x07)
			ENOSPC						; No space left on device (0x08)
			EEXIST						; File exists
			EAGAIN						; Try again (0x0a)
			EIO							  ; I/O error
			EINTR					 		; Interrupted system call
			ENOSYS						; Function not implemented
			ESPIPE						; Illegal seek
			ERANGE						; Range error (0x0f)
			EBADF							; Bad file number (0x10)
			ENOEXEC					  ; Exec format error ; 0x11

			EISDIR						; Is a directory		; 0x12
			ENOTDIR	  				; Not a directory		; 0x13
			ENOTEMPTY					; Directory not empty	; 0x14

			EUNKNOWN				 	; Unknown OS specific error - must be last!

			EMAX	 = EUNKNOWN		    ; Highest error code
.endenum

.endif