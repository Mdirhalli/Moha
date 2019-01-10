                       /* Tracking Notes Report for QA
                        The purpose of this report is to track notes (IG, BIRPS, MD, General) accross all
                        programs to see if the notes being final-saved or not, and who final - saved them.*/
declare @NoteDate Date
SET @NoteDate = :NoteDate

SELECT
        mn.CLIENTKEY2
        , mn.OP__DOCID
        , mn.DATE_NOTE as ServiceDate
        , CASE WHEN Present = 1 THEN 'Yes'
               WHEN Present = 2 THEN 'No'
               WHEN Present = 3 THEN 'Excused'
               ELSE ' '
          END AS Present

        , mn.DOC_NAME  AS NoteType
        , gr.GroupName
        , gc.CycleName
        , pro.PgmName
        , bil.Descr AS ServiceType
        , mn.LOS2 AS LOS
        , mn.TimeStart
        , mn.TimeStop
        , st.FULLNAME AS Clinician
        , t4w.OP__LASTSAVEDBY
        , CASE WHEN t4w.OP__STATUSORD = 2 THEN 'Saved'
               ELSE 'Final Saved'
          END AS SaveStatus
		-- IS the note voided?
        , CASE WHEN mn.Voided = 'T' THEN 'Yes'
               ELSE ' '
          END AS Voided
		
        , cost.FULLNAME AS Cosigner
        , t4w.OP__LASTSAVEDDATETIME
		, Pay.PayorName
		, pp.PlanName

FROM FD__MASTERNOTE AS mn
LEFT JOIN AMS_IGProgressAttendNote AS ig ON ig.OP__DOCID = mn.OP__DOCID
LEFT JOIN FD__STAFF AS st ON st.StaffKey = mn.StaffKey2
LEFT JOIN BLU_Programs AS pro ON pro.PgmKey = mn.PGMKEY2
LEFT JOIN FD__GRPFACESHEET AS gr ON ig.GroupKey = gr.GroupKey
LEFT JOIN FD__GRPCYCLES AS gc ON gc.CycleKey = ig.CycleKey
LEFT JOIN(SELECT * FROM FD__COSIGNATURE
                   WHERE OP__DOCID IN (
                        SELECT MAX (OP__DOCID)FROM FD__COSIGNATURE
                        GROUP BY ClientKey )) AS co ON co.ClientKey = mn.ClientKey2

LEFT JOIN FD__Staff cost on cost.StaffKey = co.SignedByStaffKey

/* To get co-signature name and time the note co-signed */
LEFT JOIN(SELECT * FROM T4W_DOCUMENTS
                   WHERE OP__ID IN (
                SELECT MAX (OP__ID)FROM T4W_DOCUMENTS
                GROUP BY OP__ID )) AS t4w ON t4w.OP__ID = mn.OP__DOCID

 /* To add Procedure/Service - drawn from BIRP or IG Progress Note */
LEFT JOIN BIL_Procedures bil ON mn.ProcKey2 = bil.OP__DOCID

/* to add Payor and Plan Name */ -- 20190401
LEFT JOIN BIL_ChargeSlips AS ch ON ch.ChargeKey = mn.CHARGEKEY2
LEFT JOIN BIL_InsPolicies AS ins ON ch.InsPolicyKey = ins.InsPolicyKey
LEFT JOIN BIL_Payors AS Pay ON Pay.PayorKey = ins.PayorKey
LEFT JOIN BIL_PayorPlans pp ON ins.PayorPlanKey = pp.PayorPlanKey

/* Excluding test clients  */
WHERE mn.ClientKey2 NOT IN ( 120744
			   , 535333
			   , 420890
		           , 535327
			   , 612596
			   , 112261
			   , 459761
			   , 534483
			   , 1050123)

/* Excluding Hunt, YouThrive, and Our Space */
AND mn.PGMKEY2  NOT IN( 9        -- Hunt School
		      , 10       -- YouThrive - Sonoma
		      , 11       -- YouThrive - Marin
		      , 20       -- YouThrive - Contra Costa
		      , 21       -- Our Space - YAC
		      , 22       -- Our Space - Community Center
			  )

/* Notes will show as at the date coming from the TIER form */
AND mn.DATE_NOTE >= @NoteDate

--AND mn.DATE_NOTE >= DATEADD(YEAR, -1, GETDATE()) 
