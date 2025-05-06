-- review of sql 
SELECT Nest_ID, AVG(3.14/6*Width*Width*Length) AS Avg_volume
  FROM Bird_eggs
  WHERE Nest_ID LIKE '14%'
  GROUP BY Nest_ID 
  HAVING Avg_volume > 10000
  ORDER BY Avg_volume DESC 
  LIMIT 3 OFFSET 17;

-- can group by whole expresion 
SELECT substring(Nest_ID, 1, 3), AVG(3.14/6*Width*Width*Length) AS Avg_volume
  FROM Bird_eggs
  WHERE Nest_ID LIKE '14%'
  GROUP BY substring(Nest_ID, 1, 3) -- first three characters of the string  
  HAVING Avg_volume > 10000
  ORDER BY Avg_volume DESC;


-- Joins: creates a new mega-table 
CREATE TABLE a (col INT);
INSERT INTO a VALUES (1), (2), (3), (4);
CREATE TABLE b (col INT);
INSERT INTO b VALUES (0), (1);
SELECT * FROM a;
SELECT * FROM b;
-- every possible pairing of rows 
-- ON clause is kind of a like a WHERE clause on every row 
SELECT * FROM a JOIN b ON TRUE;
SELECT * FROM a JOIN b ON a.col = b.col;
SELECT * FROM a JOIN b ON NULL;
SELECT * FROM a JOIN b ON a.col = b.col OR a.col = b.col+1;

-- an outer join adds in any rows not included by the condition
SELECT * FROM a LEFT JOIN b ON a.col = b.col OR a.col = b.col+1; 

-- the ON clause should reflect the structure of the tables, 
-- the WHERE clause can be used for any additional 'stuff'