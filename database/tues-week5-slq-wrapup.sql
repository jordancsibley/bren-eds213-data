-- Other SQL functions beside SELECT 

-- inserting data 
INSERT INTO Species VALUES ('abcb', 'thing', 'scientific_name', NULL);
-- this is a fragile statement, assumes the order of the columns 

-- you can explicitly label columns 
INSERT INTO Species
  (Common_name, Scientific_name, Code, Relevance)
  VALUES
  ('abcb', 'thing', 'scientific_name', NULL);
-- this is a more stable way to inserting data, no question about what value goes to what column
-- view inserted values 
SELECT * FROM Species;

-- can take advantage of default values 
INSERT INTO Species 
  (Common_name, Code)
  VALUES
  ('thing 3', 'ijkl'); 
SELECT * FROM Species;
-- automatically gave NULL values to the other columns that werent given a new value 


-- UPDATEs and DELETEs will demolish the entire table unless limited by WHERE 
--DELETE FROM Bird_eggs; This is a dangerous move 

-- Strategies to save yourself? 
-- Doing a SELECT first 
SELECT * FROM Bird_eggs WHERE Nest_ID LIKE 'z%';

-- try the create a copy of the table 
CREATE TABLE nest_temp AS (SELECT * FROM Bird_nests);
DELETE FROM nest_temp WHERE Site = 'chur';
-- check that it worked 
SELECT * FROM nest_temp WHERE Site = 'chur'; -- zero rows 