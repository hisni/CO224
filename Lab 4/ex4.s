
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	sub sp, sp, #100		@Make space for chars
	mov r5, sp			@(r5) add of first char
	mov r7,#0			@ (r7) length

	loop:
	ldr r0, =formats	@ %c
	mov r1, r5		@ add for char 
	bl scanf
	ldrb r6,[r5,#0]		@load scanned char
	cmp r6,#'\n'		@check for new line
	beq revPrint		@ branch to print reverse
	add r7,r7,#1		@length++
	add r5,r5,#1		@ sp++
	b loop

	revPrint:
	loop2: cmp r7,#0
        beq exit
	sub r5,r5,#1
        sub r7,r7,#1
        ldrb r1,[r5,#0]
        ldr r0,=formatp
        bl printf
        b loop2

	exit:
	@ stack handling (pop lr from the stack) and return
	ldr r0,=formatp1
        bl printf
	add sp, sp, #100
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	.data	@ data memory
formats: .asciz "%c"
formatp: .asciz "%c"
formatp1: .asciz "\n"


