	AREA DATA, DATA, READWRITE

COEFF
    ; Linear Phase FIR ��� (Q15 ����)
    ; h(0) = h(6) = -0.032 -> 0xFBE7
    ; h(1) = h(5) = 0.038  -> 0x04DD  
    ; h(2) = h(4) = 0.048  -> 0x0625
    ; h(3) = -0.048        -> 0xF9DB
    DCW 0xFBE7  ; h(0) = -0.032
    DCW 0x04DD  ; h(1) = 0.038
    DCW 0x0625  ; h(2) = 0.048
    DCW 0xF9DB  ; h(3) = -0.048
    DCW 0x0625  ; h(4) = 0.048
    DCW 0x04DD  ; h(5) = 0.038
    DCW 0xFBE7  ; h(6) = -0.032

SAMPLE
    ; �Է� ���� ������ (Q0 ����)
    DCW 0x0034, 0x0024, 0x0012, 0x0010
    DCW 0x0120, 0x0142, 0x0030, 0x0294

    AREA RESET, CODE, READONLY
    ENTRY
    EXPORT Reset_Handler

Reset_Handler
    ; FIR ���� ���: y(0) = ��(h(i) * x(i)) for i=0 to 6
    LDR R0, =SAMPLE     ; �Է� ���� �ּ� (x(0)����)
    LDR R1, =COEFF      ; ���� ��� �ּ� (h(0)����)
    MOV R2, #7          ; ���� ī���� (7�� ���)
    MOV R3, #0          ; ������ �ʱ�ȭ (Q15 �������� ����)

FIR_Loop
    LDRSH R4, [R0], #2  ; x(i) �ε� (Q0, ��ȣ Ȯ��)
    LDRSH R5, [R1], #2  ; h(i) �ε� (Q15, ��ȣ Ȯ��)
    
    ; Q0 * Q15 = Q15 ����
    SMULL R6, R7, R4, R5   ; R7:R6 = R4 * R5 (64bit ���)
    
    ; Q15 ����� ���� (���� ��Ʈ �����÷ο� üũ)
    ADDS R3, R3, R6        ; ���� 32��Ʈ ����
    
    ; ���� ī���� ���� �� ���� �б�
    SUBS R2, R2, #1
    BNE FIR_Loop

    ; Q15 ����� Q0�� ��ȯ (15��Ʈ ���� ����Ʈ)
    MOV R1, R3, ASR #15    ; ���� ����� R1�� ���� (Q0 ����)

Stop
    B Stop
    END