
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]
	
	sub sp, sp, #4
	ldr r0, =formats
	mov r1, sp			@r1 for X

	bl scanf
	ldr r1, [sp,#0]		@(r1)X
	add sp, sp, #4

	mov r4,r1       @r4=X
    	mov r5,#1       @r5=1
    
    	loop:
    	cmp r5,r4       @ r5,X
    	bgt exit        @ r5> X

    	mov r1,r5           @ r1 = r5
    	ldr r0, =formatp    
    	bl printf
    	add r5, r5, #1      @ r5++

    	b loop

exit:
    @ stack handling (pop lr from the stack) and return
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	.data	@ data memory
formats: .asciz "%d"
formatp: .asciz "%d\n"

