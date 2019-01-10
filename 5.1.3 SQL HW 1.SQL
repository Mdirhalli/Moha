#=================================================================================#
#				Mohammed Aldirhalli				  #
# 	HS-611: SEMANTIC ORGANIZATION OF HEALTH INFORMATION AND DATA STANDARDS 	  #
#				 G1 (SPRING 2018)				  #
#				  5.1.3 SQL HW 1				  #
#=================================================================================#
/*
1. Using the tablecmspop, write a query that finds the following:
a. All rows where the claim is in California and the patient is a caucasian female.
*/
mdirhalli=# SELECT *
mdirhalli-# FROM cmspop
mdirhalli-# WHERE state = 'CA'
mdirhalli-# AND race = 'white'
mdirhalli-# AND sex = 'female';

SELECT * FROM cmspop WHERE state ='CA' AND race = 'white' AND sex = 'female';

        id        |    dob     |    dod     |  sex   | race  | state | county | alz_rel_sen | heart_fail | cancer | depression
------------------+------------+------------+--------+-------+-------+--------+-------------+------------+--------+------------
 00131C35661B2926 | 1959-11-01 |            | female | white | CA    |     90 | f           | t          | t      | t
 001A8AC6DB47D3DB | 1937-08-01 |            | female | white | CA    |    640 | f           | f          | f      | f
 001E248F6DB5B893 | 1967-02-01 |            | female | white | CA    |    210 | f           | f          | f      | f
 00205821D74AA7D8 | 1964-05-01 |            | female | white | CA    |    660 | t           | t          | t      | f
 00247AD32AE68EFE | 1940-05-01 |            | female | white | CA    |    510 | f           | f          | f      | f
 0024BC7896C93558 | 1963-01-01 |            | female | white | CA    |    580 | f           | t          | f      | t
 002E7454A9DCAD4A | 1934-09-01 |            | female | white | CA    |    120 | f           | f          | f      | f
 004416F07C7507CE | 1935-12-01 |            | female | white | CA    |    400 | f           | f          | f      | f
 00683B894CEB137A | 1926-01-01 |            | female | white | CA    |    110 | f           | f          | f      | f
 007B813B2C5D0EA5 | 1940-11-01 |            | female | white | CA    |     90 | f           | f          | f      | f
 007DBB0092F1F224 | 1932-09-01 |            | female | white | CA    |    490 | f           | f          | f      | f
 00902C03311C1FFF | 1935-04-01 |            | female | white | CA    |     90 | f           | f          | f      | f
 00ABEDB54BA2DEAC | 1933-11-01 |            | female | white | CA    |     80 | f           | f          | f      | f
 00ACC32B4E5CFB06 | 1923-01-01 |            | female | white | CA    |    460 | f           | f          | f      | f
 00B728D66F273A9E | 1926-02-01 |            | female | white | CA    |    400 | f           | f          | f      | f
 00B9641D2487473C | 1913-12-01 |            | female | white | CA    |    200 | t           | f          | t      | t
 00D89F610681242D | 1925-08-01 |            | female | white | CA    |    470 | f           | f          | f      | f
 00DA910E42BA3E35 | 1931-01-01 |            | female | white | CA    |    200 | f           | t          | f      | f
 00E4A3CEB0BC6FE6 | 1936-12-01 |            | female | white | CA    |    200 | f           | f          | f      | f

/*
b. The number of claims in Washington where the patient is male.
*/
mdirhalli=# SELECT COUNT(*)
mdirhalli-# FROM cmspop
mdirhalli-# WHERE state = 'WA'
mdirhalli-# AND sex = 'male';

SELECT COUNT(*) FROM cmspop WHERE state = 'WA' AND sex = 'male';

 count
-------
 19909


/*
 c. The claims whereidcontains either “000” or “34”.
*/
mdirhalli=# SELECT *
mdirhalli-# FROM cmspop
mdirhalli-# WHERE id LIKE '%000%'
mdirhalli-# OR id LIKE '%34%';

SELECT * FROM cmspop WHERE id LIKE '%000%' OR id LIKE '%34%';

        id        |    dob     |    dod     |  sex   |   race   | state | county | alz_rel_sen | heart_fail | cancer | depression
------------------+------------+------------+--------+----------+-------+--------+-------------+------------+--------+------------
 00013D2EFD8E45D1 | 1923-05-01 |            | male   | white    | MO    |    950 | f           | t          | f      | f
 00016F745862898F | 1943-01-01 |            | male   | white    | PA    |    230 | t           | t          | f      | f
 0001FDD721E223DC | 1936-09-01 |            | female | white    | PA    |    280 | f           | f          | f      | f
 00021CA6FF03E670 | 1941-06-01 |            | male   | hispanic | CO    |    290 | f           | f          | f      | f
 00024B3D2352D2D0 | 1936-08-01 |            | male   | white    | WI    |    590 | f           | f          | f      | f
 0002DAE1C81CC70D | 1943-10-01 |            | male   | black    | NY    |    400 | f           | f          | f      | f
 0002F28CE057345B | 1922-07-01 |            | male   | white    | PA    |    270 | f           | t          | f      | f
 000308435E3E5B76 | 1935-09-01 |            | male   | white    | MN    |    680 | f           | f          | f      | f
 000345A39D4157C9 | 1976-09-01 |            | female | white    | MI    |    810 | f           | f          | f      | f
 00036A21B65B0206 | 1938-10-01 |            | female | black    | AL    |    570 | f           | f          | f      | f
 000489E7EAAD463F | 1934-02-01 |            | female | white    | IN    |    140 | f           | t          | f      | f
 00048EF1F4791C68 | 1929-06-01 |            | male   | white    | TN    |    230 | f           | f          | f      | f
 0004F0ABD505251D | 1936-07-01 |            | female | white    | RI    |     30 | t           | t          | f      | t
 00052705243EA128 | 1934-05-01 |            | male   | white    | IL    |    982 | f           | f          | t      | f
 00070B63745BE497 | 1936-03-01 |            | female | white    | ID    |    270 | t           | t          | t      | f
 0007E57CC13CE880 | 1934-01-01 | 2010-12-01 | male   | white    | CO    |    140 | f           | f          | f      | f
 0007F12A492FD25D | 1919-09-01 |            | female | black    | NC    |    400 | f           | t          | f      | t
 000A005BA0BED3EA | 1919-10-01 |            | female | black    | WA    |    160 | f           | f          | f      | f
 000B4662348C35B4 | 1942-07-01 |            | female | white    | UT    |    170 | f           | f          | f      | f
 000B97BA2314E971 | 1938-04-01 |            | male   | white    | MA    |     20 | f           | f          | f      | f
 000C7486B11E7030 | 1932-08-01 |            | male   | black    | MS    |    350 | t           | f          | f      | f
 000D6D88463D8A76 | 1942-08-01 |            | male   | hispanic | NM    |      0 | f           | f          | f      | f
 000DDD364C46E2C6 | 1932-07-01 |            | male   | white    | IL    |    580 | f           | f          | f      | t

/*
d.The first-born person in Florida that is deceased (you can ignore the fact that more than oneperson might be born on the same day).
*/
mdirhalli=# SELECT *
mdirhalli-# FROM cmspop
mdirhalli-# WHERE state = 'FL'
mdirhalli-# ORDER BY dob
mdirhalli-# ASC;

SELECT * FROM cmspop WHERE state = 'FL' ORDER BY dob ASC;


        id        |    dob     |    dod     |  sex   |   race   | state | county | alz_rel_sen | heart_fail | cancer | depression
------------------+------------+------------+--------+----------+-------+--------+-------------+------------+--------+------------
 FB1D718B4475F802 | 1909-01-01 |            | male   | white    | FL    |    120 | f           | t          | f      | f



/*
2. Using the tablecmsclaims, write a query that does the following:
a. Calculates the ratio of carrier reimbursement to beneficiary responsibility in descending order.
*/

mdirhalli=# SELECT CASE WHEN carrier_reimb = 0 THEN 0
mdirhalli-# ELSE (bene_resp :: FLOAT/ carrier_reimb)
mdirhalli-# END AS ratio FROM cmsclaims
mdirhalli-# ORDER BY ratio DESC;


SELECT CASE WHEN carrier_reimb = 0 THEN 0
            ELSE (bene_resp :: FLOAT/ carrier_reimb)
       END AS ratio 
FROM cmsclaims
ORDER BY ratio DESC;
       
        ratio
---------------------
                  23
                  22
                  19
                  19
                  19
                  18
                  18
                  18
                  18
                  18
                  18
                  18



########## OR ###########

mdirhalli=# SELECT CASE WHEN bene_resp = 0 THEN 0
mdirhalli-# ELSE (carrier_reimb::FLOAT / bene_resp)
mdirhalli-# END AS ratio
mdirhalli-# FROM cmsclaims
mdirhalli-# ORDER BY ratio
mdirhalli-# DESC;

SELECT CASE WHEN bene_resp = 0 THEN 0
	    ELSE (carrier_reimb::FLOAT / bene_resp)
       END AS ratio
FROM cmsclaims
ORDER BY ratio DESC;


       ratio
--------------------
                155
                127
                116
                115
              109.5
                109
                 95

/*
b. Finds the amount of greatest beneficiary responsibility.
*/

mdirhalli=# SELECT MAX(bene_resp) AS max_bene_resp
mdirhalli-# FROM cmsclaims;

SELECT MAX(bene_resp) AS max_bene_resp 
FROM cmsclaims;


 max_bene_resp
---------------
          3590

	#####OR###### 


mdirhalli=# SELECT bene_resp AS max_bene_resp
mdirhalli-# FROM cmsclaims
mdirhalli-# ORDER BY bene_resp DESC
mdirhalli-# LIMIT 1;

SELECT bene_resp AS max_bene_resp
FROM cmsclaims
ORDER BY bene_resp DESC LIMIT 1;


 max_bene_resp
---------------
          3590

/*
c.Finds the five records with the largest ratio of beneficiary responsibility to carrier reimbursement
(note: this ratio is different than in sub-problema) where the number of HMO months is 4. Return columns with the id,hmo_mo, and the ratio.
*/

mdirhalli=# SELECT id, hmo_mo,
mdirhalli-# CASE WHEN carrier_reimb = 0 THEN 0
mdirhalli-# ELSE ( bene_resp::FLOAT/carrier_reimb)
mdirhalli-# END AS ratio
mdirhalli-# FROM cmsclaims WHERE hmo_mo = 4
mdirhalli-# ORDER BY ratio DESC LIMIT 5;

SELECT id, hmo_mo, CASE WHEN carrier_reimb = 0 THEN 0
		        ELSE ( bene_resp::FLOAT/carrier_reimb)
		   END AS ratio
FROM cmsclaims WHERE hmo_mo = 4
ORDER BY ratio DESC LIMIT 5;

		   
        id        | hmo_mo | ratio
------------------+--------+-------
 1FD6A4F354C9F70C |      4 |    11
 0857404ECFB3F162 |      4 |     6
 6735A9DE2BB3AB96 |      4 |     6
 F6CA27664F2B6285 |      4 |     4
 F16DA626034E77A4 |      4 |   3.5
(5 rows)


########## OR ########## 

mdirhalli=# SELECT id, hmo_mo,
mdirhalli-# CASE WHEN bene_resp = 0 THEN 0
mdirhalli-# ELSE (carrier_reimb::FLOAT/bene_resp)
mdirhalli-# END AS ratio
mdirhalli-# FROM cmsclaims WHERE hmo_mo = 4
mdirhalli-# ORDER BY ratio DESC LIMIT 5;

SELECT id, hmo_mo, CASE WHEN bene_resp = 0 THEN 0
		        ELSE (carrier_reimb::FLOAT/bene_resp)
		   END AS ratio
FROM cmsclaims WHERE hmo_mo = 4
ORDER BY ratio DESC LIMIT 5;


        id        | hmo_mo | ratio
------------------+--------+-------
 1CA6DFFA94E6B2C6 |      4 |    52
 EC0BA7E6D2FF863B |      4 |    52
 54B25BAE958F05B3 |      4 |    50
 4EC96272443F5651 |      4 |    44
 05092B3DA75D1AF2 |      4 |  31.5
(5 rows)

/*
d. Counts the number of unique claim IDs for which the beneficiary was not financially responsible.Assume claim IDs in the data can contain duplicates.
*/
mdirhalli=# SELECT COUNT(DISTINCT id)
mdirhalli-# FROM cmsclaims
mdirhalli-# WHERE bene_resp = 0;

SELECT COUNT(DISTINCT id) FROM cmsclaims WHERE bene_resp = 0;


 count
--------
 604130


/*
e. Finds the average difference between carrier reimbursement and beneficiary responsibility. */

mdirhalli=# SELECT AVG(carrier_reimb - bene_resp) AS avg_difference
mdirhalli-# FROM cmsclaims;

SELECT AVG(carrier_reimb - bene_resp) AS avg_difference FROM cmsclaims;


    avg_difference
----------------------
 608.4206540026198418



