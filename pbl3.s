	AREA	RESET, CODE, READONLY
	ENTRY
	EXPORT  Reset_Handler

Reset_Handler
	LDR r0, =Rom_Code ;복사할 코드의 시작 주소
	LDR r1, =0x11028000 ;Ram 시작 주소
	LDR r2, =Rom_Code_End ;복사할 코드의 끝 주소
	SUB r2, r2, r0 ;코드의 끝 주소 - 코드의 시작 주소 = 옮겨야할 코드의 전체 크기
	
CopyLoop ;rom -> ram으로 코드 복사 루프
	LDR r3, [r0], #4 ;r0 값에 해당하는 메모리 주소에 있는 명령어를 r3에 저장, r0값 4 증가
	STR r3, [r1], #4 ;r3에 담아둔 명령어를 r1 값에 해당하는 메모리 주소에 저장, r1값 4 증가
	SUBS r2, r2, #4 ;r2 = r2 - 4
	BNE CopyLoop ;r2가 0이 될 때까지 CopyLoop 반복
	
	LDR r4, =0x11028000
	BX  r4 ;r4에 해당하는 주소로 분기 (Memory[0x11028000] 부터 실행)

Rom_Code ;40ms 지연 코드와 같음 (Ram으로 옮길 코드)
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
Rom_Code_End
	
	END