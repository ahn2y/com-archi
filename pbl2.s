	AREA DATA, DATA, READWRITE

COEFF
    ; Linear Phase FIR 계수 (Q15 형식)
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
    ; 입력 샘플 데이터 (Q0 형식)
    DCW 0x0034, 0x0024, 0x0012, 0x0010
    DCW 0x0120, 0x0142, 0x0030, 0x0294

    AREA RESET, CODE, READONLY
    ENTRY
    EXPORT Reset_Handler

Reset_Handler
    ; FIR 필터 계산: y(0) = Σ(h(i) * x(i)) for i=0 to 6
    LDR R0, =SAMPLE     ; 입력 샘플 주소 (x(0)부터)
    LDR R1, =COEFF      ; 필터 계수 주소 (h(0)부터)
    MOV R2, #7          ; 루프 카운터 (7개 계수)
    MOV R3, #0          ; 누적합 초기화 (Q15 형식으로 누적)

FIR_Loop
    LDRSH R4, [R0], #2  ; x(i) 로드 (Q0, 부호 확장)
    LDRSH R5, [R1], #2  ; h(i) 로드 (Q15, 부호 확장)
    
    ; Q0 * Q15 = Q15 곱셈
    SMULL R6, R7, R4, R5   ; R7:R6 = R4 * R5 (64bit 결과)
    
    ; Q15 결과를 누적 (상위 비트 오버플로우 체크)
    ADDS R3, R3, R6        ; 하위 32비트 누적
    
    ; 루프 카운터 감소 및 조건 분기
    SUBS R2, R2, #1
    BNE FIR_Loop

    ; Q15 결과를 Q0로 변환 (15비트 우측 시프트)
    MOV R1, R3, ASR #15    ; 최종 결과를 R1에 저장 (Q0 형식)

Stop
    B Stop
    END