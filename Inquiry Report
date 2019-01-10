
SELECT 
	 inq.Clientkey
	,inq.Fullname
	,Pay.PayorName
	,CAST(inq.DOB As DATE) AS DOB
	,sex.InSystDescript as Sex
	,pro.PgmName
	,pro.CountyCare AS County
	,pro2.PgmName AS AdmitPgm --20190109
	,preadmi.ReferralNameF   -- First name of Referral 
	,preadmi.ReferralNameL   -- Last name of Referral  
	,ref.DESCRIP -- Organization referral source/Person
	,preadmi.Referral_Phone				
	,CAST(preadmi.InquiryDate AS DATE)  AS InquiryDate -- Inquiry date
	,CAST(preadmi.ADMITDATE AS DATE) AS ADMITDATE				
	,CAST(preadmi.SCREENING_DATE AS DATE) AS SCREENING_DATE				
	,CAST(preadmi.ReferCompleteDate AS DATE) AS ReferCompleteDate				
	,CAST(preadmi.DispositionDecisionDate AS DATE) AS DispositionDecisionDate			
	,CAST(preadmi.FirstOfferedDate AS DATE) AS FirstOfferedDate -- First Offered Date
	,DATEDIFF(dd,preadmi.InquiryDate, preadmi.DispositionDecisionDate) AS 'Days'
	,adtype.Descr AS AdmitStatus	-- Did the client admit or not?
	,notadm.Descrip AS Reason_NotAdmit
	,preadmi.OP__DOCID
	
FROM  FD__INQUIRY AS inq

LEFT JOIN FD__PREADMISSION AS preadmi ON preadmi.InquiryKey = inq.InquiryKey
LEFT JOIN BLU_Programs AS pro ON preadmi.ScreenContact_Code = pro.PgmKey
LEFT JOIN BLU_SEX AS sex ON inq.Gender = sex.Code
LEFT JOIN LT__REFERRAL_TYPE AS ref ON ref.CODE = preadmi.ReferralSrcCode
LEFT JOIN LT__AdmitTypes AS adtype ON preadmi.AdmitCode = adtype.Code
LEFT JOIN LT__NotAdmit AS notadm ON preadmi.NotAdmitCode = notadm.Code
LEFT JOIN 
		 (SELECT * FROM BIL_InsPolicies
		  WHERE OP__DOCID in (
		  SELECT max (OP__DOCID) FROM BIL_InsPolicies GROUP BY PreAdmissionkey )) AS ins
		  ON  ins.ClientKey = inq.ClientKey 
		  and ins.PreAdmissionkey = preadmi.PreadmissionKey
		  AND ins.PayorKey != 147
LEFT JOIN BIL_Payors AS Pay ON Pay.PayorKey = ins.PayorKey
-- Adding a new column called Program Admit 20190109
OUTER APPLY
		( SELECT TOP 1 PgmKey FROM FD__PROGRAM_CLIENT
		  WHERE ClientKey = inq.ClientKey 
		  AND Date_Admit_Program = preadmi.ADMITDATE
		  ORDER BY ProgramAdmit_ID DESC) pc

LEFT JOIN BLU_Programs AS pro2 ON pc.PgmKey = pro2.PgmKey

WHERE inq.FULLNAME NOT LIKE 'test%' 
ORDER BY preadmi.SCREENING_DATE DESC



