C
      SUBROUTINE SOLAR_SHAW(DIRECT,DIFFUS,SUNSLP,ALTITU,SUNHOR,HAFDAY,
     >                  DECLIN,HOUR,DT,ALATUD,SLOPE,ASPECT)
C
C     THIS SUBROUTINE SEPARATES THE TOTAL RADIATION MEASURED ON THE
C     HORIZONTAL INTO THE DIRECT AND DIFFUSE ON THE LOCAL SLOPE.
C
C***********************************************************************
c
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C
      PARAMETER (SOLCON=1360.D0, HRNOON=12.0D0, DIFATM=0.76D0)
      INTEGER HOUR
C
C**** CHECK IF SUN HAS RISEN YET (OR IF IT HAS ALREADY SET)
      IF (SUNHOR .LE. 0.0d0) THEN
         DIRECT=0.0d0
         DIFFUS=0.0d0
         RETURN
      END IF
      SUNRIS=HRNOON - HAFDAY/0.261799d0
      SUNSET=HRNOON + HAFDAY/0.261799d0
C
C**** CALCULATE HOUR ANGLE AT WHICH THE SUN WILL BE DUE EAST/WEST IN
C     ORDER TO ADJUST AZIMUTH ANGLE FOR SOUTHERN AZIMUTHS
C     -- SIN(AZIMUTH) TELLS YOU ONLY THE EAST/WEST DIRECTION - NOT
C     WHETHER THE SUN IS NORTH/SOUTH.
      IF (ABS(DECLIN).GE.ABS(ALATUD)) THEN
C        LATITUDE IS WITHIN THE TROPICS (EQUATION WON'T WORK)
         HRWEST=3.14159D0
        ELSE
         HRWEST=ACOS(TAN(DECLIN)/TAN(ALATUD))
      END IF
C
C**** SUM UP VALUES AND FIND AVERAGE SUN POSITION FOR TIME STEP
      SINAZM=0.0d0
      COSAZM=0.0D0
      SUMALT=0.0D0
      COSALT=0.0D0
      SUNMAX=0.0d0
      NHRPDT=NINT(DT/3600.D0)
      IF (NHRPDT .LE. 0) NHRPDT=1
C     note: convert dtime from sec to hr  RMA: 1/28/94
C      DTIME=DT/(NHRPDT*3600.d0)
c      DO 10 IHR=0,NHRPDT
c         THOUR=HOUR + IHR*DTIME
      DO 10 IHR=HOUR-NHRPDT,HOUR
         THOUR=IHR
C
C****    DETERMINE THE GEOMETRY OF THE SUN'S RAYS AT CURRENT TIME
         HRANGL=0.261799d0*(THOUR-HRNOON)
         IF (THOUR .GT. SUNRIS  .AND.  THOUR .LT. SUNSET) THEN
C           SUN IS ABOVE HORIZON -- CALCULATE ITS ALTITUDE ABOVE THE
C           HORIZON (ALTITU) AND ANGLE FROM DUE NORTH (AZMUTH)
            SINALT=SIN(ALATUD)*SIN(DECLIN)
     >             + COS(ALATUD)*COS(DECLIN)*COS(HRANGL)
            ALTITU=ASIN(SINALT)
            AZM = ASIN(-COS(DECLIN)*SIN(HRANGL)/COS(ALTITU))
C           CORRECT AZIMUTH FOR SOUTHERN ANGLES
            IF (ALATUD-DECLIN .GT. 0.0D0) THEN
C              NORTHERN LATITUDES   (HRANGL=0.0 AT NOON)
               IF (ABS(HRANGL).LT.HRWEST) AZM=3.14159D0-AZM
              ELSE
C              SOUTHERN LATITUDES
               IF (ABS(HRANGL).GE.HRWEST) AZM=3.14159D0-AZM
            END IF
C           SUM CONDITIONS TO GET AVERAGE ALTITUDE AND AZMUTH
C           (OBTAIN AVERAGE BY SUMMING VECTOR COMPONENTS)
            SUN=SOLCON*SINALT
            SUMALT=SUMALT+SUN*SINALT
            COSALT=COSALT+SUN*COS(ALTITU)
            SINAZM=SINAZM+SUN*SIN(AZM)
            COSAZM=COSAZM+SUN*COS(AZM)
            SUNMAX=SUNMAX+SUN
         END IF
C
   10 CONTINUE
C
C**** DETERMINE AVERAGE SOLAR RADIATION, AVERAGE ALTITUDE AND AZIMUTH OF
C     THE SUN AND ANGLE ON LOCAL SLOPE
      IF (SUNMAX .EQ. 0) THEN
         ALTITU=0.0d0
         SUNSLP=0.0d0
        ELSE
         ALTITU=ATAN(SUMALT/COSALT)
         AZMUTH=ATAN2(SINAZM,COSAZM)
         SUNMAX=SUNMAX/(NHRPDT+1)
         SUNSLP=ASIN( SIN(ALTITU)*COS(SLOPE)
     >           + COS(ALTITU)*SIN(SLOPE)*COS(AZMUTH-ASPECT))
      END IF
C
C**** SEPARATE THE SOLAR RADIATION INTO DIRECT AND DIFFUSE COMPONENTS
      IF (ALTITU .LE. 0.0d0) THEN
C     SUN IS BELOW THE HORIZON - ALL RADIATION MUST BE DIFFUSE
         DIFFUS=SUNHOR
         DIRECT=0.0d0
         RETURN
      END IF
      TTOTAL=SUNHOR/SUNMAX
C     LIMIT TOTAL TRANSMISSIVITY TO MAXIMUM (DIFATM) WHICH WILL
C     CAUSE TDIFFU TO BE 0.0
      IF (TTOTAL .GT. DIFATM) TTOTAL = DIFATM
      TDIFFU=TTOTAL*(1.d0-EXP(0.6d0*(1.d0-DIFATM/TTOTAL)
     +    /(DIFATM-0.4d0)))
      DIFFUS=TDIFFU*SUNMAX
      DIRHOR=SUNHOR-DIFFUS
C
C**** NOW CALCULATE THE DIRECT SOLAR RADIATION ON THE LOCAL SLOPE
      IF (SUNSLP .LE. 0.0d0) THEN
C        SUN HAS NOT RISEN ON THE LOCAL SLOPE -- NO DIRECT RADIATION
         DIRECT=0.0d0
       ELSE
         DIRECT=DIRHOR*SIN(SUNSLP)/SIN(ALTITU)
C        IF THE SUN'S ALTITUDE IS NEAR ZERO, THE CALCULATED DIRECT
C        RADIATION ON THE SLOPING SURFACE MAY BE UNREALISTICALLY LARGE --
C        LIMIT DIRECT TO 5*DIRHOR (THIS IS APPROXIMATELY THE CASE WHEN
C        THE SUN IS 10 DEGREES ABOVE THE HORIZON AND THE SLOPING SURFACE
C        IS PERPENDICULAR TO THE SUN`S RAYS
         IF (DIRECT .GT. 5.d0*DIRHOR) DIRECT=5.d0*DIRHOR
      END IF
C
      RETURN
      END
C
C***********************************************************************