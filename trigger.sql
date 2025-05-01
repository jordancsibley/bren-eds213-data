-- to get into database in sqlite in terminal = sqlite3 database.sqlite
-- EDS 213 week 5 May 1, 2025 

.mode table
-- SQLite looks a lot like DuckDB
.schema
.tables
SELECT * FROM Species; 
.nullvalue -NULL-

-- The problem we're going to try to fix: 
INSERT INTO Species VALUES ('abcd', 'thing1', '', 'Study species');

-- Time to create trigger 
CREATE TRIGGER Fix_up_species 
AFTER INSERT ON Species 
FOR EACH ROW 
BEGIN 
  UPDATE Species 
   SET Scientific_name = NULL
   WHERE Code = new.Code AND Scientific_name = '';
END;

-- Lets test it! 
INSERT INTO Species 
  VALUES ('efgh', 'thing2', '', 'Study Species');
-- check 
SELECT * FROM Species;

-- now trigger is in database, see below 
.schema