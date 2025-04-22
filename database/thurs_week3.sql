-- To connect to database, I had to open it as follows: 
-- in terminal: duckdb  ~/Desktop/MEDS/EDS_213/bren-eds213-data/database/database.db


-- From last time, wound up
SELECT DISTINCT Location
  FROM Site 
  ORDER BY Location DESC
  LIMIT 3;

-- Filtering 
SELECT * FROM Site WHERE Area < 200; 
-- Can be arbitrary expression 
SELECT * FROM Site WHERE Area < 200 AND Latitude > 60;
-- Not equal, classifc operator is <>, but nowadays most databases support != 
SELECT * FROM Site WHERE Location <> 'Alaska, USA';

-- LIKE for string matching, uses % as the wildcard character (not *)
SELECT * FROM Site WHERE Location LIKE '%Canada';

-- COmmon pattern: databases provide tims of functions 
SELECT * FROM Site WHERE regexp_matches(Location, '.*west.*');

-- "select =" expressions; i.e you can do computation 
SELECT Site_name, Area FROM Site;
SELECT Site_name, Area*2.47 FROM Site;
SELECT Site_name, Area*2.47 AS Area_acres FROM Site;

-- You can use your database as a calculator 
SELECT 2+2;

-- String concatenation operator: classic one is ||, others via functions 
SELECT Site_name || ' in ' || Location FROM Site;

-- AGGREGATION AND GROUPING 
SELECT COUNT(*) FROM Species;
-- ^^ * means number of rows 
SELECT COUNT(Scientific_name) FROM Species;
-- ^^counts the number of non null values 
-- can also count # of distinct values 
SELECT DISTINCT Relevance FROM Species;
SELECT COUNT(DISTINCT Relevance) FROM Species;
-- ^^ count number of null values 

--  moving on to arithmetic operations 
SELECT AVG(Area) FROM Site;
SELECT AVG(Area) FROM Site WHERE Location LIKE '%Alaska%';
-- MIN, MAX 

-- Suppose we want the largest site and its name 
SELECT Site_name, MAX(Area) FROM Site;
-- You get an error, we didnt tell it return the site that connects to largest area 

-- intro to grouping (highlight whole thing to get it to run)
SELECT Location, MAX(Area)
  FROM Site 
  GROUP BY Location;

SELECT Location, COUNT(*), MAX(Area)
  FROM Site
  GROUP BY Location;

SELECT Location, COUNT(*), MAX(Area)
  FROM Site 
  WHERE Location LIKE '%Canada'
  GROUP BY Location;


-- A where clause limits the rows that are going in to the expression at the begining 
-- A HAVING filters the groups 
SELECT Location, COUNT(*) AS Count, MAX(Area) AS Max_area
  FROM Site 
  WHERE Location LIKE '%Canada'
  GROUP BY Location 
  HAVING Count > 1;

-- NULL processing 
-- NULL indicates the absence of data ina table 
-- But in an expression, it means unknown 
SELECT COUNT(*) FROM Bird_nests;
SELECT COUNT(*) FROM Bird_nests WHERE floatAge > 5;
SELECT COUNT(*) FROM Bird_nests WHERE floatAge <= 5;

-- The only way to find NULL values 
SELECT COUNT(*) FROM Bird_nests WHERE floatAge IS NULL;
SELECT COUNT(*) FROM Bird_nests WHERE floatAge IS NOT NULL;

-- Joins 
SELECT * FROM Camp_assignment LIMIT 10;
SELECT * FROM Personnel;

SELECT * FROM Camp_assignment JOIN Personnel
  ON Observer = Abbreviation 
  LIMIT 10;

-- you may need to qualify column names 
SELECT * FROM Camp_assignment JOIN Personnel
  ON Camp_assignment.Observer = Personnel.Abbreviation
  LIMIT 10;

-- another way to use aliases 
SELECT * FROM Camp_assignment AS CA JOIN Personnel AS P 
  ON CA.Observer = P.Abbreviation
  LIMIT 10;

-- relational algebra and nested quesries and subqueries 
SELECT COUNT(*) FROM Bird_nests;
-- how many rows are in that table? 
SELECT COUNT(*) FROM (SELECT COUNT(*) FROM Bird_nests);

-- create temp tables 
CREATE TEMP TABLE nest_count AS SELECT COUNT(*) FROM Bird_nests; 
.table 
SELECT * FROM nest_count;
DROP TABLE nest_count;

-- another place to nest queries is IN clauses 
SELECT Observer FROM Bird_nests;
SELECT * FROM Personnel ORDER BY Abbreviation;

-- select everything in bird nest table where abbreviation of observer starts with 'a'
SELECT * FROM Bird_nests
  WHERE Observer IN (
    SELECT Abbreviation FROM Personnel
      WHERE Abbreviation LIKE 'a%'
  );