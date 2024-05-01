-- DATABASES AND SQL FOR DATA SCIENCE WITH PYTHON: HONORS MODULE
-- ADVANCED SQL for Data Engineers

-- Exercise 1 - Joins
-- Q1.1 SQL query to list the school names, community names, and average attendance for communities with a hardship index of 98
SELECT cps.NAME_OF_SCHOOL, cps.COMMUNITY_AREA_NAME, cps.AVERAGE_STUDENT_ATTENDANCE
FROM chicago_public_schools AS cps
LEFT JOIN chicago_socioeconomic_data AS cd
ON cps.COMMUNITY_AREA_NUMBER = cd.COMMUNITY_AREA_NUMBER
WHERE cd.HARDSHIP_INDEX = 98;

-- Q1.2 SQL query to list all crimes that took place at a school. Include case number, crime type, and community name
SELECT ccd.CASE_NUMBER, ccd.PRIMARY_TYPE, cd.COMMUNITY_AREA_NAME, ccd.LOCATION_DESCRIPTION 
FROM chicago_crime AS ccd
LEFT JOIN chicago_socioeconomic_data AS cd
ON ccd.COMMUNITY_AREA_NUMBER = cd.COMMUNITY_AREA_NUMBER 
WHERE ccd.LOCATION_DESCRIPTION LIKE '%SCHOOL%';


-- Exercise 2 - View
-- Q2.1 SQL statement to create a view 
CREATE VIEW CHICAGOSCHOOL AS 
SELECT NAME_OF_SCHOOL AS School_Name,
    Safety_Icon AS Safety_Rating,
    Family_Involvement_Icon AS Family_Rating,
    Environment_Icon AS Environment_Rating,
    Instruction_Icon AS Instruction_Rating,
    Leaders_Icon AS Leaders_Rating,
    Teachers_Icon AS Teachers_Rating
FROM chicago_public_schools;

-- Write and execute a SQL statement that returns all of the columns from the view.
SELECT * FROM CHICAGOSCHOOL;

-- Write and execute a SQL statement that returns just the school name and leaders rating from the view.
SELECT School_Name, Leaders_Rating 
FROM CHICAGOSCHOOL;


-- Exercise 3 - Stored Procedure
-- Q3.1 structure of a query to create or replace stored procedure called UPDATE_LEADERS_SCORE that takes a in_School_ID parameter as an integer and a in_Leader_Score parameter as an integer
DROP PROCEDURE IF EXISTS `UPDATE_LEADERS_SCORE`;

DELIMITER //
CREATE PROCEDURE `UPDATE_LEADERS_SCORE`(in_School_ID int, in_Leaders_Score int)
BEGIN	
    
END //
DELIMITER ;


-- Q3.2 SQL statement to update the Leaders_Score field in the chicago_public_schools table for the school idenfitied by in_School_ID to the value in the in_Leader_Score parameter 
DROP PROCEDURE IF EXISTS `UPDATE_LEADERS_SCORE`;

DELIMITER //
CREATE PROCEDURE `UPDATE_LEADERS_SCORE`(in_School_ID int, in_Leaders_Score int)
BEGIN
	START TRANSACTION;
		UPDATE chicago_public_schools
		SET Leaders_Score = in_Leaders_Score
		WHERE School_ID = in_School_ID;
-- Q3.3 SQL statement to update the Leaders_Icon field in the chicago_public_schools table for the school identified by in_School_ID
		IF in_Leaders_Score > 0 AND in_Leaders_Score < 20 THEN
				UPDATE chicago_public_schools
				SET Leaders_Icon = 'Very Weak'
				WHERE School_ID = in_School_ID;
			ELSEIF in_Leaders_Score < 40 THEN
				UPDATE chicago_public_schools
				SET Leaders_Icon = 'Weak'
				WHERE School_ID = in_School_ID;
			ELSEIF in_Leaders_Score < 60 THEN
				UPDATE chicago_public_schools
				SET Leaders_Icon = 'Average'
				WHERE School_ID = in_School_ID;
			ELSEIF in_Leaders_Score < 80 THEN
				UPDATE chicago_public_schools
				SET Leaders_Icon = 'Strong'
				WHERE School_ID = in_School_ID;
			ELSEIF in_Leaders_Score < 100 THEN
				UPDATE chicago_public_schools
				SET Leaders_Icon = 'Very Strong'
				WHERE School_ID = in_School_ID;
-- Q4.1 add generic ELSE clause to IF statement that rollsback the current work if the score doesn't fit any of the preceding categories
			ELSE ROLLBACK WORK;
		END IF;
-- Q4.2 add statement to commit the current unit of work at the end of the procedure
			COMMIT WORK;
END //
DELIMITER ;

-- Q3.4 call procedure, passing valid school ID and leader score of 50 to check that procedure works
-- NOTE: I had to alter column to be able to run procedure using following command: ALTER TABLE chicago_public_schools MODIFY COLUMN Leaders_Icon VARCHAR(15);
CALL UPDATE_LEADERS_SCORE(610281, 50);

-- to check result
SELECT School_ID, Leaders_Icon, Leaders_Score 
FROM chicago_public_schools 
WHERE School_ID=610281;

-- Exercise 4 - Transactions
-- check if procedure works with valid score 38
CALL UPDATE_LEADERS_SCORE(610281, 38);

-- check if procedure works with invalid score 101
CALL UPDATE_LEADERS_SCORE(610281, 101);
