					/* Clinical Paperwork Due Dates Grid Project */
    -- Elements:
SELECT 
	  pc.ClientKey											    
	, cli.Fullname											        
	, pro.PgmName						             		     
	, pc.Date_Admit_Program									     
	, pc.Date_Admit_Program AS Intake_PaperworkDue				 
	, Days10_paperwork											 																
	, Days30_PaperDue
	, DATEADD(Year, 18, cli.DOB) AS DateTurn18					    											
      /* The County Report is due at Intake, 6mo, Annual and Discharge. */
	, DATEADD(Month, 6, Date_Admit_Program) AS Months6_Paperwork
	, ISNULL(Annual_Paperwork, Alameda_Annual_PaperDue) AS FirstAnnualPaperWork
	, DATEADD(YEAR, 1, Date_Admit_Program) AS FirstAnnualAnniversaryDate
      /* Discharge Paperwork Due */
	, pc.Date_Discharged_Program														
	, DATEADD(DAY, 7, pc.Date_Discharged_Program) AS DisPaperworkDueDate			    
	, staf.FullName	AS ResponsibleClinician														 

FROM FD__PROGRAM_CLIENT AS pc  
LEFT JOIN FD__CLIENTS AS cli ON pc.Clientkey = cli.ClientKey 
/* 10 Day Paperwork (Only for Restart Residential, Beacon Community Counseling) */
LEFT JOIN 
		 (SELECT Days10_paperwork, OP__DOCID FROM
		                                    (SELECT *, DATEADD(DAY, 10, Date_Admit_Program) AS Days10_paperwork 
		  FROM FD__PROGRAM_CLIENT) AS pc1 
		  LEFT JOIN BLU_Programs AS pro1 ON pro1.PgmKey = pc1.PgmKey 
		  /*  Beacon Community Counseling & Restart Residential programs */
		  WHERE pro1.PgmKey IN (  24   -- OBH - Sonoma
							    , 28   -- Restart Residential
		    				    , 30   -- OBH - Alameda 
							    , 31   -- OBH - Marin
							    )) AS days10 ON days10.OP__DOCID = pc.OP__DOCID 
													 
/*  30 Day Paperwork (All MH programs except Restart Resi & Beacon) */
LEFT JOIN 
		 (SELECT Days30_PaperDue, OP__DOCID FROM
							            (SELECT *, DATEADD(DAY, 25, Date_Admit_Program) AS Days30_PaperDue 	
		  FROM FD__PROGRAM_CLIENT) AS pc2 
		  LEFT JOIN BLU_Programs AS pro2 ON pro2.PgmKey = pc2.PgmKey 
		  /* (All MH programs except Restart Resi & Beacon) */
		  WHERE pro2.PgmKey NOT IN(  24   -- OBH - Sonoma
							       , 28   -- Restart Residential
		    				       , 30   -- OBH - Alameda 
							       , 31   -- OBH - Marin
								    )) AS day30 ON day30.OP__DOCID = pc.OP__DOCID
				
/* Annual_Paperwork (All MH programs except Alameda MH) */
LEFT JOIN 
		 (SELECT OP__DOCID, Annual_Paperwork
		  FROM(SELECT *,
						DATEADD(YEAR, 1, DATEADD(DAY, DATEDIFF(DAY, 0, Date_Admit_Program), -15)) AS Annual_Paperwork
			FROM FD__PROGRAM_CLIENT) AS pc5 
			LEFT JOIN BLU_Programs AS pro5 ON pro5.PgmKey = pc5.PgmKey 
			/* To exclude Alameda MH programs */
			WHERE pro5.PgmKey NOT IN (  5   -- MH - Alameda
								      , 16  -- Katie A. - Alameda
		    					      , 30  -- OBH - Alameda 
								       )) AS AP ON AP.OP__DOCID = pc.OP__DOCID

--Annual Paperwork (Only Alameda MH): 
LEFT JOIN 
 (SELECT OP__DOCID, Alameda_Annual_PaperDue
	FROM(SELECT *, DATEADD(YEAR, 1, DATEADD(MONTH, DATEDIFF(MONTH, 0, Date_Admit_Program) -1, 14)
																) AS Alameda_Annual_PaperDue	
			FROM FD__PROGRAM_CLIENT) AS pc4 
			LEFT JOIN BLU_Programs AS pro4 ON pro4.PgmKey = pc4.PgmKey 
			/* Annual Paperwork (Only Alameda MH) */
			WHERE pro4.PgmKey IN (  5   -- MH - Alameda
								  , 16  -- Katie A. - Alameda
		    					  , 30  -- OBH - Alameda 
								   )) AS AAPD ON AAPD.OP__DOCID = pc.OP__DOCID		

LEFT JOIN BLU_Programs AS pro ON pc.PgmKey = pro.PgmKey

-- Assigned Staff		  
outer apply
 ( select top 1 staffkey FROM FD__STAFF_ASSIGNED 
		  where ClientKey = cli.ClientKey 
		  and programAdmitKey = pc.PgmAdmissionKey
		  and RespPaperwork = 'Yes'
		  order by DateStart desc
		  ) SA
LEFT JOIN FD__STAFF AS staf ON staf.StaffKey = sa.StaffKey
	/*	 Excluding Programs	 */ 
WHERE pro.PgmKey NOT IN (  2   --'ERMHS - Marin'
						 , 6   --'Refocus - Alameda'
						 , 7   --'Housing - Alameda'
						 , 8   --'Housing - Sonoma'
						 , 9   --'Hunt School'
						 , 10  --'YouThrive - Sonoma'
						 , 11  --'YouThrive - Marin'
                         , 18  --'Housing - Marin'
						 , 19  --'DIS - Marin'
						 , 20  --'YouThrive - Contra Costa'
						 , 21  --'Our Space - YAC'
						 , 22  --'Our Space - Community Center'
						 , 23  --'TAY Drop-In - Marin'
	                      )
						  	                      
	/*	 Excluding test clients */ 
AND	 pc.ClientKey NOT IN ( 	120744
						  , 535333
						  , 420890
					      , 535327
						  , 612596
						  , 112261
						  , 459761
						  , 534483
					   	  , 1050123)



 ORDER BY Fullname ASC
