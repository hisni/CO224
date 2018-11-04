@ ARM Assembly - exercise 6
@ 
@ Roshan Ragel - roshanr@pdn.ac.lk
@ Hasindu Gamaarachchi - hasindu@ce.pdn.ac.lk

	.text 	@ instruction memory

	
@ Write YOUR CODE HERE	

@ ---------------------	
@Implement gcd subroutine to find gcd of arg1 and arg2
gcd:
	sub sp,#4
	str lr,[sp,#0]
	check:
	mov r7,r0
	cmp r0,r1
	beq exit
	bgt algorithm
	mov r0,r1
	mov r1,r7
	b check

exit :
	mov r0,r1
	ldr lr,[sp,#0]
	add sp,#4
	mov pc,lr

algorithm :				@Euclideian Algo
	sub r7,r7,r1
	cmp r7,#0
	beq exit
	blt nega
	b algorithm

nega :
	add r7,r1,r7
	mov r8,r1
	mov r1,r7
	mov r7,r8
	
	b algorithm
	











@ ---------------------	

	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	mov r4, #64 	@the value a
	mov r5, #24 	@the value b
	

	@ calling the mypow function
	mov r0, r4 	@the arg1 load
	mov r1, r5 	@the arg2 load
	bl gcd
	mov r6,r0
	

	@ load aguments and print
	ldr r0, =format
	mov r1, r4
	mov r2, r5
	mov r3, r6
	bl printf

	@ stack handling (pop lr from the stack) and return
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	.data	@ data memory
format: .asciz "gcd(%d,%d) = %d\n"

