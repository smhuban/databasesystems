--Sean Huban
--Professor Labouseur
--4/18/2017
--Lab 10: STORED PROCEDURES




-- 1. Function that returns the immediate prerequisites for the passed-in course number.

CREATE or REPLACE function PreReqsFor(INT, REFCURSOR) RETURNS REFCURSOR AS 
$$
DECLARE
  course_num INT      := $1; 
  resultSet REFCURSOR := $2; 

BEGIN
   OPEN resultSet FOR
    SELECT courses.name, prerequisites.preReqNum
		FROM courses, prerequisites
			WHERE courses.num = prerequisites.courseNum
			AND prerequisites.courseNum = course_num;
  RETURN resultSet;
END;

$$

LANGUAGE plpgsql; 
SELECT PreReqsFor(499, 'results');
FETCH ALL FROM results; 

-- 2. Function that returns the courses for which the passed in course number is an immediate prerequisite

CREATE or REPLACE function IsPreReqFor(INT, REFCURSOR) RETURNS REFCURSOR AS
$$
DECLARE 
  pre_req INT         := $1;
  resultSet REFCURSOR := $2;

BEGIN 
  OPEN resultSet FOR
    SELECT name, num
		FROM courses, prerequisites
			WHERE courses.num = prerequisites.courseNum
			AND prerequisites.preReqNum = pre_req;
  RETURN resultSet;
END;

$$

LANGUAGE plpgsql;
SELECT IsPreReqFor(220, 'results');
FETCH ALL FROM results;
