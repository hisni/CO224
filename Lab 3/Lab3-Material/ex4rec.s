@ ARM Assembly - exercise 4

	.text 	@ instruction memory
	
	
@ Write YOUR CODE HERE	

@ ---------------------	
fact :
	mov r2,#4
    mov r3,r0
    add r3,r3,#1
	mul r2,r3,r2
	sub sp,sp,r2
	str lr,[sp,#0]

	mov r3,r0
	mov r4,#0

	rect:
		str lr,[sp,r4]
		cmp r3,#0
		beq bran1
		sub r3,r3,#1
		add r4,r4,#4
		bl rect

		cmp r3,r0
		beq exit

		mul r5,r3,r5
		ldr lr,[sp,r6]
		sub r6,r6,#4
		mov pc,lr

	bran1:
		mov r5,#1
		add r3,r3,#1
		ldr lr,[sp,r4]
		sub r4,r4,#4
		mov pc,lr

exit :
	mov r0,r5
	ldr lr,[sp,#0]
	add sp,sp,r8
	mov pc,lr









@ ---------------------	

.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	mov r4, #8 	@the value n

	@ calling the fact function
	mov r0, r4 	@the arg1 load
	bl fact
	mov r5,r0
	

	@ load aguments and print
	ldr r0, =format
	mov r1, r4
	mov r2, r5
	bl printf

	@ stack handling (pop lr from the stack) and return
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	.data	@ data memory
format: .asciz "Factorial of %d is %d\n"

