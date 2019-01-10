					/* Clinical Paperwork Due Dates Grid Project */
    -- Elements:
SELECT 
	  pc.ClientKey											     -- Client's ID
	, cli.Fullname											     -- Client's Name   
	, pro.PgmName						             		     -- Program Name
	, pc.Date_Admit_Program									     -- Episode Opening Date
	, pc.Date_Admit_Program AS Intake_PaperworkDue				 -- Intake Paperwork Due (Same date of the Episode Opening Date)
	, Days10_paperwork											 -- 10 days Paperwork Due (Same date of the Episode Opening Date)																-- (Only for Restart Residential, Beacon Community Counseling)
	, Days30_PaperDue
	, DATEADD(Year, 18, cli.DOB) AS DateTurn18					    											
      /* The County Report is due at Intake, 6mo, Annual and Discharge. */
	, DATEADD(Month, 6, Date_Admit_Program) AS Months6_Paperwork
	, ISNULL(Annual_Paperwork, Alameda_Annual_PaperDue) AS AnnualPaperWork

	, (CASE WHEN DATEADD(YEAR, 1, Date_Admit_Program) >= GETDATE() AND Date_Discharged_Program IS NULL THEN DATEADD(YEAR, 1, Date_Admit_Program) 
					  WHEN DATEADD(YEAR, 1, Date_Admit_Program) < GETDATE() AND GETDATE() < DATEADD(YEAR, 2, Date_Admit_Program)
						   AND Date_Discharged_Program IS NULL THEN DATEADD(YEAR, 2, Date_Admit_Program)
					  WHEN DATEADD(YEAR, 2, Date_Admit_Program) < GETDATE() AND GETDATE() < DATEADD(YEAR, 3, Date_Admit_Program)
						   AND Date_Discharged_Program IS NULL THEN DATEADD(YEAR, 3, Date_Admit_Program)
					  WHEN DATEADD(YEAR, 3, Date_Admit_Program) < GETDATE() AND GETDATE() < DATEADD(YEAR, 4, Date_Admit_Program)
						   AND Date_Discharged_Program IS NULL THEN DATEADD(YEAR, 4, Date_Admit_Program)
					  WHEN DATEADD(YEAR, 4, Date_Admit_Program) < GETDATE() AND GETDATE() < DATEADD(YEAR, 5, Date_Admit_Program)
						   AND Date_Discharged_Program IS NULL THEN DATEADD(YEAR, 5, Date_Admit_Program)

					  WHEN DATEADD(YEAR, 1, Date_Admit_Program) >= GETDATE() AND Date_Discharged_Program IS NOT NULL THEN DATEADD(YEAR, 1, Date_Admit_Program)
					  WHEN DATEADD(YEAR, 1, Date_Admit_Program) < GETDATE() AND GETDATE() < DATEADD(YEAR, 2, Date_Admit_Program)
						   AND Date_Discharged_Program IS NOT NULL THEN DATEADD(YEAR, 2, Date_Admit_Program)
					  WHEN DATEADD(YEAR, 2, Date_Admit_Program) < GETDATE() AND GETDATE() < DATEADD(YEAR, 3, Date_Admit_Program)
						   AND Date_Discharged_Program IS NOT NULL THEN DATEADD(YEAR, 3, Date_Admit_Program)
					  WHEN DATEADD(YEAR, 3, Date_Admit_Program) < GETDATE() AND GETDATE() < DATEADD(YEAR, 4, Date_Admit_Program)
						   AND Date_Discharged_Program IS NOT NULL THEN DATEADD(YEAR, 4, Date_Admit_Program)
					  WHEN DATEADD(YEAR, 4, Date_Admit_Program) < GETDATE() AND GETDATE() < DATEADD(YEAR, 5, Date_Admit_Program)
						   AND Date_Discharged_Program IS NOT NULL THEN DATEADD(YEAR, 5, Date_Admit_Program)

				 END) AS AnnualAnniversaryDate
	   	   	/* Discharge Paperwork Due */
	, pc.Date_Discharged_Program														-- Date of Discharge
	, DATEADD(DAY, 7, pc.Date_Discharged_Program) AS DisPaperworkDueDate			    -- Discharge Paperwork Due
	, staf.FullName	AS Clinician														-- Staff Name who either responsible for paper work or not 

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
		 (SELECT OP__DOCID,
			(CASE WHEN Annual_Paperwork >= GETDATE() AND Date_Discharged_Program IS NULL THEN Annual_Paperwork
					  WHEN Annual_Paperwork < GETDATE() AND GETDATE() < DATEADD(YEAR, 1, Annual_Paperwork)
						   AND Date_Discharged_Program IS NULL THEN DATEADD(YEAR, 1, Annual_Paperwork)
					  WHEN DATEADD(YEAR, 1, Annual_Paperwork) < GETDATE() AND GETDATE() < DATEADD(YEAR, 2, Annual_Paperwork)
						   AND Date_Discharged_Program IS NULL THEN DATEADD(YEAR, 2, Annual_Paperwork)
					  WHEN DATEADD(YEAR, 2, Annual_Paperwork) < GETDATE() AND GETDATE() < DATEADD(YEAR, 3, Annual_Paperwork)
						   AND Date_Discharged_Program IS NULL THEN DATEADD(YEAR, 3, Annual_Paperwork)
					  WHEN DATEADD(YEAR, 3, Annual_Paperwork) < GETDATE() AND GETDATE() < DATEADD(YEAR, 4, Annual_Paperwork)
						   AND Date_Discharged_Program IS NULL THEN DATEADD(YEAR, 4, Annual_Paperwork)

					  WHEN Annual_Paperwork >= GETDATE() AND Date_Discharged_Program IS NOT NULL THEN Annual_Paperwork
					  WHEN Annual_Paperwork < GETDATE() AND GETDATE() < DATEADD(YEAR, 1, Annual_Paperwork)
						   AND Date_Discharged_Program IS NOT NULL THEN DATEADD(YEAR, 1, Annual_Paperwork)
					  WHEN DATEADD(YEAR, 1, Annual_Paperwork) < GETDATE() AND GETDATE() < DATEADD(YEAR, 2, Annual_Paperwork)
						   AND Date_Discharged_Program IS NOT NULL THEN DATEADD(YEAR, 2, Annual_Paperwork)
					  WHEN DATEADD(YEAR, 2, Annual_Paperwork) < GETDATE() AND GETDATE() < DATEADD(YEAR, 3, Annual_Paperwork)
						   AND Date_Discharged_Program IS NOT NULL THEN DATEADD(YEAR, 3, Annual_Paperwork)
					  WHEN DATEADD(YEAR,3, Annual_Paperwork) < GETDATE() AND GETDATE() < DATEADD(YEAR, 4, Annual_Paperwork)
						   AND Date_Discharged_Program IS NOT NULL THEN DATEADD(YEAR, 4, Annual_Paperwork)
				 END) AS Annual_Paperwork
		  FROM(SELECT *,
						DATEADD(YEAR, 1, DATEADD(DAY, DATEDIFF(DAY, 0, Date_Admit_Program), -15)) AS Annual_Paperwork
			FROM FD__PROGRAM_CLIENT) AS pc5 
			LEFT JOIN BLU_Programs AS pro5 ON pro5.PgmKey = pc5.PgmKey 
			/* To exclude Alameda MH programs */
			WHERE pro5.PgmKey NOT IN (  5   -- MH - Alameda
								      , 16  -- Katie A. - Alameda
		    					      , 30  -- OBH - Alameda 
								       )) AS AP ON AP.OP__DOCID = pc.OP__DOCID

/* Annual Paperwork (Only Alameda MH): All Intake & 30day paperwork to be redone - Due the 15th of the month PRIOR 
 to Episode Opening Anniversary Month (if episode opened in Feb, annual due date is Jan 15th) */
LEFT JOIN 
 (SELECT OP__DOCID,
			(CASE WHEN Alameda_Annual_PaperDue >= GETDATE() AND Date_Discharged_Program IS NULL THEN Alameda_Annual_PaperDue
					  WHEN Alameda_Annual_PaperDue < GETDATE() AND GETDATE() < DATEADD(YEAR, 1, Alameda_Annual_PaperDue)
						   AND Date_Discharged_Program IS NULL THEN DATEADD(YEAR, 1, Alameda_Annual_PaperDue)
					  WHEN DATEADD(YEAR, 1, Alameda_Annual_PaperDue) < GETDATE() AND GETDATE() < DATEADD(YEAR, 2, Alameda_Annual_PaperDue)
						   AND Date_Discharged_Program IS NULL THEN DATEADD(YEAR, 2, Alameda_Annual_PaperDue)
					  WHEN DATEADD(YEAR, 2, Alameda_Annual_PaperDue) < GETDATE() AND GETDATE() < DATEADD(YEAR, 3, Alameda_Annual_PaperDue)
						   AND Date_Discharged_Program IS NULL THEN DATEADD(YEAR, 3, Alameda_Annual_PaperDue)
					  WHEN DATEADD(YEAR, 3, Alameda_Annual_PaperDue) < GETDATE() AND GETDATE() < DATEADD(YEAR, 4, Alameda_Annual_PaperDue)
						   AND Date_Discharged_Program IS NULL THEN DATEADD(YEAR, 4, Alameda_Annual_PaperDue)

					  WHEN Alameda_Annual_PaperDue >= GETDATE() AND Date_Discharged_Program IS NOT NULL THEN Alameda_Annual_PaperDue
					  WHEN Alameda_Annual_PaperDue < GETDATE() AND GETDATE() < DATEADD(YEAR, 1, Alameda_Annual_PaperDue)
						   AND Date_Discharged_Program IS NOT NULL THEN DATEADD(YEAR, 1, Alameda_Annual_PaperDue)
					  WHEN DATEADD(YEAR, 1, Alameda_Annual_PaperDue) < GETDATE() AND GETDATE() < DATEADD(YEAR, 2, Alameda_Annual_PaperDue)
						   AND Date_Discharged_Program IS NOT NULL THEN DATEADD(YEAR, 2, Alameda_Annual_PaperDue)
					  WHEN DATEADD(YEAR, 2, Alameda_Annual_PaperDue) < GETDATE() AND GETDATE() < DATEADD(YEAR, 3, Alameda_Annual_PaperDue)
						   AND Date_Discharged_Program IS NOT NULL THEN DATEADD(YEAR, 3, Alameda_Annual_PaperDue)
					  WHEN DATEADD(YEAR,3, Alameda_Annual_PaperDue) < GETDATE() AND GETDATE() < DATEADD(YEAR, 4, Alameda_Annual_PaperDue)
						   AND Date_Discharged_Program IS NOT NULL THEN DATEADD(YEAR, 4, Alameda_Annual_PaperDue)
				 END) AS Alameda_Annual_PaperDue
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
OUTER APPLY
 ( SELECT TOP 1 staffkey FROM FD__STAFF_ASSIGNED 
		  WHERE ClientKey = cli.ClientKey 
		  AND programAdmitKey = pc.PgmAdmissionKey
		  AND RespPaperwork = 'Yes'
		  ORDER BY DateStart DESC
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
AND	 cli.FULLNAME NOT LIKE 'test%' 

ORDER BY Fullname ASC
