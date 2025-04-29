-- Exporting data from database 

-- The whole database 

EXPORT DATABASE 'export_adsn';

-- the exported files are now in a folder 'export_adsn'
-- also includes a schema of the database 
-- and a way to re upload the database into duckdb


-- One table 
COPY Species TO 'species_test.csv' (HEADER, DELIMITER ',');


-- specific query 
COPY (SELECT COUNT(*) FROM Species) TO 'species_count.csv' (HEADER, DELIMITER ',');