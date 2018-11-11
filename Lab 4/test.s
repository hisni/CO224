
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	sub sp, sp, #100
	mov r5, sp

	loop:
	ldr	r0, =formats
	mov	r1, r5
	bl scanf
	ldrb r6,[r5,#0]

	cmp r6,#'\n'
	beq exit
	add r5,r5,#1
	b loop

	exit:
	@ load aguments and print
	
	mov r6,#0
	strb r6,[r5,#0]

	mov r1,sp
	ldr r0, =formatp
	bl printf
	add sp, sp, #100

	@ stack handling (pop lr from the stack) and return
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	.data	@ data memory
formats: .asciz "%c"
formatp: .asciz "string : %s\n"
formatp1: .asciz "%c\n"
formatp2: .asciz "hello\n"

