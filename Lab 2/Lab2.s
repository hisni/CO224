@ ARM Assembly - lab 2
@ 
@ Roshan Ragel - roshanr@pdn.ac.lk
@ Hasindu Gamaarachchi - hasindu@ce.pdn.ac.lk

	.text 	@ instruction memory
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	@ load values
	mov r0, #10
	mov r1, #5 @j
	mov r2, #7
	mov r3, #-8

	
	@ Write YOUR CODE HERE to perform the following task.
	
	@	Sum = 0;
	@	for (i=0;i<10;i++){
	@			for(j=5;j<15;j++){
	@				if(i+j<10) sum+=i*2
	@				else sum+=(i&j);	
	@			}	
	@	} 
	@ Put final sum to r5


	@ ---------------------
	mov r5,#0
	mov r6,#0
	
	loop1 : cmp r6,#10
		bge exit
		mov r1, #5
		loop2: cmp r1,#15
			bge loopt
			add r7,r6,r1
			cmp r7,10
			bge else
			ADD r8,r6,r6
			ADD r5,r5,r8
			ADD r1,r1,#1
			b loop2
			else:
				AND r9,r1,r6	
				ADD r5,r5,r9
				ADD r1,r1,#1
				b loop2
			loopt:
				ADD r6,r6,#1
				b loop1
	exit:
	@ ---------------------
	
	
	@ load aguments and print
	ldr r0, =format
	mov r1, r5
	bl printf

	@ stack handling (pop lr from the stack) and return
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	.data	@ data memory
format: .asciz "The Answer is %d (Expect 300 if correct)\n"

