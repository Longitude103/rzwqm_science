C***********************************************************************
C
      SUBROUTINE SHAW_RTDIST (NS,ZS,ROOTDP,RDF)
C
C     THIS PROGRAM CALCULATES THE ROOT RESISTANCES AND FRACTION OF ROOTS
C     WITHIN EACH SOIL LAYER GIVEN THE MAXIMUM ROOTING DEPTH.  A
C     TRIANGULAR ROOTING DENSITY IS ASSUMED HAVING A MAXIMUM DENSITY AT
C     A DEPTH OF ZMXDEN AND ZERO DENSITY AT THE SURFACE AND THE MAXIMUM
C     ROOTING DEPTH.  ZMXDEN IS ASSUMED TO BE A CONSTANT 
C     FRACTION (RMXDEN) OF THE MAXIMUM ROOTING DEPTH.
C     (CURRENTLY RMXDEN IS SET IS DATA STATEMENT)
C***********************************************************************
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
c
      Double precision ZS(300),RDF(300),totrot
C
      DATA RMXDEN/ 0.1d0/
C
        TOTROT=0.0d0
        zs(1)=0.0d0
C   
c      TRANSPIRING PLANT -- CALCULATE FRACTION OF ROOTS IN EACH
C         SOIL LAYER; START BY COMPUTING DEPTH OF MAXIMUM ROOT DENSITY
          ZMXDEN=RMXDEN*ROOTDP
C
          ZMID1=0.0d0
          DO 10 I=1,NS
C           CALCULATE MID-POINT BETWEEN THIS AND NEXT NODE, I.E. THE 
C           LOWER BOUNDARY OF THIS LAYER
            IF (I.LT.NS) THEN
               ZMID2=(ZS(I+1)+ZS(I))/2.0d0
              ELSE
               ZMID2=ZS(NS)
            END IF            
C
            IF (ZMID2.LT.ZMXDEN) THEN
C             BOTTOM OF LAYER IS LESS THAN DEPTH OF MAXIMUM DENSITY
              RDF(I)=(ZMID2-ZMID1)*(ZMID2+ZMID1)/ZMXDEN
     >                      /ROOTDP
             ELSE
C             BOTTOM OF LAYER IS BEYOND DEPTH OF MAXIMUM DENSITY
              IF (ZMID2.LT.ROOTDP) THEN
C               BOTTOM OF LAYER IS WITHIN ROOTING DEPTH
                IF (ZMID1.LT.ZMXDEN) THEN
C                 LAYER STRATTLES DEPTH OF MAXIMUM DENSITY
                  AREA1=(ZMXDEN-ZMID1)*(ZMXDEN+ZMID1)/ZMXDEN
                  AREA2=(ZMID2-ZMXDEN)
     >                  *(2.-(ZMID2-ZMXDEN)/(ROOTDP-ZMXDEN))
                  RDF(I)=(AREA1+AREA2)/ROOTDP
                 ELSE
C                 LAYER IS BEYOND DEPTH OF MAXIMUM ROOTING DENSITY BUT 
C                 IS FULLY WITHIN THE ROOTING DEPTH
                  RDF(I)=(ZMID2-ZMID1)*(2.0d0*ROOTDP-ZMID2-ZMID1)         
     >                  /(ROOTDP-ZMXDEN)/ROOTDP
                END IF
               ELSE

C               BOTTOM OF LAYER IS BEYOND ROOTING DEPTH
                IF (ZMID1.LT.ROOTDP) THEN
C                 TOP OF LAYER IS STILL WITHIN ROOTING DEPTH; THE 
C                 REMAINING FRACTION OF ROOTS ARE WITHIN THIS LAYER
                  RDF(I)=1.0d0-TOTROT
                 ELSE
C                 LAYER IS BEYOND THE ROOTING DEPTH -- NO ROOTS
                  RDF(I)=0.0d0
                END IF
              END IF
            END IF
C           SUM THE TOTAL FRACTION OF ROOTS
            TOTROT=TOTROT + RDF(I)
            ZMID1=ZMID2
   10     CONTINUE
Cc         CALCULATE EFFECTIVE ROOT CONDUCTANCE FOR EACH SOIL LAYER
c         DO 20 I=1,NS
c            RROOT(J,I)=RROOT0(J)*ROOTDN(J,I)/TOTROT(J)
c  20     CONTINUE
c        END IF
c   30 CONTINUE
C
      RETURN
      END

