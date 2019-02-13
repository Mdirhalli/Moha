

SQL 2.txt
#=================================================================================#
#                                Mohammed Aldirhalli                              #
# HS-611: SEMANTIC ORGANIZATION OF HEALTH INFORMATION AND DATA STANDARDS          #
# G1 (SPRING 2018)                                                                #
# 5.2.3 SQL HW 2                                                                  #
#=================================================================================#
#================================================================================#
#1. Using the table cmsclaims, write a query to answer each of the following:    #
#================================================================================#

a. For every possible value in hmo_mo, what is the average carrier reimbursement?
    Order by number of HMO months in ascending order.

SELECT hmo_mo, AVG(carrier_reimb) AS avg_of_carrier_reimb
FROM cmsclaims GROUP BY hmo_mo ORDER BY hmo_mo ASC;
SELECT hmo_mo, AVG(carrier_reimb) AS avg_of_carrier_reimb
FROM cmsclaims
GROUP BY hmo_mo
ORDER BY hmo_mo ASC;

 hmo_mo | avg_of_carrier_reimb
--------+-----------------------
 0 | 815.4227715123550866
 1 | 969.5914076782449726
 2 | 1007.2355140186915888
 3 | 999.3674014035781358
 4 | 1013.4260792756983549
#========================================================================#
#========================================================================#


b. For every value of carrier reimbursement, how many total months of HMO coverage
were provided? Order by carrier reimbursements in descending order.


SELECT carrier_reimb, SUM(hmo_mo) AS total_months
FROM cmsclaims
GROUP BY hmo_mo, carrier_reimb
ORDER BY carrier_reimb DESC;


 carrier_reimb | total_months
---------------+--------------
 16530         |      12
 13040         |      0
 12500         |      12
 11730         |      0
 11630         |      0
 11380         |      0
 11340         |      12
 
 
 
#========================================================================#
#========================================================================#
c. Using your query from part b, create a query that finds the largest carrier
reimbursement when the total months of HMO coverage is zero

SELECT MAX(carrier_reimb) AS max_of_carrier_reimb
FROM (SELECT carrier_reimb, SUM(hmo_mo) AS total_months
FROM cmsclaims
WHERE hmo_mo = 0
GROUP BY hmo_mo, carrier_reimb
ORDER BY carrier_reimb DESC) AS SUB_QUERY;


 max_of_carrier_reimb
----------------------
 13040
(1 row)


#========================================================================#
# 2. Using the table cmspop:                                             #
#========================================================================#
a. Return the number of instances of depression by sex, ordered by sex in ascending
order.

SELECT sex, COUNT(depression) AS number_of_instances_depression
FROM cmspop
WHERE depression = 't'
GROUP BY sex
ORDER BY sex ASC;


 sex    | number_of_instances_depression
--------+--------------------------------
 female | 235200
 male   | 166927


#========================================================================#
#========================================================================#
b. Return the most common month to be born in.

SELECT most_com_month
FROM ( SELECT most_com_month, COUNT(*) AS month
FROM (SELECT *, DATE_PART('month', dob) AS most_com_month
FROM cmspop) AS SUB_SUB_QUERY
GROUP BY most_com_month )AS SUB_QUERY
ORDER BY month DESC LIMIT 1;

 most_com_month
----------------
 6
(1 row)


#========================================================================#
#========================================================================#
c. Return the average birth year for all records. Hint: use the round() function.

SELECT ROUND (AVG(DATE_PART('year', dob))) AS_AVG_birth_year
FROM cmspop;

 as_avg_birth_year
-------------------
 1936
(1 row)

#========================================================================#
#========================================================================#
d. Return the average age (should contain a decimal) of those who died under the age of 50.

SELECT AVG(AVG_AGE)
FROM
(SELECT *, ((dod - dob)::FLOAT/365) AS AVG_AGE
FROM cmspop
WHERE dod IS NOT NULL) AS SUB_Query
WHERE AVG_AGE < 50::FLOAT;


 avg
------------------
 44.7581253615113
(1 row)

 ==============OR==============
mdirhalli=# SELECT AVG((dod - dob)/ 365.0) AS AVG_AGE
mdirhalli-# FROM cmspop
mdirhalli-# WHERE((dod- dob)/ 365.0) < 50;
 avg_age
---------------------
 44.7581253615112227
(1 row)


#========================================================================#
#========================================================================#
e. Now return the average age of those who died under the age of 50 to just two
decimal places. Hint:
if you get stuck, Google the error message
SELECT ROUND(
AVG((dod - dob)/ 365.0),2) AS AVG_AGE
FROM cmspop
WHERE((dod- dob)/ 365.0) < 50;

 avg_age
---------
 44.76
(1 row)

#========================================================================#
# 3. Using the table cmspop:                                             #
#========================================================================#
a. Return the state and number of heart failures for the state with
the greatest number of heart failures.

SELECT state, COUNT(heart_fail) AS Greatest_num_of_heart_failuers
FROM cmspop
WHERE heart_fail = 't'
GROUP BY state
ORDER BY COUNT(heart_fail)
DESC LIMIT 1;

 state | greatest_num_of_heart_failuers
-------+--------------------------------
 CA    | 47281
(1 row)

#========================================================================#
#========================================================================#
b. Find which county in California has the most hispanics. Return columns
for county, race, and the number of hispanics in that county.
Hint: you can group by more than one column at a time.

SELECT county, race, COUNT(race) AS num_of_hispanics
FROM cmspop
WHERE state = 'CA'
AND race = 'hispanic'
GROUP BY county, race
ORDER BY num_of_hispanics
DESC LIMIT 1;

 county |   race   | num_of_hispanics
--------+----------+------------------
 200    | hispanic | 2817
(1 row)

#========================================================================#
#4.The data in cmspop was collected on Jan 1st, 2010. With that in mind: #
#========================================================================#
a. Return the youngest age in integer years at the time of data collection
by sex for those who had cancer and were alive, ordered by sex in
ascending order. To be clear, age in integer years means that age should
be calculated like when you tell your age to someone: for example,
“I’m 62 years old.” You don’t say, “I’m 62.7456 years old”.
Hint: use the floor() function.

SELECT sex, FLOOR(MIN(youngest_age))
FROM(SELECT sex, FLOOR(('01-01-2010' - dob) / 365.0) AS youngest_age
FROM cmspop
WHERE cancer = 't'
AND dod IS NULL) AS SUB_QUERY
GROUP BY sex
ORDER BY sex ASC;

 sex | floor
--------+-------
 female | 26
 male | 26
(2 rows)
Page 5
SQL 2.txt
#========================================================================#
#========================================================================#
b. Return the id, sex, race, and age in integer years at the time of data
collection for the oldest living person in Massachusetts that has all
complications (Alzheimers, depression, cancer, and heart failure).

SELECT id, sex, race, FLOOR(('01-01-2010' - dob)::FLOAT/ 365) AS
OLDEST_LIVING_PERSON
FROM cmspop
WHERE state = 'MA'
AND alz_rel_sen = 't'
AND depression = 't'
AND cancer = 't'
AND heart_fail = 't'
AND dod IS NULL
ORDER BY OLDEST_LIVING_PERSON
DESC LIMIT 1;

 id               |   sex  | race  | oldest_living_person
------------------+--------+-------+----------------------
 AB33557A62C914C7 | female | white | 100
(1 row)
#========================================================================#
#5.Assume that, for the deceased, the flags for Alzheimers, depression, #
# cancer, and heart failure indicate cause of death. #
# Using the table cmspop, consider the following scenario: #
#========================================================================#
a. In the 0th, 80th, 150th, 160th, 180th, 190th, and 220th counties within
Wyoming, each of the deceased had a single cause of death. Count the number
of deaths caused by each complication for those individuals.
Hints: you can use parenthesis in WHERE statements to group conditions and,
also in WHERE statements, you can pass a list of values to IN.

SELECT Causes_of_death, COUNT(*)
FROM (SELECT *, CASE WHEN alz_rel_sen = 't' THEN 'alz_rel_sen'
WHEN heart_fail = 't' THEN 'heart_fail'
WHEN depression = 't' THEN 'depression'
WHEN cancer = 't' THEN 'cancer' END AS Causes_of_death
FROM cmspop
WHERE dod IS NOT NULL
AND(alz_rel_sen = 't'
OR heart_fail = 't'
OR depression = 't'
OR cancer = 't')
AND state = 'WY'
AND county IN(0, 80, 150, 160, 180, 190, 220)) AS sub_query
 GROUP BY Causes_of_death;
 
 causes_of_death | count
-----------------+-------
 alz_rel_sen     | 2
 cancer          | 1
 depression      | 1
 heart_fail      | 4
(4 rows)
Page 7
