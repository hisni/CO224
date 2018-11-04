@ ARM Assembly - exercise 3

	.text 	@ instruction memory

	
@ Write YOUR CODE HERE	

@ ---------------------	
 Fibonacci:
	sub sp,#4
	str lr,[sp,#0]
	mov r6,#1
	mov r7,#0
	mov r8,#1
	mov r9,#1

	rec:
	cmp r6,r0
	beq exit
	add r6,r6,#1
	add r9,r8,r7
	mov r7,r8
	mov r8,r9
	b rec

exit :
	mov r0,r9
	ldr lr,[sp,#0]
	add sp,#4
	mov pc,lr



@ ---------------------
	
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	mov r4, #8 	@the value n

	@ calling the Fibonacci function
	mov r0, r4 	@the arg1 load
	bl Fibonacci
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
format: .asciz "F_%d is %d\n"

