org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start:
	jmp main


;
; Prints a string to the screen
; Params: 
; 		ds:si points to a string
;

puts:
	;save registers we will modify
	push si
	push ax

.loop:
	lodsb 			;loads next character in al
	or al, al		; verify if next character is null?
	jz .done

	mov ah, 0x0e		;call bios interrupt
	mov bh, 0
	int 0x10
	
	jmp .loop

.done:
	pop ax
	pop si
	ret 


main:

	; just values moves offset while [value] moves memory values
	;setup data segments
	mov ax, 0  			;cant write to ds/es directly, AX is a general pupose register
	mov ds, ax			;ds is used for memory segment
	mov es, ax			;es for extra memory segment

	;setup stack
	;segment registers used here
	mov ss, ax			;ss is stack segment
	mov sp, 0x7C00		;stack pointer, stack grows downwards from here


	;print message
	mov si, msg_hello
	call puts
	
	hlt

.halt:
	jmp .halt


msg_hello: db 'Hello world!', ENDL, 0
	

times 510-($-$$) db 0
dw 0AA55h
