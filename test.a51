;============================================================
; 4-WAY TRAFFIC LIGHT SYSTEM (N, E, S, W)
; Ambulance Priority on INT0 (North direction gets priority)
;============================================================

ORG 0000H
SJMP START

ORG 0003H
SJMP AMBULANCE_ISR

;--------------------------
; Bit definitions
;--------------------------

; North Lights
N_Red    BIT P1.0
N_Yel    BIT P1.1
N_Grn    BIT P1.2

; East Lights
E_Red    BIT P1.3
E_Yel    BIT P1.4
E_Grn    BIT P1.5

; South Lights
S_Red    BIT P2.0
S_Yel    BIT P2.1
S_Grn    BIT P2.2

; West Lights
W_Red    BIT P2.3
W_Yel    BIT P2.4
W_Grn    BIT P2.5

;============================================================
; MAIN PROGRAM
;============================================================
START:
    MOV IE, 10000001B    ; Enable EA + EX0
    MOV TCON, 00000001B  ; INT0 edge-triggered

MAIN_LOOP:

;============================================================
; PHASE 1: North-South GREEN, East-West RED
;============================================================
    ; NS = Green
    SETB N_Grn
    CLR  N_Yel
    CLR  N_Red

    SETB S_Grn
    CLR  S_Yel
    CLR  S_Red

    ; EW = Red
    SETB E_Red
    CLR  E_Yel
    CLR  E_Grn

    SETB W_Red
    CLR  W_Yel
    CLR  W_Grn

    ACALL DELAY5s

;============================================================
; PHASE 2: North-South YELLOW, East-West RED
;============================================================
    SETB N_Yel
    CLR  N_Grn

    SETB S_Yel
    CLR  S_Grn

    ACALL DELAY2s

;============================================================
; PHASE 3: East-West GREEN, North-South RED
;============================================================
    ; EW Green
    SETB E_Grn
    CLR  E_Yel
    CLR  E_Red

    SETB W_Grn
    CLR  W_Yel
    CLR  W_Red

    ; NS Red
    SETB N_Red
    CLR  N_Yel
    CLR  N_Grn

    SETB S_Red
    CLR  S_Yel
    CLR  S_Grn

    ACALL DELAY5s

;============================================================
; PHASE 4: East-West YELLOW, North-South RED
;============================================================
    SETB E_Yel
    CLR  E_Grn

    SETB W_Yel
    CLR  W_Grn

    ACALL DELAY2s

    SJMP MAIN_LOOP

;============================================================
; AMBULANCE PRIORITY (INT0)
; Only NORTH gets green priority
;============================================================
AMBULANCE_ISR:

    ; ALL directions red first
    SETB N_Red
    SETB E_Red
    SETB S_Red
    SETB W_Red

    ; NORTH green priority
    SETB N_Grn
    CLR  N_Red
    CLR  N_Yel

    ACALL DELAY5s     ; Give time for ambulance

    RETI

;============================================================
; Delay routines
;============================================================

DELAY2s:
    MOV R7,#40
D2_LOOP:
    ACALL DELAY50ms
    DJNZ R7,D2_LOOP
    RET

DELAY5s:
    MOV R7,#100
D5_LOOP:
    ACALL DELAY50ms
    DJNZ R7,D5_LOOP
    RET

DELAY50ms:
    MOV R6,#200
L1: MOV R5,#200
L2: DJNZ R5,L2
    DJNZ R6,L1
    RET

END
