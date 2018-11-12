
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]
	
	ldr r0, =formats
	sub sp, sp, #4	
	mov r1, sp			@r1 for X
	sub sp, sp, #4
	mov r2, sp			@r2 for Y

	bl scanf

	ldr r2, [sp,#0]		@(r2)Y
	ldr r1, [sp,#4]		@(r1)X
	add sp, sp, #8

	mov r3,r1		@r3=r1
	LSL r1,r1,r2		@r2=x*2^Y
	
	LSR r2,r3,r2		@r2=X/(2^Y)
	
	@ load aguments and print
	ldr r0, =formatp

	bl printf

	@ stack handling (pop lr from the stack) and return
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	.data	@ data memory
formats: .asciz "%d %d"
formatp: .asciz "X*(2^Y) = %d, X/(2^Y) = %d\n"

