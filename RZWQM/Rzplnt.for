C $Id: Rzplnt.for,v 1.1 2002/08/28 00:00:48 rojas Exp $
C
      FUNCTION AVEMOV(A,NUM,PRES,I)
C
C======================================================================
C
C
C       PURPOSE:  TO CALCULATE THE MOVING AVERAGE OF A TIME DEPENDENT
C             VARIABLE
C
C       REF:  NONE
C
C       VARIABLE DEFFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C
C          A  RA  VECTOR OF REAL NUMBERS REPRESENTING VALUES OF
C                    THE TIME DEPENDENT VARIABLE
C          NUM    IS  SIZE OF VECTOR A
C          PRES   RS  NEW VALUE ENTERING VECTOR A
C          I  IS  NUMBER OF CALLS TO ROUTINE FOR PRESENT MOVING
C                 AVERAGE
C          J  IS  LOOP COUNTER
C          N  IS  NUMBER OF VALUES COMPOSING PRESENT AVERAGE
C
C
C       COMMENTS:  THE VECTOR IS UPDATED IN THIS ROUTINE.  SEE LOOP 20.
C
C       MASS STORAGE FILES:  NONE
C
C
C       EXTERNAL REFERENCES: DBLE
C
C
C       CALLED FROM:  PLMAIN
C
C       PROGRAMMER:  JON HANSON AND KEN ROJAS
C
C       VERSION: 3
C
C======================================================================
C
      INTEGER I,N,NUM,J
      DOUBLE PRECISION A(NUM),AVEMOV,PRES
C
C     --INITIALIZE COUNTERS AND ACCUMULATORS
      N=MIN(I,NUM)
      A(N)=PRES
      AVEMOV=0.0D0
C
C     --FIND AVERAGE FOR THESE NUMBERS
      DO 10 J=1,N
        AVEMOV=AVEMOV+A(J)
   10 CONTINUE
      AVEMOV=AVEMOV/DBLE(N)
C
C     --CHANGE PROGRESSION FOR NEXT TIME
      IF(I.GE.NUM) THEN
        DO 20 J=1,(N-1)
          A(J)=A(J+1)
   20   CONTINUE
      ENDIF
C
      END
      FUNCTION SUMMOV(A,NUM,PRES,I)
C
C======================================================================
C
C
C       PURPOSE:  TO CALCULATE THE MOVING SUM OF A TIME DEPENDENT
C             VARIABLE
C
C       REF:  NONE
C
C       VARIABLE DEFFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C
C          A  RA  VECTOR OF REAL NUMBERS REPRESENTING VALUES OF
C                    THE TIME DEPENDENT VARIABLE
C          NUM    IS  SIZE OF VECTOR A
C          PRES   RS  NEW VALUE ENTERING VECTOR A
C          I  IS  NUMBER OF CALLS TO ROUTINE FOR PRESENT MOVING
C                 AVERAGE
C          J  IS  LOOP COUNTER
C          N  IS  NUMBER OF VALUES COMPOSING PRESENT AVERAGE
C
C
C       COMMENTS:  THE VECTOR IS UPDATED IN THIS ROUTINE.  SEE LOOP 20.
C
C       MASS STORAGE FILES:  NONE
C
C
C       EXTERNAL REFERENCES: DBLE
C
C
C       CALLED FROM:  PLMAIN
C
C       PROGRAMMER:  JON HANSON AND KEN ROJAS
C
C       VERSION: 3
C
C======================================================================
C
      INTEGER I,N,NUM,J
      DOUBLE PRECISION A(NUM),SUMMOV,PRES
C
C     --INITIALIZE COUNTERS AND ACCUMULATORS
      N=MIN(I,NUM)
      IF (N.EQ.0) RETURN
      A(N)=PRES
      SUMMOV=0.0D0
C
C     --FIND AVERAGE FOR THESE NUMBERS
      DO 10 J=1,N
        SUMMOV=SUMMOV+A(J)
   10 CONTINUE
c      AVEMOV=AVEMOV/DBLE(N)
C
C     --CHANGE PROGRESSION FOR NEXT TIME
      IF(I.GE.NUM) THEN
        DO 20 J=1,(N-1)
          A(J)=A(J+1)
   20   CONTINUE
      ENDIF
C
      END
c
      FUNCTION BELL(TC,BMAX,BMIN,BOPT,CNST)
C
C======================================================================
C
C       PURPOSE: STANDARDIZE VALUES OFF OF A BELL CURVE FUNCTION
C              DESCRIBED BY CALLING ROUTINE.
C
C       REF:  HANSON, J.D., J.W. SKILES, AND W.J. PARTON. 1987. SPUR:
C           SIMULATING PLANT GROWTH ON RANGELAND. PAGES 57-74 IN J.R.
C           WIGHT AND J.W. SKILES (EDS.), SPUR: SIMULATION OF
C           PRODUCTION AND UTILIZATION OF RANGELANDS, DOCUMENTATION
C           AND USER GUIDE.  ARS-63.
C
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C        BMAX RS  MAXIMUM TEMPERATURE FOR PLANT ACTIVITY TO OCCUR
C        BMIN RS  MINIMUM TEMPERATURE FOR PLANT ACTIVITY TO OCCUR
C        BOPT RS  OPTIMUM TEMPERATURE FOR PLANT ACTIVITY TO OCCUR
C        TC       RS  PRESENT TEMPERATURE (C)
C        A1       RS  DIFFERENCE BETWEEN BMAX AND TC
C        A2       RS  DIFFERENCE BETWEEN BMAX AND BOPT
C        A3       RS  DIFFERENCE BETWEEN TC AND BMIN
C        A4       RS  DIFFERENCE BETWEEN BOPT AND BMIN
C
C
C       COMMENTS:  THIS CONTINUOUS FUNCTION ALLOWS FOR REDUCTIONS IN
C              PLANT ACTIVITY AT LOW TEMPERATURES AND HIGH
C              TEMPERATURES; IT USES A SKEWED, BELL-SHAPED CURVE TO
C              REPRESENT THE RESPONSE OF PLANT ACTIVITY TO
C              TEMPERATURE.  THE FUNCTION RETURNS VALUES SCALED
C              BETWEEN 0-1.
C
C       MASS STORAGE FILES:  NONE
C
C       EXTERNAL REFERENCES: NONE
C                 NONE
C
C       CALLED FROM:  ENVSTR, RTDETH
C
C       PROGRAMMER: JON HANSON
C
C       VERSION:   2
C
C======================================================================
C
      DOUBLE PRECISION A1,A2,A3,A4,BELL,BMAX,BMIN,BOPT,TC,CNST
C
C     ...INPUT TEMPERATURE MUST BE VALID, I.E., BMIN <= TC <= BMAX
C
      IF(TC.LE.BMAX.AND.TC.GE.BMIN) THEN
        A1=BMAX-TC
        A2=BMAX-BOPT
        A3=TC-BMIN
        A4=BOPT-BMIN
        BELL=(A1/A2*(A3/A4)**(A4/A2))**CNST
C
      ELSE
        BELL=0.0D0
      ENDIF
C
      END
      SUBROUTINE COLNIZ(CLSIZE,CNST,DAY,EVP,PNS,EWP,GITEMP,GIWAT,GRMRAT,
     +    GS,ISTAGE,JGS,NUMDAY,P,PLTMNT,PLTMXT,PLTNEW,PLTOPT,SDLOSS,
     +    SDDVRT,SDTMGM,STEND,T10,TC,VBASE,VRNLZ,VSAT,W5,WATDAY,TMAX,
     +    TMIN,GDDFLG,GSGDD,PLNAME,GDD,VDD,NAMSTG)
C
C======================================================================
C
C       PURPOSE:  TO KEEP TRACK OF NUMBER OF INDIVIDUALS IN EACH OF THE
C             PHENOLOGICAL STAGES.  THE STAGES INCLUDE 1) DORMANT,
C             2) GERMINATING, 3) EMERGED, 4) 4-LEAF, 5) VEGETATIVE,
C             6) REPRODUCTIVE, AND 7) RIPE
C
C       REF:  LESLIE, P.H. 1945. ON THE USE OF MATRICES IN CERTAIN
C           POPULATION MATHEMATICS. BIOMETRIKA 33:183-212.
C
C           HANSON, J. D. AND R. L. OLSON.  1987.  THE SIMULATION OF
C           PLANT BIOGRAPHY. PAGES 110-116 IN: G. FRAISER AND R.A.
C           EVANS (EDS.), SEED AND SEEDBED ECOLOGY OF RANGELAND
C           PLANTS.  USDA/ARS.
C
C
C       VARIABLE DEFINITIONS:
C       VARIABLE     I/O   DESCRIPTION
C       --------     ---   -----------
C       AP           RARY  ACTUAL PROBABILITY PLACED WITH TRANSITION
C                        MATRIX P
C       CLSIZE       RARY  NUMBER OF INDIVIDUALS IN EACH CLASS
C       GRMRAT       R*8   GERMINATION RATE OF SEED (PLANT PARAMETER)
C       GITEMP       R*8   AVERAGE 10-DAY TEMPERATURE THAT MUST BE
C                     EXCEEDED
C                    FOR GERMINATION TO OCCUR (PLANT PARAMETER)
C       GIWAT    R*8   AVERAGE 5-DAY SOIL WATER POTENTIAL THAT MUST
C                     BE EXCEEDED (LESS NEGATIVE) FOR GERMINA-
C                     TION TO OCCUR (PLANT PARAMETER)
C       GS           R*8   PRESENT AVERAGE PLANT GROWTH STAGE
C       I        I*4   DO-LOOP COUNTER
C       J        I*4   DO-LOOP COUNTER
C       MAXCL    I*R   CLASS THAT HAS THE MOST INDIVIDUALS
C       NAME     CARY  NAME ASSOCIATED WITH EACH PHENOLOGICAL CLASS
C       NAMSTG       CHAR  NAME OF THE CLASS THAT HAS THE MOST INDIV.
C       NUMDAY       I*4   NUMBER OF DAYS PLANT HAVE GERMINATED
C       P        RARY  INPUT PROBABILITY TRANSITION MATRIX (PLANT
C                    PARAMETER)
C       PLTNEW       R*8   NUMBER OF PLANTS REACHING THE 4-LEAF STAGE
C       SDDVRT       R*8   SEED MATURITY RATE (PLANT PARAMETER)
C       SDLOSS       R*8   SEED MORTALITY RATE
C       STEND    RARY  GROWTH STAGE THAT MARKS THE END OF A
C                     PHENOLOGICAL STAGE (PLANT PARAMETER)
C       SUMCL    R*8   NUMBER OF INDIVIDUALS IN THE SYSTEM
C       SVR          R*8   SEED SURVIVAL RATE
C       T10          R*8   10-DAY AVERAGE TEMPERATURE
C       SDTMGM       R*8   NUMBER OF STRESS-FREE DAYS NEEDED FOR
C                     GERMINATION TO OCCUR (PLANT PARAMETER)
C       W5           R*8   5-DAY AVERAGE SOIL WATER POTENTIAL
C       WATDAY       R*8   CURRENT NUMBER OF STRESS-FREE DAYS
C
C
C       COMMENTS:
C
C       CALLED FROM:  PGMAIN
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  1.6
C
C======================================================================
      DOUBLE PRECISION CLSIZE(0:7),CNST,DAY,EVP,PNS,EWP,FV,GITEMP,GIWAT,
     +    GRMRAT,GS,P(7,7),PLTMNT,PLTMXT,PLTNEW,PLTOPT,SDLOSS,SDDVRT,
     +    SDTMGM,STEND(2:6),T10,TC,VBASE,VSAT,W5,WATDAY,TMAX,TMIN,
     +    GSGDD(2:6),GDD,VDD,PERCNT
      INTEGER ISTAGE,JGS(2),NUMDAY,VRNLZ,GDDFLG
C
C     LOCAL VARIABLES
      DOUBLE PRECISION AP(7,0:7),CLNZEVP,STAGE,SUM,SUMCL,SVR,ZERO,PMORT,
     +    EFIT
      INTEGER J,MAXCL
      CHARACTER PLNAME*30
      CHARACTER CNAME(7)*12, NAMSTG*12
      PARAMETER(ZERO=0.0D0)
      SAVE CNAME
      DATA FV /0.0D0/
C
C      DATA GSGDD(2), GSGDD(3), GSGDD(4), GSGDD(5), GSGDD(6)
C     +    /0.0D0, 270.0D0, 470.0D0, 760.0D0, 950.0D0/
C
      DATA CNAME /'DORMANT','GERMINATING','EMERGED','4-LEAF',
     +    'VEGETATIVE','REPRODUCTIVE','RIPE'/
C
C     ...ALLOW ENVIRONMENTAL FITNESS TO BE NO LOWER THAN 0.9.  THIS
C        WILL REDUCE THE OVERALL EFFECT OF CURRENT ENVIRONMENT ON
C        PHENOLOGICAL DEVELOPMENT.
      IF(EVP.LT.0.9D0) THEN
        EFIT=0.9D0
      ELSE
        EFIT=EVP
      ENDIF
C
C     ...SET THESE VALUES OF THE TRANSITION PROBABILITY MATRIX
      P(7,7)=1.0D0
      P(7,6)=SDDVRT
      P(6,6)=1.0D0-P(7,6)
C
C     ...DETERMINE IF PLANTS EXIST IN THE CLASSES (INCLUDING SEED)
      SUMCL=ZERO
      DO 10 J=1,7
        SUMCL=SUMCL+CLSIZE(J)
   10 CONTINUE
C
      IF(SUMCL.EQ.ZERO) NUMDAY=0
      IF(SUMCL.GT.ZERO) THEN
C
C       ...CONSTRUCT ACTUAL PROBABILITY TRANSITION MATRIX BASED ON
C       GROWTH STAGE
        IF(CLSIZE(1).GT.ZERO) THEN
          SVR=(CLSIZE(1)-SDLOSS)/CLSIZE(1)
        ELSE
          CLSIZE(1)=ZERO
          SVR=ZERO
        ENDIF
C
C       ...CALL SUBROUTINE TO CALCULATE CLNZEVP FOR WINTER WHEAT
        IF(INDEX(PLNAME,'WINTER WHEAT').NE.0.OR.
     +      INDEX(PLNAME,'winter wheat').NE.0) THEN
          CALL CALCEVP(TC,PNS,CLNZEVP,EWP,PLTMXT,PLTMNT,PLTOPT,CNST)
C
C         ...CALL SUBROUTINE VERNALIZ TO CALCULATE VERNALIZATION
C         FACTOR (FV)
          IF(VRNLZ.EQ.1.AND.FV.LT.1.0D0) THEN
C           ...CALL THE VERNALIZATION SUBROUTINE
            CALL VERNALIZ(TMAX,TMIN,VBASE,VSAT,FV,VDD)
          ELSE
            FV=1.0D0
          ENDIF
        ELSE
          CLNZEVP=1.0D0
          FV=1.0D0
        ENDIF
C
C       ...PHENOLOGICAL STAGES:
C       1.  GROWING DEGREE DAYS METHOD
C       2.  RZWQM FITNESS METHOD
C
c Liwang Ma, 6-28-2006
             IF((TC-PLTMNT).GT.0.0D0) GDD=GDD+TC-PLTMNT
       DO 20 J=2,6
C         ...ACTUAL AP & P CELLS USED ARE 11,21,22,32,33,43,
C         44,54,55,65,66,76,77
C         ALL OTHER CELLS ARE ALWAYS 0
C         AP(N+1,N) IS ZEROED EXCEPT FOR STAGES THAT HAVE BEEN PASSED
          IF(GDDFLG.EQ.1) THEN
C
C           ...CALCULATE NUMBER OF ACCUMULATED DEGREE DAYS ASSUMING BASE
C           TEMPERATURE OF 0 CELCIUS
c            IF(DAY.GE.366.0D0.AND.TC.GT.0.0D0) GDD=GDD+TC
C
c             write (666,*) gdd,GS
C           ...IF INSUFFICIENT NUMBER OF DEGREE DAYS IS ACCUMULATED, FORCE
C           PLANTS TO STAY IN PRESENT DEVELOPMENTAL STAGE
c            IF(GDD.LE.GSGDD(J)) THEN
            IF(GS.LE.STEND(J)) THEN
              AP(J+1,J)=ZERO
              AP(J,J)=P(J,J)+P(J+1,J)
            ELSE
C             ...CALCULATE MORTALITY RATE
              PMORT=1.0D0-(P(J,J)+P(J+1,J))
              IF(PMORT.LT.0.0D0) PMORT=0.0D0
C
C             ...ALLOW DEGREE OF VERNALIZATION TO SLOW DEVELOPMENT RATE BY
C             KEEPING PLANTS IN THE CURRENT STAGE
              IF(VRNLZ.EQ.1.AND.J.EQ.3) THEN
                AP(J+1,J)=FV*P(J+1,J)
              ELSE
                AP(J+1,J)=P(J+1,J)
              ENDIF
C
C             ...THE PROBABILITY OF STAYING IN PRESENT CLASS IS THEN 1.0 MINUS
C             PMORT PLUS THE PROBABILITY OF GOING TO THE NEXT HIGHER CLASS
              AP(J,J)=1.0D0-(PMORT+AP(J+1,J))
            ENDIF
          ELSE
C
C           ...IF APPROPRIATE GROWTH STAGE HAS NOT BEEN REACHED, THEN FORCE
C           ALL PLANTS TO STAY IN PRESENT DEVELOPMENTAL STAGE
            IF(GS.LE.STEND(J)) THEN
              AP(J+1,J)=ZERO
              AP(J,J)=P(J,J)+P(J+1,J)
            ELSE
C             ...FIRST ASSUME THAT MORTALITY RATE IS CONSTANT AND DETERMINED
C             AS 1 - SUM OF THE PROBABILITIES OF STAYING IN PRESENT
C             STAGE AND MOVING TO THE NEXT STAGE
              PMORT=1.0D0-(P(J,J)+P(J+1,J))
              IF(PMORT.LT.0.0D0) PMORT=0.0D0
C
C             ...ALLOW ENVIRONMENT TO SLOW DEVELOPMENT RATE BY KEEPING PLANTS
C             IN THE CURRENT STAGE
              IF(VRNLZ.EQ.1.AND.J.EQ.3) THEN
c                AP(J+1,J)=FV*P(J+1,J)
                AP(J+1,J)=(FV*P(J+1,J))*MIN(CLNZEVP,1.0D0)
              ELSE
                AP(J+1,J)=P(J+1,J)*EFIT
C             AP(J+1,J) = P(J+1,J)
              ENDIF
C
C             ...THE PROBABILITY OF STAYING IN PRESENT CLASS IS THEN 1.0 MINUS
C             PMORT PLUS THE PROBABILITY OF GOING TO THE NEXT HIGHER CLASS
              AP(J,J)=1.0D0-(PMORT+AP(J+1,J))
            ENDIF
          ENDIF
   20   CONTINUE
C
C       ...CALCULATE REMAINING VALUES FOR AP MATRIX
        IF(GDDFLG.EQ.1) THEN
          AP(2,1)=GRMRAT
          AP(1,1)=SVR-AP(2,1)
          AP(7,7)=P(7,7)
          AP(7,6)=SDDVRT
          AP(6,6)=1.0D0-AP(7,6)
        ELSE
C
C         ...SET AP(2,1)
          IF(WATDAY.GE.SDTMGM) THEN
            IF(T10.GE.GITEMP.AND.W5.GE.GIWAT) THEN
              AP(2,1)=GRMRAT
              NUMDAY=NUMDAY+1
            ELSE
              AP(2,1)=ZERO
            ENDIF
          ELSE
            AP(2,1)=ZERO
          ENDIF
C
C         ...SET AP(1,1)
          IF(SVR.GT.ZERO) THEN
            AP(1,1)=SVR-AP(2,1)
          ELSE
            AP(1,1)=ZERO
          ENDIF
C
C         ...SET AP(6,6), AP(7,6), AND AP(7,7) TO REDUCE MOVEMENT IN FINAL
C         TWO CLASSES
          AP(7,7)=P(7,7)
C         .. tested by Liwang Ma (5/31/2001)
          IF(GS.LT.STEND(6)) THEN
            AP(7,6)=0.0D0
          ELSE
            AP(7,6)=SDDVRT*EFIT
          ENDIF
          AP(6,6)=1.0D0-AP(7,6)
        ENDIF
C
C       ...DETERMINE NUMBER OF NEW PLANTS ENTERING SYSTEM
        IF(CLSIZE(3).GT.ZERO) THEN
          PLTNEW=CLSIZE(3)*AP(4,3)
        ELSE
          PLTNEW=ZERO
        ENDIF
        IF(PLTNEW.LT.1.0D-8) PLTNEW=ZERO
C
C       ...UPDATE CLASSES (SIMPLE MATRIX MULTIPLICATION)
C       THE TERM CLSIZE(J)*AP(J,J) IS PLANTS IN CLASS J THAT REMAIN
C       CLSIZE(J)*(1-AP(J,J)) IS PLANTS THAT LEAVE CLASS
C       CLSIZE(J-1)*AP(J,J-1) IS PLANTS ENTERING FROM LOWER CLASS
C       OR CLSIZE(J)  *AP(J+1,J) IS PLANTS GOING TO HIGHER CLASS
C       SO FOR J:CLSIZE(J)*(1-AP(J,J)-AP(J+1,J)) IS DYING PLANTS
C       C & N FROM THESE PLANTS SHOULD BE PUT SOMEWHERE
        DO 30 J=7,1,-1
          CLSIZE(J)=CLSIZE(J-1)*AP(J,J-1)+CLSIZE(J)*AP(J,J)
          IF(CLSIZE(J).LT.ZERO) CLSIZE(J)=ZERO
   30   CONTINUE
C
      ENDIF
C
C     ...DETERMINE DOMINANT CLASS NAMSTG
      IF(CLSIZE(2).GT.ZERO) THEN
        MAXCL=2
      ELSE
        MAXCL=1
      ENDIF
C
      DO 40 J=3,7
        IF(CLSIZE(J).GT.CLSIZE(MAXCL)) MAXCL=J
   40 CONTINUE
      NAMSTG=CNAME(MAXCL)
C
C     ...SET GROWTH STAGE FOR CONTROLLING GROWTH PROCESSES
C     WEIGHTED AVERAGE OF CLASSES 2-7
C     FIRST GET TOTAL OF CLASSES 2-7
      SUM=0.0D0
      DO 50 J=2,7
        SUM=SUM+CLSIZE(J)
   50 CONTINUE
C
C     ...THEN CALCULATE WEIGHTED AVERAGE
      IF(SUM.GT.0.0D0) THEN
        STAGE=0.0D0
        DO 60 J=2,7
          STAGE=STAGE+J*CLSIZE(J)/SUM
   60   CONTINUE
        ISTAGE=INT(STAGE+0.5D0)
      ELSE
        ISTAGE=1
      ENDIF
C
C     ...TO REACH STAGE=2, AT LEAST 25% OF SEED MUST HAVE GERMINATED
      IF(CLSIZE(1).GT.0.0D0) THEN
        IF(ISTAGE.EQ.2.AND.SUM/CLSIZE(1).LT.0.25D0) ISTAGE=1
      ENDIF
C
      IF(NAMSTG.EQ.'EMERGED') JGS(1)=1
C     IF (NAMSTG.EQ.'RIPE') JGS(2)=1
C
c      PRINT*,'DENSITY BY CLASS'
c      WRITE(*,1000) (CLSIZE(J),J=1,7)
C     ...XSURV = 100.0D0 * (SUMCL - CLSIZE(1))/PLTDEN
C     WRITE(*,201) 'PERCENTAGE PLANT SURVIVAL: ',XSURV,'%'
c      WRITE(*,1100) 'GS = ',GS,'NUMBER OF GERMINATION DAYS: ',NUMDAY
      IF(SUM.GT.0.0D0) THEN
        PERCNT=CLSIZE(MAXCL)/SUM*100.0D0
      ELSE
        PERCNT=0.0D0
      ENDIF
      WRITE(*,1200) ISTAGE,NAMSTG,PERCNT
C
      RETURN
 1000 FORMAT(' ',7(F8.3,2X))
 1100 FORMAT(' ',A,F6.4,3X,A,I3)
 1200 FORMAT(' ISTAGE:',I2,'    DOMINANT CLASS: ',A12,
     +    '  % IN DOM CLASS ',F7.3)
      END
C
      SUBROUTINE DCALC(NN,THETA,T,LL,UL,BD,PO,SIL,CLA,EAL,ECA,LWF,SAI,
     +    TBS,TOP,GMN,CAA,CAX,ALA,ALX,ASF,ASF1,ASF2,ASF3)
C
C======================================================================
C
C       PURPOSE:  THIS SUBROUTINE CALCULATES DYNAMIC STRESS FACTORS
C             THROUGHOUT THE SOIL PROFILE ON A DAILY BASIS
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       ALA        I  ALUMINUM SATURATION BELOW WHICH ROOT GROWTH IS
C                 UNAFFECTED (%)
C       ALX        I  ALUMINUM SATURATION ABOVE WHICH ROOT GROWTH IS
C                 NEGLIGIBLE (%)
C       ASF       I/O ACTIVE (MINIMUM) LAYER STRESS FACTOR [0-1]
C       ASF1  I/O MINIMUM OF STRESS FACTORS STP, SCA, OR SAL
C       ASF2  I/O THE SQUARE ROOT OF THE MINIMUM OF STRESS
C                 FACTORS SST OR SAI
C       ASF3  I/O MINIMUM OF STRESS FACTORS SST OR SAL
C       BD         I  BULK DENSITY FOR CURRENT HORIZON [G/CM^3]
C       BDO        L  BD BELOW WHICH ROOT GROWTH IS OPTIMUM AT
C                 OPTIMUM SOIL WATER CONTENT
C       BDX        L  BULK DENSITY AFFECTED BY SETTLING [G/CM^3]
C       CAA        I  CALCIUM SATURATION BELOW WHICH ROOT GROWTH IS
C                 REDUCED (%)
C       CAX        I  CALCIUM SATURATION BELOW WHICH ROOT GROWTH IS
C                 NEGLIGIBLE (CMOL/KG)
C       CLA        I  CLAY (%)
C       CWP        L  WATER-FILLED PORE FRACTION AT WHICH AERATION
C                 LIMITS ROOT GROWTH
C       EAL        I  FRACTION EXCHANGABLE IONS OF ALUMINUM [0..1]
C       ECA        I  FRACTION EXCHANGABLE IONS OF CALCIUM [0..1]
C       GMN        I  FRACTION OF NORMAL ROOT GROWTH WHEN PORE SPACE IS
C                 SATURATED [0-1]
C       I      L  INDEX VARIABLE
C       LL         I  LOWER LIMIT OF PLANT-EXTRACTABLE WATER [M/M]
C       LWF       I/O LAYER ROOT DISTRIBUTION WEIGHTING FACTOR
C       NN         I  NUMBER INTERIOR NODES IN RICHARD'S EQN SOLUTION
C       PO         I  PESTICIDE INITIAL AMT FOR DISS (100)
C       SAI       I/O LAYER AERATION STRESS FACTOR [0..1]
C       SAL        L  ROOT GROWTH STRESS FACTOR FOR ALUMINUM TOXICITY
C       SBD        L  ROOT GROWTH STRESS FACTOR FOR  EXCESSIVE BULK DENSITY
C       SCA        L  ROOT GROWTH STRESS FACTOR FOR CALCIUM DEFICIENCY
C       SIL        I  SILT (%)
C       SMALL  P
C       SST        L  LAYER STRENGTH STRESS FACTOR [0..1]
C       STP        L  FUNCTION FOR CALCULATING DIFFERENT FACTORS
C                 (REDUCE DISS) ON PESTICIDE DISS
C       T      I  SOIL TEMPERATURE IN NUMERICAL CONFIGURATION [C]
C       TBS        I  BASE TEMPERATURE FOR ROOT GROWTH (C)
C       THETA  I  VOLUMETRIC WATER CONTENT [CM^3/CM^3]
C       TOP        I  OPTIMUM TEMPERATURE FOR ROOT GROWTH (C)
C       UL         I  DRAINED UPPER LIMIT OF SOIL WATER FOR THE
C                 FINE EARTH FRACTION [0..1]
C       WFP        L  FRACTION OF PORE SPACE CONTAINING WATER [0..1]
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER: ALLEN JONES; MODIFIED BY JON D. HANSON
C
C       VERSION: 2.0
C
C======================================================================
C
      INTEGER I,NN
      DOUBLE PRECISION WFP,TBS,TOP,GMN,SMALL,SST,STP,CWP,SAL,SCA,BDO,
     +    BDX,CAA,CAX,ALA,ALX,SBD
      DOUBLE PRECISION UL(NN),PO(NN),SAI(NN),ECA(NN),LL(NN),T(NN),
     +    THETA(NN),LWF(NN),BD(NN),ASF(NN),ASF1(NN),ASF2(NN),ASF3(NN),
     +    SIL(NN),CLA(NN),EAL(NN)
      PARAMETER(SMALL=1.0D-10)
C
C     CALCULATE DYNAMIC ROOT GROWTH STRESS FACTORS FOR SOIL LAYERS
      DO 10 I=1,NN
C
C       CALCULATE LAYER TEMPERATURE FACTORS
        IF(T(I).GE.TBS) THEN
          STP=SIN(1.5707D0*(T(I)-TBS)/(TOP-TBS))
        ELSE
          STP=0.0D0
        ENDIF
C Liwang Ma, 6-30-2006 to lower temperature stress on rooting depth.
c         STP=max(STP,0.6d0)
c
C       CALCULATE CRITICAL WATER-FILLED PORE FRACTION
        CWP=0.7D0-0.002D0*CLA(I)
C
C       CALCULATE CALCIUM STRESS FACTOR BY LAYER
        IF(ECA(I).LT.CAA) THEN
          SCA=(ECA(I)-CAX)/(CAA-CAX)
        ELSE
          SCA=1.0D0
        ENDIF
C
C       TEMPORARY FIX:  TURN OFF CALCIUM STRESS
        SCA=1.0D0
C
C       CALCULATE ALUMINUM TOXICITY STRESS FACTOR BY LAYER
        IF(EAL(I).LE.ALA) THEN
          SAL=1.0D0
        ELSEIF(EAL(I).GE.ALX) THEN
          SAL=0.0D0
        ELSE
          SAL=(ALX-EAL(I))/(ALX-ALA)
        ENDIF
C
C       TEMPORARY FIX:  TURN OFF ALUMINUM STRESS
        SAL=1.0D0
C
C       CALCULATE BULK DENSITY STRESS FACTOR BY LAYER
        BDO=1.5D0-0.004D0*(SIL(I)+CLA(I))
        BDX=2.0D0-0.004D0*(SIL(I)+CLA(I))
        IF(BD(I).LE.BDO) THEN
          SBD=1.0D0
        ELSEIF(BD(I).GE.BDX) THEN
          SBD=0.0D0
        ELSE
          SBD=(BDX-BD(I))/(BDX-BDO)
        ENDIF
C
C       CALCULATE LAYER STRENGTH FACTORS
C       THIS IS A WATER-INDUCED STRESS FACTOR
        IF(THETA(I).LT.LL(I)) THEN
          LWF(I)=0.0D0
        ELSEIF(THETA(I).GT.UL(I)) THEN
          LWF(I)=1.0D0
        ELSE
          LWF(I)=(THETA(I)-LL(I))/(UL(I)-LL(I))
        ENDIF
        SST=SBD*LWF(I)**0.5D0
C
C       CALCULATE LAYER AERATION FACTORS
        WFP=THETA(I)/PO(I)
        SAI(I)=1.0D0
        IF(WFP.GT.CWP) THEN
          SAI(I)=1.0D0-(1.0D0-GMN)*(WFP-CWP)/(1.0D0-CWP)
        ENDIF
        IF(SAI(I).LT.0.0D0) SAI(I)=0.0D0
C
C       CALCULATE MINIMUM OF STATIC AND DYNAMIC STRESS FACTORS
C       CHECK FOR POTENTIAL ERRORS IN SOIL FITNESS FUNCTIONS
        IF(STP.GT.1.0D0.OR.STP.LT.0.0D0) THEN
          PRINT*,'ERROR IN CALCULATION OF SOIL TEMPERATURE ',
     +        'FITNESS FUNCTION'
C       PAUSE 'CHECK ON ERROR'
        ENDIF
        IF(SST.GT.1.0D0.OR.SST.LT.0.0D0) THEN
          PRINT*,'ERROR IN CALCULATION OF SOIL WATER ',
     +        'FITNESS FUNCTION'
C       PAUSE 'CHECK ON ERROR'
        ENDIF
        IF(SCA.GT.1.0D0.OR.SCA.LT.0.0D0) THEN
          PRINT*,'ERROR IN CALCULATION OF SOIL CALCIUM ',
     +        'FITNESS FUNCTION'
C       PAUSE 'CHECK ON ERROR'
        ENDIF
        IF(SAL.GT.1.0D0.OR.SAL.LT.0.0D0) THEN
          PRINT*,'ERROR IN CALCULATION OF SOIL ALUMINUM ',
     +        'FITNESS FUNCTION'
C       PAUSE 'CHECK ON ERROR'
        ENDIF
        IF(SBD.GT.1.0D0.OR.SBD.LT.0.0D0) THEN
          PRINT*,'ERROR IN CALCULATION OF SOIL BULK DENSITY ',
     +        'FITNESS FUNCTION'
C       PAUSE 'CHECK ON ERROR'
        ENDIF
        ASF(I)=DMAX1(DMIN1(STP,SST,SAI(I),SCA,SAL),SMALL)
        ASF1(I)=DMAX1(DMIN1(STP,SCA,SAL),SMALL)
        ASF2(I)=DMAX1(DMIN1(SST,SAI(I))**0.5D0,SMALL)
        ASF3(I)=DMAX1(DMIN1(SST,SAL),SMALL)
   10 CONTINUE
      RETURN
      END
C
      FUNCTION DLODG(DWR,PREC,SR,AHLDG,PCLDG,WDLDG,STDEAD)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       AHLDG  I
C       DLODG  O
C       DWR        I
C       EGL        L
C       EPL        L
C       EWL        L
C       PCLDG  I
C       PREC   I
C       SR         I
C       STDEAD     I
C       WDLDG  I
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 HYP
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
      DOUBLE PRECISION AHLDG,DWR,PCLDG,PREC,SR,STDEAD,WDLDG
C     LOCAL VARIABLES
      DOUBLE PRECISION DLODG,EGL,EPL,EWL,HYP
C     --CALCULATE THE EFFECT OF WIND ON PLANT LODGING
      EWL=HYP(WDLDG,DWR)
C
C     --CALCULATE THE EFFECT OF PRECIPITATION ON PLANT LODGING
      EPL=HYP(PCLDG,PREC)
C
C     --CALCULATE THE EFFECT OF AN ANIMAL HERD ON PLANT LODGING
      EGL=HYP(AHLDG,SR)
C
      DLODG=STDEAD*DMIN1(DMAX1(EWL,EPL)+EGL,1.0D0)
C
      END
      FUNCTION EHERBP()
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       EHERBP     O
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
C
      DOUBLE PRECISION EHERBP
C
      EHERBP=1.0D0
C
      END
      FUNCTION ENDFND(DAY,ALEAF,SENES)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       ALEAF  I
C       DAY        I
C       ENDFND     O
C       N      L  EDDY DIFFUSIVITY DECAY CONSTANT AERODYNAMIC
C                 RESISTANCE BETWEEN CANOPY AND MEASUREMENT HEIGHT
C       SENES  I
C       SLOPE  L  SLOPE OF FIELD [RAD]
C       SUMX   L
C       SUMX2  L
C       SUMXY  L
C       SUMY   L
C       TERCPT     L
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
C
      DOUBLE PRECISION SUMXY,SUMX,SUMY,SUMX2,SLOPE,TERCPT,ENDFND,DAY,
     +    ALEAF,SENES
      INTEGER N
C
      IF(SENES.EQ.0.0D0) THEN
C
        SUMXY=0.0D0
        SUMX=0.0D0
        SUMY=0.0D0
        SUMX2=0.0D0
        N=0
        ENDFND=365.0D0
C
      ELSE
C
        SUMXY=SUMXY+DAY*ALEAF
        SUMX=SUMX+DAY
        SUMY=SUMY+ALEAF
        SUMX2=SUMX2+DAY*DAY
        N=N+1
C
        IF(N.GT.1) THEN
          SLOPE=(SUMXY-SUMX*SUMY/N)/(SUMX2-SUMX*SUMX/N)
          TERCPT=SUMY/N-SLOPE*SUMX/N
        ELSE
          SLOPE=0.0D0
          TERCPT=0.0D0
        ENDIF
C
        IF(SLOPE.LT.0.0D0) THEN
          ENDFND=-TERCPT/SLOPE
        ELSE
          ENDFND=DAY+120.0D0-N
        ENDIF
      ENDIF
      IF(ENDFND.GT.365.0D0) ENDFND=365.0D0
C
C
      END
      FUNCTION ENITP(PERCN,EFFN,PMNNIT,IPLTYP)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       EFFN   I
C       ENITP  O
C       IPLTYP     I
C       MINENP     P
C       PERCN  I
C       PMNNIT     I
C       REST   P
C       SPCTN  L
C
C
C       COMMENTS:
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
      DOUBLE PRECISION ENITP,PERCN,PMNNIT,SPCTN,EFFN,HYP,MINENP,REST
      INTEGER IPLTYP
      PARAMETER(MINENP=0.25D0,REST=1.0D0-MINENP)
C
C
      IF(IPLTYP.EQ.1) THEN
        ENITP=1.0D0
      ELSE
        IF(PERCN.GT.PMNNIT) THEN
          SPCTN=PERCN-PMNNIT
          ENITP=REST*HYP(EFFN,SPCTN)+MINENP
        ELSE
          ENITP=MINENP
        ENDIF
      ENDIF
      END
C
      SUBROUTINE ENVSTR(TC,T10,W5,DMD,PNLL,TMAX,TMIN,TOPT,HFMAX,DROTOL,
     +    ETTRS,EVP,ETP,EWP,ENP,EPP,EHP,PNS,STRESS,EWTRS,PERCN,PLTNW,
     +    PMNNIT,EFFN,CNST,IMAGIC,IPLTYP,ISTAGE,IPL)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       CNST   I
C       DROTOL     I
C       EFFN   I
C       EHP       I/O
C       ENP       I/O
C       EPP       I/O
C       ETP       I/O
C       ETTRS I/O
C       EVP       I/O
C       EWP       I/O
C       EWTRS I/O
C       HFMAX  I
C       IMAGIC     I  INDICATOR OF DEBUG OUTPUT
C       IPLTYP     I
C       PERCN  I
C       PMNNIT     I
C       STRESS    I/O (1 - (ACTUAL TRANSP / POTENTIAL TRANSP)).
C       T10        I
C       TC         I
C       TMAX   I  MAXIMUM AIR TEMPERATURE [C]
C       TMIN   I  MINIMUM AIR TEMPERATURE [C]
C       TOPT   I
C       W5         I
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 BELL
C                 EHERBP
C                 ENITP
C                 EPHOP
C                 THRESH
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
C
      DOUBLE PRECISION DROTOL,EHP,ENP,EPP,ETP,ETTRS,EVP,EWP,EWTRS,HFMAX,
     +    PERCN,PMNNIT,STRESS,T10,TC,TMAX,TMIN,TOPT,W5,EFFN,CNST,PNS,
     +    DMD,EMIN,PLTNW,PNLL, bell, ephop,eherbp, enitp, thresh,wsi(10)
C
      INTEGER ISTAGE, IPL
C Liwang Ma, 0 to 0.25 for testing only
      PARAMETER(EMIN=0.0D0)
C
      common /wsi/ wsi, alaireset, heightset, iresetlai, iresetht1
C     ...LOCAL VARIABLES
C      DOUBLE PRECISION BELL,EHERBP,ENITP,EPHOP,THRESH
      INTEGER IPLTYP,IMAGIC
C
      ETP=BELL(TC,TMAX,TMIN,TOPT,CNST)
      EPP=EPHOP()
      EHP=EHERBP()
c       if (wsi(IPL).eq.0.0d0) EWP=0.65D0*EWP+0.35D0
       if (wsi(IPL).eq.0.0d0) EWP=0.85D0*EWP+0.15D0  !since wsi was used based on Kozak et al. (2006)
c       ewp = ewp**0.5
C
C     ...ALLOW NITROGEN STRESS TO BE ELIMINATED IF IMAGIC = -8
      IF(IMAGIC.EQ.-8) THEN
        ENP=1.0D0
c Liwang Ma
        EWP=1.0D0
        PNS=1.0D0
      ELSE
c     tested by Liwang Ma
        ENP=ENITP(PERCN,EFFN,PMNNIT,IPLTYP)
C
C       ...CALCULATE WHOLE-PLANT NITROGEN FITNESS
        IF(ISTAGE.GT.3) THEN
          PNS=DMAX1(DMIN1(1.0D0-(DMD-PLTNW)/(DMD-PNLL),1.0D0),EMIN)
c          PNS=DMAX1(DMIN1(PLTNW/(DMD*0.7d0),1.0D0),EMIN)
        ELSE
          PNS=1.0D0
        ENDIF
      ENDIF
c      ENP = PNS
C
C     CALCULATE ENVIRONMENTAL FITNESS
      EVP=ETP*DMIN1(EWP,PNS,EPP)
C
      ETTRS=BELL(T10,TMAX,TMIN,TOPT,CNST)
      EWTRS=THRESH(HFMAX,DROTOL,W5)
C
      STRESS=1.0D0-EVP
      RETURN
      END
      FUNCTION EPHOP()
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       EPHOP  O
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
C
      DOUBLE PRECISION EPHOP
C
      EPHOP=1.0D0
C
      END
      SUBROUTINE ESTAB(ALMASS,ISTAGE,RTMASS,STMASS,RATRS,cvlbioC,seedrv)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       ALMASS    I/O
C       ISTAGE     I
C       RATRS  I
C       RTMASS    I/O
C       STMASS    I/O
C       ZERO   P
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
      INTEGER ISTAGE
      DOUBLE PRECISION RTMASS,ALMASS,STMASS,RATRS,cvlbioC,seedrv
C
      IF(ISTAGE.EQ.2) THEN
C
C       AT GERMINATION, ASSIGN ROOT WEIGHT
C       ASSIGN 1/10TH OF ROOT WEIGHT EACH DAY IN STAGE 2
C       RATRS IS ROOT/SHOOT RATIO AT EMERGENCE
C
        RTMASS=(cvlbioC-(cvlbioC/(1.0D0+RATRS)))/10.0D0
        STMASS=0.0D0
        ALMASS=0.0D0
      ELSEIF(ISTAGE.EQ.3) THEN
C       INITIALIZE LFWT,STWT,LEAFN,STEMN,ROOTN,SEEDRV,PLA,RLV(1:RTDEP)
        RTMASS=0.0D0
        STMASS=.0000004D0  !seedrv/10.0d0  !.0000004D0
        ALMASS=.000004D0   !seedrv/10.0d0*9.0d0  !.000004D0
c        seedrv=0.0d0
      ENDIF
C     INCLUDE ABILITY TO ADD LEAF AREA OF PLANTS IN CLASSES EMERGENT
C     TO 4-LEAF
C     SUMNEW = CLSIZE(2) + CLSIZE(3)
C     IF (SUMNEW .GT. ZERO .OR. PLTNEW .GT. ZERO) THEN
C     ADDS C & N EVERY DAY THAT PLANTS ARE IN CLASS 2 OR 3
C     PLTWGT = TOT4WT*(CLSIZE(2)/20.0D0+CLSIZE(3)/10.0D0)/SUMNEW
C     IF (PLTNEW .GT. ZERO) THEN
C     ADDS CONSTANT AMOUNT IF ANY # OF NEW PLANTS ENTER CLASS 4
C     TOTNEW = TOT4WT + PLTWGT
C     ELSE
C     TOTNEW = PLTWGT
C     END IF
C
C     SHTMAS = TOTNEW / (1.0D0 + RATRS)
C     RTMASS = TOTNEW - SHTMAS
C
C     STMASS = SHTMAS / (1.0D0 + RATLS)
C     ALMASS = SHTMAS - STMASS
C     ADDS LEAF, STEM, ROOT MASS IF ANY PLANTS HAVE REACHED CLASS 2
C     ELSE
C     RTMASS = ZERO
C     ALMASS = ZERO
C     STMASS = ZERO
C
C     END IF
C     PRINT *, RTMASS, ALMASS, STMASS
      RETURN
      END
      SUBROUTINE FSDDTH(DTSEED,BGSEED,SDSVRT,CVLBIO,SDDETH,SDLOSS)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:  SILVERTOWN (1982), INTRODUCTION TO PLANT POPULATIONS,
C           PAGE 42
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       A0         L  ALBEDO OF DRY SOIL
C       B0         L
C       B1         L
C       BGSEED     I
C       CVLBIO     I
C       DTSEED     I
C       HFLIFE     L
C       SDDETH    I/O
C       SDLOSS    I/O
C       SDMEAN     L
C       SDSVRT     I
C
C
C       COMMENTS: THIS APPROACH ASSUMES ALL PLANTS EXHIBIT DEEVEY
C             TYPE II SURVIVORSHIP--CONSTANT DEATH RISK THROUGHOUT
C             LIFE HISTORY (COLD IN WINTER, ANIMALS AND BACTERIA IN
C             SUMMER, FOR EXAMPLE) AND A UNIFORM MIX OF ALL AGE
C             CLASSES
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
C
      DOUBLE PRECISION HFLIFE,B0,B1,A0,SDMEAN,DTSEED,BGSEED,SDSVRT,
     +    CVLBIO,SDDETH,SDLOSS
C
C     ...CALCULATE 1/2-LIFE DEPENDENT UPON NUMBER OF YEARS FOR TRIAL
C        (DTSEED), BEGINNING SEED POPULATION (BGSEED), AND THE NUMBER
C        OF SEEDS SURVIVING AFTER DTSEED YEARS (SDSVRT).
      IF(BGSEED.NE.SDSVRT) THEN
        HFLIFE=DTSEED*LOG(2.0D0)/(LOG(BGSEED)-LOG(SDSVRT))
      ELSE
        HFLIFE=1.0D-9
      ENDIF
C
C     ...CALCULATE DAILY SEED MORTALITY RATE (NUMBER OF SEEDS LOST)
      B0=LOG(0.5D0)/HFLIFE
C
C     ...APPLY THE MEAN-VALUE THEOREM TO CALCULATE AVERAGE SEED DENSITY
      B1=DTSEED*B0
      A0=BGSEED/B1
      SDMEAN=A0*(EXP(B1)-1.0D0)
C
C     ...CALCULATE DAILY SEED DEATH RATE
      SDLOSS=((BGSEED-SDMEAN)/DTSEED)/365.0D0
C
C     ...CONVERT NUMBER OF SEEDS LOST TO SEED BIOMASS (CVLBIO AS
C     G/SEED)
      SDDETH=SDLOSS*CVLBIO
      RETURN
      END
C      FUNCTION GROINT (DAY,BIOSHT,BIORT,T10,ETTRS,EWTRS,RATRS,GITEMP,
C     1BEGSEN,ENDSEN)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       AGEFCT     L
C       BEGSEN     I
C       BIORT  I
C       BIOSHT     I
C       DAY        I
C       ENDSEN     I
C       ETTRS  I
C       EWTRS  I
C       GITEMP     I
C       GROINT     O
C       RATRS  I
C       T10        I
C       TRSMAX     L
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.C
C======================================================================
C
C      DOUBLE PRECISION AGEFCT,TRSMAX,GROINT,DAY,BIOSHT,BIORT,T10,ETTRS,
C     1EWTRS,RATRS,GITEMP,BEGSEN,ENDSEN
C
C      IF (DAY.LE.BEGSEN) THEN
C         AGEFCT=1.0D0
C      ELSE
C         AGEFCT=1.0D0/3.0D0+2.0D0/3.0D0*(ENDSEN-DAY)/(ENDSEN-BEGSEN)
C      END IF
C
C      AGEFCT=DMAX1(AGEFCT,1.0D0/3.0D0)
C
C      IF (T10.GT.GITEMP.AND.BIOSHT*RATRS.LT.BIORT) THEN
C         TRSMAX=BIORT-BIOSHT*RATRS
C         GROINT=TRSMAX*AGEFCT*ETTRS*EWTRS
C      ELSE
C         GROINT=0.0D0
C      END IF
C
C      END
      SUBROUTINE GRSTAG(ISTAGE,EVP,DEVRAT,GS,GDDFLG,TC,PLTMNT,GDD)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       DEVRAT     I
C       EVP        I
C       FACT   L
C       GS        I/O GROWTH STAGE [0..1]
C       ISTAGE     I
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
C
      DOUBLE PRECISION DEVRAT(2:7)
      DOUBLE PRECISION GS,EVP,FACT,PLTMNT,TC,GDD
      INTEGER ISTAGE,GDDFLG
      SAVE FACT
      DATA FACT /1.0D0/
C
C     ...THE INCREMENT IN GROWTH STAGE IS THE DEVELOPMENT RATE
C        FOR THE DOMINANT CLASS REDUCED BY THE CURRENT ENVIRONMENTAL
C        CONDITIONS
C
      IF(ISTAGE.GT.1) THEN
        IF(EVP.GE.0.6D0) THEN
          FACT=1.15D0-0.25D0*EVP
        ELSEIF(EVP.LT.0.6D0.AND.EVP.GE.0.2D0) THEN
          FACT=0.25D0*EVP+0.85D0
        ELSE
          FACT=0.9D0
        ENDIF
        IF(FACT.LT.0.9D0) FACT=0.9D0
        IF(FACT.GT.1.0D0) FACT=1.0D0
c Liwang Ma, 6-29-2006
        if (GDDFLG.eq.0) then
        GS=GS+DEVRAT(ISTAGE)*FACT
	  else
        GS=GS+DEVRAT(ISTAGE)*(TC-PLTMNT)*FACT
        endif
      ELSE
        GS=0.0D0
      ENDIF
      GS=DMIN1(GS,1.0D0)
c      write (666,*) istage,GS,GDD
C
      RETURN
      END
      FUNCTION HYP(AK,X)
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       AK         I
C       HYP        O
C       TEMP1  L
C       X      I  I: PREVIOUS SOLUTION VECTOR, O: REPLACED WITH XNEW
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
C
      DOUBLE PRECISION TEMP1,HYP,AK,X
C
      TEMP1=-X*AK
C
      IF(TEMP1.LT.-25.0D0) THEN
        HYP=1.0D0
      ELSEIF(TEMP1.GE.0.0D0) THEN
        HYP=0.0D0
      ELSE
        HYP=1.0D0-EXP(TEMP1)
      ENDIF
C
      END
      SUBROUTINE MORTAL(EWP,TMIN,DWR,PREC,SR,BIOLF,BIOSHT,SDAMAX,SDWMAX,
     +    SFREEZ,AHLDG,PCLDG,WDLDG,TDSL,STDEAD,CLSIZE,ALMORT,BIOSD,
     +    STMORT,SDDETH,SDMORT,DAY,ENDSEN,BEGSEN,NAMSTG)
C
C=======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       AHLDG  I
C       ALMORT    I/O
C       BIOLF  I
C       BIOSD  I
C       BIOSHT     I
C       CLSIZE     I
C       DWR        I
C       EWP        I
C       PCLDG  I
C       PREC   I
C       SDAMAX     I
C       SDDETH     I
C       SDMORT    I/O
C       SDWMAX     I
C       SFREEZ     I
C       SMORT  L
C       SR         I
C       STDEAD     I
C       STMORT    I/O
C       TDSL  I/O
C       TMIN   I  MINIMUM AIR TEMPERATURE [C]
C       WDLDG  I
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES: RTDETH, SHTDET
C                 DLODG
C                 SHTDET
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
      DOUBLE PRECISION AHLDG,ALMORT,BIOLF,BIOSD,BIOSHT,CLSIZE(0:7),DWR,
     +    EWP,PCLDG,PREC,SDAMAX,SDDETH,SDMORT,SDWMAX,SFREEZ,SR,STDEAD,
     +    STMORT,TDSL,TMIN,WDLDG,DAY,ENDSEN,BEGSEN
      CHARACTER NAMSTG*12
C
C     ...LOCAL VARIABLES
      DOUBLE PRECISION DLODG,SHTDET,SMORT
C
      SMORT=SHTDET(EWP,TMIN,BIOSHT,SDAMAX,SDWMAX,SFREEZ,NAMSTG,CLSIZE,
     +    DAY,ENDSEN,BEGSEN)
C
C     MAKE SURE SMORT IS NOT LARGER THAN 10% ABOVEGROUND BIOMASS
      IF(SMORT.GT.0.10D0*BIOSHT) SMORT=0.10D0*BIOSHT
C
      IF(BIOSHT.GT.0.0D0) THEN
C       ...MAKE THE ASSUMPTION THAT DEATH IS DISTRIBUTED IN PROPORTION TO
C       THE RELATIVE PROPORTIONS OF LEAVES AND SHOOTS
        ALMORT=SMORT*BIOLF/BIOSHT
        STMORT=SMORT-ALMORT
      ELSE
        ALMORT=0.0D0
        STMORT=0.0D0
      ENDIF
C
      IF(SDDETH.GT.BIOSD) THEN
        SDMORT=BIOSD
      ELSE
        SDMORT=SDDETH
      ENDIF
C
      TDSL=DLODG(DWR,PREC,SR,AHLDG,PCLDG,WDLDG,STDEAD)
      RETURN
      END
C
      SUBROUTINE PARTIT(DMDRT,PNS,EWP,GS,ISTAGE,ERP,PERCL6,PGDVRT,PLEAF,
     +  PNCA,PSTEM,PPROP,STEND,RATRS,RATLS,sla1,sla2,dmdnit,plden,INFIX)
C======================================================================
C
C       PURPOSE: CALCULATE THE PARTITIONING OF CARBON BETWEEN THE
C              ROOTS AND SHOOTS OF A PLANT SPECIES
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       AGFACT     L
C       BHIGH  L
C       BLOW   L
C       DMDRT I/O DRY MATTER ALLOCATION TO ROOT SYSTEM ON A DAY (KG/HA)
C       ENP        I
C       ERP        I
C       EWP        I
C       GS         I  GROWTH STAGE [0..1]
C       ISTAGE     I
C       PERCL6     I
C       PGDVRT     I
C       PLEAF I/O
C       PLEFT  L
C       PNCA   I
C       PPROP I/O
C       PSHOOT     L
C       PSTEM I/O
C       RATLS  I
C       RATRS  I
C       REQL   L
C       REQR   L
C       REQS   L
C       REQT   L
C       STEND  I
C
C       COMMENTS:
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
      INTEGER ISTAGE
      DOUBLE PRECISION DMDRT,PNS,EWP,GS,ERP,PSHOOT,PERCL6,PGDVRT,PLEAF,
     +    PNCA,PSTEM,PPROP,STEND(2:6),c2bm,dmdnit
      DOUBLE PRECISION AGFACT,PLEFT,RATLS,RATRS,REQT,REQR,REQS,REQL
      DOUBLE PRECISION BLOW,BHIGH,sla1,sla2,plden
      double precision rfixn
      parameter (c2bm=2.5d0,RFIXN=2.830d0)
C
      double precision CNOD,DWNOD,DWNODA,NDTH,NFIXN,NODGR,WTNFX,
     +  SENNOD(300),DNOD,CTONOD,CTONODS,WNDOT,WTNOO,NNOFF,WTNNO,PRONOD
      COMMON/NFIX1/CNOD,DWNOD,DWNODA,NDTH,NFIXN,NODGR,WTNFX,
     +  SENNOD,DNOD,CTONOD,CTONODS,WNDOT,WTNOO,NNOFF,WTNNO,PRONOD
C     ...DETERMINE ROOT, SHOOT, AND LEAF MAINTENANCE REQUIREMENTS
      IF(ISTAGE.GT.2.AND.ISTAGE.LE.6) THEN
        REQT=sla1*PNCA
        REQR=sla2*REQT
        IF(ISTAGE.EQ.6) THEN
          REQS=sla2*REQT
          REQL=0.0D0
        ELSE
          REQS=sla1*REQT
          REQL=sla1*REQT
        ENDIF
      ELSE
        REQT=0.0D0
        REQR=0.0D0
        REQS=0.0D0
        REQL=0.0D0
      ENDIF
      PLEFT=PNCA-REQT
C
C     ...ALLOCABLE CARBON CAN BE PARTITIONED INTO:
C     PROPAGULES, LEAVES, STEMS, ROOTS
C     PROPAGULES GET FIRST ACCESS TO ALLOCATABLE CARBON (PNCA)
C
      IF(PERCL6.GT.0.0D0.OR.ISTAGE.GT.5) THEN
        IF(GS.GE.STEND(6)) THEN
          PPROP=PLEFT
        ELSE
          PPROP=PLEFT*PGDVRT
        ENDIF
      ELSE
        PPROP=0.0D0
      ENDIF
      PLEFT=PLEFT-PPROP
C
C     ...DETERMINE AGE EFFECT FOR ROOT/SHOOT AND LEAF/STEM PARTITIONING
      BLOW=(STEND(4)+STEND(5))*0.5D0
      BHIGH=(STEND(5)+STEND(6))*0.5D0
      IF(GS.GE.BHIGH) THEN
        AGFACT=0.0D0
      ELSEIF(GS.LT.BLOW) THEN
        AGFACT=1.0D0
      ELSE
        AGFACT=(BHIGH-GS)/(BHIGH-BLOW)
      ENDIF
C
C     ...DIVIDE REMAINING CARBON BETWEEN ROOTS AND SHOOTS
C     IF ISTAGE > 6, THERE IS NO ROOT GROWTH
C     IF GS <= STEND(2), THERE IS NO LEAF OR STEM GROWTH
C     ALLOW MORE CARBON TO ROOTS IF UNDER WATER OR NITROGEN STRESS
      IF(PLEFT.LE.0.0D0) THEN
        DMDRT=0.0D0
        PSHOOT=0.0D0
      ELSEIF(ISTAGE.GT.5) THEN
        DMDRT=0.0D0
        PSHOOT=PLEFT
      ELSEIF(GS.LE.STEND(2)) THEN
        DMDRT=PLEFT
        PSHOOT=0.0D0
      ELSE
        PSHOOT=PLEFT/(1.0D0+RATRS/MAX(0.5D0,MIN(EWP,PNS)))
C ADDED BY LIWANG MA TO INCOPORATE N-FIXATION FROM CROPGRO
C        infix=1
        IF (INFIX.EQ.1) THEN
        CTONOD = MAX(0.0d0, (DMDNIT-ALFTN-TNITUP)*(plden/10.0d0)
     &           *RFIXN/0.16d0)
        IF (CTONODS.GT.CTONOD) THEN
            CTONODS=CTONODS-CTONOD
            CTONODR=0.0d0
        ELSE
            CTONODR=CTONOD-CTONODS
            CTONODS=0.0d0
        ENDIF
        ENDIF
        DMDRT=PLEFT-PSHOOT-CTONODR/C2BM/(plden/10.0d0)
        IF (DMDRT.LT.0.0D0) THEN
            DMDRT=0.0D0
            CTONOD=(PLEFT-PSHOOT)*C2BM*(plden/10.0d0)
        ENDIF
      ENDIF
C
C     ...PARTITIONING BETWEEN LEAVES AND STEMS
C     IF LOW LIGHT; THEN GROW MORE LEAVES (ERP)
C     AS PLANT GETS OLDER; GROW MORE STEM
C     AS PLANT MATURES; L/S DECREASES
      IF(PSHOOT.GT.0.0D0) THEN
        PSTEM=PSHOOT/(1.0D0+AGFACT*RATLS/ERP)
        PLEAF=PSHOOT-PSTEM
      ELSE
        PSTEM=0.0D0
        PLEAF=0.0D0
      ENDIF
C
C     ...DETERMINE TOTAL ALLOCATION TO PLANT PARTS
      DMDRT=DMDRT+REQR
      PSTEM=PSTEM+REQS
      PLEAF=PLEAF+REQL
C
C     ...END PROGRAM
      RETURN
      END
      SUBROUTINE PGINIT(NN,RINIT,TOT4WT,RATRS,SINIT,RADHGT,PLHGHT,
     +    PLDIAM,SHTDEN,PLBIO,DTSEED,BGSEED,SDSVRT,CVLBIO,SDDETH,SDLOSS,
     +    TLT,ZA)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       BGSEED     I
C       CVLBIO     I
C       DTSEED     I
C       I      L  INDEX VARIABLE
C       NN         I  NUMBER INTERIOR NODES IN RICHARD'S EQN SOLUTION
C       PI         P  MATHEMATICAL CONSTANT = 3.141592654...
C       PLBIO  I
C       PLDIAM     I
C       PLHGHT     I
C       RADHGT    I/O
C       RATRS  I
C       RINIT I/O
C       SDDETH     I
C       SDLOSS     I
C       SDSVRT     I
C       SHTDEN    I/O
C       SINIT I/O
C       TLAPSE     L
C       TLAY   L
C       TLT        I  DEPTH TO BOTTOM OF NUMERICAL LAYERS [CM]
C       TOT4WT     I
C       ZA        I/O MEAN LAYER DEPTH [M]
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 FSDDTH
C
C
C       CALLED FROM:
C
C       PROGRAMMER:
C
C       VERSION:  2.0
C
C======================================================================
      INTEGER I,NN
      DOUBLE PRECISION BGSEED,CVLBIO,DTSEED,PI,PLBIO,PLDIAM,PLHGHT,
     +    RADHGT,RATRS,RINIT,SDSVRT,SDDETH,SDLOSS,SHTDEN,SINIT,TOT4WT
      DOUBLE PRECISION TLT(NN),ZA(NN)
      DOUBLE PRECISION TLAPSE,TLAY
      PARAMETER(PI=3.141592654D0)
C
C======================================================================
C   START CALCULATIONS TO DETERMINE PLANT GROWTH
C======================================================================
      RINIT=TOT4WT*RATRS/(1.0D0+RATRS)
      SINIT=TOT4WT-RINIT
C
      RADHGT=(PLDIAM*0.5D0)/PLHGHT
      SHTDEN=PLBIO/(PI*(PLDIAM*0.5D0)**2.0D0*PLHGHT)
C
      CALL FSDDTH(DTSEED,BGSEED,SDSVRT,CVLBIO,SDDETH,SDLOSS)
C
C     CALCULATE DEPTH TO CENTER OF EACH SOIL LAYER
      DO 10 I=1,NN
C       ..CONVERT FROM CM TO M
        TLAY=TLT(I)*0.01D0
        IF(I.EQ.1) THEN
          ZA(1)=TLAY*0.5D0
        ELSE
C         ..CALCULATE LAPSED SOIL LAYER DEPTH; CONVERT FROM CM TO M
          TLAPSE=TLT(I-1)*0.01D0
          ZA(I)=TLAPSE+(TLAY-TLAPSE)*0.5D0
        ENDIF
   10 CONTINUE
      RETURN
      END
C
      SUBROUTINE PGMAIN(TRFDD,DAY,TMAX,TMIN,RTOTAL,PP,DWR,HEIGHT,ALEAF,
     +    THETA,HEAD,T,TLT,SOILPP,SOILHP,NDXN2H,NN,RDF,JGS,NSC,PLTSLV,
     +    RPOOL,UPNIT,EWP,SDEAD,TLPLNT,XNIT,BASE,FIXN,IPL,IPM,FIRST,PCN,
     +    IMAGIC,PNIT,TADRT,CN,RM,RCN,SDCN,CHLRFL,TDAY,IRES,OMSEA,TLEAF,
     +    jday,iyyy,CO2R,tadrtc,ndxt2n,RCO2,CGSAT,TL,plantNseed,
     +    rwl,rootn)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C  VARIABLE DEFINITIONS:
C  VARIABLE    DESCRIPTION
C  --------    -----------
C
C  ALA     ALUMINUM SATURATION BELOW WHICH ROOT GROWTH IS UNAFFECTED (%)
C  ALX     ALUMINUM SATURATION ABOVE WHICH ROOT GROWTH IS NEGLIGIBLE (%)
C  ASF     ACTIVE (MINIMUM) LAYER STRESS FACTOR (0-1)
C  ASF1    MINIMUM OF STRESS FACTORS STP, SCA, OR SAL
C  ASF2    THE SQUARE ROOT OF THE MINIMUM OF STRESS FACTORS SST OR SAI
C  ASF3    MINIMUM OF STRESS FACTORS SST OR SAL
C  BD      BULK DENSITY OF THE FINE EARTH FRACTION (MG/M3)
C  BDO     BD BELOW WHICH ROOT GROWTH IS OPTIMUM AT OPTIMUM SOIL WATER
C            CONTENT
C  BDX     BD ABOVE WHICH ROOT GROWTH IS NEGLIGIBLE AT OPT. SOIL-WATER
C            CONTENT
C  C2BM    CONVERSION FACTOR FOR G-CARBON ==> G-BIOMASS
C  CAA     CALCIUM SATURATION BELOW WHICH ROOT GROWTH IS REDUCED (%)
C  CAX     CALCIUM SATURATION BELOW WHICH ROOT GROWTH IS NEGLIGIBLE
C            (CMOL/KG)
C  CLA     CLAY (%)
C  CWP     WATER-FILLED PORE FRACTION AT WHICH AERATION LIMITS ROOT
C            GROWTH
C  DCA     CUMULATIVE ACTUAL DRY MATTER INCREASE OF ROOT SYSTEM (KG/HA)
C  DMDRT   DRY MATTER ALLOCATION TO ROOT SYSTEM ON A DAY (KG/HA)
C  DPL     POTENTIAL ROOT GROWTH IN THE LAYER (KG/HA)
C  DPS     POTENTIAL ROOT SYSTEM GROWTH (KG/HA)
C  DRD     POTENTIAL INCREASE IN ROOT DEPTH (M)
C  DRL     CHANGE IN ROOT WEIGHT IN THE LAYER (KM/HA)
C  DWL     DAILY DEATH OF ROOTS IN LAYER (KG/HA)
C  DZ      THICKNESS OF LAYER PENETRATED BY ROOTING FRONT (M)
C  EAL     ALUMINUM SATURATION (%) (IF NOT GIVEN)
C  ECA     CALCIUM SATURATION (%)
C  FCR     FRACTION CARBON IN NORMAL BIOMASS
C  GMN     FRACTION OF NORMAL ROOT GROWTH WHEN PORE SPACE IS SATURATED
C            (0-1)
C  GS      GROWTH STAGE (0-1)
C  GSD     GROWTH STAGE WHEN NORMAL ROOT SENESCENCE BEGINS
C  GSR     GROWTH STAGE WHEN ROOT DEPTH REACHES MAXIMUM
C  GSY     GROWTH STAGE PREVIOUS DAY
C  HEAD    WATER PRESSURE HEAD (CM OF WATER--[-15 BARS=-15000 CM]
C  IPL     INDEX TO PLANT (ONLY GENERIC PLANTS IN THE MASTER LIST)
C  IRES    INDEX TO RESIDUE TYPE (CORN, SOY, WHEAT...)
C  IPM     INDEX TO PLANT MANAGEMENT APPLICATION FROM PLANT MAN SECT
C  IR      NUMBER OF LAYERS WITH ROOTS
C  LAYNDX  SOIL LAYER WHERE SEED IS PLANTED
C  LL      LOWER LIMIT OF PLANT-EXTRACTABLE WATER (M/M)
C  LWA     LENGTH/WEIGHT RATIO FOR ROOTS GROWING ON A DAY IN A LAYER
C            (M/G)
C  LWF     LAYER ROOT DISTRIBUTION WEIGHTING FACTOR
C  LWM     RATIO OF ROOT LENGTH TO WEIGHT IN PLOW LAYER AT MATURITY
C            (M/G)
C  LWN     NORMAL LENGTH/WEIGHT RATIO (KM/KG)
C  LWR     LENGTH/WEIGHT RATIO OF ALL ROOTS IN A LAYER (M/G)
C  LWS     NORMAL RATIO OF ROOT LENGTH TO WEIGHT IN SEEDLING (M/G)
C  MXPEST  MAXIMUM NUMBER OF PESTICIDES
C  NN      NUMBER OF SOIL LAYERS
C  NRD     NORMAL ROOT DEATH IN THE LAYER (KG/HA)
C  PLTDEP  PLANTING DEPTH (M)
C  PO      POROSITY OF THE FINE EARTH FRACTION (%)
C  PSTATE  1: C STRORAGE
C          2: LEAF 
C          3: STEM
C          4: PROPAGULES
C          5: ROOT
C          6: SEED
C          7: STANDING DEAD
C          8: LITTER CARBON
C          9: DEAD ROOT
C  RD      ROOT SYSTEM DEPTH (M)
C  RDP     POTENTIAL ROOT SYSTEM DEPTH ON A DAY (M)
C  RDR     MAXIMUM, NORMAL ROOT DEATH RATE (PROP. OF ROOT GROWTH)
C  RDX     NORMAL MAXIMUM ROOT SYSTEM DEPTH (M)
C  RGA     ACTUAL ROOT GROWTH IN LAYER (KG/HA)
C  RLL     ROOT LENGTH IN THE LAYER (KM/HA)
C  RLV     ROOT LENGTH DENSITY (CM/CM3)
C  RM      MASS OF SURFACE RESIDUE (KG/HA)
C  T       SOIL TEMPERATURE IN THE LAYER (C)
C  SAI     LAYER AERATION STRESS FACTOR (0-1)
C  SAL     ROOT GROWTH STRESS FACTOR FOR ALUMINUM TOXICITY
C  SAN     SAND (%)
C  SBD     ROOT GROWTH STRESS FACTOR FOR EXCESSIVE BULK DENSITY
C  SCA     ROOT GROWTH STRESS FACTOR FOR CALCIUM DEFICIENCY
C  SDEAD   STANDING DEAD CARBON (KG/HA)
C  SDCN    STANDING DEAD C:N RATIO
C  SIL     SILT (%)
C  SST     LAYER STRENGTH STRESS FACTOR (0-1)
C  STP     LAYER TEMPERATURE STRESS FACTOR (0-1)
C  T       LAYER TEMPERATURE (C)
C  TBS     BASE TEMPERATURE FOR ROOT GROWTH (C)
C  TDAY    TOTAL DAYS THAT HAVE PASSED SINCE START OF SIMULATION
C  THETA   LAYER VOLUMETRIC WATER CONTENT (CM WATER/CM SOIL)
C  TLT     DEPTH TO BOTTOM OF LAYER (M)
C  TOP     OPTIMUM TEMPERATURE FOR ROOT GROWTH (C)
C  TRW     TOTAL ROOT SYSTEM WEIGHT (KG/HA)
C  UL      DRAINED UPPER LIMIT OF SOIL WATER FOR THE FINE EARTH FRACTION
C             (M/M)
C  WCG     WEIGHTING COEFFICIENT - GEOTROPISM
C  WCP     WEIGHTING COEFFICIENT FOR PLASTICITY
C  WFL     WEIGHTING FACTOR FOR LAYER (0-1)
C  WFP     FRACTION OF PORE SPACE CONTAINING WATER
C  WFT     WEIGHTING FACTOR, TOTAL
C  WPOT    MAXIMUM SOIL WATER POTENTIAL IN ROOTING ZONE
C  ZA      MEAN LAYER DEPTH (M)
C
C  COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES: AVEMOV,COLNIZ,DCALC,ENVSTR,GROINT,GRSTAG,
C                     MORTAL,PARTIT,PHOPER,PLHGT,PLPROD,RTDIST
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  3.1
C
C======================================================================
C   ARRAY DIMENSION VALUES
C-----------------------------------------------------------------------
      IMPLICIT NONE
      INTEGER MXNOD,MAXHOR,MXAPP,MXSPEC,MXPEST,MXANA,MXNODT,
     +        JDAY,ID,IM,IYYY,LAYNDX,IPTYPE,IEMRG,yrdoy
      DOUBLE PRECISION C2BM,CO2R,CARBO,PAR,PCO2,ALIFAC,RUE,PCARB,PARSR
      REAL TABEX
      DOUBLE PRECISION TARGET1,PNCA1,RMASS,RCO2,SDWTPLR,SDAGER,SPRLAPR
C
      PARAMETER(MXNOD=300,MAXHOR=12,MXAPP=200,MXSPEC=10,MXPEST=3,C2BM=
     +    2.5D0,MXANA=135,mxnodt=3001)
C
C PASSED VARIABLES
      INTEGER JGS(2),NDXN2H(MXNOD),NN,NSC,IPL,IRES,ndxt2n(mxnodt)
C
      DOUBLE PRECISION ALEAF,DAY,DWR,EWP,HEAD(NN),HEIGHT,PLTSLV,PP,
     +    RDF(MXNOD),RPOOL(MXNOD,2),RTOTAL,SDEAD,SOILHP(13,MAXHOR),RM,
     +    SOILPP(8,MAXHOR),T(NN),THETA(NN),TLPLNT,TFIX,FIXN,TLT(NN),
     +    TMAX,TMIN,TRFDD,UPNIT(MXNOD),XNIT,BASE,PCN(0:MXNOD),TADRT(2),
     +    CN(9),RCN,SDCN,TDAY,OMSEA(MXANA),TLEAF,tadrtc(2),TEMPPOP
C
C FUNCTION DECLARATIONS
      DOUBLE PRECISION AVEMOV,CALCWAT,PLPROD,WPRESP
C
C LOCAL VARIABLES
      LOGICAL FIRST,CHLRFL,firstnfix
      CHARACTER NAMSTG*12
      INTEGER I,INWSTG,IR,IRIPE,ISTAGE,IT10,IW5,J,JN,IMAGIC,IPM,IRDAYS,
     +    JJ,NGPL,NUMDAY
C
      DOUBLE PRECISION EXTN,PK,PLTNW,PMAXN,PNLL,PNRED,PNS,TOTC,TOTN,
     +    OLDRT,OLDAL,OLDST,GDEMAND,SDMN,SSCN,PST7
C
      DOUBLE PRECISION FACT,PLTS17,PLTS47,RESP,RTOTC,RWLTOT,S,SEEDRV,
     +    SHTMAS,TOTAVN,TRS,TTC1,TTC2,TTN1,TTN2,TARGET,WAIT,XLN,XSTN,
     +    TOTNP0,TNITN,RTOTN,TLDR,TLSD,TLLT,TOTL,TOTNP,BAL,TOTA,XPROPN,
     +    PROPMX,SEEDMX,PHYTM,RATRSB,GDD,VDD,DMDMAX,XCONVLA
C
      DOUBLE PRECISION TOTNIT,RSD,P(7,7),TL(300),SeedNstore,plantNseed
C
      DOUBLE PRECISION ALFTN,ALMASS,ALMORT,ASF(MXNOD),ASF1(MXNOD),
     +    ASF2(MXNOD),ASF3(MXNOD),ATP(10),BD(MXNOD),BEGSEN,BIOLF,BIOPLT,
     +    BIOSHT,CLA(MXNOD),CLS6,DCA,DMD,DMDRT,DWL(MXNOD),EHP,ENDSEN,
     +    ENP,EPP,ETP,ETTRS,EVP,EWTRS,GS,GSY,LL(MXNOD),LWF(MXNOD),
     +    LWR(MXNOD),OLDHGT,PCTN2,PCTN3,PCTN4,PCTN5,PCTN6,PCTN7,PERCL6,
     +    PERCN,PLEAF,PLTNEW,PLTS26,PLTS27,PLTS36,PLWTS(10,4),PNCA,
     +    PNIT(9),PO(MXNOD),PPROP,PREC,PROVOL,PSTEM,RADHGT,RGA(MXNOD),
     +    RINIT,RLL(MXNOD),RLV(MXNOD),RMORT,ROOTN(MXNOD),RTLAST,RTMASS,
     +    RWL(MXNOD),SAI(MXNOD),SDDETH,SDLOSS,SDMORT,SENES,SHTDEN,
     +    SIL(MXNOD),SINIT,SR,STDEAD,STEMP,STMASS,STMORT,STRESS,SWT(5),
     +    T10,TC,TDSL,THGHT,TLS,TPVS,TSP,TSR,UL(MXNOD),VBASE,VSAT,W5,
     +    WATDAY,WGERM,WPOT,ZA(MXNOD),RATRS,co2x(10),co2y(10)
C
C
C COMMON VARIABLES
      LOGICAL SCL
      DOUBLE PRECISION CEC,EAL,ECA,EMG,ENH4,ENA
      COMMON /SCHMIN/ ECA(MXNOD),ENA(MXNOD),EMG(MXNOD),ENH4(MXNOD),
     +    EAL(MXNOD),SCL(MXNOD,3),CEC(MXNOD)
C
c   
      CHARACTER SOLTYP*10,NMPEST*30,PLNAME*30
      COMMON /NAMES/ NMPEST(MXPEST),SOLTYP(MAXHOR),PLNAME(MXSPEC)
C
      DOUBLE PRECISION AHLDG,ALA,ALNAVL,ALNGER,ALNLW,ALPHA,ALX,BETA,
     +    BGSEED,CAA,CANK,CAX,CONVLA,CVLBIO,DEVRAT,DROTOL,DTSEED,GITEMP,
     +    GIWAT,GMN,GRMRAT,GSR,HFMAX,LWM,LWS,PCLDG,PGDVRT,PGNTGT,PLALFA,
     +    PLBIO,PLDIAM,PLHGHT,PLTMNT,PLTMXT,PLTOPT,PMAX,PMNNIT,PRNLW,
     +    PTLAMX,R20,RATLS,RATRSX,RATRSN,RDR,RDX,RQ10,RTNLW,SDAMAX,
     +    SDDVRT,SDSVRT,SDTMGM,SDWMAX,SFREEZ,SLA1,SLA2,SLA3,SLA4,STEND,
     +    STNAVL,STNGER,STNLW,TBS,TOP,TOT4WT,WCG,WCP,WDLDG,EFFN,CNST,
     +    PRB,GSGDD,SUFNDX,PEXP
      INTEGER IPLTYP,NPL,VRNLZ,GDDFLG,INFIXN
      COMMON /PLNTIN/ AHLDG(MXSPEC),ALA(MXSPEC),ALNAVL(MXSPEC),
     +    ALNGER(MXSPEC),ALNLW(MXSPEC),ALPHA(MXSPEC),ALX(MXSPEC),
     +    BETA(MXSPEC),BGSEED(MXSPEC),CAA(MXSPEC),CANK(MXSPEC),
     +    CAX(MXSPEC),CONVLA(MXSPEC),CVLBIO(MXSPEC),DEVRAT(2:7,MXSPEC),
     +    DROTOL(MXSPEC),EFFN(MXSPEC),DTSEED(MXSPEC),GITEMP(MXSPEC),
     +    GIWAT(MXSPEC),GMN(MXSPEC),GRMRAT(MXSPEC),GSR(MXSPEC),
     +    HFMAX(MXSPEC),PCLDG(MXSPEC),PGDVRT(MXSPEC),PGNTGT(MXSPEC),
     +    PLALFA(MXSPEC),PLBIO(MXSPEC),PLDIAM(MXSPEC),PLHGHT(MXSPEC),
     +    PLTMNT(MXSPEC),PLTMXT(MXSPEC),PLTOPT(MXSPEC),PMAX(MXSPEC),
     +    PMAXN(MXSPEC),PNRED(MXSPEC),PMNNIT(MXSPEC),PRNLW(MXSPEC),
     +    PTLAMX(MXSPEC),R20(MXSPEC),RATLS(MXSPEC),RATRSX(MXSPEC),
     +    RATRSN(MXSPEC),RDR(MXSPEC),RDX(MXSPEC),RQ10(MXSPEC),
     +    RTNLW(MXSPEC),SDAMAX(MXSPEC),SDDVRT(MXSPEC),SDSVRT(MXSPEC),
     +    SDTMGM(MXSPEC),SDWMAX(MXSPEC),SFREEZ(MXSPEC),SLA1(MXSPEC),
     +    SLA2(MXSPEC),SLA3(MXSPEC),SLA4(MXSPEC),STEND(2:6,MXSPEC),
     +    STNAVL(MXSPEC),STNGER(MXSPEC),STNLW(MXSPEC),TBS(MXSPEC),
     +    TOP(MXSPEC),TOT4WT(MXSPEC),WCG(MXSPEC),WCP(MXSPEC),
     +    WDLDG(MXSPEC),CNST(MXSPEC),PRB(7,7,MXSPEC),GSGDD(2:6,MXSPEC),
     +    GDDFLG(MXSPEC),VRNLZ(MXSPEC),SUFNDX(MXSPEC),IPLTYP(MXSPEC),
     +    LWM(MXSPEC),LWS(MXSPEC),NPL,INFIXN(MXSPEC)
C
      DOUBLE PRECISION CLSIZE,DMDNIT,PSTATE,PWRTS,TNITUP,CNUP1,CNUP2,
     +    UPLUX,PLNTSW,PLNTWD
      COMMON /PLNTDA/ CLSIZE(0:7),PSTATE(9),PWRTS,DMDNIT,TNITUP,GS,
     +    CNUP1(MXSPEC),CNUP2(MXSPEC),UPLUX
C
      double precision CNOD,DWNOD,DWNODA,NDTH,NFIXN,NODGR,WTNFX,
     +  CGSAT(MXNOD),rootnup,
     +  SENNOD(300),DNOD,CTONOD,CTONODS,WNDOT,WTNOO,NNOFF,WTNNO,PRONOD
      COMMON/NFIX1/CNOD,DWNOD,DWNODA,NDTH,NFIXN,NODGR,WTNFX,
     +  SENNOD,DNOD,CTONOD,CTONODS,WNDOT,WTNOO,NNOFF,WTNNO,PRONOD
c Liwang Ma, June 24, 2006 to pass rooting depth to nitrogen balance to calculate plant available soil N
	common/rootdepth/ IR
c
      DOUBLE PRECISION ROWSP,PLDEN,PLTDAY,ERP,TOIMB,pldepth
      INTEGER NPGS,NPR
      COMMON /PLNTG/ PLDEN(MXAPP),PLTDAY(MXAPP,2),ROWSP(MXAPP),
     +    PLDEPTH(MXAPP),sdwtplr(mxapp),sdager(mxapp),sprlapr(mxapp),
     +    PLNTSW(MXAPP),PLNTWD(MXAPP),LAYNDX(MXAPP),NPGS,NPR(MXAPP),
     +    NGPL(MXAPP),iptype(mxapp),iemrg(mxapp)
C
      DOUBLE PRECISION RMN,CNEW,TOTGERM,OLDLAI,totalnup
C
      SAVE PLTS27,IRDAYS,STRESS,OLDHGT,DMD,TOTNIT,RSD,RATRSB
      DATA TOTGERM /0.0D0/,GDEMAND /0.0D0/
      data PARSR/0.50d0/      !Conversion of solar radiation to PAR 
      data CO2X/0.0d0,220d0,330d0,440d0,550d0,660d0,770d0,880d0,
     +             990d0,9999d0/
      data CO2Y/0.0d0,0.81d0,1.00d0,1.03d0,1.06d0,1.10d0,1.13d0,
     +             1.16d0,1.18d0,1.25d0/
C
C     ...INITIALIZE VALUES IF FIRST TIME THROUGH
C
      IF(FIRST) THEN
        CALL PGINIT(NN,RINIT,TOT4WT(IPL),RATRSX(IPL),SINIT,RADHGT,
     +      PLHGHT(IPL),PLDIAM(IPL),SHTDEN,PLBIO(IPL),DTSEED(IPL),
     +      BGSEED(IPL),SDSVRT(IPL),CVLBIO(IPL),SDDETH,SDLOSS,TLT,ZA)
C
C       ...INITIALIZE VARIABLES TO ZERO
        OLDST=0.0D0
        OLDAL=0.0D0
        OLDRT=0.0D0
        TOTN=0.0D0
        TOTC=0.0D0
        PNS=0.0D0
        PNLL=0.0D0
        PLTNW=0.0D0
        PK=0.0D0
        EXTN=0.0D0
        TOTA=0.0D0
        BAL=0.0D0
        TOTNP=0.0D0
        TOTL=0.0D0
        TNITN=0.0D0
        RESP=0.0D0
        PLTS47=0.0D0
        PLTS17=0.0D0
        DMDRT=0.0D0
        PLTNEW=0.0D0
        PREC=0.0D0
        RATRS=0.0D0
        PLTSLV=0.0D0
        BASE=0.0D0
        DMDMAX=0.0D0
        ERP=0.0D0
        FACT=0.0D0
        HEIGHT=0.0D0
        PHYTM=0.0D0
        PROPMX=0.0D0
        RMN=0.0D0
        RTOTC=0.0D0
        RTOTN=0.0D0
        RWLTOT=0.0D0
        S=0.0D0
        SDMN=0.0D0
        SEEDMX=0.0D0
        SHTMAS=0.0D0
        SSCN=0.0D0
        STDEAD=0.0D0
        TARGET1=0.0D0
        TLDR=0.0D0
        TLLT=0.0D0
        TLSD=0.0D0
        TOTAVN=0.0D0
        TTC1=0.0D0
        TTC2=0.0D0
        TTN1=0.0D0
        TTN2=0.0D0
c changes made by Liwang Ma, 6-28-2006
        VBASE=8.0D0
        VSAT=33.0D0
        WAIT=0.0D0
        XCONVLA=0.0D0
        XLN=0.0D0
        XNIT=0.0D0
        XPROPN=0.0D0
        XSTN=0.0D0
        PCTN2=0.0D0
        PCTN3=0.0D0
        PCTN4=0.0D0
        PCTN5=0.0D0
        PCTN6=0.0D0
        PCTN7=0.0D0
        RSD=0.0D0
        TOTNIT=0.0D0
        TFIX=0.0D0
        THGHT=0.0D0
        OLDHGT=0.0D0
        IRDAYS=0
        NUMDAY=0
        IW5=0
        WATDAY=0.0D0
        IT10=0
        GS=0.0D0
        GDD=0.0D0
        VDD=0.0D0
        ISTAGE=1
        IRIPE=0
        INWSTG=1
        IR=0
        STRESS=0.0D0
        DCA=0.0D0
        GSY=0.0D0
        TLS=0.0D0
        TRS=0.0D0
        TSP=0.0D0
        TSR=0.0D0
        PLEAF=0.0D0
        PSTEM=0.0D0
        PPROP=0.0D0
        ALMORT=0.0D0
        RMORT=0.0D0
c        SDEAD=0.0D0
        STMORT=0.0D0
        SENES=0.0D0
        ALFTN=0.0D0
        PCN(0)=0.0D0
        PWRTS=0.0D0
        BEGSEN=0.0D0
        BIOLF=0.0D0
        BIOPLT=0.0D0
        BIOSHT=0.0D0
        TOIMB=0.0D0
        CLS6=0.0D0
        EHP=0.0D0
        ENDSEN=0.0D0
        ENP=0.0D0
        EPP=0.0D0
        ETP=0.0D0
        ETTRS=0.0D0
        EVP=0.0D0
        EWTRS=0.0D0
        OLDLAI=0.0D0
        PERCL6=0.0D0
        PERCN=0.0D0
        PLTS27=0.0D0
        PLTS26=0.0D0
        PLTS36=0.0D0
        PNCA=0.0D0
        PROVOL=0.0D0
        RTLAST=0.0D0
        SDMORT=0.0D0
        SR=0.0D0
        STEMP=0.0D0
        T10=0.0D0
        TC=0.0D0
        TPVS=0.0D0
        TDSL=0.0D0
        TOTNP0=0.0D0
        W5=0.0D0
        WGERM=0.0D0
        WPOT=0.0D0
        ALMASS=0.0D0
        STMASS=0.0D0
        RTMASS=0.0D0
        PST7=0.0D0
        TLEAF=0.0D0
        totalnup=0.0d0
        DO 20 J=1,5
          ATP(J)=0.0D0
          ATP(5+J)=0.0D0
          SWT(J)=0.0D0
          DO 10 I=1,4
            PLWTS(J,I)=0.0D0
            PLWTS(J+5,I)=0.0D0
   10     CONTINUE
   20   CONTINUE
        DO 30 I=1,NN
          LWR(I)=LWS(IPL)
          RWL(I)=0.0D0
          RLL(I)=0.0D0
          RLV(I)=0.0D0
          ROOTN(I)=0.0D0
          PCN(I)=0.0D0
          ASF(I)=0.0D0
          ASF1(I)=0.0D0
          ASF2(I)=0.0D0
          ASF3(I)=0.0D0
          BD(I)=0.0D0
          CLA(I)=0.0D0
          DWL(I)=0.0D0
          LL(I)=0.0D0
          LWF(I)=0.0D0
          PO(I)=0.0D0
          SAI(I)=0.0D0
          SIL(I)=0.0D0
          UL(I)=0.0D0
   30   CONTINUE
        DO 40 I=1,9
          PSTATE(I)=0.0D0
          PNIT(I)=0.0D0
   40   CONTINUE
C
C       ...POTENTIAL PARAMETERS FOR LATER VERSIONS
        SEEDRV=cvlbio(ipl)/c2bm  !0.24D0
        SeedNstore=pgntgt(ipl)*cvlbio(ipl)
        DMD=PMAXN(IPL)
C
C       ...DEFINE TRANSITION PROBABIITY MATRIX FOR COLONIZATION MODULE
        DO 60 I=1,7
          DO 50 J=1,7
            P(I,J)=PRB(I,J,IPL)
   50     CONTINUE
   60   CONTINUE
C
C       ...SEEDING RATE
C       NUMBER OF PLANTS IS IN THOUSANDS (1E3) / HECTARE
C        CLSIZE(1)=PLDEN(IPM)
C
           temppop=plden(ipm)
          IF((INDEX(PLNAME(IPL),'ALFALFA').NE.0.or.
     &        INDEX(PLNAME(IPL),'BERMUDAGRASS').NE.0)
     &        .and.temppop.eq.0.0d0) then
          IF ((IPM.EQ.1).AND.TEMPPOP.EQ.0.0D0) STOP 'PLANT POP IS 0'
           do i=1,mxapp
              Temppop=plden(ipm-i)
              if (temppop.gt.0.0d0) goto 123
           enddo
           endif
123       continue
        CLSIZE(1)=TEMPPOP
C       ...SET EXPONENT FOR ROOT/SHOOT RATIO CALCULATION
        RATRSB=-LOG(RATRSN(IPL)/RATRSX(IPL))/STEND(4,IPL)
        firstnfix=.true.
C
        FIRST=.FALSE.
C
      ENDIF
C
C     ...CHECK FOR NITROGEN UPTAKE; ACCUMULATE NITROGEN UPTAKE
      TOTNIT=TOTNIT+TNITUP
C
C     ...CONVERT UNITS FOR MASS BALANCE FROM G-N/PLANT ==> KG-N/HA
c      TLPLNT=TNITUP*PWRTS*1.0D-3
C
C     ...DETERMINE NITROGEN FIXATION RATE IF PLANT IS A N-FIXER
      IF(IPLTYP(IPL).EQ.1.and.pwrts.gt.0.0d0) THEN
c Liwang Ma, July 21, 2005
c        FIXN=min(MAX((DMDNIT-ALFTN-TNITUP)*0.60d0,0.0D0),
c     +       7.0d0/(pwrts*1.0d-3))
        FIXN=MAX(DMDNIT-ALFTN-TNITUP,0.0D0)
C     IF (PSTATE(5) .GT. 0.0D0) THEN
C     IF (TC .GT. 0.0D0 .AND. TC .LT. 40.0D0) THEN
C     FIXN = MAX(0.0033D0*(1.0D0-(ABS(TC-20.0D0)/20.0D0)),
C     +              0.0D0)
C     END IF
C     END IF
C        infix=1
        IF (INFIXN(IPL).EQ.1) THEN
C
           temppop=plden(ipm)
          IF(INDEX(PLNAME(IPL),'ALFALFA').NE.0.
     &        and.temppop.eq.0.0d0) then
           do i=1,mxapp
              Temppop=plden(ipm-i)
              if (temppop.gt.0.0d0) goto 223
           enddo
           endif
223       continue
C
      CALL DSSATNFIX(TEMPPOP/10.d0,CGSAT,T,THETA, 
     +     EWP,TL,NN,firstnfix) 
      FIXN=NFIXN/(TEMPPOP/10.0d0)
      IF (FIXN.LT.MAX(DMDNIT-ALFTN-TNITUP,0.0D0)) THEN
C   NEED TO ADJUST PLANT N CONCENTRATION       
          DMDNIT=ALFTN+TNITUP+FIXN
      ENDIF
      DO I=1,NN
      DWL(I)=DWL(I)+NDTH/C2BM/(TEMPPOP/10.0D0)*RDF(I)*PCN(I)*
     &       (C2BM*0.16D0*PRONOD)
      ENDDO
      ENDIF
      ELSE
        FIXN=0.0D0
      ENDIF
      TFIX=TFIX+FIXN
      TLPLNT=(TNITUP+FIXN)*PWRTS*1.0D-3
      totalnup=totalnup+tlplnt
c      TFIXN=FIXN*PWRTS*1.0D-3
     
C
C     ...ADD ALFTN (SURPLUS NITROGEN FROM PREVIOUS DAY) AND THE
C     AMOUNT OF FIXED NITROGEN TO TODAY'S UPTAKE & ZERO ALFTN
      TNITN=TNITUP+ALFTN+FIXN  !+GDEMAND  !+SeedNstore  !-GDEMAND
      if ((tnitn.gt.0.0d0).and.(SeedNstore.gt.0.0d0)) then
         tnitn=tnitn+SeedNStore
         PlantNseed=PlantNseed+SeedNstore
         SeedNStore=0.0d0
c      PlantNseed=pgntgt(ipl)*cvlbio(ipl)
      endif
      ALFTN=0.0D0
c      IF(PLTS27.GT.0.0D0) PSTATE(7)=SDEAD/PLTS27/C2BM
C
C     ...BEGIN ROUTINE
C
C     ...INITIALIZE DAILY VARIABLES
      STEMP=0.0D0
c      DMDNIT=0.0D0
      RESP=0.0D0
      PWRTS=0.0D0
      PNCA=0.0D0
      ALMASS=0.0D0
      STMASS=0.0D0
      RTMASS=0.0D0
      IW5=IW5+1
C
C
C     ...CALCULATE WATER AVAILABILITY FOR SEED GERMINATION
      IF(INDEX(PLNAME(IPL),'WINTER WHEAT').NE.0.OR.
     +   INDEX(PLNAME(IPL),'winter wheat').NE.0) THEN
        WGERM=CALCWAT(DAY)
      ELSE
        WGERM=HEAD(NDXT2N(INT(PLDEPTH(IPM))))  !Liwang Ma, 10-17-2007
c        WGERM=HEAD(INT(LAYNDX(IPM)))
      ENDIF
      WPOT=-25000.0D0
      DO 70 J=1,NN
        IF(RWL(J).GT.0.0D0) THEN
          WPOT=DMAX1(WPOT,HEAD(J))
        ENDIF
        RDF(J)=0.0D0
        STEMP=STEMP+T(J)/NN
   70 CONTINUE
C
C     ...CALCULATE AVERAGE TEMPERATURE
      TC=(TMAX+TMIN)*0.5D0
      W5=AVEMOV(SWT,5,WGERM,IW5)
C
      IT10=IT10+1
      IF(ISTAGE.LT.3) THEN
        T10=AVEMOV(ATP,10,T(NDXT2N(INT(PLDEPTH(IPM)))),IT10)
      ELSE
        T10=AVEMOV(ATP,10,TC,IT10)
      ENDIF
C
C     ...CONVERT TRFDD FROM CM TO MM
      PREC=TRFDD*10.0D0
C
      BIOSHT=PSTATE(2)+PSTATE(3)
      BIOPLT=BIOSHT+PSTATE(5)
C
C     ...DETERMINE NUMBER OF GROWING PLANTS (CLASSES 4,5, AND 6;
C     4-LEAF STAGE, VEGETATIVE, AND REPRODUCTIVE, RESPECTIVELY
C
      IF(CLSIZE(1).GT.0.0D0) WATDAY=WATDAY+(1.0D0-STRESS)
C
C
C     ...TOTAL OF ALL PLANTS --
C     PLANTED SEEDS TO MATURE OR DEAD AT START OF DAY
      PLTS17=0.0D0
      DO 80 I=1,7
        PLTS17=PLTS17+CLSIZE(I)
   80 CONTINUE
C
      IF(PLTS17.GT.0.0D0) THEN
C
C       ...VARIOUS GROUPINGS OF PLANTS --
        PLTS47=0.0D0
        PLTSLV=0.0D0
C
C       ...ACTIVE(4-LEAF) THROUGH DEAD AT START OF DAY
        DO 90 I=4,7
          PLTS47=PLTS47+CLSIZE(I)
   90   CONTINUE
C
C       ...DETERMINE LIVE PLANTS IN SYSTEM
        IF(ISTAGE.GT.3) THEN
          DO 100 I=4,6
            PLTSLV=PLTSLV+CLSIZE(I)
  100     CONTINUE
        ELSE
          DO 110 I=2,6
            PLTSLV=PLTSLV+CLSIZE(I)
  110     CONTINUE
        ENDIF
C
C       ...ESTIMATE PERCENTAGE N TARGET FOR TOTAL PLANT N CONTENT
C       DMD REPRESENTS THE DESIRED WHOLE-PLANT N CONTENT
C
C       ...METHOD 1
C       ...THIS IS A GENERALIZED METHOD.
C
C       ...DERIVED VARIABLES FOR DMD CALCULATION; TO BE ESTIMATED
C       WHEN DATA IS READ INTO RZWQM
        EXTN=-LOG(PNRED(IPL)/PMAXN(IPL))/STEND(6,IPL)
        PK=PMNNIT(IPL)/(PMAXN(IPL)*EXP(-EXTN))
C
C       ...CALCULATE OPTIMUM N (DMD) AND LOWER LIMIT (PNLL)
        DMD=PMAXN(IPL)*EXP(-EXTN*GS)
        PNLL=DMD*PK
C
C
C       ...DETERMINE PRESENT PERCENTAGE NITROGEN OF PHOTOSYNTHETIC TISSUE
        IF(ISTAGE.GT.3) THEN
          IF(PSTATE(2)+PSTATE(3).GT.0.0D0) THEN
            PERCN=(PNIT(2)+PNIT(3))/((PSTATE(2)+PSTATE(3))*C2BM)
          ELSE
            PERCN=DMD
          ENDIF
        ELSE
          PERCN=DMD
        ENDIF
C
C       ...DETERMINE PERCENTAGE NITROGEN OF THE ENTIRE PLANT
        TOTC=0.0D0
        TOTN=0.0D0
        DO 120 I=2,6
          TOTC=TOTC+PSTATE(I)
          TOTN=TOTN+PNIT(I)
  120   CONTINUE
        IF(TOTC.GT.0.0D0) THEN
          PLTNW=TOTN/(TOTC*C2BM)
        ELSE
          PLTNW=DMD
        ENDIF
C
C       ...DETERMINE ENVIRONMENTAL STRESS
        ENP=1.0D0
        CALL ENVSTR(TC,T10,W5,DMD,PNLL,PLTMXT(IPL),PLTMNT(IPL),
     +      PLTOPT(IPL),HFMAX(IPL),DROTOL(IPL),ETTRS,EVP,ETP,EWP,ENP,
     +      EPP,EHP,PNS,STRESS,EWTRS,PERCN,PLTNW,PMNNIT(IPL),EFFN(IPL),
     +      CNST(IPL),IMAGIC,IPLTYP(IPL),ISTAGE,IPL)
C
        IF(ISTAGE.GT.1) THEN
          CALL GRSTAG(ISTAGE,EVP,DEVRAT(2,IPL),GS,GDDFLG(IPL),
     +                TC,PLTMNT(IPL),GDD)
        ELSE
          GS=0.0D0
        ENDIF
C
C       ..DETERMINE ROOT/SHOOT RATIO AT CURRENT GROWTH STAGE
        RATRS=RATRSX(IPL)*EXP(-RATRSB*GS)
        RATRS=MAX(RATRS,RATRSN(IPL))
C
C       ..SET MANAGEMENT ACTIVATION FLAGS
        JGS(1)=366
C
C       ...DETERMINE PHENOLOGICAL DEVELOPEMENT
        CALL COLNIZ(CLSIZE,CNST(IPL),DAY,EVP,PNS,EWP,GITEMP(IPL),
     +      GIWAT(IPL),GRMRAT(IPL),GS,ISTAGE,JGS,NUMDAY,P,PLTMNT(IPL),
     +      PLTMXT(IPL),PLTNEW,PLTOPT(IPL),SDLOSS,SDDVRT(IPL),
     +      SDTMGM(IPL),STEND(2,IPL),T10,TC,VBASE,VRNLZ(IPL),VSAT,W5,
     +      WATDAY,TMAX,TMIN,GDDFLG(IPL),GSGDD(2,IPL),PLNAME(IPL),GDD,
     +      VDD,NAMSTG)
C
C       ...IF PLANTS ARE KILLED FROM A STAGE, USE THESE VALUES TO
C       CALCULATE C & N AMOUNTS/AREA THAT ARE INVOLVED
        IF(ISTAGE.GT.3) THEN
          DO 130 J=2,6
            PLWTS(J-1,ISTAGE-3)=PSTATE(J)
            PLWTS(J+4,ISTAGE-3)=PNIT(J)
  130     CONTINUE
        ENDIF
C
C       ...DETERMINE TOTAL PLANT POPULATION -- ACTIVE(4-LEAF)
C       THROUGH DEAD FOR DAY
        PLTS47=0.0D0
        DO 140 I=4,7
          PLTS47=PLTS47+CLSIZE(I)
  140   CONTINUE
C
C       ...NUMBER OF PLANTS: GERMINATED TO RIPE
        PLTS27=0.0D0
        DO 150 I=2,7
          PLTS27=PLTS27+CLSIZE(I)
  150   CONTINUE
C
C       ...GET NUMBER OF ACTIVE PLANTS WITH ROOTS PER HECTARE
        PLTS26=0.0D0
        DO 160 I=2,6
          PLTS26=PLTS26+CLSIZE(I)*1.0D3
  160   CONTINUE
C
C       ...DETERMINE NUMBER OF PHOTOSYNTHETICALLY ACTIVE PLANTS (PLTS/M2)
        PLTS36=0.0D0
        DO 170 I=3,6
          PLTS36=PLTS36+CLSIZE(I)/10.0D0
  170   CONTINUE
C
C       ...INITIALIZE ROOTS AT STAGE 2, LEAVES & STEMS AT STAGE 3
C       AT STAGE 2, SET RTMASS; AT STAGE 3, SET ALMASS,STMASS
C       ...ESTABLISH PLANTS
        OLDRT=PNIT(5)
        OLDAL=PNIT(2)
        OLDST=PNIT(3)
        GDEMAND=0.0D0
        IF(ISTAGE.EQ.2.OR.(ISTAGE.EQ.3.AND.ISTAGE.GT.INWSTG)) THEN
          CALL ESTAB(ALMASS,ISTAGE,RTMASS,STMASS,RATRS,cvlbio(ipl)/c2bm,
     +         seedrv)
C
C         ...FEED ROOTS FROM ROOT RESERVE
          IF(ISTAGE.EQ.2) THEN
            SEEDRV=SEEDRV-RTMASS
            if (seedrv.lt.0.0d0) then
              rtmass=rtmass+seedrv
              seedrv=0.0d0
              endif
c            if ((pnit(5))/
c     +         ((pstate(5)+rtmass)*C2BM).lt.rtnlw(IPL)) then
c	         rtmass=min((pnit(5)+RTNLW(IPL)*RTMASS*C2BM)/
c     +         (rtnlw(IPL)*C2BM)-pstate(5),rtmass)
c	         rtmass=max(rtmass,0.0d0)
c	      endif
              
            RWL(1)=RWL(1)+RTMASS
            ROOTN(1)=ROOTN(1)+RTNLW(IPL)*RTMASS*C2BM
            PNIT(5)=PNIT(5)+RTNLW(IPL)*RTMASS*C2BM
c            DMDRT=RTMASS
            PSTATE(5)=PSTATE(5)+RTMASS
            
            RTMASS=0.0D0
          ELSEIF(ISTAGE.EQ.3) THEN
            SEEDRV=SEEDRV-ALMASS
            if (seedrv.lt.0.0d0) then
              almass=almass+seedrv
              seedrv=0.0d0
              endif
            PSTATE(2)=ALMASS
            PNIT(2)=ALNGER(IPL)*ALMASS*C2BM
            ALMASS=0.0D0
            SEEDRV=SEEDRV-STMASS
            if (seedrv.lt.0.0d0) then
              stmass=stmass+seedrv
              seedrv=0.0d0
              endif
            PSTATE(3)=STMASS
            PNIT(3)=STNGER(IPL)*STMASS*C2BM
            STMASS=0.0D0
          ENDIF
          GDEMAND=MAX(PNIT(5)-OLDRT,0.0D0)
          GDEMAND=GDEMAND+MAX(PNIT(2)-OLDAL,0.0D0)
          GDEMAND=GDEMAND+MAX(PNIT(3)-OLDST,0.0D0)
          SeedNstore=SeedNstore-gdemand
C
          INWSTG=ISTAGE
        ELSEIF(ISTAGE.EQ.3) THEN
          IF(SEEDRV.GT.0.0D0) THEN
            IF(SEEDRV.GT.0.016D0) THEN
              SHTMAS=.016D0/(1.0D0+RATRS)
              SEEDRV=SEEDRV-.016D0
              RTMASS=.016D0-SHTMAS
            ELSE
              SHTMAS=SEEDRV/(1.0D0+RATRS)
              RTMASS=SEEDRV-SHTMAS
              SEEDRV=0.0D0
            ENDIF
            STMASS=SHTMAS*0.005D0
            PSTATE(2)=PSTATE(2)+SHTMAS-STMASS
            PSTATE(3)=PSTATE(3)+STMASS
            PSTATE(5)=PSTATE(5)+RTMASS
            PNIT(2)=pnit(2)+(SHTMAS-STMASS)*ALNGER(IPL)*C2BM
            PNIT(3)=pnit(3)+stmass*STNGER(IPL)*C2BM
            PNIT(5)=Pnit(5)+rtmass*RTNLW(IPL)*C2BM
            
            SeedNstore=SeedNstore-(SHTMAS-STMASS)*ALNGER(IPL)*C2BM
     +                   -stmass*STNGER(IPL)*C2BM
     +                   -rtmass*RTNLW(IPL)*C2BM
c          if (pgntgt(ipl)*cvlbio(ipl).lt.(pnit(2)+pnit(3)+pnit(5))) then
c            stop
c          endif
c            
            SHTMAS=0.0D0
            STMASS=0.0D0
            RTMASS=0.0D0
          ENDIF
        ENDIF
C
c          if (istage.gt.3) then
c          SeedNstore=SeedNstore-(pnit(2)+pnit(3)+pnit(5))
          if (SeedNstore.lt.0.0d0) then
            stop 'too little N for germination'
          endif
          PlantNseed=pgntgt(ipl)*cvlbio(ipl)-SeedNstore
c          endif
C       ...UPDATE BIOMASS AND NITROGEN POOLS FOR NEW BIOMASS AS A RESULT
C       PLANT ESTABLISHMENT
        BIOSHT=BIOSHT+ALMASS+STMASS
        BIOPLT=BIOSHT+PSTATE(5)
C
C       ...DETERMINE LEAF AREA INDEX
C       **********************************************************************
C       CALCULATE SPECIFIC LEAF AREA FOR CURRENT GROWTH STAGE      *
C       **********************************************************************
C
C       IF (GS.LT.STEND(3,IPL)) SLA = SLA1(IPL)-
C       +    (GS-STEND(3,IPL))*SLA2(IPL)/(STEND(4,IPL)-STEND(3,IPL))
C       IF (GS.GE.STEND(4,IPL) .AND. GS.LT.STEND(5,IPL)) SLA =SLA3(IPL)
C       +    - (GS - STEND(4,IPL))*SLA4(IPL)/(STEND(5,IPL)-STEND(4,IPL))
C
C       **********************************************************************
C       LEAFC      CH2O/C   M2 LEAF/G  PLANTS/M2       *
C       G C/PLANT  G/G C M2/G      PL/M2        *
C       **********************************************************************
C
C       ...PORTION OF GROWING PLANTS IN REPRODUCTIVE STAGE
        IF(PLTS36.GT.0.0D0.AND.CLSIZE(6).GT.0.0D0) THEN
          PERCL6=CLSIZE(6)/PLTS36/10.0D0
        ELSE
          PERCL6=0.0D0
        ENDIF
C
        IF(BIOPLT.GT.0.0D0) THEN
C
C         ...DETERMINE PLANT HEIGHT
          IF(BIOSHT.GT.0.0D0.AND.ISTAGE.LT.7) CALL PLHGT(BIOSHT,
     +        PLHGHT(IPL),PLALFA(IPL),SHTDEN,RADHGT,HEIGHT,THGHT,PROVOL,
     +        OLDHGT)
C
C         ...ESTIMATE PROJECTED END OF GROWING SEASON
          CLS6=CLSIZE(6)
          CALL SNSNC(DAY,SENES,ALEAF,CLS6,BEGSEN,ENDSEN,OLDLAI)
C
C         ...CALCULATE PRESENT PHOTOSYNTHESIS RATE ONCE PLANTS REACH CLASS 2
          IF(ISTAGE.GT.2) THEN
          !-------------------------------------------------------------
          !   Daily Photosynthesis Rate (DSSAT4.0-CERES-Maize) 8-9-2014
          !   use this one to show CO2 effects on photosynthesis
          !   This section is not used except for PCO2 to correct PMAX(IPL)
          ! ------------------------------------------------------------
          PAR = RTOTAL*PARSR    !PAR local variable
          RUE=BETA(IPL)*100.D0  !USE THE LIGHT COEFFICIENT FROM PLGEN.DAT FOR NOW
           temppop=plden(ipm)
          IF((INDEX(PLNAME(IPL),'ALFALFA').NE.0.OR.
     &     INDEX(PLNAME(IPL),'BERMUDAGRASS').NE.0)
     &        .and.temppop.eq.0.0d0) then
           do i=1,mxapp
              Temppop=plden(ipm-i)
              if (temppop.gt.0.0d0) goto 213
           enddo
           endif
213       continue
          ALIFAC=1.5D0-0.768D0*((ROWSP(ipm)*0.01D0)**2.0D0*(TEMPPOP
     +           /10.0D0))**0.1D0 
          PCO2=DBLE(TABEX(REAL(CO2Y),REAL(CO2X),REAL(CO2R),10))
          PCARB=RUE*PAR/(TEMPPOP/10.0D0)*
     +          (1.0D0-DEXP(-ALIFAC*ALEAF))*PCO2
C          TAVGD = 0.25*TMIN+0.75*TMAX
C          PRFT = CURV('LIN',PRFTC(1),PRFTC(2),PRFTC(3),PRFTC(4),TAVGD)
C          PRFT  = DMAX1 (PRFT,0.0)
C          PRFT = DMIN1(PRFT,1.0)
C          CARBO = PCARB*DMIN1 (PRFT,EWP,ENP)
          CARBO = PCARB*DMIN1 (ETP,EWP,ENP)
          PNCA1=CARBO/c2bm    !change to gram of Carbon
c         ! -----------------------------------------------------------
c            
            PNCA=PLPROD(BETA(IPL),ETP,GS,STEND(5,IPL),CANK(IPL),ALEAF,
     +          PLTS36,PMAX(IPL)*PCO2,PP,ERP,ENP,EWP,RTOTAL,ISTAGE,
     +          SLA3(IPL),SLA4(IPL),STEND(6,IPL),IMAGIC,PEXP)
          ELSE
            PNCA=0.0D0
          ENDIF
C
C         ...DARK RESPIRATION RATE
          IF(PNCA.GT.0.0D0) RESP=
     +        WPRESP(BIOPLT,PNCA,TC,RQ10(IPL),R20(IPL),ALPHA(IPL))
C
C         ...CORRECT PHOTOSYNTHESIS FOR DARK RESPIRATION
          IF(RESP.LT.PNCA) THEN
            PNCA=PNCA-RESP
          ELSE
            PNCA=0.0D0
          ENDIF
C
       yrdoy=iyyy*1000+jday
       WRITE (6666,'(I10,5X,8(F10.6,6X))') YRDOY,PNCA*c2bm,ETP,EWP,
     &      ENP,PCO2, 1.0, TC  !,SLPF
C         ...NOT FOR ANNUALS
C         IF (IPLTYP(IPL) .EQ. 1) THEN
          TRS=0.0D0
C         ELSE
C         TRS = GROINT(DAY,BIOSHT,PSTATE(5),T10,ETTRS,EWTRS,
C         +       RATRS,GITEMP(IPL),BEGSEN,ENDSEN)
C         END IF
C
C         ...DETERMINE RATE AT WHICH PLANTS ARE MATURING; ASSUME THAT PLANTS
C         MUST WAIT THE RECIPRICOL OF THE DEVELOPMENT TIME
C
          IF(PSTATE(4).GT.0.0D0.AND.IRIPE.EQ.0) IRIPE=1
          IF(IRIPE.EQ.1.AND.PSTATE(4).EQ.0.0D0) IRIPE=0
C
C         ...CALCULATE VIABLE SEED DEVELOPMENT RATE
          TPVS=0.0D0
          IF(IRIPE.GT.0) THEN
            IRDAYS=IRDAYS+1
            WAIT=1.0D0/SDDVRT(IPL)
            IF(IRDAYS.GT.WAIT) THEN
              TPVS=PSTATE(4)*SDDVRT(IPL)
            ENDIF
          ENDIF
C
C         ...DETERMINE MORTALITY RATES ASSUMING GRAZING ANIMAL STOCKING
C         RATE IS 0.0
          SR=0.0D0
          BIOLF=PSTATE(2)+STMASS
          IF (INDEX(PLNAME(IPL),'ALFALFA').EQ.0.OR.
     +        INDEX(PLNAME(IPL),'BERMUDAGRASS').EQ.0)
     +    CALL MORTAL(EWP,TMIN,DWR,PREC,SR,BIOLF,BIOSHT,SDAMAX(IPL),
     +        SDWMAX(IPL),SFREEZ(IPL),AHLDG(IPL),PCLDG(IPL),WDLDG(IPL),
     +        TDSL,STDEAD,CLSIZE,ALMORT,PSTATE(6),STMORT,SDDETH,SDMORT,
     +        DAY,ENDSEN,BEGSEN,NAMSTG)
C
C         ...PARTITION CARBON (PNCA) INTO DIFFERENT AREAS
          IF(PNCA.NE.0.0D0) THEN
            CALL PARTIT(DMDRT,PNS,EWP,GS,ISTAGE,ERP,PERCL6,PGDVRT(IPL),
     +          PLEAF,PNCA,PSTEM,PPROP,STEND(2,IPL),RATRS,RATLS(IPL),
     +          sla1(ipl),sla2(ipl),dmdnit,TEMPPOP,INFIXN(IPL))
          ELSEIF(ISTAGE.NE.2) THEN
            DMDRT=0.0D0
            PLEAF=0.0D0
            PSTEM=0.0D0
            PPROP=0.0D0
          ENDIF
C
C         ...UPDATE SOIL FACTORS
          IF(PSTATE(5).GT.0.0D0.AND.GS.GT.0.0D0) THEN
            DO 180 I=1,NN
              JN=NDXN2H(I)
C
C             -- SET LOWER LIMIT OF PLANT-EXTRACTABLE SOIL WATER
              LL(I)=SOILHP(9,JN)
C
C             -- SET DRAINED UPPER LIMIT OF SOIL WATER FOR FINE EARTH FRACTION
              UL(I)=SOILHP(7,JN)
C
C             -- SET SOIL BULK DENSITY
              BD(I)=SOILPP(3,JN)
C
C             -- SET SOIL POROSITY
              PO(I)=SOILPP(4,JN)
C
C             -- SET PERCENTAGE SILT
              SIL(I)=SOILPP(6,JN)
C
C             -- SET PERCENTAGE CLAY
              CLA(I)=SOILPP(7,JN)
  180       CONTINUE
C
C           ...CALCULATE DYNAMIC SOIL STRESS FACTORS
            CALL DCALC(NN,THETA,T,LL,UL,BD,PO,SIL,CLA,EAL,ECA,LWF,SAI,
     +          TBS(IPL),TOP(IPL),GMN(IPL),CAA(IPL),CAX(IPL),ALA(IPL),
     +          ALX(IPL),ASF,ASF1,ASF2,ASF3)
C

C           ...GROW ROOTS BY LAYER  -- NOTE THAT RTMASS SHOULD GO HERE ALSO
            if ((dmdrt.gt.0.0d0).and.(istage.gt.2)) then
            CALL RTDIST(ASF,ASF1,ASF2,ASF3,CLSIZE(7),DCA,DMDRT,DWL,
     +          GSR(IPL),GSY,GS,IR,LWM(IPL),LWR,LWS(IPL),NN,
     +          PLTMNT(IPL),PLTMXT(IPL),PLTOPT(IPL),PLTS26,RDR(IPL),
     +          RDX(IPL),RGA,RLL,RLV,RMORT,RWL,T,TLT,WCG(IPL),WCP(IPL),
     +          ZA,RSD,CNST(IPL),RTNLW(IPL),TNITN)
            endif
C
C           ...CALCULATE ROOT PERCENTAGE PER LAYER
            RWLTOT=0.0D0
            RTLAST=0.0D0
            DO 190 I=1,NN
              IF(I.NE.1.AND.RLL(I).GT.0.0D0) RTLAST=TLT(I)
              RWLTOT=RWLTOT+RWL(I)
  190       CONTINUE
            DO 200 I=1,NN
              RDF(I)=RWL(I)/RWLTOT
  200       CONTINUE
          ENDIF
C
C.....................................................................
C         UPDATE CARBON AND NITROGEN POOLS
C
C         ...UPDATE NITROGEN POOLS USING TODAY'S CARBON ALLOCATION.
C         THIS WILL GIVE US A LITTLE BETTER ESTIMATE OF HOW MUCH
C         NITROGEN WILL BE NEEDED IN EACH POOL
C
          IF(PSTATE(2).GT.0.0D0) PCTN2=100.0D0*PNIT(2)/((PSTATE(2)+
     +        ALMASS)*C2BM)
          IF(PSTATE(3).GT.0.0D0) PCTN3=100.0D0*PNIT(3)/((PSTATE(3)+
     +        STMASS)*C2BM)
          IF(PSTATE(4).GT.0.0D0) PCTN4=100.0D0*PNIT(4)/(PSTATE(4)*C2BM)
          IF(PSTATE(5).GT.0.0D0) PCTN5=100.0D0*PNIT(5)/((PSTATE(5)+
     +        RTMASS)*C2BM)
          IF(PSTATE(6).GT.0.0D0) PCTN6=100.0D0*PNIT(6)/(PSTATE(6)*C2BM)
          RTOTC=0.0D0
          DO 210 I=1,IR
            RTOTC=RTOTC+RWL(I)
  210     CONTINUE
C
C         ...ALLOCATE NITROGEN TO PLANT COMPONENTS
          CALL PGNITE(ALFTN,ALMASS,ALMORT,ALNAVL(IPL),ALNGER(IPL),DMD,
     +        DWL,IR,PCTN2,PCTN3,PCTN4,PCTN6,PCTN7,PLEAF,PGNTGT(IPL),
     +        PNIT,PPROP,PRNLW(IPL),PSTATE,PSTEM,ROOTN,RTMASS,
     +        RTNLW(IPL),RWL,SDMORT,STMASS,STMORT,STNAVL(IPL),
     +        STNGER(IPL),TDSL,TLS,TNITN,TPVS,TSP,TSR,UPNIT,XNIT,TLDR,
     +        TLSD,TLLT,RTOTN,stnlw(ipl),alnlw(ipl),totalnup)
C
c           rootnup=pnit(5)*pwrts*1.0d-3
c           write(*,*) totalnup,rootnup
C         ...MAKE SURE THAT ALFTN IS NOT LT 0.O
          IF(ALFTN.LT.0.0D0) ALFTN=0.0D0
C
C         ...UPDATE CARBON POOLS
C         ...1. ALLOCABLE CARBON
          PSTATE(1)=PSTATE(1)+PNCA-(PLEAF+PSTEM+PPROP+DMDRT)
C
C         ...2. LEAF CARBON
          PSTATE(2)=PSTATE(2)+PLEAF+ALMASS-(TLS+ALMORT)
C
C         ...3. STEM CARBON
          PSTATE(3)=PSTATE(3)+PSTEM+STMASS+TLS+TRS-(TSP+STMORT+TSR)
C
C         ...4. PROPAGULES CARBON
          PSTATE(4)=PSTATE(4)+PPROP+TSP-TPVS
C
C         ...5. ROOT CARBON
          PSTATE(5)=PSTATE(5)+DMDRT+RTMASS+TSR-(TRS+RMORT)
C
C         ...6. SEED CARBON
          PSTATE(6)=PSTATE(6)+TPVS-SDMORT
C
C         ...7. STANDING DEAD CARBON
c          SDEAD=PSTATE(7)*PLTS27*C2BM   !this is not needed, otherwise, dead residue is double counted at harvest, Liwang Ma, 6-16-2009
          PST7=PST7+ALMORT-TDSL
C
          PSTATE(7)=PSTATE(7)+ALMORT+STMORT-TDSL
C
C
C         ...CONVERSION FACTOR FOR G-CARBON/PLANT ==> G-CARBON/CM^2
          FACT=PLTS27*1.0D3*1.0D-8
C commented out by Liwang Ma to avoid double counting of dead residue. It is counted at harvest already. 6-16-2009
C         ..SET CN RATIO AND NEW MASS FOR STANDING DEAD
c          IF(PSTATE(7).GT.0.0D0.AND.PNIT(7).GT.0.0D0) THEN
c            SSCN=PSTATE(7)/PNIT(7)
C
C           ..SINCE THE NITROGEN AND CARBON BALANCE SEEMS TO BE OFF FOR
C           STANDING DEAD WILL IMPOSE A LIMIT ON SSCN
c            SSCN=MAX(MIN(SSCN,CN(2)),CN(1))
c            SDMN=(ALMORT+STMORT-TDSL)*PLTS27*C2BM
c            SDCN=CNEW(SDEAD,SDMN,SDCN,SSCN,IRES)
C           SDCN = MAX(MIN(SDCN,CN(2)),CN(1))
c            SDEAD=SDEAD+SDMN
c          ENDIF
C
C         ...8. LITTER CARBON
          PSTATE(8)=PSTATE(8)+TDSL+SDMORT
C
C         ...9. DEAD ROOT CARBON
          PSTATE(9)=PSTATE(9)+RMORT
C
C         ...IF CARBON POOLS ARE WITHIN EPSILON=1E-10 OF ZERO THEN SET THEM
C         EQUAL TO 0.0D0
          DO 220 I=1,9
            IF(PSTATE(I).LT.0.0D0) PSTATE(I)=0.0D0
  220     CONTINUE
C
C         ...DETERMINE LEAF AREA
          XCONVLA=CONVLA(IPL)/PLTS27
          PRINT*,XCONVLA,CONVLA(IPL),PLTS27
          ALEAF=C2BM*PSTATE(2)/XCONVLA
C
C         ...DETERMINE LEAF AREA FOR LIVE & STANDING DEAD LEAVES
          TLEAF=2.5D0*(PSTATE(2)+PST7)/XCONVLA
C
          WRITE(*,2500) 'PNCA = ',PNCA,'   CONVLA =',XCONVLA,
     +        '     LEAF AREA INDEX = ',ALEAF
C
C         ...FINAL N REPARTITIONING:
C
C         ..TAKE NITROGEN FROM STANDING DEAD AND PUT IT BACK INTO
C         THE ACTIVE PARTS OF THE PLANT (NITROGEN EFFICIENCY)
C         SDMAX = MAX(PNIT(7)-0.007D0*PSTATE(7)*C2BM,0.0D0)
C         IF(PNIT(2).GT.0.0D0.OR.PNIT(3).GT.0.0D0)
C         +      SDTMP = SDMAX * PNIT(2)/(PNIT(2)+PNIT(3))
C         PNIT(2) = PNIT(2)+SDTMP
C         PNIT(3) = PNIT(3)+SDMAX-SDTMP
C         PNIT(7) = PNIT(7)-SDMAX
C
C         ...REPARTITION N SO THAT PROPAGULES AND SEEDS HAVE
C         ADEQUATE NITROGEN.  THESE WILL NOW BE OUR BEST
C         ESTIMATES OF THE PERCENTAGE NITROGEN IN THE VARIOUS
C         N POOLS.  CHECK FOR TOO MUCH N IN THE LEAVES AND
C         STEMS.  REMOVE FROM POOL. USE EXCESS TO INCORPORATE
C         INTO PROPAGULES AND SEEDS.
C
          XLN=0.0D0
          XSTN=0.0D0
          XPROPN=0.0D0
          IF(PSTATE(4).GT.0.0D0) THEN
C           ...CALCULATE AMOUNT N NEEDED TO BRING PROPAGULES TO
C           MAXIMUM LEVEL (A C/N OF 10 IS 4% NITROGEN BY WT)
c Liwang Ma, 11-4-2005
c            PROPMX=PSTATE(4)*0.1D0-PNIT(4)
            PROPMX=PSTATE(4)*2.5d0*pgntgt(ipl)-PNIT(4)
            IF(PROPMX.GT.0.0D0) THEN
C
C             ...FIRST TRY TO FILL NEED FROM LEFT OVER N
              IF(ALFTN.GT.0.0D0) THEN
                IF(ALFTN.LE.PROPMX) THEN
                  PNIT(4)=PNIT(4)+ALFTN
                  PROPMX=PROPMX-ALFTN
                  ALFTN=0.0D0
                ELSE
                  PNIT(4)=PNIT(4)+PROPMX
                  ALFTN=ALFTN-PROPMX
                  PROPMX=0.0D0
                ENDIF
              ENDIF
C
C             ...IS THERE STILL A N NEED?
              IF(PROPMX.GT.0.0D0) THEN
C
C               ...DETERMINE AMOUNT OF N AVAILABLE FROM LEAVES
                IF(PSTATE(2).GT.0.0D0) THEN
                  PHYTM=PSTATE(2)*C2BM
                  PCTN2=PNIT(2)/PHYTM
                  IF(PCTN2.GT.ALNLW(IPL)) THEN
                    XLN=MAX(PNIT(2)-PHYTM*ALNLW(IPL),0.0D0)
                    PNIT(2)=PNIT(2)-XLN
                  ENDIF
                ENDIF
C
C               ...DETERMINE AMOUNT OF N AVAILABLE FROM STEMS
                IF(PSTATE(3).GT.0.0D0) THEN
                  PHYTM=PSTATE(3)*C2BM
                  PCTN3=PNIT(3)/PHYTM
                  IF(PCTN3.GT.STNLW(IPL)) THEN
                    XSTN=MAX(PNIT(3)-PHYTM*STNLW(IPL),0.0D0)
                    PNIT(3)=PNIT(3)-XSTN
                  ENDIF
                ENDIF
C
C               ...DETERMINE AMOUNT OF NITROGEN IN STEMS, LEAVES
C               AND OTHER CAN BE INCORPORTATED INTO PROPAGULES
                TOTAVN=XLN+XSTN
C
C               ...PUT AS MUCH N AS POSSIBLE INTO THE PROPAGULES
                IF(TOTAVN.LE.PROPMX) THEN
                  PNIT(4)=PNIT(4)+TOTAVN
                  PROPMX=PROPMX-TOTAVN
                  XLN=0.0D0
                  XSTN=0.0D0
                ELSE
                  PNIT(4)=PNIT(4)+PROPMX
C
C                 ...KEEP TRACK OF HOW MUCH N WAS NOT ALLOCATED
C                 FROM THE LEAVES (XLN) AND THE STEMS (XSTN).
                  PCTN2=1.0D0-PROPMX/TOTAVN
                  XLN=XLN*PCTN2
                  XSTN=XSTN*PCTN2
                ENDIF
              ENDIF
            ENDIF
          ENDIF
C
C         ...IF NITROGEN IS AVAILABLE FROM LEAVES, STEMS,
C         PROPAGULES, AND ANY OTHER SOURCE, THEN DETERMINE
C         NEED IN THE SEEDS CONCERNING THE TARGET %N
C         REQUIREMENT (PGNTGT)
          IF(PSTATE(6).GT.0.0D0) THEN
C
C           ...ARE SEEDS IN NEED OF ADDITIONAL N. SOME MAY STILL
C           BE LEFT IN ALFTN.  N WILL THEN BE TAKE FROM THE
C           PROPAGULES TO MEET ITS %N TARGET.  AS A LAST
C           RESORT, N STILL CAN BE EXTRACTED FROM THE LEAVES
C           AND SHOOTS IF SEEDS ARE BELOW THEIR MINIMUM
C           REQUIREMENT.
C
C           ...CALCULATE AMOUNT OF N NEED TO BRING SEEDS TO THE
C           TARGET %N
            SEEDMX=PSTATE(6)*C2BM*PGNTGT(IPL)-PNIT(6)
            IF(SEEDMX.GT.0.0D0) THEN
C             ...FIRST CHECK ALFTN
              IF(ALFTN.GT.0.0D0) THEN
                IF(ALFTN.LE.SEEDMX) THEN
                  PNIT(6)=PNIT(6)+ALFTN
                  SEEDMX=SEEDMX-ALFTN
                  ALFTN=0.0D0
                ELSE
                  PNIT(6)=PNIT(6)+SEEDMX
                  ALFTN=ALFTN-SEEDMX
                  SEEDMX=0.0D0
                ENDIF
              ENDIF
C
C             ...NEXT, IF NECESSARY, GET WHATEVER IS AVAILABLE
C             FROM THE PROPAGULES
              IF(SEEDMX.GT.0.0D0) THEN
                XPROPN=MAX(PNIT(4)-PSTATE(4)*C2BM*PRNLW(IPL),0.0D0)
                IF(XPROPN.LE.SEEDMX) THEN
                  PNIT(6)=PNIT(6)+XPROPN
                  PNIT(4)=PNIT(4)-XPROPN
                  SEEDMX=SEEDMX-XPROPN
                ELSE
                  PNIT(6)=PNIT(6)+SEEDMX
                  PNIT(4)=PNIT(4)-SEEDMX
                  SEEDMX=0.0D0
                ENDIF
              ENDIF
C
C             ...GET ANY EXCESS N FROM THE ROOTS
              IF(SEEDMX.GT.0.0D0) THEN
                TOTAVN=MAX(PNIT(5)-PSTATE(5)*C2BM*RTNLW(IPL),0.0D0)
                IF(TOTAVN.LE.SEEDMX) THEN
                  PNIT(6)=PNIT(6)+TOTAVN
                  PNIT(5)=PNIT(5)-TOTAVN
                  SEEDMX=SEEDMX-TOTAVN
                ELSE
                  PNIT(6)=PNIT(6)+SEEDMX
                  PNIT(5)=PNIT(5)-SEEDMX
                  SEEDMX=0.0D0
                ENDIF
              ENDIF
C
C             ...IF A NEED STILL EXISTS, GET ANY N STILL AVAILABLE
C             IN THE LEAVES AND STEMS
              IF(SEEDMX.GT.0.0D0) THEN
                TOTAVN=XLN+XSTN
C
C               ...PUT AS MUCH N AS POSSIBLE INTO THE SEEDS
                IF(TOTAVN.LE.SEEDMX) THEN
                  PNIT(6)=PNIT(6)+TOTAVN
                  SEEDMX=SEEDMX-TOTAVN
                  XLN=0.0D0
                  XSTN=0.0D0
                ELSE
                  PNIT(6)=PNIT(6)+SEEDMX
                  PCTN2=PROPMX/TOTAVN
C
C                 ...KEEP TRACK OF HOW MUCH N WAS NOT ALLOCATED
C                 FROM THE LEAVES (XLN) AND THE STEMS (XSTN).
                  XLN=XLN*(1.0D0-PCTN2)
                  XSTN=XSTN*(1.0D0-PCTN2)
                ENDIF
              ENDIF
            ENDIF
          ENDIF
C
C         ...PUT THE REMAINING N BACK INTO THE APPROPRIATE POOLS
          PNIT(2)=PNIT(2)+XLN
          PNIT(3)=PNIT(3)+XSTN
changed by Liwang Ma as shown below
          PNIT(5)=PNIT(5)+ALFTN
C
C
C         ...DETERMINE FINAL NITROGEN PERCENTAGES
          IF(PSTATE(2).GT.0.0D0) PCTN2=100.0D0*PNIT(2)/(PSTATE(2)*C2BM)
          IF(PSTATE(3).GT.0.0D0) PCTN3=100.0D0*PNIT(3)/(PSTATE(3)*C2BM)
          IF(PSTATE(4).GT.0.0D0) PCTN4=100.0D0*PNIT(4)/(PSTATE(4)*C2BM)
          IF(PSTATE(5).GT.0.0D0) PCTN5=100.0D0*PNIT(5)/(PSTATE(5)*C2BM)
          IF(PSTATE(6).GT.0.0D0) PCTN6=100.0D0*PNIT(6)/(PSTATE(6)*C2BM)
          IF(PSTATE(7).GT.0.0D0) PCTN7=100.0D0*PNIT(7)/(PSTATE(7)*C2BM)
C
C         ...CALCULATE WHOLE-PLANT NITROGEN DEMAND
C         ...DMDNIT SHOULD BE THE AMOUNT OF NITROGEN NEEDED TO
C         BRING THE TOTAL PLANT NITROGEN TO PERCENTAGE SPECIFIED
C         BY DMD PLUS THE AMOUNT NEEDED TO BRING PROPAGULES AND
C         SEEDS UP TO THEIR TARGET PERCENTAGE PLUS NITROGEN NEEDED
C         FOR TOMORROW'S PHOTOSYNTHESIS (USE PNCA) ASSUME THAT NEW
C         GROWTH FROM PNCA WILL REQUIRE A HIGH N LEVEL.
C
C         ...STRAIGHT-FORWARD METHOD
C         TARGET IS THE AMOUNT OF N CURRENTLY REQUIRED FOR TOTAL
C         PLANT CARBON POOL (TTC2). TTN2 IS THE TOTAL PLANT
C         NITROGEN POOL
C
C         ...CALCULATE AMOUNT OF C AND N THE WHOLE PLANT
          TTC1=PSTATE(2)+PSTATE(3)+PSTATE(5)
          TTC2=TTC1+PSTATE(4)+PSTATE(6)
          TTN1=PNIT(2)+PNIT(3)+PNIT(5)
          TTN2=TTN1+PNIT(4)+PNIT(6)
C
          TARGET1=DMD*TTC2*C2BM
          DMDNIT=MAX(TARGET1-TTN2,0.0D0)
c          write (unit=666,fmt=665) ttc1,ttc2,ttn1,ttn2
c665       format (8(f10.6,2x))
C
C         ---KEN CODE---
C
C         IF(PLTS47.GT.0.0D0) DMDMAX = 4.0D0/PLTS47
C         DMDNIT=MIN(DMDMAX,DMDNIT)+GDEMAND
C
C         IF (RWLTOT.LE.0.0D0) DMDNIT=0.0D0
C         IF (ISTAGE .GT. 6) DMDNIT = 0.0D0
C
C         ...ALLOCATE REMAI NING N TO ROOTS (ALFTN)
          IF(ALFTN.GT.0.0D0) THEN
c  commented out by Liwang Ma, Feb 10, 2005
c            PNIT(5)=PNIT(5)+ALFTN
            DO 230 I=1,IR
              ROOTN(I)=ROOTN(I)+ALFTN*RDF(I)
  230       CONTINUE
            ALFTN=0.0D0
          ENDIF
C
C         ..DETERMINE IF CHLOROPHYLL METER CRITIERIA IS MEET
          IF(PNS.LT.SUFNDX(IPL)) THEN
            CHLRFL=.TRUE.
          ELSE
            CHLRFL=.FALSE.
          ENDIF
C
C         ...SAVE LITTER CARBON IN SURFACE RESIDUE POOL (KG/HA)
          IF(PSTATE(8).GT.0.0D0.AND.PNIT(8).GT.0.0D0) THEN
            PCN(0)=PSTATE(8)/PNIT(8)
C           PCN(0) = MAX(MIN(PCN(0),CN(2)),CN(1))
            RMN=(TDSL+SDMORT)*PLTS27*C2BM
            RCN=CNEW(RM,RMN,RCN,PCN(0),IRES)
C           RCN = MAX(MIN(RCN,CN(2)),CN(1))
            RM=RM+RMN
          ENDIF
C
C         ...DEAD ROOT CARBON   :::USE DWL FOR LAYER DIST
          DO 240 I=1,NN
            IF(ROOTN(I).LT.0.0D0) PRINT*,'ROOTN < 0 LAYER = ',I
            IF(RWL(I).LT.0.0D0) PRINT*,'RWL < 0 LAYER = ',I
            IF(RWL(I).GT.0.0D0.AND.ROOTN(I).GT.0.0D0) THEN
              PCN(I)=RWL(I)/ROOTN(I)
              IF(PCN(I).LE.CN(1)) THEN
                S=0.0D0
              ELSEIF(PCN(I).GE.CN(2)) THEN
                S=1.0D0
              ELSE
                S=(1.0D0/PCN(I)-1.0D0/CN(1))/(1.0D0/CN(2)-1.0D0/CN(1))
              ENDIF
              RPOOL(I,1)=RPOOL(I,1)+DWL(I)*(1.0D0-S)*FACT
              RPOOL(I,2)=RPOOL(I,2)+DWL(I)*S*FACT
C
C             ..SAVE FOR MASS BALANCE CALCULATIONS (CONVERT TO KG/HA)
              TADRT(1)=TADRT(1)+DWL(I)*(1.0D0-S)*FACT*1.0D5/CN(1)
              TADRT(2)=TADRT(2)+DWL(I)*S*FACT*1.0D5/CN(2)
              TADRTC(1)=TADRTC(1)+DWL(I)*(1.0D0-S)*FACT*1.0D5
              TADRTC(2)=TADRTC(2)+DWL(I)*S*FACT*1.0D5
              RMASS=DWL(I)*FACT/(1.0d-5)
              IF(PCN(I).LE.CN(1)) THEN
              RCO2=RCO2+RMASS-(RMASS*(1.0D0-S)/PCN(I))*CN(1)
              ELSEIF(PCN(I).GE.CN(2)) THEN
              RCO2=RCO2+RMASS-(RMASS*S/PCN(I))*CN(2)
              endif
c
            ENDIF
  240     CONTINUE
        ENDIF
      ENDIF
C
C     ...GET NUMBER OF ACTIVE PLANTS WITH ROOTS PER HECTARE
      PWRTS=0.0D0
      DO 250 I=4,6
        PWRTS=PWRTS+CLSIZE(I)*1.0D3
  250 CONTINUE
C     PWRTS=plts47*1.0d3
C
C     ...CONVERT NUMBER OF PLANTS ==> TRUE NUMBER OF PLANTS/HECTARE
      PWRTS=PLTS47*1.0D3
      PLTSLV=PLTS27*1.0D3
      BASE=3.141592654D0*(HEIGHT*RADHGT)**2.0D0
C
C     BUILD OUTPUT FILES
C     .............................
      IF(NSC.GE.1) THEN
        CALL SGATE(TDAY,11,ALEAF)
        CALL SGATE(TDAY,12,HEIGHT)
        CALL SGATE(TDAY,14,RTLAST)
        CALL SGATE(TDAY,16,EWP)
        CALL SGATE(TDAY,17,ETP)
        CALL SGATE(TDAY,18,PNS)
        CALL SGATE(TDAY,41,EVP)
        CALL SGATE(TDAY,49,GS)
        CALL SGATE(TDAY,50,PLTSLV)
        DO 260 I=1,7
          CALL SGATE(TDAY,50+I,CLSIZE(I)*1.0D3)
  260   CONTINUE
        DO 270 I=2,9
          CALL SGATE(TDAY,56+I,PSTATE(I))
  270   CONTINUE
        DO 280 I=2,9
          CALL SGATE(TDAY,64+I,PNIT(I))
  280   CONTINUE
        CALL SGATE(TDAY,12,HEIGHT)
c        CALL VGATE(TDAY,51,RWL)
c        CALL VGATE(TDAY,35,ROOTN)
      ENDIF
C
      IF(IMAGIC.EQ.-7.OR.IMAGIC.EQ.-8) THEN
c added by Liwang Ma, July 12, 2005
      CALL CDATE(JDAY,ID,IM,IYYY)
c
        WRITE(97,*) '  ALFTN == ',ALFTN,' DMDNIT == ',DMDNIT
C
C       ...SUM UP ALL THE GAINS
        TOTA=FIXN+TNITUP
C
C       ...SUM UP ALL THE LOSES
        TOTL=TLDR+TLSD+TLLT
C
C       ...CALC THE BALANCE
        TOTNP=PNIT(2)+PNIT(3)+PNIT(4)+PNIT(6)+PNIT(5)
        BAL=TOTNP+TOTL-TOTA-TOTNP0
C
        WRITE(97,1000) TDAY,TOTNP0,FIXN,TNITUP,TOTA
        WRITE(97,1100) TLDR,TLSD,TLLT,TOTL
        WRITE(97,1200) PNIT(2),PNIT(3),PNIT(4),PNIT(6),PNIT(5),TOTNP,
     +      BAL,BAL*PLTS27
C
        TOIMB=TOIMB+BAL*PLTS27
        TOTGERM=TOTGERM+GDEMAND*PLTS27
C
C       PRINT*,'RUNNING TOTAL OF IMBALANCE',TOIMB,' KG/HA'
C       PRINT*,'BIOMASS IN GERMINATING PLANTS',TOTGERM,' KG/HA'
C
        TOTNP0=TOTNP
        WRITE(97,'(4(G15.3,2X))') TDAY,PLTSLV,ALEAF,HEIGHT/100.0D0
C
        WRITE(97,1300)
        WRITE(97,1400) STRESS,EVP,PNS,ETP,EPP,EHP,ETTRS,EWTRS,EWP
        WRITE(97,1500) TFIX
C
        WRITE(90,1600) TDAY,(C2BM*PSTATE(I),I=2,9),(PNIT(I),I=2,9)
c        WRITE(91,1700) TDAY,PCTN2,PCTN3,PCTN4,PCTN5,PCTN6,im,id,iyyy
c        WRITE(92,1800) TDAY,EVP,PNS,ENP,ETP,EWP,im,id,iyyy
c        WRITE(93,1900) TDAY,(CLSIZE(I),I=1,7),im,id,iyyy
c        WRITE(94,2000) TDAY,HEIGHT,ALEAF,im,id,iyyy
c        WRITE(95,2100) TDAY,GS,DMD,PLTNW,PNLL,PMNNIT(1),PNS,TNITUP,
c     +      DMDNIT,im,id,iyyy
        WRITE(91,1700) TDAY,PCTN2,PCTN3,PCTN4,PCTN5,PCTN6
        WRITE(92,1800) TDAY,EVP,PNS,ENP,ETP,EWP
        WRITE(93,1900) TDAY,(CLSIZE(I),I=1,7)
        WRITE(94,2000) TDAY,HEIGHT,ALEAF
        WRITE(95,2100) TDAY,GS,DMD,PLTNW,PNLL,PMNNIT(1),PNS,TNITUP,
     +      DMDNIT
C
        IF(ISTAGE.GT.1) THEN
          WRITE(97,2200) PCTN2,PCTN3,PCTN4,PCTN5,PCTN6,(PSTATE(JJ),JJ=2,
     +        9),(PNIT(JJ),JJ=2,9)
C         ...NOTE THAT PLTS47 HAS UNITS OF PLANTS*10/M2;
C         PSTATE, PNIT, PLWTS ARE G/PL
          IF(ISTAGE.GT.3) THEN
            WRITE(97,2300) PLTS47*1000.0D0,(PLTS47*PLWTS(JJ,ISTAGE-3),JJ
     +          =1,5),(PLTS47*PLWTS(JJ,ISTAGE-3),JJ=6,10)
          ENDIF
C2950     FORMAT(1X,F5.1,1X,F7.1,5(1X,F6.1),5(1X,F5.2))
          WRITE(97,2400)
        ENDIF
      ENDIF
      OMSEA(13)=EWP
      OMSEA(25)=FIXN*PWRTS*1.0D-3
      OMSEA(40)=PNS
      OMSEA(43)=ALEAF
c      OMSEA(45)=DBLE(ISTAGE)
      OMSEA(45)=GS
      OMSEA(62)=HEIGHT
      OMSEA(63)=RTLAST
      OMSEA(64)=ETP
      OMSEA(65)=(PSTATE(2)*C2BM)
      OMSEA(66)=(PSTATE(3)*C2BM)
      OMSEA(67)=(PSTATE(5)*C2BM)
      OMSEA(68)=(PSTATE(6)*C2BM)
      OMSEA(69)=(PSTATE(7)*C2BM)
      OMSEA(70)=(PSTATE(8)*C2BM)
      OMSEA(71)=(PSTATE(9)*C2BM)
C
c      TLPLNT=(TNITUP+FIXN)*PWRTS*1.0D-3
c      FIXN=FIXN*PWRTS*1.0D-3
C
C
      RETURN
 1000 FORMAT(//' TOTAL PLANT NITROGEN MASS BALANCE--DAY ',F4.0,/
     +    ' TOTAL PLANT (N) AT START (G/PLANT)',T60,G15.6,/
     +    ' ADDITIONS:',/T4,'FIXATION',T50,G15.6,/T4,'UPTAKE',T50,G15.6,
     +    /T4,'TOTAL ADDITIONS',T60,G15.6)
 1100 FORMAT(/' LOSSES:',/T4,'DEAD ROOT',T50,G15.6,/T4,'STANDING DEAD',
     +    T50,G15.6,/T4,'LITTER',T50,G15.6,/T4,'TOTAL LOSSES',T60,G15.6)
 1200 FORMAT(/' STORAGE:',/T4,'LEAVES',T50,G15.6,/T4,'STEMS',T50,G15.6,/
     +    T4,'PROPROGULES',T50,G15.6,/T4,'SEEDS',T50,G15.6,/T4,'ROOTS',
     +    T50,G15.6,/' TOTAL PLANT (N) AT END (G/PLANT)',T60,G15.6,/T60,
     +    15('-'),/' MASS BALANCE AT END OF DAY:',T60,G15.6,/T60,/
     +    'IMBALANCE AMOUNT OF NITROGEN',T60,G15.6)
 1300 FORMAT(' ',T2,'STRESS',T11,'EVP',T19,'PNS',T27,'ETP',T35,'EPP',
     +    T43,'EHP',T51,'ETTRS',T59,'EWTRS',T67,'EWP')
 1400 FORMAT(9(1X,F7.5))
 1500 FORMAT(' TOTAL N FIXED = ',G15.3)
 1600 FORMAT(1X,F7.1,16(1X,F8.4),3x,i2,'/',i2.2,'/',i4)
 1700 FORMAT(1X,F7.1,5(1X,G10.3),3x,i2,'/',i2.2,'/',i4)
 1800 FORMAT(1X,F7.1,5(1X,F6.4),3x,i2,'/',i2.2,'/',i4)
 1900 FORMAT(1X,F7.1,7(1X,F8.1),3x,i2,'/',i2.2,'/',i4)
 2000 FORMAT(1X,F7.1,1x,2(1X,F8.4),3x,i2,'/',i2.2,'/',i4)
 2100 FORMAT(1X,F7.1,8(1X,F8.5),3x,i2,'/',i2.2,'/',i4)
 2200 FORMAT('     LEAF   STEM     PROP   ROOT     SEEDS',
     +    '  ST.DEAD   LITTER  DEADROOT',/,1X,'%N',5(1X,F8.4),/,'  C',8(
     +    1X,F8.3),/,'  N',8(1X,F8.4))
 2300 FORMAT(' CARBON & NITROGEN WEIGHTS(KG/HA);  POP(PL/HA)=',F9.1,/,
     +    '  C ',5F9.1,/,'  N  ',5F9.2)
 2400 FORMAT(1X)
 2500 FORMAT(' ',A,F10.6,3X,A,F10.6,3X,A,F10.3)
      END
C
      SUBROUTINE PGNITE(ALFTN,ALMASS,ALMORT,ALNAVL,ALNGER,DMD,DWL,IR,
     +    PCTN2,PCTN3,PCTN4,PCTN6,PCTN7,PLEAF,PGNTGT,PNIT,PPROP,PRNLW,
     +    PSTATE,PSTEM,ROOTN,RTMASS,RTNLW,RWL,SDMORT,STMASS,STMORT,
     +    STNAVL,STNGER,TDSL,TLS,TNITN,TPVS,TSP,TSR,UPNIT,XNIT,TLDR,
     +    TLSD,TLLT,RTOTN,stnlw,alnlw,totalnup)
C
C
C======================================================================
C
C       PURPOSE: MASS BALANCE ROUTINE FOR NITROGEN. THIS ROUTINE
C              PARALLELS THE CARBON ALLOCATION ROUTINE FOUND IN PGMAIN
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       ALFTN I/O
C       ALMASS     I
C       ALMORT     I
C       ALMRTN     L
C       ALNAVL     I
C       ALNEW  L
C       ALNGER     I
C       DMD        I
C       DWL        I  DAILY DEATH OF ROOTS IN LAYER [KG/HA]
C       I      L  INDEX VARIABLE
C       IR         I  NUMBER OF LAYERS WITH ROOTS
C       LFLOSS     L
C       MINELF     L
C       MINEST     L
C       MXNOD  P  MAX NUMBER OF NUMERICAL NODES
C       PCTN2 I/O
C       PCTN3 I/O
C       PCTN4 I/O
C       PCTN6  I
C       PCTN7  I
C       PGNTGT     I
C       PLEAF  I
C       PLEAFN     L
C       PNIT  I/O
C       PPROP  I
C       PRNLW  I
C       PROPN  L
C       PSTATE     I  1-ALLOCABLE CARBON 
C                     2-LEAF CARBON
C                     3-STEM CARBON
C                     4-PROPAGULE CARBON
C                     5-ROOT CARBON
C                     6-SEED CARBON
C                     7-STANDING DEAD
C                     8-LITTER CARBON
C                     9-DEAD ROOT
C       PSTEM  I
C       PTEMP  L
C       RMORTN     L
C       ROOTN I/O
C       RTMASS     I
C       RTNEW  L
C       RTNLW  I
C       RTOTN  I
C       RWL        I  ROOT WEIGHT IN THE LAYER (KG)
C       SDMORT    I/O
C       SDMRTN     L
C       STEMN  L
C       STLOSS     L
C       STMASS     I
C       STMORT     I
C       STMRTN     L
C       STNAVL     I
C       STNEW  L
C       STNGER     I
C       SUMRTN     L
C       TDSL   I
C       TDSLN  L
C       TLDR  I/O
C       TLLT  I/O
C       TLS        I
C       TLSD  I/O
C       TLSN   L
C       TNITN  I
C       TPVS   I
C       TPVSN  L
C       TSP        I
C       TSPN   L
C       TSR        I  SUNRISE ON ACTUAL SLOPE [R]
C       TSRN   L
C       UPNIT  I  UPTAKE OF NITROGEN FOR EACH LAYER [G/PLANT/LAYER]
C       XNIT  I/O
C
C       COMMENTS:
C
C       CALLED FROM:  PGMAIN
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:   2
C
C-----------------------------------------------------------------------
      INTEGER MXNOD
      PARAMETER(MXNOD=300,c2bm=2.5d0)
C
C  PASSED VARIABLES
      DOUBLE PRECISION ALFTN,ALMORT,ALMASS,ALNAVL,ALNGER,DMD,
     +    DWL(MXNOD),PCTN2,PCTN3,PCTN4,PCTN6,PCTN7,PGNTGT,PLEAF,
     +    PNIT(9),PPROP,PRNLW,PSTATE(9),PSTEM,ROOTN(MXNOD),RTMASS,RTNLW,
     +    RWL(MXNOD),SDMORT,STMASS,STMORT,STNAVL,STNGER,TDSL,TLS,TNITN,
     +    TPVS,TSP,TSR,UPNIT(MXNOD),XNIT,RTOTN,stnlw,alnlw
      INTEGER IR
C
C  LOCAL VARIABLES
      DOUBLE PRECISION ALMRTN,ALNEW,LFLOSS,MINELF,MINEST,PLEAFN,PROPN,
     +    PTEMP,RMORTN,RTNEW,SDMRTN,STEMN,STLOSS,STMRTN,STNEW,SUMRTN,
     +    TDSLN,TLSN,TPVSN,TSPN,TSRN,TLDR,TLSD,TLLT,totalnup,dailyrn
      INTEGER I
C
C     ..PARTITION NITROGEN UPTAKEN BY ROOTS INTO DIFFERENT AREAS
C     FIRST PUT NEWLY CREATED N INTO ROOTN(1)
C     ...THIS NITROGEN SHOULD COME FROM THE SOIL POOL;
C     ...WITH THIS ALGORITHM IT IS BEING SPONTANEOUSLY GENERATED
      RTNEW=RTNLW*RTMASS*2.5D0
      RTNEW=MAX(RTNEW,0.0D0)
C     ...TOM:
      ROOTN(1)=ROOTN(1)+RTNEW
      PNIT(5)=PNIT(5)+RTNEW
      IF(TNITN.GT.0.0D0) THEN
        CALL DISTN(ALFTN,DMD,IR,PGNTGT,PLEAF,PLEAFN,PNIT,PPROP,PROPN,
     +      PSTATE,PSTEM,ROOTN,RTNLW,RWL,STEMN,TNITN,UPNIT,RTOTN,
     +      alnlw,stnlw,prnlw,dailyrn)
      ELSE
        STEMN=0.0D0
        PLEAFN=0.0D0
        PROPN=0.0D0
      ENDIF
C     NOT USED
      TLSN=TLS*PCTN2/100.0D0
C
      ALNEW=ALNGER*ALMASS*2.5D0
      ALNEW=MAX(ALNEW,0.0D0)
C
C     ...LFLOSS IS LOSS OF N FROM LEAVES DUE TO NORMAL SENESCENCE
C     AMOUNT OF N RETAINED WHEN LEAF SENESCES (MINING N AT DEATH)
C     ASSUMED TO BE 50% = MINELF
C     REMAINDER GOES TO STANDING DEAD MATERIAL OR PNIT(7) = 1.-MINELF
      MINELF=0.5D0
      PCTN2=0.0D0
      IF(PSTATE(2).GT.0.0D0) PCTN2=100.0D0*PNIT(2)/(PSTATE(2)*2.5D0)
      IF(PCTN2.GT.ALNAVL*100.0D0) THEN
        PTEMP=PSTATE(2)*2.5D0*ALNAVL
        LFLOSS=PNIT(2)-PTEMP
      ELSEIF(PCTN2.GT.0.0D0) THEN
        LFLOSS=ALMORT*PCTN2/100.0D0*2.5D0
      ELSE
        LFLOSS=0.0D0
      ENDIF
      ALMRTN=(1.0D0-MINELF)*LFLOSS
      ALFTN=ALFTN+MINELF*LFLOSS
C
C     NOT USED  ..STEM LOSSES AND GAINS
      TSPN=TSP*PRNLW
C
      STNEW=STNGER*STMASS*2.5D0
      STNEW=MAX(STNEW,0.0D0)
C
C     ...STLOSS IS LOSS OF N FROM STEMS DUE TO NORMAL SENESCENCE
C     AMOUNT OF N RETAINED WHEN STEM SENESCES (MINING N AT DEATH)
C     ASSUMED TO BE 50% : MINEST
C     REMAINDER GOES TO STANDING DEAD MATERIAL OR PNIT(7) = 1.-MINEST
C     ...TOM:
      MINEST=0.5D0
C
C     ...JON: MAY 21, 1992
      MINEST=0.0D0
C
      PCTN3=0.0D0
      IF(PSTATE(3).GT.0.0D0) PCTN3=100.0D0*PNIT(3)/(PSTATE(3)*2.5D0)
      IF(PCTN3.GT.STNAVL*100.0D0) THEN
        PTEMP=PSTATE(3)*2.5D0*STNAVL
        STLOSS=PNIT(3)-PTEMP
      ELSEIF(PCTN3.GT.0.0D0) THEN
        STLOSS=STMORT*PCTN3/100.0D0*2.5D0
      ELSE
        STLOSS=0.0D0
      ENDIF
      STMRTN=(1.0D0-MINEST)*STLOSS
      ALFTN=ALFTN+MINEST*STLOSS
      TSRN=TSR*PCTN3/100.0D0
C
C     ...PROPAGULE AND SEED NITROGEN LOSS
      PCTN4=0.0D0
      IF(PSTATE(4).GT.0.0D0) THEN
C Liwang Ma, 11-3-2005
C       ...PROPAGULE LOSS
        PCTN4=100.0D0*PNIT(4)/(PSTATE(4)*2.5D0)
        IF(PCTN4.GE.PRNLW*100.0D0) THEN
          PTEMP=PSTATE(4)*2.5D0*PRNLW
C Liwang Ma, 11-3-2005
          TPVSN=min(PNIT(4)-PTEMP,tpvs*C2BM*PGNTGT)
        ELSE
          TPVSN=min(PCTN4/100.0D0*TPVS*2.5d0,tpvs*C2BM*PGNTGT)
        ENDIF
C
C       ..SEED LOSS
        SDMRTN=PCTN6/100.0D0*SDMORT
      ELSE
        TPVSN=0.0D0
        SDMORT=0.0D0
        SDMRTN=0.0D0
      ENDIF
C
C     ..DEAD SHOOT LOSS
      TDSLN=PCTN7/100.0D0*TDSL
C
C     --UPDATE PLANT NITROGEN POOLS
C     ..LEAF NITROGEN
      PNIT(2)=PNIT(2)+ALNEW+PLEAFN-(TLSN+LFLOSS)
C
C     ..STEM NITROGEN
      PNIT(3)=PNIT(3)+STNEW+STEMN-(TSPN+STLOSS+TSRN)
C
C     ..FLOWER NITROGEN
      PNIT(4)=PNIT(4)+TSPN+PROPN-TPVSN
C
C     ..TOTAL ROOT NITROGEN AND ROOT NITROGEN BY LAYER
C     PNIT(5) = 0.0D0
      RMORTN=0.0D0
      SUMRTN=0.0D0
      DO 10 I=1,IR
        IF(RWL(I).GT.0.0D0) THEN
          RMORTN=ROOTN(I)*DWL(I)/(RWL(I)*2.5D0)
          SUMRTN=SUMRTN+RMORTN
          ROOTN(I)=ROOTN(I)-RMORTN
          PNIT(5)=PNIT(5)-RMORTN
        ENDIF
   10 CONTINUE
C
C     ..SEED NITROGEN
      IF(PSTATE(6).GT.0.0D0) THEN
        PNIT(6)=PNIT(6)+TPVSN-SDMRTN
c Liwang Ma, Oct 29, 2005
c       if (PNIT(6).gt.(PSTATE(6)*C2BM*PGNTGT)) then
c         ALFTN=ALFTN+(PNIT(6)-PSTATE(6)*C2BM*PGNTGT)
c	   PNIT(6)=PSTATE(6)*C2BM*PGNTGT
c	 endif
c      PCTN6=100.0D0*PNIT(6)/(PSTATE(6)*C2BM)
      ELSE
        ALFTN=ALFTN+TPVSN
      ENDIF
C
C     ..STANDING DEAD PLANT MATERIAL NITROGEN
      PNIT(7)=PNIT(7)+ALMRTN+STMRTN-TDSLN
C
C     ..LITTER NITROGEN
      PNIT(8)=PNIT(8)+TDSLN+SDMRTN
C
C     ..DEAD ROOT NITROGEN
      PNIT(9)=PNIT(9)+SUMRTN
C
C     ..DETERMINE AMOUNT OF NITROGEN NEEDED TO MOVE FROM EMERGING
C     TO 4-LEAF STAGE
      XNIT=ALNEW+STNEW+RTNEW
C
C     ..SUM UP ALL THE LOSSES
      TLDR=SUMRTN
      TLSD=ALMRTN+STMRTN-TDSLN
      TLLT=SDMRTN
C
      RETURN
      END
C
      SUBROUTINE DISTN(ALFTN,DMD,IR,PGNTGT,PLEAF,PLEAFN,PNIT,PPROP,
     +    PROPN,PSTATE,PSTEM,ROOTN,RTNLW,RWL,STEMN,TNITN,UPNIT,RTOTN,
     +    alnlw,stnlw,prnlw,dailyrn)
C
C======================================================================
C
C       PURPOSE: ALLOCATES NITROGEN TO PLANT TISSUE. USES THE SAME
C              DISTRIBUTION PROPORTIONS ESTABLISHED FOR CARBON ALLOC.
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       ALFTN I/O
C       DEML   L
C       DEMS   L
C       DMD        I
C       FACT   L
C       I      L  INDEX VARIABLE
C       IR         I  NUMBER OF LAYERS WITH ROOTS
C       MXNOD  P  MAX NUMBER OF NUMERICAL NODES
C       PGNTGT     I
C       PLEAF  I
C       PLEAFN    I/O
C       PNIT  I/O
C       PPROP  I
C       PROPN I/O
C       PSTATE     I  1-ALLOCABLE CARBON 
C                     2-LEAF CARBON
C                     3-STEM CARBON
C                     4-PROPAGULE CARBON
C                     5-ROOT CARBON
C                     6-SEED CARBON
C                     7-STANDING DEAD
C                     8-LITTER CARBON
C                     9-DEAD ROOT
C       PSTEM  I
C       ROOTN I/O
C       RTARG  L
C       RTDMD  L
C       RTNLW  I
C       RTOTC  L
C       RTOTN I/O
C       RWL        I  ROOT WEIGHT IN THE LAYER (KG)
C       STEMN I/O
C       TNITN  I
C       TOTAVN     L
C       TOTDEM     L
C       UPNIT I/O UPTAKE OF NITROGEN FOR EACH LAYER [G/PLANT/LAYER]
C
C       COMMENTS:
C
C       CALLED FROM:  PGNITE
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:   2
C
C-----------------------------------------------------------------------
C
      INTEGER MXNOD
      PARAMETER(MXNOD=300)
C     ...PASSED VARIABLES
      DOUBLE PRECISION ALFTN,DMD,PGNTGT,PLEAF,PLEAFN,PNIT(9),PPROP,
     +    PROPN,PSTATE(9),PSTEM,ROOTN(MXNOD),RTNLW,RWL(MXNOD),STEMN,
     +    TNITN,UPNIT(MXNOD),alnlw,stnlw,prnlw
      INTEGER IR
C     ...LOCAL VARIABLES
      DOUBLE PRECISION DEML,DEMS,FACT,RTARG,RTDMD,RTOTC,RTOTN,TOTAVN,
     +    TOTDEM,dailyrn
      INTEGER I
C
C     ...AVAILABLE NITROGEN IS THAT AMOUNT TAKEN UP BY THE ROOTS WITH
C        THE TRANSPIRED WATER
C
      TOTAVN=TNITN
      RTOTC=0.0D0
      RTOTN=0.0D0
      RTDMD=0.0D0
C
C     ...ROOTS HAVE FIRST ACCESS TO NITROGEN
      DO 10 I=1,IR
C       ...DETERMINE TOTAL ROOT CARBON AND ROOT NITROGEN
C       AND CHECK FOR SHORTAGE OF ROOT NITROGEN
        RTOTC=RTOTC+RWL(I)
        RTOTN=RTOTN+ROOTN(I)
C       ...BY THE WAY, CLEAN UP UPNIT
        UPNIT(I)=0.0D0
   10 CONTINUE
C
C     ...CALCULATE TARGET N LEVEL
      RTARG=RTNLW*RTOTC*2.5D0
C     ...SURPLUS N IN ROOTS -- PUT INTO AVAILABLE N
      IF(RTOTN.GT.RTARG) THEN
        TOTAVN=TOTAVN+RTOTN-RTARG
        PNIT(5)=PNIT(5)-(RTOTN-RTARG)
C       ...RESET ROOTN TO TARGET LEVEL FOR EACH LAYER
        DO 20 I=1,IR
          ROOTN(I)=RTNLW*RWL(I)*2.5D0
   20   CONTINUE
      ELSE
C       ...ROOTS LACK SOME NITROGEN; UPTAKE IS NECESSARY
        RTDMD=RTARG-RTOTN
      ENDIF
C
C     ...HOW MUCH NITROGEN IS AVAILABLE?
      IF(TOTAVN.GT.0.0D0.AND.RTDMD.GT.0.0D0) THEN
C       ...START WITH ROOTS IF ANY NITROGEN IS AVAILABLE
        IF(RTDMD.LE.TOTAVN) THEN
C         ...ENOUGH NITROGEN IS AVAILABLE TO MEET ROOT NITROGEN DEMAND
C         I.E. RTNLW
          DO 30 I=1,IR
            ROOTN(I)=RTNLW*RWL(I)*2.5D0
   30     CONTINUE
          TOTAVN=TOTAVN-RTDMD
          PNIT(5)=PNIT(5)+RTDMD
        ELSE
C         ...ROOT NITROGEN SHORTAGE;  ALLOCATE ALL FREE N TO ROOTS
C         PROPORTIONAL TO (RTOTN+TOTAVN)/RTOTC
          FACT=(RTOTN+TOTAVN)/RTOTC
          DO 40 I=1,IR
            ROOTN(I)=FACT*RWL(I)
   40     CONTINUE
          PNIT(5)=PNIT(5)+TOTAVN
          TOTAVN=0.0D0
        ENDIF
      ENDIF
      RTOTN=0.0D0
      DO 50 I=1,IR
        RTOTN=RTOTN+ROOTN(I)
   50 CONTINUE
C
      dailyrn=TNITN-TOTAVN
      PROPN=0.0D0
      PLEAFN=0.0D0
      STEMN=0.0D0
      ALFTN=0.0D0
C
C     ...DETERMINE NITROGEN NEED FOR EACH ORGAN
C     PROPAGULES WILL DEMAND NITROGEN AT % OF THE BIOMASS
      IF(TOTAVN.LE.0.0D0) then
c Liwang Ma, 7-2-2006, to limit plant growth when N is limited
            if ((pleaf.gt.0.0d0).and.(pnit(2)/
     +         ((pstate(2)+pleaf)*2.5d0).lt.alnlw)) then
	         pleaf=min(pnit(2)/(alnlw*2.5d0)-pstate(2),pleaf)
	         pleaf=max(pleaf,0.0d0)
	      endif
           if ((pstem.gt.0.0d0).and.
     +        (pnit(3)/((pstate(3)+pstem)*2.5d0).lt.stnlw)) then
	         pstem=min(pnit(3)/(stnlw*2.5d0)-pstate(3),pstem)
	         pstem=max(pstem,0.0d0)
	      endif
            if((pprop.gt.0.0d0).and.
     +        (pnit(4)/((pstate(4)+pprop)*2.5d0).lt.prnlw)) then
	         pprop=min(pnit(4)/(prnlw*2.5d0)-pstate(4),pprop)
	         pprop=max(pprop,0.0d0)
	      endif
c	  
	      RETURN
      endif
C
      PROPN=MAX((PSTATE(4)+PPROP)*2.5D0*PGNTGT-PNIT(4),0.0D0)
      IF(PROPN.LT.0.0D0) PROPN=0.0D0
      IF(PROPN.GE.TOTAVN) THEN
C
C       ...PROPAGULES USE REMAINING NITROGEN
        PROPN=TOTAVN
c Liwang Ma, 7-2-2006, to limit plant growth when N is limited
	  TOTAVN=0.0d0
            if(pnit(4)/((pstate(4)+pprop)*2.5d0).lt.prnlw) then
	         pprop=min((pnit(4)+propn)/(prnlw*2.5d0)-pstate(4),pprop)
	         pprop=max(pprop,0.0d0)
	      endif
      ELSE
C
C       ...NITROGEN LEFT FOR LEAVES AND SHOOTS
        ALFTN=TOTAVN-PROPN
C
C       ...CALCULATE THE DEMAND FOR THE LEAVES AND SHOOTS
        DEML=MAX((PSTATE(2)+PLEAF)*2.5D0*DMD-PNIT(2),0.0D0)
        DEMS=MAX((PSTATE(3)+PSTEM)*2.5D0*DMD-PNIT(3),0.0D0)
        TOTDEM=DEML+DEMS
C
C       ...ANY NITROGEN LEFT OVER?
        IF(TOTDEM.GT.ALFTN) THEN
C         ...NO NITROGEN LEFT OVER
          PLEAFN=DEML*ALFTN/TOTDEM
          STEMN=DEMS*ALFTN/TOTDEM
          ALFTN=0.0D0
c Liwang Ma, 7-2-2006, to limit plant growth when N is limited
            if(pnit(2)/((pstate(2)+pleaf)*2.5d0).lt.alnlw) then
	         pleaf=min((pnit(2)+pleafN)/(alnlw*2.5d0)-pstate(2),pleaf)
	         pleaf=max(pleaf,0.0d0)
	      endif
            if (pnit(3)/((pstate(3)+pstem)*2.5d0).lt.stnlw) then
	         pstem=min((pnit(3)+stemN)/(stnlw*2.5d0)-pstate(3),pstem)
	         pstem=max(pstem,0.0d0)
	      endif
        ELSE
C         ...STILL NITROGEN LEFT OVER
          PLEAFN=DEML
          STEMN=DEMS
          ALFTN=ALFTN-PLEAFN-STEMN
        ENDIF
      ENDIF
C     IF (ALFTN .GT. 0.0D0) THEN
C     ...REMAINDER OF NITROGEN PLACED IN ROOTS
C     RTNDMD = PSTATE(5) * 2.5D0 * RTNLW
C     IF (RTNDMD .GT. ALFTN) THEN
C     RTNDMD = ALFTN
C     ALFTN = 0.0D0
C     ELSE
C     ALFTN = ALFTN - RTNDMD
C     END IF
C     DO 25 I=1,IR
C     ROOTN(I) = ROOTN(I) + RTNDMD * RWL(I) / RTTOT
C     25   CONTINUE
C     END IF
      RETURN
      END
C
      FUNCTION PHOPER(APHI,DAY)
C
C======================================================================
C
C       PURPOSE: TO DETERMINE THE PHOTO PERIOD FOR ANY DAY AT A
C              GIVEN LATITUDE
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       ADEPT  L
C       AHOU   L
C       APHI   I
C       DAY        I
C       PHOPER     O
C       PI         P  MATHEMATICAL CONSTANT = 3.141592654...
C       TEM1   L
C       TEM2   L
C
C       COMMENTS:
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:   2
C
C======================================================================
C
      DOUBLE PRECISION PI,ADEPT,TEM1,TEM2,AHOU,PHOPER,APHI,DAY
      PARAMETER(PI=3.141592654D0)
C
C     ..FIND DEFLECTION DUE TO DAY OF YEAR
C
      ADEPT=0.414D0*SIN(6.28D0*(DAY-77.0D0)/365.0D0)
C
C     ..CORRECT FOR LATITUDE POSITION ANGLE HOUR
C
      TEM1=SQRT(1.0D0-(-TAN(APHI)*ADEPT)**2.0D0)
      TEM2=-TAN(APHI)*TAN(ADEPT)
      AHOU=ATAN2(TEM1,TEM2)
C
C     ..FIND PHOTOPERIOD
C
      PHOPER=AHOU*24.0D0/PI
C
      END
      FUNCTION PHOTO(BETA,K,ALEAF,PMAX,PP,RTOTAL)
C
C======================================================================
C
C       PURPOSE: CALCULATE THE AMOUNT OF ASSIMILATED CARBON PER UNIT
C              AREA AND ADJUST THIS FOR TOTAL LEAF AREA
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       A1         L  CONSTANT FOR THETA(H) CURVE
C       A2         L  LAMDA- SLOPE OF THETA(H) CURVE
C       ALEAF  I
C       BETA   I  TEMPORARY STORAGE OF COEFF
C       K      I  VON KARMAN CONSTANT ( =.41)
C       PHOTO  O
C       PHOTON     L
C       PI         P  MATHEMATICAL CONSTANT = 3.141592654...
C       PMAX   I
C       PP         I  PHOTOPERIOD [HR]
C       R      L  GAS CONSTANT (J/KG/K)
C       RCAN   L
C       RMAX  I/O
C       RS         L  SPACING BETWEEN THE ROWS FOR THE CROPS [CM]
C       RTOTAL    I/O
C
C       COMMENTS: **NOTE** DIMENSIONS OF ABOVE ITEMS NEED TO BE
C                      DETERMINED.
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION: 2.0
C
C======================================================================
      DOUBLE PRECISION BETA,ALEAF,PMAX,PP,RMAX,RTOTAL
C     LOCAL VARIABLES
      DOUBLE PRECISION A1,A2,K,PHOTO,PHOTON,PI,R,RCAN,RS
C
      PARAMETER(PI=3.1415927D0)
C     CONVERT RTOTAL FROM MJ/M2/DAY TO MOLES PAR/M2/DAY
C               LY/(MJ/M^2)  PARFAC FROM SOYGRO
C     PHOTON=RMJOUL*23.923     /12.07 (LY/(MOLES/M^2))
C     PHOTON IS IN MOLES PAR/M^2/DAY
C
      IF(RTOTAL.LE.0.0D0) THEN
        PHOTON=18.0D0
      ELSE
        PHOTON=RTOTAL
      ENDIF
C
      PHOTON=PHOTON*23.923D0/12.07D0
C
C     AVERAGE DAILY LIGHT FLUX IN THE CANOPY: INTEGRAL{0->ALEAF} OF
C     [(1-EXP(-KALEAF))DALEAF]/(ALEAF-0)   FROM MEAN VALUE THEOREM
C     K SHOULD BE ABOUT .65 FOR MAIZE, BUT 1.0 IS NEEDED HERE
C
      RCAN=PHOTON/K*(1.D0-EXP(-K*ALEAF))/ALEAF
C
C     LIGHT FLUX AT NOON
      RMAX=PI/2.0D0*RCAN/PP
C
C     R  (MOLES C/M^2/HOUR) / [(MOLES C/MOLE PAR) * (MOLES PAR/M^2/HOUR)
C     R IS UNITLESS SO A1 SHOULD ALSO BE UNITLESS
      R=PMAX/(BETA*RMAX)
C
      IF(R.GT.1.0D0) THEN
        RS=1.0D0/SQRT(R*R-1.0D0)
        A2=1.0D0-ATAN(RS)/(PI/2.0D0)
        A1=1.0D0-R*RS*A2
      ELSEIF(R.EQ.1.0D0) THEN
        A1=1.0D0-2.0D0/PI
      ELSE
        RS=SQRT(1.0D0-R*R)
        A2=LOG((1.0D0-RS)/(1.0D0+RS))
        A1=1.0D0+A2*R/(PI*RS)
      ENDIF
C     PHOTO IS SAME UNITS AS PMAX (MOLES C/M^2/HOUR)
C     THIS IS AVERAGE HOURLY NET PHOTOSYNTHESIS RATE
      PHOTO=A1*PMAX
C     WRITE(*,*) ' PHOTON,RCAN,RMAX,PHOTO',PHOTON,RCAN,RMAX,PHOTO
      END
C
      SUBROUTINE PLHGT(TOTSHT,PLHGHT,PLALFA,SHTDEN,RADHGT,HEIGHT,THGHT,
     +    PROVOL,OLDHGT)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       HEIGHT    I/O
C       OLDHGT    I/O
C       PI         P  MATHEMATICAL CONSTANT = 3.141592654...
C       PLALFA     I
C       PLHGHT     I
C       PLRAD  L
C       PROVOL    I/O
C       RADHGT     I
C       SHTDEN    I/O
C       STEM2  L
C       THGHT I/O
C       TOTSHT     I
C
C
C       COMMENTS:
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
C
      DOUBLE PRECISION PI,OLDHGT,STEM2,PLRAD,TOTSHT,PLHGHT,PLALFA,
     +    SHTDEN,RADHGT,HEIGHT,THGHT,PROVOL
      PARAMETER(PI=3.141592654D0)
C
C     --CALCULATE PLANT HEIGHT AND VOLUME FROM BIOMASS ASSUMING PLANT
C     --IS CYLINDER SHAPED
      STEM2=(TOTSHT*2.5D0)
      HEIGHT=PLHGHT*(1.0D0-EXP(-PLALFA*STEM2/(2.0D0*PLHGHT)))
      HEIGHT=MAX(HEIGHT,OLDHGT)
      IF(HEIGHT.EQ.OLDHGT) THEN
        THGHT=THGHT+1.0D0
      ELSE
        THGHT=0.0D0
      ENDIF
      OLDHGT=HEIGHT
C
      PLRAD=HEIGHT*RADHGT
      PROVOL=HEIGHT*PI*PLRAD*PLRAD
      IF(PROVOL.GT.0.0D0) THEN
        SHTDEN=TOTSHT/PROVOL
      ELSE
        SHTDEN=0.0D0
      ENDIF
      RETURN
      END
C
      FUNCTION PLPROD(BETA,ETP,GS,ENDVEG,K,ALEAF,PLTS36,PMAX,PP,ERP,ENP,
     +    EWP,RTOTAL,ISTAGE,SLA3,SLA4,ENDREP,IMAGIC,PEXP)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       ALEAF  I
C       BETA   I  TEMPORARY STORAGE OF COEFF
C       EAP        L
C       ENDREP     I
C       ENDVEG     I
C       ERP       I/O
C       EVP        I
C       GS         I  GROWTH STAGE [0..1]
C       ISTAGE     I
C       K      I  VON KARMAN CONSTANT ( =.41)
C       PEXP   L
C       PLPROD     O
C       PLTS36     I
C       PMAX   I
C       PP         I  PHOTOPERIOD [HR]
C       RMAX   L
C       RTOTAL     I
C       SLA3   I
C       SLA4   I
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 PHOTO
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
      DOUBLE PRECISION BETA,ETP,K,ALEAF,PLTS36,PMAX,PP,ERP,RTOTAL,GS,
     +    ENDVEG,SLA3,SLA4,ENDREP,ENP,EWP
      INTEGER ISTAGE,IC,IMAGIC
C
C     LOCAL VARIABLES
      DOUBLE PRECISION PEXP,PHOTO,PLPROD,EAP
      SAVE EAP
      SAVE IC
      DATA IC /0/
C
C     PEXP IS SAME UNITS AS PHOTO & PMAX (MOLES C/M^2/HOUR)
      IF(ALEAF.GT.0.0D0) THEN
        PEXP=PHOTO(BETA,K,ALEAF,PMAX,PP,RTOTAL)
      ELSE
        PEXP=0.0D0
      ENDIF
C
C     ERP IS USED IN PARTIT TO PARTITION BETWEEN LEAVES AND SHOOTS.
C     IT IS SUPPOSED TO RUN FROM 0 TO 1 AS LIGHT INTENSITY INCREASES
C     LOW LIGHT INTENSITY INCREASES SHOOT GROWTH OVER ROOT GROWTH
C     WITH BETA=.0524, PMAX=63*.036 (MOLES C/M2/HR)=2.26, ERP IS 0->1
C
      ERP=BETA*RTOTAL/(PMAX+BETA*RTOTAL)
C     ERP = PEXP / PMAX
C
C
C     JDH 4/9/93; MAKE PEXP A FUNCTION OF PLANT AGE (GROWTH STAGE)
C
      IF(GS.LE.ENDVEG) THEN
        EAP=1.0D0
      ELSEIF(ISTAGE.EQ.6) THEN
        EAP=SLA3
      ELSEIF(ISTAGE.EQ.7) THEN
        EAP=SLA4*(1.0D0-GS)/(1.0D0-ENDREP)
      ENDIF
      PEXP=PEXP*EAP*12.0D0*PP
C
C     ...CONVERT PEXP TO G C/M^2 LEAF/DAY   *12 G C/MOLE C *PP HOUR/DAY
C     CALCULATE PHOTOSYNTHESIS (G C/PLANT/DAY)
C     ...NOTE:  PEXP (GC/M2 LEAF/DAY); * LEAF AREA/PLANT (M2/PLANT)
C     ALEAF (M2 LEAF/M2-AREA); PLTS36 (PLANTS/M2)
      PLPROD=PEXP*ETP*DMIN1(ENP,EWP)*ALEAF/PLTS36
      IC=IC+1
      IF(IMAGIC.EQ.-7.OR.IMAGIC.EQ.-8) WRITE(96,1000) IC,PLPROD,PEXP,
     +    ALEAF,PLTS36
      RETURN
 1000 FORMAT(I4,14F13.3)
      END
C
      SUBROUTINE RTDIST(ASF,ASF1,ASF2,ASF3,CL7,DCA,DMDRT,DWL,GSR,GSY,GS,
     +    IR,LWM,LWR,LWS,NN,PLTMNT,PLTMXT,PLTOPT,PLTS26,RDR,RDX,RGA,RLL,
     +    RLV,RMORT,RWL,T,TLT,WCG,WCP,ZA,RSD,CNST,RTNLW,TNITN)
C
C======================================================================
C
C       PURPOSE: THIS SUBROUTINE DISTRIBUTES ROOT GROWTH THROUGHOUT THE
C              SOIL PROFILE IN RESPONSE TO ROOT SYSTEM GROWTH, LAYER
C              DEPTH, STATIC, AND DYNAMIC STRESS FACTORS
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       ASF        I  ACTIVE (MINIMUM) LAYER STRESS FACTOR [0-1]
C       ASF1   I  MINIMUM OF STRESS FACTORS STP, SCA, OR SAL
C       ASF2   I  THE SQUARE ROOT OF THE MINIMUM OF STRESS
C                 FACTORS SST OR SAI
C       ASF3   I  MINIMUM OF STRESS FACTORS SST OR SAL
C       CL7        I
C       CNST   I
C       DCA       I/O CUMULATIVE ACTUAL DRY MATTER INCREASE OF ROOT
C                 SYSTEM (KG/HA)
C       DDI        L
C       DMDRT  I  DRY MATTER ALLOCATION TO ROOT SYSTEM ON A DAY (KG/HA)
C       DPL        L  POTENTIAL ROOT GROWTH IN THE LAYER (KG/HA)
C       DPS        L  POTENTIAL ROOT SYSTEM GROWTH (KG/HA)
C       DRD        L  POTENTIAL INCREASE IN ROOT DEPTH (M)
C       DRL        L  CHANGE IN ROOT WEIGHT IN THE LAYER (KM/HA)
C       DWL       I/O DAILY DEATH OF ROOTS IN LAYER [KG/HA]
C       DZ         L
C       ETRSRV     L
C       GS         I  GROWTH STAGE [0..1]
C       GSR        I  GROWTH STAGE WHEN ROOT DEPTH REACHES MAXIMUM [0..1]
C       GSY       I/O GROWTH STAGE PREVIOUS DAY [0..1]
C       I      L  INDEX VARIABLE
C       IR        I/O NUMBER OF LAYERS WITH ROOTS
C       J      L  INDEX VARIABLE
C       K      L  VON KARMAN CONSTANT ( =.41)
C       L      L
C       LWA        L  LENGTH/WEIGHT RATIO FOR ROOTS GROWING ON A DAY
C                 IN A LAYER [M/G)
C       LWM        I  RATIO OF ROOT LENGTH TO WEIGHT IN PLOW LAYER
C                 AT MATURITY [M/G)
C       LWN        L  NORMAL LENGTH/WEIGHT RATIO (KM/KG)
C       LWR       I/O LENGTH/WEIGHT RATIO OF ALL ROOTS IN A LAYER [M/G)
C       LWS        I  NORMAL RATIO OF ROOT LENGTH TO WEIGHT IN
C                 SEEDLING [M/G)
C       M      L
C       MAXBP  P  MAXIMUM NUMBER OF BREAK POINTS IN A RAINSTORM
C       MAXHOR     P  MAXIMUM NUMBER OF SOIL HORIZONS
C       MAXSCT     P  MAX NUMBER OF SOIL CONSTITUENTS PER HORIZON
C       MXAPP  P  MAXIMUM NUMBER OF MANAGEMENT APPLICATIONS
C       MXCHEM     P  MAXIMUM NUMBER OF CHEMICALS SIMULATED
C       MXNOD  P  MAX NUMBER OF NUMERICAL NODES
C       MXNODT     P
C       MXSPEC     P
C       N      L  EDDY DIFFUSIVITY DECAY CONSTANT AERODYNAMIC
C                 RESISTANCE BETWEEN CANOPY AND MEASUREMENT HEIGHT
C       NN         I  NUMBER INTERIOR NODES IN RICHARD'S EQN SOLUTION
C       PLRTS  L
C       PLTMNT     I
C       PLTMXT     I
C       PLTOPT     I
C       PLTS26     I
C       RCLEFT     L
C       RDP        L  POTENTIAL ROOT SYSTEM DEPTH ON A DAY [M]
C       RDR        I  MAXIMUM, NORMAL ROOT DEATH RATE
C                 (PROP. OF ROOT GROWTH)
C       RDX        I  NORMAL MAXIMUM ROOT SYSTEM DEPTH [M]
C       RGA       I/O ACTUAL ROOT GROWTH IN LAYER [KG/HA]
C       RGROW  L
C       RLL       I/O ROOT LENGTH IN THE LAYER (KM/HA)
C       RLV       I/O ROOT LENGTH DENSITY [CM/CM3]
C       RMORT I/O
C       RSD       I/O ROOT SYSTEM DEPTH [M]
C       RTMNT  L
C       RWL       I/O ROOT WEIGHT IN THE LAYER (KG)
C       T      I  SOIL TEMPERATURE IN NUMERICAL CONFIGURATION [C]
C       TLT        I  DEPTH TO BOTTOM OF NUMERICAL LAYERS [CM]
C       TRW        L  TOTAL ROOT SYSTEM WEIGHT (KG/HA)
C       TTLT   L
C       UPDEP  L
C       WCG        I  WEIGHTING COEFFICIENT - GEOTROPISM
C       WCP        I  WEIGHTING COEFFICIENT FOR PLASTICITY
C       WFL        L  WEIGHTING FACTOR FOR LAYER [0..1]
C       WFT        L  WEIGHTING FACTOR, TOTAL
C       ZA         I  MEAN LAYER DEPTH [M]
C
C
C       EXTERNAL REFERENCES:
C                 BELL
C
C       CALLED FROM:
C
C       PROGRAMMER: ALLEN JONES
C
C       VERSION:  2.0
C
C=======================================================================
C   ARRAY DIMENSION VALUES
C-----------------------------------------------------------------------
      INTEGER MXNOD
      PARAMETER(MXNOD=300)
C PASSED VARIABLES
      INTEGER IR,NN
      DOUBLE PRECISION ASF(MXNOD),ASF1(MXNOD),ASF2(MXNOD),ASF3(MXNOD),
     +    CL7,CNST,DCA,DMDRT,DWL(MXNOD),GSR,GSY,GS,LWM,LWR(NN),LWS,
     +    PLTMNT,PLTMXT,PLTOPT,PLTS26,RDR,RDX,RGA(NN),RLL(NN),RLV(NN),
     +    RMORT,RWL(NN),T(NN),TLT(NN),WCG,WCP,ZA(NN),RTNLW,TNITN,
     +    ReqN
C  LOCAL VARIABLES
      INTEGER I,J,L,M,N,K
      DOUBLE PRECISION BELL,DDI,DPL(MXNOD),DPS,DRD,DRL,DZ(MXNOD),ETRSRV,
     +    LWA(MXNOD),LWN,RDP,RSD,TRW,TTLT(MXNOD),UPDEP,WFL(MXNOD),WFT,
     +    PLRTS,RCLEFT,RGROW,RTMNT
C
C     INITIALIZE VARIABLES
      DPS=0.0D0
      TRW=0.0D0
      WFT=0.0D0
      DO 10 I=1,NN
C       ..CONVERT FROM CM TO M
        TTLT(I)=TLT(I)*0.01D0
   10 CONTINUE
C
C
      
C     DETERMINE INCREASE IN ROOT DEPTH
      DO 30 I=1,NN
        IF((GS.LT.GSR).or.(rdp.lt.rdx)) THEN
          IF(RSD.LT.TTLT(I)) THEN
            DDI=RDX*(GS-GSY)/GSR
            DO 20 J=I,NN
              DRD=DDI*MIN(ASF1(J),ASF2(J))
              IF(DRD.GT.(TTLT(J)-RSD)) THEN
                DDI=DDI-(TTLT(J)-RSD)
                RSD=TTLT(J)
              ELSE
                RSD=RSD+DRD
                IR=I
                GOTO 40
              ENDIF
   20       CONTINUE
          ENDIF
        ELSEIF(RWL(I).GT.0.0D0) THEN
C         ..DETERMINE NUMBER OF LAYER CONTAINING ROOTS AT MAX GROWTH STAGE
          IR=I
        ENDIF
   30 CONTINUE
C
C     .. CHANGED THIS FROM ORIGINAL JONES MODEL FOR SIMPLICITY OF DETERMINING IR
C     FROM LAYERS THAT CONTAINS ROOTS AFTER REACHING MAX GROWTH STAGE.  BEFORE
C     IR WAS DEFAULTING TO NN INSTEAD OF ACTUAL DEPTH AS WAS IMPLIED.  KWR 6/98
C
C
C     ...CALCULATE EFFECTS OF DEPTH AND LAYER THICKNESS ON ROOT
C     DISTRIBUTION CALCULATE POTENTIAL DEPTH OF ROOT SYSTEM FOR
C     THE DAY
   40 IF((GS.GT.GSR).or.(rdp.ge.rdx)) THEN
        RDP=RDX
      ELSE
        RDP=min(RDX,RDX*GS/GSR)
      ENDIF
C
      DO 50 L=1,IR
C
C       CALCULATE GEOTROPISM WEIGHTING FACTOR ON WEIGHTING FACTOR
        IF(ZA(L).GE.RDP) THEN
          WFL(L)=0.05D0**WCG
        ELSE
          WFL(L)=(1.0D0-ZA(L)/RDP)**WCG
        ENDIF
C
C       CALCULATE LAYER THICKNESS EFFECT ON WEIGHTING FACTOR
        IF(L.EQ.1) THEN
          UPDEP=0.0D0
        ELSE
          UPDEP=min(rsd,TTLT(L-1))
        ENDIF
        IF(RSD.GT.TTLT(L)) THEN
          DZ(L)=TTLT(L)-UPDEP
        ELSE
          DZ(L)=RSD-UPDEP
        ENDIF
        WFL(L)=DZ(L)/RSD*WFL(L)
        WFT=WFT+WFL(L)
   50 CONTINUE
C
C     .. CALCULATE POTENTIAL ROOT GROWTH / LAYER
C     AND THE TOTAL ROOT SYSTEM GROWTH POTENTIAL
      DO 60 M=1,IR
        DPL(M)=WCP*ASF(M)*DMDRT*WFL(M)/WFT
        DPS=DPS+DPL(M)
   60 CONTINUE
C
      RCLEFT=DMDRT-DPS
      RMORT=0.0D0
      RGROW=0.0D0
      ReqN=0.0d0
      DO 80 N=1,IR
C
C       DISTRIBUTE ROOT GROWTH BY LAYERS
C       FIX TO ALLOW PROPER DISTRIBUITON BETWEEN ROOTS AND PROPAGULES
        IF(DMDRT.EQ.0.0D0) THEN
          RGA(N)=0.0D0
        ELSEIF(DPS.GT.DMDRT) THEN
          RGA(N)=DPL(N)*(DMDRT/DPS)
        ELSE
C         ..ALLOCATE ALL DMDRT USING RCLEFT
          RGA(N)=DPL(N)*(1.0D0+RCLEFT/DPS)
        ENDIF
        DCA=DCA+RGA(N)
c  limit root growth by N available
          ReqN=ReqN+RGA(N)*2.5d0*RTNLW
          if (ReqN.gt.TNITN) then
          RGA(N)=0.0d0
          endif
C
C       CALCULATE ROOT DEATH BY LAYER
C       ..RTMNT IS EXISTING ROOT MAINTANCE REQUIREMENT
        PLRTS=PLTS26*1.0D-3
        IF(PLRTS+CL7.GT.0.0D0) THEN
          RTMNT=RDR*(1.0D0-PLRTS/(PLRTS+CL7))
        ELSE
          RTMNT=0.0D0
        ENDIF
        ETRSRV=1.0D0-BELL(T(N),PLTMXT,PLTMNT,PLTOPT,CNST)
C       ..NEW ROOTS ARE MODIFIED BY ENVIRONMENTAL STRESS
C       AND TOTAL ROOT MORTALITY IS CALCULATED
        DWL(N)=(RWL(N)*RTMNT+RGA(N)*ETRSRV)*(1.0D0-ASF2(N))
        RMORT=RMORT+DWL(N)
C
C       CONVERT LENGTH TO WEIGHT AND ACCUMULATE ROOT WEIGHT AND LENGTH
C       BY LAYER
        DO 70 K=1,IR
C
C         CALCULATE NORMAL LENGTH/WEIGHT RATIO AS AFFECTED BY GROWTH
C         STAGE AND LAYER DEPTH
          IF(ZA(K).GT.RSD) THEN
            LWN=LWS
          ELSE
            LWN=LWS-GS*(LWS-LWM)*(1.0D0-ZA(K)/RSD)
          ENDIF
C
C         EXCESSIVE ALUMINUM, STRENGTH, OR COARSE FRAGMENTS CAUSE LOWER
C         ROOT LENGTH/WEIGHT RATIOS
          LWA(K)=LWN/(1.0D0+3.0D0*(1.0D0-ASF3(K)))
C
   70   CONTINUE
C
        RWL(N)=RWL(N)+RGA(N)-DWL(N)
        RGROW=RGROW+RGA(N)
        TRW=TRW+RWL(N)
        DRL=LWA(N)*RGA(N)-LWR(N)*DWL(N)
        RLL(N)=RLL(N)+DRL
        IF(N.GT.1) THEN
          UPDEP=TTLT(N-1)
        ELSE
          UPDEP=0.0D0
        ENDIF
        RLV(N)=RLV(N)+DRL*1.0D-5/(TTLT(N)-UPDEP)
        IF(RWL(N).GT.0.0D0) THEN
          LWR(N)=RLL(N)/(RWL(N)+1.0D-9)
        ELSE
          LWR(N)=0.0D0
        ENDIF
   80 CONTINUE
      GSY=GS
      RETURN
      END
      FUNCTION SHTDET(EWP,TMIN,BIOSHT,SDAMAX,SDWMAX,SFREEZ,NAMSTG,
     +    CLSIZE,DAY,ENDSEN,BEGSEN)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       BIOSHT     I
C       CLSIZE     I
C       DS1        L
C       DS2        L
C       DS3        L
C       DS4        L
C       DS5        L
C       EWP        I
C       SDAMAX     I
C       SDWMAX     I
C       SFREEZ     I
C       SHTDET     O
C       TMIN   I  MINIMUM AIR TEMPERATURE [C]
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES: THRESH
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
C  PASSED VARIABLES
      DOUBLE PRECISION BIOSHT,CLSIZE(0:7),EWP,SDAMAX,SDWMAX,SFREEZ,
     +    SHTDET,TMIN,DAY,ENDSEN,BEGSEN,PARM,BRKPNT,BRKVAL
      CHARACTER NAMSTG*12
C  LOCAL VARIABLES
      DOUBLE PRECISION DS1,DS2,DS3,DS4,DS5,SUM
C
      DS1=0.0D0
      DS2=0.0D0
      DS3=0.0D0
      DS4=0.0D0
      DS5=0.0D0
C
C     --CALCULATE WATER-STRESS-INDUCED SHOOT DEATH
      DS1=SDWMAX*BIOSHT*(1.0D0-EWP)
c      DS1=0.0D0
C
C     --CALCULATE FREEZE-INDUCED SHOOT DEATH
      IF(TMIN.LT.SFREEZ) DS2=0.9D0*BIOSHT
C
C     IF (CLSIZE(6).GT.0.0D0.AND.CLSIZE(7).EQ.0.0D0) THEN
C     --CALCULATE AGE-INDUCED SHOOT DEATH (DURING SENESCENCE)
C     ...JDH 4/9/93; INSTEAD MAKE PEXP A FUNCTION OF GROWTH STAGE
C     DS3 = 0.005D0 * BIOSHT
      DS3=0.0D0
C     --CALCULATE AGE-INDUCED SHOOT DEATH (AFTER SENESCENCE)
      SUM=0.0D0
      DO 10 I=3,7
        SUM=SUM+CLSIZE(I)
   10 CONTINUE
      IF(SUM.GT.0.0D0) THEN
        IF(CLSIZE(7).GT.0.0D0) THEN
          BRKPNT=(BEGSEN+3.0D0*ENDSEN)/4.0D0
          BRKVAL=0.10D0
          IF(DAY.LE.BRKPNT) THEN
            PARM=BRKVAL*(DAY-BEGSEN)/(BRKPNT-BEGSEN)
          ELSEIF(DAY.LE.ENDSEN) THEN
            PARM=BRKVAL+(1.0D0-BRKVAL)*(DAY-BRKPNT)/(ENDSEN-BRKPNT)
          ELSE
            PARM=1.0D0
          ENDIF
          IF(PARM.GT.1.0D0) PARM=1.0D0
          IF(PARM.LT.0.0D0) PARM=0.0D0
          DS4=PARM*BIOSHT*CLSIZE(7)/SUM
        ENDIF
      ELSE
        DS4=0.0D0
      ENDIF
C
C     ...CALCULATE DIE-BACK RESULTING FROM EXCESS BIOMASS
C     THIS IS NOT USED SINCE CONVLA IS M2 LEAF AREA/G LEAF WEIGHT
C     IF (BIOSHT / CONVLA .GT. PTLAMX) THEN
C     DS5 = BIOSHT - CONVLA * PTLAMX
C     ELSE
      DS5=0.0D0
C     ENDIF
C
C     --DETERMINE TOTAL SHOOT DEATH
C
      SHTDET=DS1+DS2+DS3+DS4+DS5
C
      END
      SUBROUTINE SNSNC(DAY,SENES,ALEAF,CLS6,BEGSEN,ENDSEN,OLDLAI)
C
C======================================================================
C
C       PURPOSE:
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       BEGSEN    I/O
C       BIOSHT     I
C       CLS6   I
C       DAY        I
C       ENDSEN    I/O
C       HEIGHT     I
C       PLHGHT     I
C       PMAXHT     L
C       SENES I/O
C
C
C       COMMENTS:
C
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 ENDFND
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
C
      DOUBLE PRECISION ENDFND,DAY,OLDLAI,ALEAF,SENES,CLS6,BEGSEN,ENDSEN
C
C KEY SENESCENCE TO THE START OF REPRODUCTION (CLSIZE(6))
      IF(SENES.LT.1.0D0) THEN
        IF(CLS6.GT.0.0D0.OR.OLDLAI.GT.ALEAF) THEN
          SENES=1.0D0
          BEGSEN=DAY
        ENDIF
C     ELSE
C     SENES=0.0D0
C     BEGSEN=365.0D0
      ENDIF
      OLDLAI=ALEAF
C
      ENDSEN=ENDFND(DAY,ALEAF,SENES)
      RETURN
      END
      FUNCTION THRESH(XK,XN,X)
C
C======================================================================
C
C       PURPOSE: TO PROVIDE A GENERAL THRESHOLD EQUATION RELATIONSHIP
C              FOR USE BY STRESS FACTORS
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       THRESH     O
C       X      I  I: PREVIOUS SOLUTION VECTOR, O: REPLACED WITH XNEW
C       XK         I  DEPTH CONSTANT
C       XN         I
C
C       COMMENTS:
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER: JON HANSON AND KEN ROJAS
C
C       VERSION:   2
C
C======================================================================
C
      DOUBLE PRECISION X,XK,XN,THRESH
C
C     ..CHECK POINT FOR BOUNDARY AND EVALUATE
C
      IF(X.NE.0.0D0) THEN
        THRESH=1.0D0/(1.0D0+(X/XK)**XN)
      ELSE
        THRESH=1.0D0
      ENDIF
C
      END
      FUNCTION WPRESP(BIOPLT,PNCA,TEMP,RQ10,R20,ALPHA)
C
C======================================================================
C
C       PURPOSE: CALCULATE THE WHOLE-PLANT PHOTORESPITATION RATE AS A
C          FUNCTION OF PLANT WEIGHT AND PHOTOSYNTHETIC RATE
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       ALPHA  I  TEMPORARY STORAGE OF COEFF
C       BETA   L  TEMPORARY STORAGE OF COEFF
C       BIOPLT     I
C       PNCA   I
C       R20        I
C       RISE   L
C       RQ10   I
C       RUN        L
C       TEMP   I  TEMPERATURE OF LAYER (C)
C       WPRESP     O
C
C
C       COMMENTS: THE VALUE DETERMINED BY THIS METHOD MUST BY PART-
C          ITIONED BETWEEN THE VARIOUS PLANT COMPONENTS (LEAVES,
C          SHOOTS, ROOT, ETC) IN PROPORTION TO THE RELATIVE BIOMASS
C          OF EACH.
C
C       MASS STORAGE FILES:
C
C
C       EXTERNAL REFERENCES:
C                 NONE
C
C
C       CALLED FROM:
C
C       PROGRAMMER:  JON HANSON
C
C       VERSION:  2.0
C
C======================================================================
C  PASSED VARIABLES
      DOUBLE PRECISION ALPHA,BIOPLT,PNCA,R20,RQ10,TEMP
C LOCAL VARIABLES
      DOUBLE PRECISION RISE,RUN,WPRESP,BETA
C
C     -- CALCULATE TEMPERATURE DEPENDENT RESPIRATION PARAMETER
C
      RISE=R20*(RQ10-1.0D0)
      RUN=10.0D0
      BETA=TEMP*RISE/RUN-2.0D0*RISE+R20
C
      IF(BETA.LT.0.0D0) BETA=0.0D0
C
C     -- ESTIMATE WHOLE-PLANT RESPITATION BASED ON MCCREE (1970)
C
      WPRESP=ALPHA*PNCA+BETA*BIOPLT
C
      END
      SUBROUTINE CALCEVP(TC,ENP,CLNZEVP,EWP,PLTMXT,PLTMNT,PLTOPT,CNST)
C
C======================================================================
C
C       PURPOSE:  TO CALCULATE EVP(CLNZEVP) FOR THE COLNIZ SUBROUTINE
C
C       REF:
C
C
C       VARIABLE DEFINITIONS:
C       VARIABLE     I/O   DESCRIPTION
C       --------     ---   -----------
C       CNST     R       SHAPE PARAMETER FOR TEMPERATURE CURVE
C       ENP          R       REPRESENTS STRESS DUE TO NITROGEN REDUCTION
C       EVP          R       THE ENVIRONMENTAL STRESS
C       EWP          R       RATIO OF ACTUAL TRANSPIRATION TO POTENTIAL
C                    TRANSPIRATION\
C       PLTMNT       R       MINIMUM TEMPERATURE FOR PLANT GROWTH
C       PLTMXT       R       MAXIMUM TEMPERATURE FOR PLANT GROWTH
C       PLTOPT       R       OPTIMUM TEMPERATURE FOR PLANT GROWTH
C
C       LOCAL VARIABLES
C       BELL     RFUN  FUNCTION REPRESENTING THE RESPONSE OF PLANT
C                    ACTIVITY TO TEMPERATURE
C       ETP          R       REPRESENTS THE RESPONSE OF PLANT ACTIVITY TO
C                    TEMPERATURE
C
C       COMMENTS:
C
C
C       CALLED FROM:  COLNIZ
C
C       PROGRAMMER:  JON HANSON AND DEBBIE EDMUNDS
C
C       VERSION: 2.0
C
C======================================================================
C     ...ARGUMENT DECLARATIONS
      DOUBLE PRECISION PLTMNT,PLTMXT,PLTOPT,ENP,CLNZEVP,EWP,TC,CNST
C
C     ...LOCAL DECLARATIONS
      DOUBLE PRECISION BELL,ETP
C
C     ...CALL BELL FUNCTION TO CALCULATE ETP
      ETP=BELL(TC,PLTMXT,PLTMNT,PLTOPT,CNST)
C
C     ...COMPUTE VALUE FOR EVP
      CLNZEVP=ETP*MIN(EWP,ENP)
C
C     ...END SUBROUTINE
      RETURN
      END
      FUNCTION CALCWAT(DAY)
C
C=======================================================================
C
C       PURPOSE: TO CALCULATE WGERM FOR A DAY
C
C       REF:
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       CALCWA     O
C       DAY        I
C
C       COMMENTS:
C
C       CALLED FROM: PGMAIN
C
C       PROGRAMMER: JON HANSON AND DEBBIE EDMUNDS
C
C       VERSION: 2.0
C
C=======================================================================
C
C     ...ARGUMENT DECLARATIONS
      DOUBLE PRECISION CALCWAT,DAY
C
C     ...CALCULATE CALCWAT
      IF(DAY.LT.180.0D0) THEN
        CALCWAT=-1500.0D0
      ELSEIF(DAY.GT.180.0D0.AND.DAY.LT.220.0D0) THEN
        CALCWAT=36750.0D0-(212.5D0*DAY)
      ELSEIF(DAY.GT.220.0D0.AND.DAY.LT.240.0D0) THEN
        CALCWAT=-10000.0D0
      ELSEIF(DAY.GT.240.0D0.AND.DAY.LT.260.0D0) THEN
        CALCWAT=-112000.0D0+(425.0D0*DAY)
      ELSEIF(DAY.GT.260.0D0) THEN
        CALCWAT=-1500.0D0
      ENDIF
C
C     ...END FUNCTION
      RETURN
      END
      SUBROUTINE VERNALIZ(TMAX,TMIN,VBASE,VSAT,FV,VDD)
C
C======================================================================
C
C       PURPOSE: TO DETERMINE THE VERNALIZATION FACTOR FOR THE CROP.
C              THIS IS DEPENDENT ON THE TEMPERATURE HISTORY OF THE
C              PLANT
C
C       REF:  WEIR, A. H., P. L. BRAGG, J. R. PORTER, AND J. H. RAYNER.
C           1984. A WINTER WHEAT CROP SIMULATION MODEL WITHOUT WATER
C           OR NUTRIENT LIMITATIONS. J AGRIC SCI, CAMB 102:371-382.
C
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C       FV        R   THE VERNALIZATION FACTOR
C       VBASE R   BASE NUMBER OF DAYS FOR VERNALIZATION
C       VSAT  R   NUMBER OF DAYS FOR SATURATION FOR VERNALIZATION
C
C       LOCAL VARIABLES
C       FR        R   USED IN CALCULATING TH
C       MVDD  R   MEAN VERNALIZED DEGREE DAYS
C       R     I   DO LOOP CONTROL VARIABLE
C       TH        R   INVOLVED IN TEMPERATURE CALCULATIONS
C       VDD       R   VERNALIZED DEGREE DAYS
C       VDD1  R   ACCUMULATES VEFF
C       VEFF  R   VERNALIZATION EFFECTIVENESS FACTOR
C
C       COMMON VARIABLES
C       TMAX  R   THE MAXIMUM TEMPERATURE FOR ONE DAY READ FROM A
C                 CLIMATE FILE
C       TMIN  R   THE MINIMUM TEMPERATURE FOR ONE DAY READ FROM A
C                 CLIMATE FILE
C
C       COMMENTS:
C
C
C       CALLED FROM: COLNIZ
C
C       PROGRAMMER:  DEBBIE EDMUNDS
C
C       VERSION:  2.0
C
C======================================================================
C
C     ...ARGUMENT VARIABLES
      DOUBLE PRECISION VBASE,VSAT,FV,TMAX,TMIN
C
C     ...LOCAL VARIABLES
      DOUBLE PRECISION TH,MVDD,VDD,VDD1,FR,VEFF,PI
      PARAMETER(PI=3.14159D0)
      INTEGER R
C
C     ...INITIALIZE VARIABLES
      TH=0.0D0
      VDD1=0.0D0
C
C     ...SUM 1/8 DAY CONTRIBUTIONS FOR EACH DAY AND SUM THE VALUES FOR
C     THE DAYS FROM GERMINATION TO DOUBLE RIDGES
C     ..CHECK IF VDD IS EQUAL TO FULL VERNALIZATION
      IF(VDD.GE.33.0D0) THEN
        VDD=33.0D0
        FV=1.0D0
      ELSEIF(FV.LT.1.0D0) THEN
C       ...CALCULATE TH
        DO 10 R=1,8
          FR=0.5D0*(1.0D0+COS((PI/16.0D0)*(2.0D0*R-1.0D0)))
          TH=TMIN+FR*(TMAX-TMIN)
C Changes made by Liwang Ma, 6-28-2006
C         ...DETERMINE THE VEFF VALUE
          IF(TH.GE.-4.0D0.AND.TH.LE.3.0D0) THEN
            VEFF=(TH+4.0D0)/7.0D0
          ELSEIF(TH.GT.3.0D0.AND.TH.LE.10.0D0) THEN
            VEFF=1.0D0
          ELSEIF(TH.GT.10.0D0.AND.TH.LE.17.0D0) THEN
            VEFF=(17.0D0-TH)/7.0D0
          ELSE
            VEFF=0.0D0
          ENDIF
C
C         ...CALCULATE VDD
          VDD1=VDD1+VEFF
   10   CONTINUE
C
C       ...CALCULATE MEAN OF THE VDD FOR EACH DAY AND SUM VDD FOR THE
C       DAYS FROM GERMINATION TO DOUBLE RIDGES
        MVDD=0.125D0*VDD1
        VDD=VDD+MVDD
C
C       ...CALCULATE FV
        FV=(VDD-VBASE)/(VSAT-VBASE)
        IF(FV.GT.1.0D0) FV=1.0D0
        IF(FV.LT.0.0D0) FV=0.0D0
      ENDIF
C
      RETURN
      END
