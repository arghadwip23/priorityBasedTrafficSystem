ORG 00H

MAIN:
    MOV TMOD, #20H     ; Timer1 Mode2
    MOV TH1, #0FDH     ; 9600 baud @ 11.0592 MHz
    MOV SCON, #50H     ; Serial mode 1, REN=1
    SETB TR1           ; Start Timer1

LOOP:
    MOV A, #'A'        ; Send test character
    ACALL TX
    SJMP LOOP

TX:
    MOV SBUF, A
WAIT: JNB TI, WAIT
    CLR TI
    RET
END
