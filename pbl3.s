	AREA	RESET, CODE, READONLY
	ENTRY
	EXPORT  Reset_Handler

Reset_Handler
	LDR r0, =Rom_Code ;������ �ڵ��� ���� �ּ�
	LDR r1, =0x11028000 ;Ram ���� �ּ�
	LDR r2, =Rom_Code_End ;������ �ڵ��� �� �ּ�
	SUB r2, r2, r0 ;�ڵ��� �� �ּ� - �ڵ��� ���� �ּ� = �Űܾ��� �ڵ��� ��ü ũ��
	
CopyLoop ;rom -> ram���� �ڵ� ���� ����
	LDR r3, [r0], #4 ;r0 ���� �ش��ϴ� �޸� �ּҿ� �ִ� ��ɾ r3�� ����, r0�� 4 ����
	STR r3, [r1], #4 ;r3�� ��Ƶ� ��ɾ r1 ���� �ش��ϴ� �޸� �ּҿ� ����, r1�� 4 ����
	SUBS r2, r2, #4 ;r2 = r2 - 4
	BNE CopyLoop ;r2�� 0�� �� ������ CopyLoop �ݺ�
	
	LDR r4, =0x11028000
	BX  r4 ;r4�� �ش��ϴ� �ּҷ� �б� (Memory[0x11028000] ���� ����)

Rom_Code ;40ms ���� �ڵ�� ���� (Ram���� �ű� �ڵ�)
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