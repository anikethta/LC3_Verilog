.ORIG x3000
;;; This program calculates some fibonacci numbers because it is easy to test and everything ;;;
INIT    AND R1, R1, #0;
        ADD R1, R1, #10;
        AND R2, R2, #0;
        AND R3, R3, #0;
        ADD R3, R3, #1;

CALC    ADD R4, R2, R3;
        ADD R2, R3, #0;
        ADD R3, R4, #0;
        ADD R1, R1, #-1;
        BRp CALC

HALT
.END