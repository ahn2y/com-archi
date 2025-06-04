	AREA	RESET, CODE, READONLY
	ENTRY
	EXPORT  Reset_Handler
		
	DCD     Reset_Handler

Reset_Handler
	MOV r0, #120
		
OuterLoop
	MOV r1, #1000
	
InnerLoop
	SUBS r1, r1, #1
	BNE InnerLoop
	SUBS r0, r0, #1
	BNE OuterLoop
	
Stop
	B Stop
	
	END