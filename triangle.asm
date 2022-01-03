; System calls
SYS_WRITE		equ		1
; File descriptors
FD_STDOUT		equ		1

; External symbols
extern compute_area
extern get_sides
extern show_results

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Begin the data section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section	.data
; Strings
msg1 		db 	"This manager is here to help you find the area of your triangle.", 13, 10, "Input your 3 floating point numbers representing the sides of a triangle.", 13, 10, "Please enter after each number.", 13, 10, 13, 10
msg1_len	equ	$-msg1
msg2 		db 	"The area will be returned to heron.", 13, 10, 13, 10
msg2_len	equ	$-msg2
msg3 		db 	"Your triangle is nonsense!", 13, 10, 13, 10
msg3_len	equ	$-msg3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Begin the text section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section	.text

global triangle
triangle:
	; Save registers
	push rbx
	push rbp
	
	; Save current value of rsp register
	mov rbp, rsp
	
	; Print out the welcome message
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg1				; Provide the memory location to start reading our characters to print
	mov rdx, msg1_len			; Provide the number of characters print
	syscall

	; Allocate space in stack to store a, b, and c
	sub rsp, 24
	
	; Call C function to get the length of the sides
	mov rdi, rsp
	call get_sides				
	
	; Call assembly function to compute the area of the triangle
	mov rdi, [rsp]				; a
	mov rsi, [rsp+8]			; b
	mov rdx, [rsp+16]			; c	
	call compute_area			
	mov rbx, rax				; Save the area in rbx
	cmp rbx, 0
	jne valid_triangle

	; Print out the 'nonsense' message
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg3				; Provide the memory location to start reading our characters to print
	mov rdx, msg3_len			; Provide the number of characters print
	syscall
	
valid_triangle:	
	; Call C++ function to show the results
	movsd xmm0, [rsp]			; a
	movsd xmm1, [rsp+8]			; b
	movsd xmm2, [rsp+16]		; c
	push rbx	
	movsd xmm3, [rsp]			; area
	pop rbx
	call show_results
		
	; Print out the bye message
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg2				; Provide the memory location to start reading our characters to print
	mov rdx, msg2_len			; Provide the number of characters print
	syscall	
	
	; Return
	push rbx	
	movsd xmm0, [rsp]			; Set return value to area
	pop rbx 
	mov rsp, rbp				; Free up the space that was reserved in stack for input array
	pop rbp
	pop rbx
	ret
