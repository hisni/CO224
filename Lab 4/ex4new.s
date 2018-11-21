	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	ldr r0,=formatp1
        bl printf
        
	sub sp, sp, #4 // get space for the string
	mov r1,sp

	ldr r0, =formats1	//scanf(%d)
	bl scanf
	
        ldr r8,[sp,#0]
 	add sp,sp,#4
	
	sub sp, sp, #100	// get space for the string
	mov r5, sp		// move the address to r5

	sub sp, sp, #1		// get space for the char
	mov r1,sp
	ldr	r0,=formats2
	bl scanf
	add sp,sp,#1

	cmp r8,#0
	ble invalid
	mov r9,#0
 
	
	mainloop:
		cmp r9,r8
          	beq exit
           	
		ldr r0, =formatp5	//printf("Enter the input strings %d:\n")
		mov r1, r9
		bl printf

        	mov r7,#0		// string length
		
		loop:			// scan chars
		ldr r0, =formats2	// scanf("%c")
		mov r1, r5
		bl scanf		// call scanf
		ldrb r6,[r5,#0] 	// load the character scanned
        	add r7,r7,#1		// length++	
		cmp r6,#'\n'		// check for new line
		beq reverse		// if new line branch to print in reverse
		add r5,r5,#1		// else adjust stackpointer for next char
		b loop


		reverse:		// printing in reverse
		loop2: cmp r7,#1	// check the first charcter 
        	beq exit1		// if all charcters printed ,go to exit
		sub r5,r5,#1		// adjust stack
        	sub r7,r7,#1		// length--
        	ldrb r1,[r5,#0]		// load the charcater
        	ldr r0,=formatp2	// printf("\n")
        	bl printf		// print
        	b loop2	
       
    		exit1:
		ldr r0,=formatp4	// load the print format 
        	bl printf
        
		//sub r8,r8,#1
		add r9,r9,#1
        	b mainloop
  

invalid:
	ldr r0,=formatp3
        bl printf
        
	 	 
exit:
	add sp,sp,#100

 @   stack handling (pop lr from the stack) and return
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	.data	@ data memory
formats1: .asciz "%d"
formats2: .asciz "%c"
formatp1: .asciz "Enter number of strings:"
formatp2: .asciz "%c"
formatp3: .asciz "invalid Input\n"
formatp4: .asciz "\n"
formatp5: .asciz "Enter the input strings %d:\n"


