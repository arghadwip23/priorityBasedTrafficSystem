;===========================================================
; TWO-WAY TRAFFIC LIGHT CONTROLLER WITH AMBULANCE PRIORITY
; MCU   : AT89S52 (8051 family)
; XTAL  : 12 MHz
;===========================================================

ORG 0000H
LJMP START        ; Main program start

; --- Interrupt vector for external interrupt 0 (INT0) ---
ORG 0003H
LJMP AMB_ISR

;===========================================================
; BIT DEFINITIONS
;===========================================================

; Main Road lights (Road A)
A_RED   BIT P1.0
A_YEL   BIT P1.1
A_GRN   BIT P1.2

; Cross Road lights (Road B)
B_RED   BIT P1.3
B_YEL   BIT P1.4
B_GRN   BIT P1.5

; Ambulance indicator LED
AMB_IND BIT P2.0    ; P2.0 lights up during interrupt

;===========================================================
; MAIN PROGRAM
;===========================================================

ORG 0030H
START:
    MOV IE, #10000001B     ; EA=1, EX0=1 enable external interrupt
    MOV TCON, #00000001B   ; Edge triggered INT0
    CLR AMB_IND             ; Ensure indicator off at start

MAIN_LOOP:

    ; --- MAIN ROAD GREEN, CROSS ROAD RED ---
    CLR AMB_IND
    SETB A_GRN
    SETB B_RED
    CLR  A_YEL
    CLR  A_RED
    CLR  B_YEL
    CLR  B_GRN
    ACALL DELAY10S

    ; --- MAIN ROAD YELLOW ---
    CLR  A_GRN
    SETB A_YEL
    ACALL DELAY3S
    CLR  A_YEL
    SETB A_RED

    ; --- CROSS ROAD GREEN ---
    SETB B_GRN
    CLR  B_RED
    ACALL DELAY10S

    ; --- CROSS ROAD YELLOW ---
    CLR  B_GRN
    SETB B_YEL
    ACALL DELAY3S
    CLR  B_YEL
    SETB B_RED

    SJMP MAIN_LOOP

;===========================================================
; AMBULANCE INTERRUPT SERVICE ROUTINE
;===========================================================
AMB_ISR:
    SETB AMB_IND             ; Turn ON indicator on P2.0
    SETB A_GRN               ; Main road green
    CLR  A_RED
    CLR  A_YEL
    SETB B_RED
    CLR  B_YEL
    CLR  B_GRN

    ACALL DELAY10S           ; 10 seconds ambulance priority

    CLR  AMB_IND             ; Turn OFF indicator after ISR
    SETB A_RED
    CLR  A_GRN
    RETI

;===========================================================
; DELAY SUBROUTINES (accurate for ~12 MHz)
;===========================================================

; ~3 seconds
DELAY3S:
    MOV R7, #70
D3_LOOP:
    ACALL DELAY50MS
    DJNZ R7, D3_LOOP
    RET

; ~10 seconds
DELAY10S:
    MOV R7, #230
D10_LOOP:
    ACALL DELAY50MS
    DJNZ R7, D10_LOOP
    RET

; ~50 ms base delay
DELAY50MS:
    MOV R6, #200
D50_OUTER:
    MOV R5, #200
D50_INNER:
    DJNZ R5, D50_INNER
    DJNZ R6, D50_OUTER
    RET

END
