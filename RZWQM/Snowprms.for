C $Id: Snowprms.for,v 1.1 2002/08/28 00:00:48 rojas Exp $
C
      SUBROUTINE SNOWCOMP_PRMS(SSTART,JDAY,RTS,RCS,PTRANS,TMIN,TMAX,AS,
     +    POTEVTR,RFDNEW,SNP,SMELT,FSNC,PKTEMP,FRACIN,SNOWPK)
C
C***********************************************************************
C
C    Main snowprms<==>rzwqm interface routine
C
C
C    CONV1    --  CONVERT MJ/M2 ==> LANG
C    CONV2    --  CONVERT CM ==> IN
C    SSTART       L      FLAG FOR SNOW ROUTINE INITIALIZATION
C    SNOWPK --  PACK WATER EQUILIVALENT THAT IS PASSED IN FOR INITIAL
C
      DOUBLE PRECISION CONV1,CONV2
      PARAMETER(CONV1=1.0D2/4.186D0,CONV2=1.0D0/2.54D0)
C
      LOGICAL SSTART,README
C
      INTEGER(KIND=4) PPTMIX_NOPACK,JWDAY,NEWSNOW,PPTMIX,IT !RM - Changed to new decl style. (old = Int*#)
      INTEGER(KIND=4) IASW,ISO,MSO,LSO,LST,JDAY,MO,INT_SNOW,TRANSP_ON !RM - Changed to new decl style. (old = Int*#)
      DOUBLE PRECISION PKWATER_EQUIV,SNOWMELT,SNOW_EVAP,BASIN_SNOWMELT,
     +    BASIN_PWEQV,BASIN_SNOWEVAP,BASIN_SNOWCOV,ALBEDO,PK_TEMP,
     +    PK_DEN,TCAL,PK_DEF,PK_ICE,FREEH2O,PK_DEPTH,PSS,PST,SNSV,SALB,
     +    RTS,RCS,OBSRAD,RADPL_POTSW,SWRAD,NET_PPT,NET_SNOW,PTRANS,TMAX,
     +    TMIN,TAVGC,TMAXF,TMINF,AS,POTET,INTCP_EVAP,RFDNEW,NET_RAIN,
     +    PRMX,BASIN_PPT,SNOWCOV_AREA,POTEVTR,FRAC_INFIL,SNP,SMELT,FSNC,
     +    PKTEMP,FRACIN,SNOWPK
C
      SAVE JWDAY,README
      SAVE BASIN_SNOWMELT,BASIN_PWEQV
      SAVE PKWATER_EQUIV,SNOWMELT,SNOW_EVAP,SNOWCOV_AREA
      SAVE BASIN_SNOWEVAP,BASIN_SNOWCOV
      SAVE ALBEDO,PK_TEMP,PK_DEN
      SAVE TCAL,PPTMIX_NOPACK
      SAVE IASW,ISO,MSO,LSO,PK_DEF,PK_ICE
      SAVE FREEH2O,PK_DEPTH,PSS,PST,SNSV,LST,FRAC_INFIL
C
      DATA IT /0/,README /.TRUE./
C
C     .. SETUP SNOWPACK WATER EQUIVALENT AT START FOR INITIALIZATION
      PKWATER_EQUIV=SNOWPK*CONV2
C
C     ..READ IN ALL THE SNOW PARAMETERS
      IF(README) THEN
        CALL READ_SNOW(FRAC_INFIL)
        README=.FALSE.
        PSS=PKWATER_EQUIV
      ENDIF
C
      IF(SSTART) THEN
        CALL SNOINIT(SNOWMELT,SNOW_EVAP,SNOWCOV_AREA,PPTMIX_NOPACK,TCAL,
     +      PK_DEF,PK_TEMP,PK_ICE,FREEH2O,PST,PK_DEN,ALBEDO,SNSV,
     +      PK_DEPTH,IASW,ISO,MSO,LSO,LST)
        JWDAY=1
      ENDIF
C
C     ..DETERMINE MONTH OF YEAR FROM JULIAN DATE
      CALL CDATE(JDAY,IT,MO,IT)
C
      INTCP_EVAP=0.0D0
      INT_SNOW=0
      OBSRAD=RTS*CONV1
      RADPL_POTSW=RCS*CONV1
      SALB=AS
      SWRAD=RTS*CONV1
      TAVGC=(TMAX+TMIN)*0.5D0
      TMAXF=TMAX/0.5556D0+32.0D0
      TMINF=TMIN/0.5556D0+32.0D0
      POTET=POTEVTR*CONV2
      IF(PTRANS.GT.0.0D0) THEN
        TRANSP_ON=1
      ELSE
        TRANSP_ON=0
      ENDIF
C
C     ..DETERMINE WHAT WATER IS COMING IN AS, SNOW OR RAIN
      PPTMIX=0
      IF(RFDNEW.GT.0.0D0) THEN
C
        BASIN_PPT=RFDNEW*CONV2
        IF(TAVGC.LE.0.0D0) THEN
C
C         ..HAVE SNOW
          NET_PPT=RFDNEW*CONV2
          NET_RAIN=0.0D0
          NET_SNOW=NET_PPT
          PRMX=0.0D0
          NEWSNOW=1
        ELSE
C
C         ..HAVE RAIN
          NET_PPT=RFDNEW*CONV2
          NET_RAIN=NET_PPT
          NET_SNOW=0.0D0
          PRMX=1.0D0
          NEWSNOW=0
        ENDIF
      ELSE
C
C       ..NO PRECIP
        BASIN_PPT=0.0D0
        NET_PPT=0.0D0
        NET_RAIN=0.0D0
        NET_SNOW=0.0D0
        PRMX=0.0D0
        NEWSNOW=0
      ENDIF
C
C
      CALL SNORUN(PKWATER_EQUIV,SNOWMELT,SNOW_EVAP,SNOWCOV_AREA,
     +    BASIN_SNOWMELT,BASIN_PWEQV,BASIN_SNOWEVAP,BASIN_SNOWCOV,
     +    ALBEDO,PK_TEMP,PK_DEN,TCAL,PPTMIX_NOPACK,IASW,ISO,MSO,LSO,
     +    PK_DEF,PK_ICE,FREEH2O,PK_DEPTH,PSS,PST,SNSV,LST,JDAY,SALB,
     +    OBSRAD,RADPL_POTSW,SWRAD,NET_PPT,NET_SNOW,NET_RAIN,INTCP_EVAP,
     +    PPTMIX,NEWSNOW,BASIN_PPT,PRMX,TMAXF,TMINF,TAVGC,TRANSP_ON,
     +    POTET,INT_SNOW,JWDAY,SSTART,MO)
C
C     ..SEND BACK AMOUNT OF SNOWPACK AND MELT
C     SNP = SNOWPACK WATER EQUILIVALENCE (CM)
C     SMELT = AMOUNT OF SNOWMELT (CM)
C     FSNC = FRACTIONAL AREA COVERED BY SNOWPACK
C     PKTEMP = TEMPERATURE OF THE SNOWPACK  (C)
C     FRACIN = FRACTION INFILTRATION OF SNOWMELT
C
      SNP=BASIN_PWEQV/CONV2
      SMELT=BASIN_SNOWMELT/CONV2
      FSNC=BASIN_SNOWCOV
      PKTEMP=PK_TEMP
      FRACIN=FRAC_INFIL
      SNOWPK=PKWATER_EQUIV/CONV2
C
      WRITE(*,1000) BASIN_PPT/CONV2,BASIN_SNOWMELT/CONV2,BASIN_PWEQV/
     +    CONV2,BASIN_SNOWEVAP/CONV2,BASIN_SNOWCOV
C
C
C
      RETURN
 1000 FORMAT(/' NEW PRECIPITATION',T40,F12.5,/' SNOWPACK MELT',T40,f12.5
     +    ,/' PACK WATEREQU',T40,f12.5,/' SNOWPACK EVAPORATION',T40,
     +    F12.5,/' SNOWPACK COVER',T40,F12.5)
      END
C
C***********************************************************************
C
C     snoinit - Initialize snowcomp module - get parameter values,
C              compute initial values
C
C
      SUBROUTINE SNOINIT(SNOWMELT,SNOW_EVAP,SNOWCOV_AREA,PPTMIX_NOPACK,
     +    TCAL,PK_DEF,PK_TEMP,PK_ICE,FREEH2O,PST,PK_DEN,ALBEDO,SNSV,
     +    PK_DEPTH,IASW,ISO,MSO,LSO,LST)
C
      INTEGER(KIND=4) IASW,ISO,MSO,LSO,LST,PPTMIX_NOPACK !RM - Changed to new decl style. (old = Int*#)
      DOUBLE PRECISION SNOWMELT,SNOW_EVAP,SNOWCOV_AREA,TCAL,PK_DEF,
     +    PK_TEMP,PK_ICE,FREEH2O,PST,PK_DEN,ALBEDO,SNSV,PK_DEPTH
C
C
C      PKWATER_EQUIV = 0.0D0
      SNOWMELT=0.0D0
      SNOW_EVAP=0.0D0
      SNOWCOV_AREA=0.0D0
      PPTMIX_NOPACK=0
      TCAL=0.0D0
      IASW=0
      ISO=1
      MSO=1
      LSO=0
      PK_DEF=0.0D0
      PK_TEMP=0.0D0
      PK_ICE=0.0D0
      FREEH2O=0.0D0
      PK_DEPTH=0.0D0
      PST=0.0D0
      PK_DEN=0.0D0
      ALBEDO=0.0D0
      SNSV=0.0D0
      LST=0
C
      RETURN
      END
C
C***********************************************************************
C
C     snorun -
C
C
C
      SUBROUTINE SNORUN(PKWATER_EQUIV,SNOWMELT,SNOW_EVAP,SNOWCOV_AREA,
     +    BASIN_SNOWMELT,BASIN_PWEQV,BASIN_SNOWEVAP,BASIN_SNOWCOV,
     +    ALBEDO,PK_TEMP,PK_DEN,TCAL,PPTMIX_NOPACK,IASW,ISO,MSO,LSO,
     +    PK_DEF,PK_ICE,FREEH2O,PK_DEPTH,PSS,PST,SNSV,LST,JDAY,SALB,
     +    OBSRAD,RADPL_POTSW,SWRAD,NET_PPT,NET_SNOW,NET_RAIN,INTCP_EVAP,
     +    PPTMIX,NEWSNOW,BASIN_PPT,PRMX,TMAXF,TMINF,TAVGC,TRANSP_ON,
     +    POTET,INT_SNOW,JWDAY,SSTART,MO)
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C   HRU_AREA    HRU AREA
C   BASIN_AREA      TOTAL BASIN AREA
C       ALBEDO
C       BASIN_PPT
C       BASIN_PWEQV
C       BASIN_SNOWCOV
C       BASIN_SNOWEVAP
C       BASIN_SNOWMELT
C       FREEH2O
C       IASW
C       INTCP_EVAP
C       INT_SNOW
C       ISO
C       JDAY
C       LSO
C       LST
C       MSO
C       NDEPL Index number for snowpack areal depletion curves
C       NET_PPT
C       NET_RAIN
C       NET_SNOW
C       NEWSNOW
C       OBSRAD
C       PKWATER_EQUIV
C       PK_DEF
C       PK_DEN
C       PK_DEPTH
C       PK_ICE
C       PK_TEMP
C       POTET
C       PPTMIX
C       PPTMIX_NOPACK
C       PRMX
C       PSS
C       PST
C       RADPL_POTSW
C       SALB
C       SNOWCOV_AREA
C       SNOWMELT
C       SNOW_EVAP
C       SNSV
C       SWRAD
C       TAVGC
C       TCAL
C       TMAXF
C       TMINF
C       TRANSP_ON
C
      LOGICAL SSTART
      INTEGER MAXMO,MAXSNODPL
      PARAMETER(MAXSNODPL=5)
      PARAMETER(MAXMO=12)
C     !RM - Changed to new integer decl style. (old = Int*#)
      INTEGER(KIND=4) NDEPL,PPTMIX_NOPACK,JWDAY 
      INTEGER(KIND=4) MELT_LOOK,MELT_FORCE,HRU_DEPLCRV
      INTEGER(KIND=4) COV_TYPE
      INTEGER(KIND=4) TSTORM_MO(MAXMO)
      INTEGER(KIND=4) IASW,ISO,MSO,LSO
      INTEGER(KIND=4) LST,INT_SNOW,JDAY
      DOUBLE PRECISION DEN_INIT,SETTLE_CONST,DEN_MAX,RAD_TRNCF,
     +    SNAREA_CURVE(11,MAXSNODPL),SNAREA_THRESH,ALBSET_RNM,
     +    ALBSET_RNA,ALBSET_SNM,ALBSET_SNA,EMIS_NOPPT,CECN_COEF(MAXMO),
     +    POTET_SUBLIM,FREEH2O_CAP,TMAX_ALLSNOW,SNOWCOV_AREA,COVDEN_WIN,
     +    COVDEN_SUM,PKWATER_EQUIV,SNOWMELT,SNOW_EVAP,BASIN_AREA,
     +    HRU_AREA,BASIN_SNOWMELT,BASIN_PWEQV,BASIN_SNOWEVAP,
     +    BASIN_SNOWCOV,ALBEDO,PK_TEMP,PK_DEN,TCAL,PK_DEF,PK_ICE,
     +    FREEH2O,PK_DEPTH,PSS,PST,SNSV,SALB
C
      COMMON /SNOW/ ALBSET_RNA,ALBSET_RNM,ALBSET_SNA,ALBSET_SNM,
     +    CECN_COEF,COVDEN_SUM,COVDEN_WIN,DEN_INIT,DEN_MAX,EMIS_NOPPT,
     +    FREEH2O_CAP,POTET_SUBLIM,RAD_TRNCF,SETTLE_CONST,SNAREA_CURVE,
     +    SNAREA_THRESH,TMAX_ALLSNOW,TSTORM_MO,MELT_FORCE,MELT_LOOK,
     +    NDEPL,HRU_DEPLCRV,COV_TYPE
C
C******Local variables
C     !RM - Changed to new decl style. (old = Int*#)
      INTEGER(KIND=4) K,MO
      INTEGER(KIND=4) NITEDA
C
C
      DOUBLE PRECISION DENINV,SETDEN,SET1,TRD,TMINC,TMAXC,EMIS,ESV,SWN,
     +    CEC,DPT1,EFFK,CST,TEMP,CALS
C     !RM - Changed to new decl style. (old = Int*#)
      INTEGER(KIND=4) PPTMIX,NEWSNOW,TRANSP_ON
      DOUBLE PRECISION OBSRAD,RADPL_POTSW,NET_PPT,NET_SNOW,INTCP_EVAP,
     +    TMAXF,TMINF,TAVGC,NET_RAIN,POTET,BASIN_PPT,SWRAD,SW,PRMX
C
C
      SAVE DENINV,SETDEN,SET1
C
C
C      NSTEP = GETSTEP()
C
C      CALL DATTIM('now',NOWTIME)
C      MO = NOWTIME(2)
C     JDAY = JULIAN('now','calendar')
C     JWDAY = JULIAN('now','water')
      HRU_AREA=1.0D0
      BASIN_AREA=1.0D0
      BASIN_SNOWMELT=0.0D0
      BASIN_PWEQV=0.0D0
      BASIN_SNOWEVAP=0.0D0
      BASIN_SNOWCOV=0.0D0
C
      IF(SSTART) THEN
        DENINV=1.0D0/DEN_INIT
        SETDEN=SETTLE_CONST/DEN_MAX
        SET1=1.0D0/(1.0D0+SETTLE_CONST)
        JWDAY=0
      ENDIF
C
      JWDAY=JWDAY+1
      IF(JWDAY.EQ.1) THEN
C       PSS = 0.0D0
        ISO=1
        MSO=1
        LSO=0
      ENDIF
      TRD=OBSRAD/RADPL_POTSW
C
C
      PPTMIX_NOPACK=0
      SNOWMELT=0.0D0
      SNOW_EVAP=0.0D0
      SNOWCOV_AREA=1.0D0
      IF(JDAY.EQ.MELT_FORCE) ISO=2
      IF(JDAY.EQ.MELT_LOOK) MSO=2
      IF(PKWATER_EQUIV.GT.0.0D0.OR.NEWSNOW.NE.0.OR.INT_SNOW.NE.0) THEN
        IF(NEWSNOW.EQ.1.AND.PKWATER_EQUIV.EQ.0.0D0) SNOWCOV_AREA=1.0D0
C
C******Add rain and/or snow to snowpack
        IF((PKWATER_EQUIV.GT.0.0D0.AND.NET_PPT.GT.0.0D0).OR.NET_SNOW.GT.
     +      0.0D0) CALL PPT_TO_PACK(PPTMIX,IASW,TMAXF,TMINF,TAVGC,
     +      TMAX_ALLSNOW,PKWATER_EQUIV,NET_RAIN,PK_DEF,PK_TEMP,PK_ICE,
     +      FREEH2O,SNOWCOV_AREA,SNOWMELT,PK_DEPTH,PSS,PST,NET_SNOW,
     +      PK_DEN,FREEH2O_CAP,PPTMIX_NOPACK)
C
        IF(PKWATER_EQUIV.GT.0) THEN
C
C******Compute snow-covered area
          IF(NDEPL.GT.0) THEN
            K=HRU_DEPLCRV
            CALL SNOWCOV(K,IASW,NEWSNOW,SNOWCOV_AREA,SNAREA_CURVE,
     +          PKWATER_EQUIV,PST,SNAREA_THRESH,NET_SNOW)
          ENDIF
C
C******Compute albedo
C
          CALL SNALBEDO(NEWSNOW,ISO,MSO,LST,SNSV,PRMX,PPTMIX,ALBSET_RNM,
     +        NET_SNOW,ALBSET_SNM,ALBSET_RNA,ALBSET_SNA,ALBEDO,SALB)
C******
          TMINC=(TMINF-32.0D0)*0.5556D0
          TMAXC=(TMAXF-32.0D0)*0.5556D0
          EMIS=EMIS_NOPPT
          IF(BASIN_PPT.GT.0.0D0) EMIS=1.0D0
          ESV=EMIS
          SWN=SWRAD*(1.0D0-ALBEDO)*RAD_TRNCF
          CEC=CECN_COEF(MO)*0.5D0
          IF(COV_TYPE.EQ.3) CEC=CEC*0.5D0
C
C******Compute density and pst
          PSS=PSS+NET_SNOW
          DPT1=((NET_SNOW*DENINV)+(SETDEN*PSS)+PK_DEPTH)*SET1
          PK_DEPTH=DPT1
          PK_DEN=PKWATER_EQUIV/DPT1
          EFFK=0.0154D0*PK_DEN
          CST=PK_DEN*(SQRT(EFFK*13751.0D0))
C
C***** Check whether to force spring melt
          IF(ISO.EQ.1) THEN
            IF(MSO.EQ.2) THEN
              IF(PK_TEMP.GE.0.0D0) THEN
                LSO=LSO+1
                IF(LSO.LE.4) THEN
                  ISO=2
                  LSO=0
                ENDIF
              ELSE
                LSO=0
              ENDIF
            ENDIF
          ENDIF
C
C******Compute energy balance for night period
          NITEDA=1
          SW=0.0D0
          TEMP=(TMINC+TAVGC)*0.5D0
          CALL SNOWBAL(NITEDA,TSTORM_MO(MO),IASW,TEMP,ESV,BASIN_PPT,TRD,
     +        EMIS_NOPPT,COVDEN_WIN,CEC,PKWATER_EQUIV,PK_DEF,PK_TEMP,
     +        PK_ICE,FREEH2O,FREEH2O_CAP,SNOWCOV_AREA,SNOWMELT,PK_DEPTH,
     +        PSS,PST,PK_DEN,CST,CALS,SW)
          TCAL=CALS
C
C******Compute energy balance for day period
          IF(PKWATER_EQUIV.GT.0.0D0) THEN
            NITEDA=2
            SW=SWN
            TEMP=(TMAXC+TAVGC)*0.5D0
            CALL SNOWBAL(NITEDA,TSTORM_MO(MO),IASW,TEMP,ESV,BASIN_PPT,
     +          TRD,EMIS_NOPPT,COVDEN_WIN,CEC,PKWATER_EQUIV,PK_DEF,
     +          PK_TEMP,PK_ICE,FREEH2O,FREEH2O_CAP,SNOWCOV_AREA,
     +          SNOWMELT,PK_DEPTH,PSS,PST,PK_DEN,CST,CALS,SW)
            TCAL=TCAL+CALS
          ENDIF
C******Compute snow evaporation
          IF(PKWATER_EQUIV.GT.0.0D0) THEN
            IF(TRANSP_ON.EQ.0.OR.(TRANSP_ON.EQ.1.AND.COV_TYPE.LE.1))
     +          CALL SNOWEVAP(COV_TYPE,TRANSP_ON,COVDEN_WIN,COVDEN_SUM,
     +          POTET_SUBLIM,POTET,SNOWCOV_AREA,INTCP_EVAP,SNOW_EVAP,
     +          PKWATER_EQUIV,PK_ICE,PK_DEF,FREEH2O,PK_TEMP)
          ELSE
            SNOW_EVAP=0.0D0
          ENDIF
C
C******
          IF(PKWATER_EQUIV.GT.0.0D0) THEN
            PK_DEPTH=PKWATER_EQUIV/PK_DEN
            PSS=PKWATER_EQUIV
            IF(LST.GT.0) THEN
              SNSV=SNSV-SNOWMELT
              IF(SNSV.LE.0.0D0) SNSV=0.0D0
            ENDIF
          ELSE
            PK_DEPTH=0.0D0
            PSS=0.0D0
            SNSV=0.0D0
            LST=0
            PST=0.0D0
            IASW=0
            ALBEDO=0.0D0
            PK_DEN=0.0D0
            SNOWCOV_AREA=0.0D0
            PK_DEF=0.0D0
            PK_TEMP=0.0D0
            PK_ICE=0.0D0
            FREEH2O=0.0D0
          ENDIF
        ENDIF
        BASIN_SNOWMELT=BASIN_SNOWMELT+SNOWMELT*HRU_AREA
        BASIN_PWEQV=BASIN_PWEQV+PKWATER_EQUIV*HRU_AREA
        BASIN_SNOWEVAP=BASIN_SNOWEVAP+SNOW_EVAP*SNOWCOV_AREA*HRU_AREA
        BASIN_SNOWCOV=BASIN_SNOWCOV+SNOWCOV_AREA*HRU_AREA
      ENDIF
C
      BASIN_SNOWMELT=BASIN_SNOWMELT/BASIN_AREA
      BASIN_PWEQV=BASIN_PWEQV/BASIN_AREA
      BASIN_SNOWEVAP=BASIN_SNOWEVAP/BASIN_AREA
      BASIN_SNOWCOV=BASIN_SNOWCOV/BASIN_AREA
C
      RETURN
      END
C
C
C
C***********************************************************************
C      Subroutine to add rain and/or snow to snowpack
C***********************************************************************
C
      SUBROUTINE PPT_TO_PACK(PPTMIX,IASW,TMAXF,TMINF,TAVGC,TMAX_ALLSNOW,
     +    PKWATER_EQUIV,NET_RAIN,PK_DEF,PK_TEMP,PK_ICE,FREEH2O,
     +    SNOWCOV_AREA,SNOWMELT,PK_DEPTH,PSS,PST,NET_SNOW,PK_DEN,
     +    FREEH2O_CAP,PPTMIX_NOPACK)
C
      INTEGER(KIND=4) PPTMIX,IASW,PPTMIX_NOPACK !RM - Changed to new decl style. (old = Int*#)
      DOUBLE PRECISION TMAXF,TMINF,TAVGC,TMAX_ALLSNOW,PKWATER_EQUIV,
     +    NET_RAIN,PK_DEF,PK_TEMP,PK_ICE,FREEH2O,SNOWCOV_AREA,SNOWMELT,
     +    PK_DEPTH,PSS,PST,NET_SNOW,PK_DEN,FREEH2O_CAP,TRAIN,TSNOW,CALN,
     +    PNDZ,CALPR,CALPS
C
C
C******Compute temperature of rain and snow
C
      IF(PPTMIX.EQ.1) THEN
        TRAIN=(((TMAXF+TMAX_ALLSNOW)*0.5D0)-32.0D0)*.5556D0
        IF(TRAIN.LT.0.0D0) TRAIN=0.0D0
C
        IF(PKWATER_EQUIV.GT.0.0D0) THEN
          TSNOW=(((TMINF+TMAX_ALLSNOW)*0.5D0)-32.0D0)*.5556D0
          IF(TSNOW.GT.0.0D0) TSNOW=0.0D0
        ELSE
          TSNOW=TAVGC
          IF(TSNOW.GT.0.0D0) TSNOW=0.0D0
        ENDIF
C
      ELSE
        TRAIN=TAVGC
        IF(TRAIN.LE.0.0D0) TRAIN=((TMAXF+TMAX_ALLSNOW)*0.5D0)-32.0D0
        TRAIN=MAX(0.0D0,TRAIN)
        TSNOW=TAVGC
        TSNOW=MIN(0.0D0,TSNOW)
      ENDIF
C
C******If snowpack already exists, add rain first, then add
C******snow.  If no antecedent snowpack, rain is already taken care
C******of, so start snowpack with snow.  This subroutine assumes
C******that in a mixed event, the rain will be first and turn to
C******snow as the temperature drops.
C
      IF(PKWATER_EQUIV.GT.0.0D0) THEN
        IF(NET_RAIN.GT.0) THEN
          PKWATER_EQUIV=PKWATER_EQUIV+NET_RAIN
          IF(PK_DEF.GT.0) THEN
            CALN=(80.0D0+TRAIN)*2.54D0
            PNDZ=PK_DEF/CALN
C
C******Exactly enough rain to bring pack to isothermal
C
            IF(NET_RAIN.EQ.PNDZ) THEN
              PK_DEF=0.0D0
              PK_TEMP=0.0D0
              PK_ICE=PK_ICE+NET_RAIN
C
C******Rain not sufficient to bring pack to isothermal
            ELSEIF(NET_RAIN.LT.PNDZ) THEN
              PK_DEF=PK_DEF-(CALN*NET_RAIN)
              PK_TEMP=-PK_DEF/(PKWATER_EQUIV*1.27D0)
              PK_ICE=PK_ICE+NET_RAIN
C
C******Rain in excess of amount required to bring pack to isothermal
            ELSE
              PK_DEF=0.0D0
              PK_TEMP=0.0D0
              PK_ICE=PK_ICE+PNDZ
              FREEH2O=NET_RAIN-PNDZ
              CALPR=TRAIN*(NET_RAIN-PNDZ)*2.54D0
              CALL CALIN(CALPR,PKWATER_EQUIV,PK_DEF,PK_TEMP,PK_ICE,
     +            FREEH2O,SNOWCOV_AREA,SNOWMELT,PK_DEPTH,PSS,PST,IASW,
     +            PK_DEN,FREEH2O_CAP)
            ENDIF
C
C******Snowpack isothermal when rain occurred
          ELSE
            FREEH2O=FREEH2O+NET_RAIN
            CALPR=TRAIN*NET_RAIN*2.54D0
            CALL CALIN(CALPR,PKWATER_EQUIV,PK_DEF,PK_TEMP,PK_ICE,
     +          FREEH2O,SNOWCOV_AREA,SNOWMELT,PK_DEPTH,PSS,PST,IASW,
     +          PK_DEN,FREEH2O_CAP)
          ENDIF
        ENDIF
      ELSE
C******Set switch if rain/snow event with no antecedent snowpack
        IF(NET_RAIN.GT.0.0D0) THEN
          PPTMIX_NOPACK=1
        ENDIF
      ENDIF
C
      IF(NET_SNOW.GT.0) THEN
        PKWATER_EQUIV=PKWATER_EQUIV+NET_SNOW
        PK_ICE=PK_ICE+NET_SNOW
        IF(TSNOW.GE.0.0D0) THEN
          PK_TEMP=-PK_DEF/(PKWATER_EQUIV*1.27D0)
        ELSE
          CALPS=TSNOW*NET_SNOW*1.27D0
          IF(FREEH2O.GT.0.0D0) THEN
            CALL CALOSS(CALPS,PKWATER_EQUIV,PK_DEF,PK_TEMP,PK_ICE,
     +          FREEH2O)
          ELSE
            PK_DEF=PK_DEF-CALPS
            PK_TEMP=-PK_DEF/(PKWATER_EQUIV*1.27D0)
          ENDIF
        ENDIF
      ENDIF
C
      RETURN
      END
C
C***********************************************************************
C      Subroutine to compute change in snowpack when a net loss in
C        heat energy has occurred.
C***********************************************************************
C
      SUBROUTINE CALOSS(CAL,PKWATER_EQUIV,PK_DEF,PK_TEMP,PK_ICE,FREEH2O)
C
      DOUBLE PRECISION CAL,PKWATER_EQUIV,PK_DEF,PK_TEMP,PK_ICE,FREEH2O,
     +    CALND,DIF
C
C
C******if no free water exists in pack
      IF(FREEH2O.LE.0.0D0) THEN
        PK_DEF=PK_DEF-CAL
C
C******free water does exist in pack
      ELSE
        CALND=FREEH2O*203.2D0
        DIF=CAL+CALND
C
C******all free water freezes
        IF(DIF.LE.0.0D0) THEN
          IF(DIF.LT.0.0D0) PK_DEF=-DIF
          PK_ICE=PK_ICE+FREEH2O
          FREEH2O=0.0D0
C
C******only part of free water freezes
        ELSE
          PK_ICE=PK_ICE+(-CAL/203.2D0)
          FREEH2O=FREEH2O-(-CAL/203.2D0)
          RETURN
        ENDIF
      ENDIF
C
      IF(PKWATER_EQUIV.GT.0.0D0) PK_TEMP=-PK_DEF/(PKWATER_EQUIV*1.2D0)
C
      RETURN
      END
C
C
C***********************************************************************
C      Subroutine to compute changes in snowpack when a net gain in
C        heat energy has occurred.
C***********************************************************************
C
      SUBROUTINE CALIN(CAL,PKWATER_EQUIV,PK_DEF,PK_TEMP,PK_ICE,FREEH2O,
     +    SNOWCOV_AREA,SNOWMELT,PK_DEPTH,PSS,PST,IASW,PK_DEN,FREEH2O_CAP
     +    )
C
      INTEGER(KIND=4) IASW !RM - Changed to new decl style. (old = Int*#)
      DOUBLE PRECISION CAL,PKWATER_EQUIV,PK_DEF,PK_TEMP,PK_ICE,FREEH2O,
     +    SNOWCOV_AREA,SNOWMELT,PK_DEPTH,PSS,PST,PK_DEN,FREEH2O_CAP,DIF,
     +    PMLT,APMLT,APK_ICE,PWCAP
C
C
      DIF=CAL-PK_DEF
C
C******calorie deficit exists
      IF(DIF.LT.0) THEN
        PK_DEF=PK_DEF-CAL
        PK_TEMP=-PK_DEF/(PKWATER_EQUIV*1.27D0)
C
C******no calorie deficit or excess
      ELSEIF(DIF.EQ.0.0D0) THEN
        PK_TEMP=0.0D0
        PK_DEF=0.0D0
C
C******calorie excess, melt snow
      ELSE
        PMLT=DIF/203.2D0
        APMLT=PMLT*SNOWCOV_AREA
        PK_DEF=0.0D0
        PK_TEMP=0.0D0
        APK_ICE=PK_ICE/SNOWCOV_AREA
C
C******calories sufficient to melt entire pack
        IF(PMLT.GT.APK_ICE) THEN
          SNOWMELT=SNOWMELT+PKWATER_EQUIV
          PKWATER_EQUIV=0.0D0
          IASW=0
          SNOWCOV_AREA=0.0D0
          PK_DEF=0.0D0
          PK_TEMP=0.0D0
          PK_ICE=0.0D0
          FREEH2O=0.0D0
          PK_DEPTH=0.0D0
          PSS=0.0D0
          PST=0.0D0
          PK_DEN=0.0D0
C
C******calories sufficient to melt part of pack
        ELSE
          PK_ICE=PK_ICE-APMLT
          FREEH2O=FREEH2O+APMLT
          PWCAP=FREEH2O_CAP*PK_ICE
          DIF=FREEH2O-PWCAP
          IF(DIF.GT.0.0D0) THEN
            SNOWMELT=SNOWMELT+DIF
            FREEH2O=PWCAP
            PKWATER_EQUIV=PKWATER_EQUIV-DIF
            PK_DEPTH=PKWATER_EQUIV/PK_DEN
            PSS=PKWATER_EQUIV
          ENDIF
        ENDIF
      ENDIF
C
C
      RETURN
      END
C
C***********************************************************************
C      Subroutine to compute snowpack albedo
C***********************************************************************
C
C
      SUBROUTINE SNALBEDO(NEWSNOW,ISO,MSO,LST,SNSV,PRMX,PPTMIX,
     +    ALBSET_RNM,NET_SNOW,ALBSET_SNM,ALBSET_RNA,ALBSET_SNA,ALBEDO,
     +    SALB)
C     !RM - Changed to new decl style. (old = Int*#)
      INTEGER(KIND=4) NEWSNOW,ISO,MSO,PPTMIX
      INTEGER(KIND=4) INTAL,LST,L
      DOUBLE PRECISION ALBSET_RNM,NET_SNOW,ALBSET_SNM,ALBSET_RNA,
     +    ALBSET_SNA,ALBEDO,PRMX,ACUM(15),AMLT(15),SALB,SLST,SNSV
C
      DATA ACUM /0.80D0,0.77D0,0.75D0,0.72D0,0.70D0,0.69D0,0.68D0,
     +    0.63D0,0.62D0,0.61D0,0.6D0,0.6D0,0.6D0,0.6D0,0.6D0/
      DATA AMLT /0.72D0,0.65D0,0.60D0,0.58D0,0.56D0,0.54D0,0.52D0,
     +    0.43D0,0.42D0,0.41D0,0.4D0,0.4D0,0.4D0,0.4D0,0.4D0/
      DATA INTAL /1/
C
      IF(NEWSNOW.EQ.0) THEN
C******If no new snow, check to adjust albedo for shallow snowpack
        IF(LST.GT.0) THEN
          SLST=SALB-3.0D0
          IF(SLST.LT.1.0D0) SLST=1.0D0
          IF(ISO.NE.2) THEN
            IF(SLST.GT.5.) SLST=5.0D0
          ENDIF
          LST=0
          SNSV=0.0D0
        ENDIF
C
C******New snowfall
      ELSE
C******New snow in melt stage
        IF(MSO.EQ.2) THEN
          IF(PRMX.LT.ALBSET_RNM) THEN
            IF(NET_SNOW.GT.ALBSET_SNM) THEN
              SLST=0.0D0
              LST=0
              SNSV=0.0D0
            ELSE
              SNSV=SNSV+NET_SNOW
              IF(SNSV.GT.ALBSET_SNM) THEN
                SLST=0.0D0
                LST=0
                SNSV=0.0D0
              ELSE
                IF(LST.EQ.0) SALB=SLST
                SLST=0.0D0
                LST=1
              ENDIF
            ENDIF
          ENDIF
C
C******New snow in accumulation stage
        ELSE
          IF(PPTMIX.LE.0) THEN
            SLST=0.0D0
            LST=0
          ELSE
            IF(PRMX.GE.ALBSET_RNA) THEN
              LST=0
            ELSE
              IF(NET_SNOW.GE.ALBSET_SNA) THEN
                SLST=0.0D0
                LST=0
              ELSE
                SLST=SLST-3.0D0
                IF(SLST.LT.0.0D0) SLST=0.0D0
                IF(SLST.GE.5.0D0) SLST=5.0D0
                LST=0
              ENDIF
            ENDIF
          ENDIF
          SNSV=0.0D0
        ENDIF
      ENDIF
C
C******Set counter for days since last snowfall
      L=INT(SLST+0.5D0)
      SLST=SLST+1.0D0
C
C******compute albedo
      IF(L.GT.0) THEN
C******Old snow - Winter accumulation period
        IF(INTAL.NE.2) THEN
          IF(L.LE.15) THEN
            ALBEDO=ACUM(L)
          ELSE
            L=L-12
            IF(L.GT.15) L=15
            ALBEDO=AMLT(L)
          ENDIF
C******Old snow - Spring melt period
        ELSE
          IF(L.GT.15) L=15
          ALBEDO=AMLT(L)
        ENDIF
C******New snow condition
      ELSE
        IF(MSO.EQ.2) THEN
          ALBEDO=0.81D0
          INTAL=2
        ELSE
          ALBEDO=0.91D0
          INTAL=1
        ENDIF
      ENDIF
C
      RETURN
      END
C
C***********************************************************************
C      Subroutine to compute energy balance of snowpack
C        1st call is for night period, 2nd call for day period
C***********************************************************************
C
      SUBROUTINE SNOWBAL(NITEDA,TSTORM_MO,IASW,TEMP,ESV,BASIN_PPT,TRD,
     +    EMIS_NOPPT,COVDEN_WIN,CEC,PKWATER_EQUIV,PK_DEF,PK_TEMP,PK_ICE,
     +    FREEH2O,FREEH2O_CAP,SNOWCOV_AREA,SNOWMELT,PK_DEPTH,PSS,PST,
     +    PK_DEN,CST,CAL,SW)
C
      INTEGER(KIND=4) NITEDA,TSTORM_MO,IASW !RM - Changed to new decl style. (old = Int*#)
C
      DOUBLE PRECISION TEMP,ESV,BASIN_PPT,TRD,EMIS_NOPPT,COVDEN_WIN,CEC,
     +    PKWATER_EQUIV,PK_DEF,PK_TEMP,PK_ICE,FREEH2O,SNOWCOV_AREA,
     +    SNOWMELT,PK_DEPTH,PSS,PST,PK_DEN,CST,FREEH2O_CAP,AIR,TS,EMIS,
     +    SNO,SKY,CAN,CECSUB,CAL,QCOND,PK_DEFSUB,PKT,PKS,SW
C
C
      CAL=0.0D0
      AIR=.585D-7*((TEMP+273.16D0)**4.0D0)
      TS=0.0D0
      EMIS=ESV
C
      IF(TEMP.LT.0.0D0) THEN
        TS=TEMP
        SNO=AIR
      ELSE
        SNO=325.7D0
      ENDIF
C
      IF(BASIN_PPT.GT.0.0D0) THEN
        IF(TSTORM_MO.EQ.1) THEN
          IF(NITEDA.EQ.1) THEN
            EMIS=.85D0
            IF(TRD.GT.0.33D0) EMIS=EMIS_NOPPT
          ELSE
            IF(TRD.GT.0.33D0) EMIS=1.29D0-(0.882D0*TRD)
            IF(TRD.GE.0.5D0) EMIS=0.95D0-(0.2D0*TRD)
          ENDIF
        ENDIF
      ENDIF
C
      SKY=(1.0D0-COVDEN_WIN)*((EMIS*AIR)-SNO)
      CAN=COVDEN_WIN*(AIR-SNO)
      CECSUB=0.0D0
      IF(TEMP.GT.0.0D0) THEN
        IF(BASIN_PPT.GT.0.0D0) CECSUB=CEC*TEMP
      ENDIF
      CAL=SKY+CAN+CECSUB+SW
C
      IF(TS.GE.0.0D0) THEN
        IF(CAL.GT.0.0D0) THEN
          CALL CALIN(CAL,PKWATER_EQUIV,PK_DEF,PK_TEMP,PK_ICE,FREEH2O,
     +        SNOWCOV_AREA,SNOWMELT,PK_DEPTH,PSS,PST,IASW,PK_DEN,
     +        FREEH2O_CAP)
          RETURN
        ENDIF
      ENDIF
C
      QCOND=CST*(TS-PK_TEMP)
      IF(QCOND.LT.0.0D0) THEN
        IF(PK_TEMP.LT.0.0D0) THEN
          PK_DEF=PK_DEF-QCOND
          PK_TEMP=-PK_DEF/(PKWATER_EQUIV*1.27D0)
        ELSE
          CALL CALOSS(QCOND,PKWATER_EQUIV,PK_DEF,PK_TEMP,PK_ICE,FREEH2O)
        ENDIF
C
      ELSEIF(QCOND.EQ.0.0D0) THEN
        IF(PK_TEMP.GE.0.0D0) THEN
          IF(CAL.GT.0.0D0) CALL CALIN(CAL,PKWATER_EQUIV,PK_DEF,PK_TEMP,
     +        PK_ICE,FREEH2O,SNOWCOV_AREA,SNOWMELT,PK_DEPTH,PSS,PST,
     +        IASW,PK_DEN,FREEH2O_CAP)
        ENDIF
C
      ELSE
        IF(TS.GE.0.0D0) THEN
          PK_DEFSUB=PK_DEF-QCOND
          IF(PK_DEFSUB.LT.0.0D0) THEN
            PK_DEF=0.0D0
            PK_TEMP=0.0D0
          ELSE
            PK_DEF=PK_DEFSUB
            PK_TEMP=-PK_DEFSUB/(PKWATER_EQUIV*1.27D0)
          ENDIF
        ELSE
          PKT=-TS*PKWATER_EQUIV*1.27D0
          PKS=PK_DEF-PKT
          PK_DEFSUB=PKS-QCOND
          IF(PK_DEFSUB.LT.0.0D0) THEN
            PK_DEF=PKT
            PK_TEMP=TS
          ELSE
            PK_DEF=PK_DEFSUB+PKT
            PK_TEMP=-PK_DEF/(PKWATER_EQUIV*1.27D0)
          ENDIF
        ENDIF
      ENDIF
C
C
      RETURN
      END
C
C
C
C***********************************************************************
C      Subroutine to compute evaporation from snowpack
C***********************************************************************
C
      SUBROUTINE SNOWEVAP(COV_TYPE,TRANSP_ON,COVDEN_WIN,COVDEN_SUM,
     +    POTET_SUBLIM,POTET,SNOWCOV_AREA,INTCP_EVAP,SNOW_EVAP,
     +    PKWATER_EQUIV,PK_ICE,PK_DEF,FREEH2O,PK_TEMP)
C
      INTEGER(KIND=4) COV_TYPE,TRANSP_ON !RM - Changed to new decl style. (old = Int*#)
C
      DOUBLE PRECISION COVDEN_WIN,COVDEN_SUM,POTET_SUBLIM,POTET,
     +    SNOWCOV_AREA,INTCP_EVAP,SNOW_EVAP,PKWATER_EQUIV,PK_ICE,PK_DEF,
     +    FREEH2O,PK_TEMP,COV,EZ,CAL
C
C
C
      IF(COV_TYPE.GT.1) THEN
        COV=COVDEN_WIN
        IF(TRANSP_ON.EQ.1) COV=COVDEN_SUM
        EZ=(POTET_SUBLIM*POTET*SNOWCOV_AREA)-(INTCP_EVAP*COV)
      ELSE
        EZ=POTET_SUBLIM*POTET*SNOWCOV_AREA
      ENDIF
C
      IF(EZ.LE.0) THEN
        SNOW_EVAP=0.0D0
C
      ELSE
C******Entirely depletes snowpack
        IF(EZ.GE.PKWATER_EQUIV) THEN
          SNOW_EVAP=PKWATER_EQUIV
          PKWATER_EQUIV=0.0D0
          PK_ICE=0.0D0
          PK_DEF=0.0D0
          FREEH2O=0.0D0
          PK_TEMP=0.0D0
C******Partially depletes snowpack
        ELSE
          PK_ICE=PK_ICE-EZ
          CAL=PK_TEMP*EZ*1.27D0
          PK_DEF=PK_DEF+CAL
          PKWATER_EQUIV=PKWATER_EQUIV-EZ
          SNOW_EVAP=EZ
        ENDIF
      ENDIF
C
C
      RETURN
      END
C
C
C
C***********************************************************************
C      Subroutine to compute snow-covered area
C***********************************************************************
C
      SUBROUTINE SNOWCOV(K,IASW,NEWSNOW,SNOWCOV_AREA,SNAREA_CURVE,
     +    PKWATER_EQUIV,PST,SNAREA_THRESH,NET_SNOW)
C
      INTEGER MAXSNODPL
      PARAMETER(MAXSNODPL=5)
C     !RM - Changed to new decl style. (old = Int*#)
      INTEGER(KIND=4) K,IASW,NEWSNOW
      INTEGER(KIND=4) JDX,IDX
C
      DOUBLE PRECISION SNOWCOV_AREA,SNAREA_CURVE(11,MAXSNODPL),
     +    PKWATER_EQUIV,PST,SNAREA_THRESH,NET_SNOW,AI,SCRV,PKSV,DIFX,
     +    PCTY,SNOWCOV_AREASV,FRAC,AF,DIFY
C
      SAVE SCRV,PKSV,SNOWCOV_AREASV
C
      DATA SNOWCOV_AREASV,PKSV,SCRV /0.0D0,0.0D0,0.0D0/
C
      SNOWCOV_AREA=SNAREA_CURVE(11,K)
C
C
      IF(PKWATER_EQUIV.GT.PST) PST=PKWATER_EQUIV
      AI=PST
      IF(AI.GE.SNAREA_THRESH) AI=SNAREA_THRESH
      IF(PKWATER_EQUIV.GE.AI) THEN
        IASW=0
      ELSE
        IF(NEWSNOW.EQ.0) THEN
          IF(IASW.NE.0) THEN
            IF(PKWATER_EQUIV.GT.SCRV) RETURN
C
C******New snow not melted back to original partial area
            IF(PKWATER_EQUIV.GE.PKSV) THEN
              DIFX=SNOWCOV_AREA-SNOWCOV_AREASV
              PCTY=(PKWATER_EQUIV-PKSV)/(SCRV-PKSV)
              SNOWCOV_AREA=SNOWCOV_AREASV+(PCTY*DIFX)
              RETURN
C
C******Pack water equivalent back to value before new snow
            ELSE
              IASW=0
            ENDIF
          ENDIF
C
C******New snow
        ELSE
          IF(IASW.GT.0) THEN
            SCRV=PKWATER_EQUIV-(0.25D0*NET_SNOW)
          ELSE
            IASW=1
            SNOWCOV_AREASV=SNOWCOV_AREA
            PKSV=PKWATER_EQUIV-NET_SNOW
            SCRV=PKWATER_EQUIV-(0.25D0*NET_SNOW)
          ENDIF
          RETURN
        ENDIF
C
C******Interpolate along snow area depletion curve
C
        FRAC=PKWATER_EQUIV/AI
        IDX=INT(MIN(10.0D0*(FRAC+0.2D0),11.0D0))
        JDX=IDX-1
        AF=DBLE(JDX-1)
        DIFY=(FRAC*10.0D0)-AF
        DIFX=SNAREA_CURVE(IDX,K)-SNAREA_CURVE(JDX,K)
        SNOWCOV_AREA=SNAREA_CURVE(JDX,K)+(DIFY*DIFX)
C
      ENDIF
C
C
C
      RETURN
      END
C
      SUBROUTINE READ_SNOW(FRAC_INFIL)
C
C======================================================================
C
C       PURPOSE:  THE IS THE RZWQM <==> PRMS SNOW ROUTINES INTERFACE
C
C
C       VARIABLE DEFINITIONS:
C       VARIABLE  I/O DESCRIPTION
C       --------  --- -----------
C   ALBSET_RNA      ALBEDO RESET - RAIN, ACCUMULATION STAGE
C   ALBSET_RNM      ALBEDO RESET - RAIN, MELT STAGE
C   ALBSET_SNA      ALBEDO RESET - SNOW, ACCUMULATION STAGE
C   ALBSET_SNM      ALBEDO RESET - SNOW, MELT STAGE
C   CECN_COEF   CONVECTION CONDENSATION ENERGY COEFFICIENT
C   COVDEN_SUM      SUMMER VEGETATION COVER DENSITY FOR MAJOR VEGETATION TYPE
C   COVDEN_WIN      WINTER VEGETATION COVER DENSITY FOR MAJOR VEGETATION TYPE
C   COV_TYPE    COVER TYPE DESIGNATION FOR HRU
C   DEN_INIT    INITIAL DENSITY OF NEW-FALLEN SNOW IN GM/CM3
C   DEN_MAX         AVERAGE MAXIMUM SNOWPACK DENSITY
C   EMIS_NOPPT      EMISSIVITY OF AIR ON DAYS WITHOUT PRECIPITATION
C   FRAC_INFIL      FRACTION OF SNOWMELT THAT IS INFIL, REMAINDER IS RUNOFF
C   FREEH2O_CAP     FREE-WATER HOLDING CAPACITY OF SNOWPACK
C   HRU_DEPLCRV     INDEX NUMBER FOR SNOWPACK AREAL DEPLETION CURVE
C   MELT_FORCE      JULIAN DATE TO FORCE SNOWPACK TO SPRING SNOWMELT STAGE
C   MELT_LOOK   JULIAN DATE TO START LOOKING FOR SPRING SNOWMELT
C   POTET_SUBLIM    PROPORTION OF POTENTIAL ET THAT IS SUBLIMATED FROM SNOW
C   RAD_TRNCF   SOLAR RADIATION TRANSMISSION COEFFICIENT
C   SETTLE_CONST    SNOWPACK SETTLEMENT TIME CONSTANT
C   SNAREA_CURVE    SNOW AREA DEPLETION CURVE VALUES
C   SNAREA_THRESH   MAXIMUM THRESHHOLD WATER EQUIVALENT FOR SNOW DEPLETION
C   TMAX_ALLSNOW    PRECIP ALL SNOW IF HRU MAX TEMPERATURE BELOW THIS VALUE
C   TSTORM_MO   SET TO 1 IF THUNDERSTORMS PREVALENT DURING MONTH
C
C       COMMENTS:
C
C       EXTERNAL REFERENCES: SNOW.DAT [18] - SNOWMELT MODEL INPUT DATAFILE
C
C       CALLED FROM: SNOWCOMP_PRMS
C
C       PROGRAMMER: KEN ROJAS
C
C       VERSION: 3.0
C
C======================================================================
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C
      INTEGER MAXMO,MAXSNODPL
      PARAMETER(MAXSNODPL=5)
      PARAMETER(MAXMO=12)
C     !RM - Changed to new decl style. (old = Int*#)
      INTEGER(KIND=4) HRU_DEPLCRV,COV_TYPE,TSTORM_MO(MAXMO),NDEPL,INPSNO
C
      DOUBLE PRECISION SNAREA_CURVE(11,MAXSNODPL),CECN_COEF(MAXMO),
     +    FRAC_INFIL
C
      COMMON /SNOW/ ALBSET_RNA,ALBSET_RNM,ALBSET_SNA,ALBSET_SNM,
     +    CECN_COEF,COVDEN_SUM,COVDEN_WIN,DEN_INIT,DEN_MAX,EMIS_NOPPT,
     +    FREEH2O_CAP,POTET_SUBLIM,RAD_TRNCF,SETTLE_CONST,SNAREA_CURVE,
     +    SNAREA_THRESH,TMAX_ALLSNOW,TSTORM_MO,MELT_FORCE,MELT_LOOK,
     +    NDEPL,HRU_DEPLCRV,COV_TYPE
      COMMON/SNOWDEN/DEN_MAX1,DEN_INIT1
C
      INPSNO=18
C     OPEN (INPSNO,FILE='SNOW.DAT',STATUS='UNKNOWN')
C
      CALL ECHO(INPSNO)
      READ(INPSNO,*) DEN_MAX,DEN_INIT,FREEH2O_CAP,SETTLE_CONST,
     +    TMAX_ALLSNOW
C
      DEN_MAX1=DEN_MAX
      DEN_INIT1=DEN_INIT
C
      CALL ECHO(INPSNO)
      READ(INPSNO,*) ALBSET_RNM,ALBSET_RNA,ALBSET_SNM,ALBSET_SNA
C
      CALL ECHO(INPSNO)
      READ(INPSNO,*) COV_TYPE,COVDEN_SUM,COVDEN_WIN
C
      CALL ECHO(INPSNO)
      READ(INPSNO,*) RAD_TRNCF,EMIS_NOPPT,POTET_SUBLIM
      READ(INPSNO,*) (CECN_COEF(I),I=1,12)
      READ(INPSNO,*) (TSTORM_MO(I),I=1,12)
C
      CALL ECHO(INPSNO)
      READ(INPSNO,*) FRAC_INFIL,MELT_LOOK,MELT_FORCE,SNAREA_THRESH,
     +    HRU_DEPLCRV,NDEPL
      DO 10 J=1,NDEPL
        READ(INPSNO,*) (SNAREA_CURVE(I,J),I=1,11)
   10 CONTINUE
      IF(HRU_DEPLCRV.EQ.0) THEN
        HRU_DEPLCRV=1
        JJ=MAX(NDEPL,1)
        DO 30 J=1,JJ
          DO 20 K=1,11
            SNAREA_CURVE(K,J)=1.0D0
   20     CONTINUE
   30   CONTINUE
      ENDIF
      CLOSE(INPSNO)
C
      RETURN
      END
