    AREA DATA, DATA, READWRITE

COEFF
    ; [0.5, 0.25, 0.25, 1.0, 0.25, 0.25, 0.5] in Q15
    DCW 0x4000, 0x2000, 0x2000, 0x7FFF
    DCW 0x2000, 0x2000, 0x4000

SAMPLE
    ; [1, 1, 1, 1, 1, 1, 1] in Q0
    DCW 0x0001, 0x0001, 0x0001, 0x0001
    DCW 0x0001, 0x0001, 0x0001

    AREA RESET, CODE, READONLY
    ENTRY
    EXPORT Reset_Handler

Reset_Handler
    ; FIR ���� ��� ����
    LDR R0, =SAMPLE     ; �Է°� �ּ�
    LDR R1, =COEFF      ; ��� �ּ�
    MOV R2, #7          ; loop counter
    MOV R3, #0          ; ������

Loop
    LDRSH R4, [R0], #2  ; x[i]
    LDRSH R5, [R1], #2  ; h[i]
    SMULL R6, R7, R4, R5
    MOV R6, R6, ASR #15 ; Q15 �� Q0
    ADD R3, R3, R6
    SUBS R2, R2, #1
    BNE Loop

    MOV R1, R3          ; ��� �� R1 ����

Stop
    B Stop
    END
