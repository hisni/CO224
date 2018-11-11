
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]
	
	sub sp, sp, #4
	ldr r0, =formats
	mov r1, sp			@r1 for X
	sub sp, sp, #4
	mov r2, sp			@r2 for Y

	bl scanf
	ldr r2, [sp,#0]		@(r2)Y
	ldr r1, [sp,#4]		@(r1)X
	add sp, sp, #8

    cmp r1,r2
	beq eqbr

	ldr r0, =formatp2
	b exit

	eqbr:
	ldr r0, =formatp1

	exit:
	@ load aguments and print

	bl printf

	@ stack handling (pop lr from the stack) and return
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	.data	@ data memory
formats: .asciz "%d %d"
formatp1: .asciz "%d and %d are equal\n"
formatp2: .asciz "%d and %d are not equal\n"

