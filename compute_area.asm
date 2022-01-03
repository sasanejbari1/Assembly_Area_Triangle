;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Begin the text section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section	.text

global compute_area

compute_area:
	push rbp
	mov rbp, rsp
	push rdi
	fld qword [rsp]				; Push a in FPU stack
	pop rdi
	push rsi
	fadd qword [rsp]	 		; Find a+b
	pop rsi
	push rdx
	fadd qword [rsp]			; Find a+b+c	
	pop rdx
	mov rcx, 0x4000000000000000	; 2
	push rcx
	fdiv qword [rsp]			; Find (a+b+c)/2 
	pop rcx
	sub rsp, 8
	fst qword [rsp]				; Store (a+b+c)/2 in runtime stack 	
	mov rcx, [rsp]				; Store (a+b+c)/2 in rcx
	add rsp, 8
	push rdi
	fsub qword [rsp]			; Find s-a
	pop rdi
	sub rsp, 8
	fstp qword [rsp]			; Store s-a in runtime stack 	
	mov rax, [rsp]				; Store s-a in rax
	add rsp, 8
	push rcx
	fld qword [rsp]				; Push s in FPU stack
	pop rcx
	push rsi
	fsub qword [rsp]			; Find s-b
	pop rsi
	sub rsp, 8
	fstp qword [rsp]			; Store s-b in runtime stack 	
	mov r8, [rsp]				; Store s-b in r8
	add rsp, 8
	push rcx
	fld qword [rsp]				; Push s in FPU stack
	pop rcx
	push rdx
	fsub qword [rsp]			; Find s-c
	pop rdx
	push r8
	fmul qword [rsp]			; Find (s-b)(s-c)
	pop r8
	push rax
	fmul qword [rsp]			; Find (s-a)(s-b)(s-c)
	pop rax
	push rcx
	fmul qword [rsp]			; Find s(s-a)(s-b)(s-c)
	pop rcx
	mov rax, 0
	push rax
	fcom qword [rsp]
	pop rax
	fnstsw ax 					; Move status word into AX
	sahf 						; Copy AH into EFLAGS
	mov rax, 0
	jna return_back				; Return 0 in case the value turns out to be negative
	fsqrt
	sub rsp, 8
	fstp qword [rsp]
	mov rax, [rsp]				; set return value to sqrt(s(s-a)(s-b)(s-c))
	add rsp, 8
return_back:	
	mov rsp, rbp
	pop rbp
	ret							; Return
	
