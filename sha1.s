.global sha1_chunk

sha1_chunk:
	push %rbp				#Subroutine porologue
	movq %rsp, %rbp

	pushq %r10				#Pushing all calee-saved regs in order to use them freely
	pushq %r11
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
	pushq %rbx

	movq $16, %rdx				#Initialize i=16
	messLoop:
		movq %rdx, %rcx			#i
		subq $3, %rcx			#i-3

		movl (%rsi, %rcx, 4), %eax	#Copy value of w[i-3] to %eax

		movq %rdx, %rcx			#i
		subq $8, %rcx			#i-8
		xorl (%rsi, %rcx, 4), %eax 	#w[i-3] = xor(w[i-8],w[i-3])


		movq %rdx, %rcx			#i
		subq $14, %rcx			#i-14

		xorl (%rsi, %rcx, 4), %eax	#w[i-3] = xor(xor(w[i-3],w[i-8]),w[i-14])


		movq %rdx, %rcx			#i
		subq $16, %rcx			#i-16

		xorl (%rsi, %rcx, 4), %eax 	#w[i-3] = xor(xor(w[i-3],w[i-8],w[i-14],w[i-16])
		roll $1, %eax

		movl %eax, (%rsi, %rdx, 4) 	#w[i] = xor of all the values

		incq %rdx			#i++
	cmp $80, %rdx
		jne messLoop			#If i!=80 continue loop


	movl (%rdi), %ecx			#%ecx = a
	movl 4(%rdi), %r8d			#%r8d = b
	movl 8(%rdi), %r9d			#%r9d  = c
	movl 12(%rdi), %r10d			#%r10d = d
	movl 16(%rdi), %r11d			#%r11d = e

	movq $0, %rdx				#i=0
	mainLoop1:
		movl %r8d, %r12d  		#Copy b to %r12d
		and %r9d, %r12d  		#r12d = and(b,c)

		mov %r8d, %r13d  		#Copy b to %r13d
		not %r13d       		#negate b
		and %r10d, %r13d 		#and (not b) d

		or  %r13d, %r12d 		#Calculated value of f

		mov %ecx, %r13d 		#move a to temp
		rol $5, %r13d   		#Rotateleft a by 5
		add %r12d, %r13d 		#Add f
		add %r11d, %r13d 		#Add e
		add $0x5A827999, %r13d 		#Add k
		add (%rsi, %rdx, 4), %r13d 	#Add w[i] 

		mov %r10d, %r11d 		#e = d
		mov %r9d, %r10d  		#d = c
		rol $30, %r8d   		#Leftrotate b by 30
		mov %r8d, %r9d   		#c = b
		mov %ecx, %r8d  		#b = a
		mov %r13d, %ecx 		#a = temp

		incq %rdx			#i++
	cmp $20, %rdx
		jne mainLoop1			#If i!=20 continue loop


	mainLoop2:
		mov %r8d, %r12d  		#copy b to %r12d
		xor %r9d, %r12d  		#xor b and c
		xor %r10d, %r12d 		#xor b and c and d


		mov %ecx, %r13d 		#move a to temp
                rol $5, %r13d   		#Rotateleft a by 5
                add %r12d, %r13d 		#Add f
                add %r11d, %r13d 		#Add e
                add $0x6ED9EBA1, %r13d 		#Add k
                add (%rsi, %rdx, 4), %r13d 	#Add w[i]

                mov %r10d, %r11d 		#e = d
                mov %r9d, %r10d  		#d = c
                rol $30, %r8d   		#Leftrotate b by 30
                mov %r8d, %r9d   		#c = b
                mov %ecx, %r8d  		#b = a
                mov %r13d, %ecx 		#a = temp

		incq %rdx			#i++
	cmp $40, %rdx
		jne mainLoop2			#If i!=40 continue loop


	mainLoop3:
		mov %r8d, %r12d 		#copy b to r12d
		and %r9d, %r12d 		#and b c

		mov %r8d, %r13d 		#copy b to %r13d
		and %r10d, %r13d 		#and b d

		or %r13d, %r12d			#or (and b c) (and b d)

		mov %r9d,%r13d			#copy c to %r13d
		and %r10d, %r13d		#and c d

		or %r13d, %r12d			#or with the rest



		mov %ecx, %r13d			#move a to temp
                rol $5, %r13d   		#Rotateleft a by 5
                add %r12d, %r13d		#Add f
                add %r11d, %r13d 		#Add e
		mov $0x8F1BBCDC, %eax		#Add k value to temp reg %eax
                add %eax, %r13d 		#Add k
                add (%rsi, %rdx, 4), %r13d 	#Add w[i]

                mov %r10d, %r11d 		#e = d
                mov %r9d, %r10d  		#d = c
                rol $30, %r8d   		#Leftrotate b by 30
                mov %r8d, %r9d   		#c = b
                mov %ecx, %r8d  		#b = a
                mov %r13d, %ecx 		#a = temp

		incq %rdx			#i++
	cmp $60, %rdx
		jne mainLoop3			#If i!=60 continue loop


	mainLoop4:
                mov %r8d, %r12d  		#copy b to %r12d
                xor %r9d, %r12d  		#xor b and c
                xor %r10d, %r12d 		#xor b and c and d

		mov %ecx, %r13d 		#move a to temp
                rol $5, %r13d   		#Rotateleft a by 5
                add %r12d, %r13d 		#Add f
                add %r11d, %r13d 		#Add e
		mov $0xCA62C1D6, %eax		#Add k value to temp reg %eax
                add %eax, %r13d 		#Add k
                add (%rsi, %rdx, 4), %r13d 	#Add w[i]

                mov %r10d, %r11d 		#e = d
                mov %r9d, %r10d 		#d = c
                rol $30, %r8d   		#Leftrotate b by 30
                mov %r8d, %r9d   		#c = b
                mov %ecx, %r8d  		#b = a
                mov %r13d, %ecx 		#a = temp

                incq %rdx			#i++
        cmp $80, %rdx
                jne mainLoop4			#If i!=80 continue loop


	add %ecx, (%rdi)			#Add value to the original ones
	add %r8d,  4(%rdi)
	add %r9d,  8(%rdi)
	add %r10d, 12(%rdi)
	add %r11d, 16(%rdi)


	popq %rbx				#Pop default values of calle-saved registers
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %r11
	popq %r10

	movq %rbp, %rsp				#Subroutine epilogue
	popq %rbp
	ret
