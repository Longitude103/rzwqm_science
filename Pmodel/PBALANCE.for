      SUBROUTINE PBALANCE(ID,IM,IYYY)
      USE VARIABLE
      IMPLICIT NONE
      CHARACTER(LEN=100)::String
      INTEGER,INTENT(IN) :: ID,IM,IYYY
      INTEGER :: Day,Month,Year,Simuyear,Jday,i,daycount,daycount1
      DOUBLE PRECISION :: Computed_FinalSoilP,TotYFP,TotYMP,TotYResP,
     +TotYLatP,TotYDSP,TotYROP,TotYDrnP,TotYPltPup,IniP,OverallFP,
     +OverallMP,OverallResP,OverallLatP,OverallDSP,OverallROP,
     +OverallDrnP,OverallPltPup,IniP1,TotPflow_Frs_Lab,
     +TotPflow_Frs_Staorg,TotPflow_Staorg_Lab,TotPflow_Lab_Frs,
     +TotPflow_Lab_Act,TotPflow_Act_Lab,TotPflow_Act_Stainorg,
     +TotPflow_Stainorg_Act,TotLabP,TotActP,TotStabIP,TotStabOP,
     +TotFrsOP,FinalP,
     +TotPflow_Frs_Lab_Y,
     +TotPflow_Frs_Staorg_Y,TotPflow_Staorg_Lab_Y,TotPflow_Lab_Frs_Y,
     +TotPflow_Lab_Act_Y,TotPflow_Act_Lab_Y,TotPflow_Act_Stainorg_Y,
     +TotPflow_Stainorg_Act_Y,TotLabP_Y,TotActP_Y,TotStabIP_Y,
     +TotStabOP_Y,TotFrsOP_Y,TotFertPLabP_Y, TotManSO_WI_Y,
     +TotManSI_WI_Y,TotManWO_WI_Y,TotManSO_WO_Y,TotManWI_LabP_Y,
     +TotManSI_ActP_Y,TotFertP_Y,TotManP_Y,
     +OverallPflow_Frs_Lab,
     +OverallPflow_Frs_Staorg,OverallPflow_Lab_Frs,
     +OverallPflow_Staorg_Lab,OverallPflow_Lab_Act, 
     +OverallPflow_Act_Lab, OverallPflow_Stainorg_Act,
     +OverallPflow_Act_Stainorg, OverallFertPLabP,
     +OverallManSO_WI, OverallManSI_WI, OverallManWO_WI,
     +OverallManSO_WO,OverallManWI_LabP,OverallManSI_ActP,
     +OverallLabP,OverallActP,OverallStabIP,OverallStabOP,
     +OverallFrsOP,OverallFertP,OverallManP  
      
      DAY = ID
      Month = IM
      Year = IYYY
      Simuyear = Eyear - Syear + 1
      TotPflow_Frs_Lab = 0
      TotPflow_Frs_Staorg = 0
      TotPflow_Staorg_Lab = 0
      TotPflow_Lab_Frs = 0
      TotPflow_Lab_Act = 0
      TotPflow_Act_Lab = 0
      TotPflow_Act_Stainorg = 0
      TotPflow_Stainorg_Act = 0
      TotLabP = 0
      TotActP = 0
      TotStabIP = 0
      TotStabOP = 0
      TotFrsOP = 0     
      
      Computed_FinalSoilP = IniSoilP + (FertilizerP + ManuP + ResP) -
     + (Drplosslatflow + PPlosslatflow + Drplossdesp + PPlossdesp +
     + Drplossrnf + PPlossrnf + Drplosstdrain + PPlosstdrain +
     + PlntP_Up)   
      String ="(3I6,10(F22.5,2X),(E22.5,2X))"
      WRITE(117,String)Day,Month,Year,IniSoilP,FertilizerP,ManuP,
     + ResP,(Drplosslatflow + PPlosslatflow),
     + (Drplossdesp+PPlossdesp),
     + (Drplossrnf+PPlossrnf),
     + (Drplosstdrain+PPlosstdrain), PlntP_Up,
     + FinalSoilP,(FinalSoilP -Computed_FinalSoilP)
      
      WRITE(120,1001) Day,Month,Year,IniSoilP,FertilizerP,ManuP,
     +  ResP,(FertilizerP+ManuP+ResP) 
      
      
      
      DO  i = 1,Nsoil
         TotPflow_Frs_Lab = TotPflow_Frs_Lab + Pflowfrsolab(i)
         TotPflow_Frs_Staorg = TotPflow_Frs_Staorg + 
     +                                 Pflowfrsostbo(i)
         TotPflow_Staorg_Lab = TotPflow_Staorg_Lab +Pflowstbolab(i)
         TotPflow_Lab_Frs = TotPflow_Lab_Frs + Pflowlabfrso(i)
         TotPflow_Lab_Act = TotPflow_Lab_Act + Pflowlabact(i)
         TotPflow_Act_Lab = TotPflow_Act_Lab + Pflowactlab(i)
         TotPflow_Act_Stainorg = TotPflow_Act_Stainorg+ Pflowactstbi(i)
         TotPflow_Stainorg_Act = TotPflow_Stainorg_Act + Pflowstbiact(i)
         TotLabP =  TotLabP + LabP(i)
         TotActP = TotActP + ActP(i)
         TotStabIP = TotStabIP + Stabip(i)
         TotStabOP = TotStabOP +  Stabop(i)
         TotFrsOP = TotFrsOP + Frsop(i)
      END DO
      
      WRITE(120,1101)(Drplosslatflow + PPlosslatflow), 
     +  (Drplossdesp+PPlossdesp),(Drplossrnf+PPlossrnf),
     +  (Drplosstdrain+PPlosstdrain), PlntP_Up,
     +  (Drplosslatflow + PPlosslatflow + Drplossdesp+PPlossdesp +
     +  Drplossrnf+PPlossrnf+ Drplosstdrain+PPlosstdrain + PlntP_Up),
     +  TotPflow_Frs_Lab,TotPflow_Frs_Staorg,TotPflow_Lab_Frs,
     +  TotPflow_Staorg_Lab,TotPflow_Lab_Act,TotPflow_Act_Lab,
     +  TotPflow_Stainorg_Act,TotPflow_Act_Stainorg,
     +  (TotFertPLabP1+TotFertPLabP2),TotManSO_WI,
     +  TotManSI_WI,TotManWO_WI,TotManSO_WO,
     +  (TotManWI_LabP1+ TotManWI_LabP2+ TotManWI_LabP3 +  
     +   TotManWO_LabP1+TotManWO_LabP2+TotManWO_LabP3+
     +   TotManSO_LabP1+TotManSO_LabP2+TotManSO_LabP3),
     +   (TotManSI_ActP1+TotManSI_ActP2+TotManSI_ActP3)
      
       WRITE(120,1201)TotLabP,TotActP,TotStabIP,TotFrsOP,TotStabOP,
     +  Totfrt,Totm, FinalSoilP,(FinalSoilP -Computed_FinalSoilP)
      
      
      IF(Day == Sday .AND. Month == Smon .AND. Year == Syear) THEN
          IniP = IniSoilP
          IniP1 = IniSoilP
          TotYFP = 0
          TotYMP = 0
          TotYResP = 0
          TotYLatP = 0
          TotYDSP = 0
          TotYROP = 0
          TotYDrnP = 0
          TotYPltPup = 0
          OverallFP = 0
          OverallMP = 0
          OverallResP = 0
          OverallLatP = 0
          OverallDSP = 0
          OverallROP = 0
          OverallDrnP = 0
          OverallPltPup = 0
          TotPflow_Frs_Lab_Y = 0
          TotPflow_Frs_Staorg_Y = 0
          TotPflow_Staorg_Lab_Y = 0
          TotPflow_Lab_Frs_Y = 0
          TotPflow_Lab_Act_Y = 0
          TotPflow_Act_Lab_Y = 0
          TotPflow_Act_Stainorg_Y = 0
          TotPflow_Stainorg_Act_Y = 0
          TotFertPLabP_Y = 0
          TotManSO_WI_Y = 0
          TotManSI_WI_Y = 0
          TotManWO_WI_Y = 0
          TotManSO_WO_Y = 0
          TotManWI_LabP_Y = 0
          TotManSI_ActP_Y = 0
          TotLabP_Y = 0 
          TotActP_Y = 0
          TotStabIP_Y = 0
          TotStabOP_Y = 0
          TotFrsOP_Y = 0
          TotFertP_Y = 0
          TotManP_Y = 0 
          daycount = 0
          OverallPflow_Frs_Lab = 0
          OverallPflow_Frs_Staorg = 0
          OverallPflow_Staorg_Lab = 0
          OverallPflow_Lab_Frs = 0
          OverallPflow_Lab_Act = 0
          OverallPflow_Act_Lab = 0
          OverallPflow_Act_Stainorg = 0
          OverallPflow_Stainorg_Act = 0
          OverallFertPLabP = 0
          OverallManSO_WI = 0
          OverallManSI_WI= 0
          OverallManWO_WI = 0
          OverallManSO_WO = 0
          OverallManWI_LabP = 0
          OverallManSI_ActP = 0  
          OverallLabP = 0 
          OverallActP = 0
          OverallStabIP = 0
          OverallStabOP = 0
          OverallFrsOP = 0
          OverallFertP = 0
          OverallManP = 0 
          daycount1 = 0
      
      ENDIF   
       
          TotYFP = TotYFP + FertilizerP
          TotYMP = TotYMP + ManuP
          TotYResP = TotYResP + ResP
          TotYLatP = TotYLatP + (Drplosslatflow + PPlosslatflow)
          TotYDSP = TotYDSP + (Drplossdesp+PPlossdesp)
          TotYROP = TotYROP + (Drplossrnf+PPlossrnf)
          TotYDrnP = TotYDrnP + (Drplosstdrain+PPlosstdrain)
          TotYPltPup = TotYPltPup + PlntP_Up
          TotPflow_Frs_Lab_Y = TotPflow_Frs_Lab_Y + TotPflow_Frs_Lab
          TotPflow_Frs_Staorg_Y = TotPflow_Frs_Staorg_Y + 
     +                                         TotPflow_Frs_Staorg
          TotPflow_Staorg_Lab_Y = TotPflow_Staorg_Lab_Y 
     +                                           + TotPflow_Staorg_Lab
          TotPflow_Lab_Frs_Y = TotPflow_Lab_Frs_Y + TotPflow_Lab_Frs
          TotPflow_Lab_Act_Y = TotPflow_Lab_Act_Y + TotPflow_Lab_Act
          TotPflow_Act_Lab_Y = TotPflow_Act_Lab_Y + TotPflow_Act_Lab
          TotPflow_Act_Stainorg_Y = TotPflow_Act_Stainorg_Y + 
     +                                         TotPflow_Act_Stainorg
          TotPflow_Stainorg_Act_Y = TotPflow_Stainorg_Act_Y +
     +                                          TotPflow_Stainorg_Act
          
          TotFertPLabP_Y = TotFertPLabP_Y + TotFertPLabP1 +TotFertPLabP2
          TotManSO_WI_Y = TotManSO_WI_Y + TotManSO_WI
          TotManSI_WI_Y = TotManSI_WI_Y + TotManSI_WI
          TotManWO_WI_Y = TotManWO_WI_Y + TotManWO_WI
          TotManSO_WO_Y = TotManSO_WO_Y + TotManSO_WO
          TotManWI_LabP_Y = TotManWI_LabP_Y + (TotManWI_LabP1+ 
     +     TotManWI_LabP2+ TotManWI_LabP3 +  
     +   TotManWO_LabP1+TotManWO_LabP2+TotManWO_LabP3+
     +   TotManSO_LabP1+TotManSO_LabP2+TotManSO_LabP3)
          TotManSI_ActP_Y = TotManSI_ActP_Y + (TotManSI_ActP1+
     +                                TotManSI_ActP2+TotManSI_ActP3)
          
          TotLabP_Y = TotLabP_Y + TotLabP
          TotActP_Y = TotActP_Y + TotActP
          TotStabIP_Y = TotStabIP_Y + TotStabIP
          TotStabOP_Y = TotStabOP_Y + TotStabOP
          TotFrsOP_Y = TotFrsOP_Y + TotFrsOP
          TotFertP_Y = TotFertP_Y + Totfrt
          TotManP_Y = TotManP_Y + Totm
          daycount = daycount + 1
          
       
       IF(Day == 31 .AND. Month == 12 ) THEN
        Computed_FinalSoilP = IniP + (TotYFP + TotYMP + TotYResP) -
     +  (TotYLatP + TotYDSP + TotYROP +  TotYDrnP + TotYPltPup )
        String ="(I10,10(F22.5,2X),(E22.5,2X))"
        WRITE(118,String) Year,IniP,TotYFP,TotYMP,
     +  TotYResP,TotYLatP,TotYDSP,
     +  TotYROP,TotYDrnP, TotYPltPup,
     +  FinalSoilP,(FinalSoilP -Computed_FinalSoilP)
        
         WRITE(120,1002) Year,IniP,TotYFP,TotYMP,TotYResP, 
     +  (TotYFP + TotYMP + TotYResP) 
         
         WRITE(120,1101) TotYLatP,TotYDSP,TotYROP,TotYDrnP,TotYPltPup,
     + (TotYLatP + TotYDSP + TotYROP + TotYDrnP + TotYPltPup),
     + TotPflow_Frs_Lab_Y,TotPflow_Frs_Staorg_Y,TotPflow_Lab_Frs_Y,
     + TotPflow_Staorg_Lab_Y,TotPflow_Lab_Act_Y,TotPflow_Act_Lab_Y,
     + TotPflow_Stainorg_Act_Y,TotPflow_Act_Stainorg_Y,TotFertPLabP_Y,
     + TotManSO_WI_Y,TotManSI_WI_Y,TotManWO_WI_Y,TotManSO_WO_Y,
     + TotManWI_LabP_Y,TotManSI_ActP_Y    
         
        WRITE(120,1202) TotLabP_Y/daycount,TotActP_Y/daycount,
     +   TotStabIP_Y/daycount,TotFrsOP_Y/daycount,TotStabOP_Y/daycount, 
     +   TotFertP_Y/daycount,TotManP_Y/daycount,FinalSoilP,
     +   (FinalSoilP -Computed_FinalSoilP)
         
        IniP = FinalSoilP
        TotYFP = 0
        TotYMP = 0
        TotYResP = 0
        TotYLatP = 0
        TotYDSP = 0
        TotYROP = 0
        TotYDrnP = 0
        TotYPltPup = 0
        TotPflow_Frs_Lab_Y = 0
        TotPflow_Frs_Staorg_Y = 0
        TotPflow_Staorg_Lab_Y = 0
        TotPflow_Lab_Frs_Y = 0
        TotPflow_Lab_Act_Y = 0
        TotPflow_Act_Lab_Y = 0
        TotPflow_Act_Stainorg_Y = 0
        TotPflow_Stainorg_Act_Y = 0
        TotFertPLabP_Y = 0
        TotManSO_WI_Y = 0
        TotManSI_WI_Y = 0
        TotManWO_WI_Y = 0
        TotManSO_WO_Y = 0
        TotManWI_LabP_Y = 0
        TotManSI_ActP_Y = 0  
        TotLabP_Y = 0 
        TotActP_Y = 0
        TotStabIP_Y = 0
        TotStabOP_Y = 0
        TotFrsOP_Y = 0
        TotFertP_Y = 0
        TotManP_Y = 0 
        daycount = 0
        
      END IF
          
             
      
      OverallFP = OverallFP + FertilizerP
      OverallMP = OverallMP + ManuP
      OverallResP = OverallResP + ResP
      OverallLatP = OverallLatP + (Drplosslatflow + PPlosslatflow)
      OverallDSP = OverallDSP + (Drplossdesp+PPlossdesp)
      OverallROP = OverallROP + (Drplossrnf+PPlossrnf)
      OverallDrnP = OverallDrnP + (Drplosstdrain+PPlosstdrain)
      OverallPltPup = OverallPltPup + PlntP_Up
      OverallPflow_Frs_Lab = OverallPflow_Frs_Lab + TotPflow_Frs_Lab
      OverallPflow_Frs_Staorg = OverallPflow_Frs_Staorg + 
     +                                            TotPflow_Frs_Staorg
      OverallPflow_Staorg_Lab = OverallPflow_Staorg_Lab + 
     +                                             TotPflow_Staorg_Lab
      OverallPflow_Lab_Frs = OverallPflow_Lab_Frs + TotPflow_Lab_Frs
      OverallPflow_Lab_Act = OverallPflow_Lab_Act + TotPflow_Lab_Act
      OverallPflow_Act_Lab = OverallPflow_Act_Lab + TotPflow_Act_Lab
      OverallPflow_Act_Stainorg = OverallPflow_Act_Stainorg + 
     +                                            TotPflow_Act_Stainorg
      OverallPflow_Stainorg_Act = OverallPflow_Stainorg_Act + 
     +                                            TotPflow_Stainorg_Act
      OverallFertPLabP = OverallFertPLabP + TotFertPLabP1 +TotFertPLabP2
      OverallManSO_WI = OverallManSO_WI + TotManSO_WI
      OverallManSI_WI =  OverallManSI_WI + TotManSI_WI
      OverallManWO_WI = OverallManWO_WI + TotManWO_WI
      OverallManSO_WO = OverallManSO_WO + TotManSO_WO
      OverallManWI_LabP = OverallManWI_LabP + (TotManWI_LabP1+ 
     +     TotManWI_LabP2+ TotManWI_LabP3 +  
     +   TotManWO_LabP1+TotManWO_LabP2+TotManWO_LabP3+
     +   TotManSO_LabP1+TotManSO_LabP2+TotManSO_LabP3)
         
      OverallManSI_ActP = OverallManSI_ActP + (TotManSI_ActP1+
     +                                TotManSI_ActP2+TotManSI_ActP3) 
          OverallLabP = OverallLabP +  TotLabP
          OverallActP = OverallActP +  TotActP
          OverallStabIP = OverallStabIP + TotStabIP
          OverallStabOP = OverallStabOP +  TotStabOP
          OverallFrsOP =  OverallFrsOP +  TotFrsOP
          OverallFertP = OverallFertP + Totfrt
          OverallManP = OverallManP +  Totm
          daycount1 = daycount1 + 1
          
      
      IF(Day == Eday .AND. Month == Emon .AND. Year == Eyear) THEN
        Computed_FinalSoilP = IniP1 + (OverallFP + OverallMP + 
     +   OverallResP)-(OverallLatP + OverallDSP + OverallROP +  
     +   OverallDrnP + OverallPltPup)
        String ="(A10,10(F22.5,2X),(E22.5,2X))"
        WRITE(118,String) 'Overall',IniP1,OverallFP,OverallMP,
     +  OverallResP,OverallLatP,OverallDSP,
     +  OverallROP,OverallDrnP, OverallPltPup,
     +  FinalSoilP,(FinalSoilP - Computed_FinalSoilP)
        
         WRITE(120,1003) IniP1,OverallFP,OverallMP,OverallResP, 
     +  (OverallFP + OverallMP+ OverallResP) 
         
         WRITE(120,1101) OverallLatP,OverallDSP,OverallROP,OverallDrnP, 
     +       OverallPltPup,(OverallLatP + OverallDSP + OverallROP + 
     +    OverallDrnP + OverallPltPup),OverallPflow_Frs_Lab,
     +    OverallPflow_Frs_Staorg,OverallPflow_Lab_Frs,
     +    OverallPflow_Staorg_Lab,OverallPflow_Lab_Act, 
     +    OverallPflow_Act_Lab, OverallPflow_Stainorg_Act,
     +    OverallPflow_Act_Stainorg, OverallFertPLabP,
     +    OverallManSO_WI, OverallManSI_WI, OverallManWO_WI,
     +    OverallManSO_WO,OverallManWI_LabP,OverallManSI_ActP
         
         WRITE(120,1203) OverallLabP/daycount1, OverallActP/daycount1,
     +    OverallStabIP/daycount1,OverallFrsOP/daycount1,
     +    OverallStabOP/daycount1,OverallFertP/daycount1,
     +    OverallManP/daycount1,FinalSoilP,
     +    (FinalSoilP -Computed_FinalSoilP)    
      
      END IF
      
      
      PrevYear = Year
      FertilizerP = 0.0
      ManuP = 0.0
      ResP = 0.0
      PlntP_Up = 0.0
      
      
 1001 FORMAT(//,' ---',I3,'/',I2,'/',I4,' ---',
     +    ' DAILY PHOSPHORUS MASS BALANCE (KG/HA) ',/
     +    ' TOTAL (P) AT START OF DAY',T100,G15.6,/' ADDITIONS:',/T4,
     +     'FERTILIZER APP',
     +    T90,G15.6,/T4,'MANURE APP',T90,G15.6,/T4,
     +    'FROM INCORPORATED RESIDUE',T90,G15.6,/T4,
     +    'TOTAL ADDITIONS',T100,G15.6)
      
 1101 FORMAT(/,' LOSSES:',/T4,'LATERAL FLOW',T90,G15.6,/T4,
     +    'SEEPAGE',T90,G15.6,/T4,'RUNOFF',T90,G15.6,/T4,
     +    'TILE DRAINAGE',T90,G15.6,/T4,
     +    'PLANT UPTAKE',T90,G15.6,/T4,'TOTAL LOSSES',T100,G15.6/,
     +  /' TRANSFORMATIONS:',
     +  /T4,'FRESH ORG-P TO LABILE-P',T90,G15.6,
     +  /T4,'FRESH ORG-P TO STABLE ORG-P',T90,G15.6,
     +  /T4,'LABILE-P TO FRESH ORG-P',T90,G15.6,
     +  /T4,'STABLE ORG-P TO LABILE-P',T90,G15.6,
     +  /T4,'LABILE-P TO ACTIVE-P',T90,G15.6,
     +  /T4,'ACTIVE-P TO LABILE-P',T90,G15.6, 
     + /T4,'STABLE INORG-P TO ACTIVE-P',T90,G15.6, 
     + /T4,'ACTIVE-P TO STABLE INORG-P',T90,G15.6,
     + /T4,'FERTILIZER-P TO LABILE-P',T90,G15.6,
     + /T4,'MANURE STABLE ORG-P TO MANURE WATER EXTRACTABLE 
     + INORG-P',T90,G15.6,
     + /T4,'MANURE STABLE INORG-P TO MANURE WATER EXTRACTABLE
     + INORG-P',T90,G15.6, 
     + /T4,'MANURE WATER EXTRACTABLE ORG-P TO MANURE WATER EXTRACT
     +ABLE INORGA-P ',T90,G15.6,
     + /T4,'MANURE STABLE ORG-P TO MANURE WATER EXTRACT
     +ABLE ORG-P ',T90,G15.6,
     + /T4,'MANURE-P TO LABILE-P',T90,G15.6, 
     + /T4,'MANURE-P TO ACTIVE-P',T90,G15.6)
      
      
      
 1201 FORMAT(/' STORAGE:',/T4,'LABILE-P',T90,G15.6,
     + /T4,'ACTIVE-P',T90,G15.6,
     + /T4,'STABLE INORG-P',T90,G15.6,
     + /T4,'FRESH ORG-P',T90,G15.6, 
     + /T4,'STABLE ORG-P',T90,G15.6,
     + /T4,'FERTILIZER-P',T90,G15.6, 
     + /T4,'MANURE-P',T90,G15.6,
     + /T4,'TOTAL(P) AT END',T100,G15.6,/T100,15('-')
     +,/' MASS BALANCE AT END OF DAY:',T100,G15.6)

  
 1202 FORMAT(/' STORAGE:',/T4,'AVERAGE LABILE-P',T90,G15.6,
     + /T4,'AVERAGE ACTIVE-P',T90,G15.6,
     + /T4,'AVERAGE STABLE INORG-P',T90,G15.6,
     + /T4,'AVERAGE FRESH ORG-P',T90,G15.6, 
     + /T4,'AVERAGE STABLE ORG-P',T90,G15.6,
     + /T4,'AVERAGE FERTILIZER-P',T90,G15.6, 
     + /T4,'AVERAGE MANURE-P',T90,G15.6,
     + /T4,'TOTAL(P) AT END OF YEAR',T100,G15.6,/T100,15('-')
     +,/' MASS BALANCE AT END OF YEAR:',T100,G15.6)    
      
1002  FORMAT(//,' ---',I4,' ---',
     +    ' YEARLY PHOSPHORUS MASS BALANCE SUMMARY (KG/HA) ',/
     +    ' TOTAL (P) AT START OF YEAR',T100,G15.6,/' ADDITIONS:',/T4,
     +     'FERTILIZER APP',
     +    T90,G15.6,/T4,'MANURE APP',T90,G15.6,/T4,
     +    'FROM INCORPORATED RESIDUE',T90,G15.6,/T4,
     +    'TOTAL ADDITIONS',T100,G15.6)
  
1003  FORMAT(////,
     +    ' OVERALL PHOSPHORUS MASS BALANCE SUMMARY (KG/HA) ',/
     + ' TOTAL (P) AT START OF SIMULATION',T100,G15.6,/' ADDITIONS:',/T4,
     +     'FERTILIZER APP',
     +    T90,G15.6,/T4,'MANURE APP',T90,G15.6,/T4,
     +    'FROM INCORPORATED RESIDUE',T90,G15.6,/T4,
     +    'TOTAL ADDITIONS',T100,G15.6)
     

1203  FORMAT(/' STORAGE:',/T4,'AVERAGE LABILE-P',T90,G15.6,
     + /T4,'AVERAGE ACTIVE-P',T90,G15.6,
     + /T4,'AVERAGE STABLE INORG-P',T90,G15.6,
     + /T4,'AVERAGE FRESH ORG-P',T90,G15.6, 
     + /T4,'AVERAGE STABLE ORG-P',T90,G15.6,
     + /T4,'AVERAGE FERTILIZER-P',T90,G15.6, 
     + /T4,'AVERAGE MANURE-P',T90,G15.6,
     + /T4,'TOTAL(P) AT END OF SIMIULATION',T100,G15.6,/T100,15('-')
     +,/' MASS BALANCE AT END OF SIMULATION:',T100,G15.6)    
      
      
      END SUBROUTINE PBALANCE