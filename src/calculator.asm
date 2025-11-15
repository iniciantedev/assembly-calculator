.globl _start

_start:
	lea req0(%rip), %rax
	call write

	lea operation(%rip), %rax
	mov $10, %rdi
	call read

	lea req1(%rip), %rax
	call write
	
	lea input1(%rip), %rax
	mov $10, %rdi
	call read
	
	lea req2(%rip), %rax
	call write

	lea input2(%rip), %rax
	mov $10, %rdi
	call read
	
	lea input1(%rip), %rsi
	call ascii2int
	mov %rax, %rdi

	lea input2(%rip), %rsi
	call ascii2int
	
	lea operation(%rip), %rbx
	movb (%rbx), %cl
	cmpb $'+', %cl
	je add
	cmpb $'-', %cl
	je sub
	cmpb $'/', %cl
	je div
	cmpb $'*', %cl
	je mult

	add:
		add %rax, %rdi /* rdi = rdi + rax */
		jmp end
	sub:
		sub %rax, %rdi /* rdi = rdi - rax */
		jmp end

	div: /* esta operação não esta pronta, termina-la */
		xor %rdx, %rdx

		/* rax(dest) = rdi(src) rdi(src) = rax(dest) */
		mov %rax, %rsi
		mov %rdi, %rax
		mov %rsi, %rdi


		idivq %rdi /* rax = rax / rdi */
		movq %rax, %rdi /* rdi = rax */
		jmp end

	mult:
		imul %rax, %rdi /* rdi = rdi * rax */
		jmp end

	end:

		lea tmp(%rip), %rsi
		call int2ascii

		call write

		mov $60, %rax
		mov $0, %rdi
		syscall

	/*
	strlen:
	in: RAX = ponteiro
	out: RAX = tamanho
	*/

	strlen:
		mov %rax, %rsi
	w_loop:
		mov (%rax), %cl
		test %cl, %cl
		je w_done
		inc %rax
		jmp w_loop
	w_done:
		sub %rsi, %rax
		ret
	
	/*
	write:
	in: rax = buffer
	*/
	write:
		call strlen
		mov %rax, %rdx
		mov $1, %rdi
		mov $1, %rax
		syscall
		ret

	/*
	in:
	rax = buffer
	rdi = size_t
	*/

	read:
		mov %rdi, %rdx
		mov %rax, %rsi
		mov $0, %rax
		mov $0, %rdi
		syscall
		dec %rax
		movb $0, (%rsi,%rax)
		ret
	/*
	int2ascii:
	in:
	RSI = buffer + sizeof(buffer)
	RDI = numero
	; out:
	; RAX = buffer
	*/

	int2ascii:
	movb $0, (%rsi)
	mov %rdi, %rax

	loop_c:
		xor %dl, %dl
		mov $10, %rbx
		div %rbx
		add $'0', %dl
		dec %rsi
		mov %dl, (%rsi)
		test %rax, %rax
		jne loop_c
		mov %rsi, %rax
		ret

	/*
	ascii2int:
	in:
	RSI = ascii
	out:
	RAX = int
	*/
	ascii2int:
		xor %rax, %rax
		c_loop:
		movzbl (%rsi), %ebx
		cmpb $0, %bl
		je .done
		subb $'0', %bl
		mov $10, %rcx
		mul %rcx
		add %rbx, %rax
		inc %rsi
		jmp c_loop
	.done:
		ret

.data
	req0: .ascii "enter the operation (+, -, *, /): \0"
	req1: .ascii "enter the first number: \0"
	req2: .ascii "\nenter the second number: \0"

.bss
	input1: .skip 10
	input2: .skip 10
	tmp: .skip 10
	operation: .skip 10
