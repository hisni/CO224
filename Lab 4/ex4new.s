
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

    ldr r0, =formatps       @Enter the number of strings :
	bl printf

    sub sp, sp, #4
	ldr r0, =formatsint
	mov r1, sp
    bl scanf
	ldr r11, [sp,#0]		@number of strings
	add sp, sp, #4

    cmp r11,#0              @
    blt exit1               @ no of str < 0 -> invalid input
    beq exit2               @ no of str = 0 -> no input
 
	sub sp, sp, #100
	
    ldr r0, =formatp3   @Enter input String :
    mov r1,#0
    bl printf

    mov r5, sp
	loopStr:
	ldr	r0, =formats
	mov	r1, r5
	bl scanf
	ldrb r6,[r5,#0]

	cmp r6,#'\n'
	beq exit
	add r5,r5,#1
	b loopStr

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
exit1:
exit2:
	.data	@ data memory

formatsint: .asciz "%d"
formats: .asciz "%c"
formatps: .asciz "Enter the number of strings :\n" 
formatp1: .asciz "Invalid number\n"
formatp2: .asciz "No input\n"
formatp3: .asciz "Enter input String %d : "
formatp4: .asciz "Output string %d is :\n"
formatp: .asciz "%s\n"

