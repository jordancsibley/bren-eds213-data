-- define table for data 
CREATE TABLE Snow_cover (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1990 AND 2018),
    Date DATE NOT NULL, 
    Plot VARCHAR NOT NULL, 
    Location VARCHAR NOT NULL, 
    Snow_cover REAL CHECK (Snow_cover BETWEEN 0 AND 130), 
    Water_cover REAL CHECK (Water_cover BETWEEN 0 AND 130), 
    Land_cover REAL CHECK (Land_cover BETWEEN 0 AND 130), 
    Total_cover REAL CHECK (Total_cover BETWEEN 0 AND 130),
    Observer VARCHAR, 
    Notes VARCHAR,
    PRIMARY KEY (Site, Date, Plot, Location), 
    FOREIGN KEY (Site) REFERENCES Site (Code)
);
-- copy in data (download snow_survey_fixed from github, link in slack)
COPY Snow_cover FROM '../ASDN_csv/snow_survey_fixed.csv' (header TRUE);

-- view data 
SELECT * FROM Snow_cover LIMIT 10;

-- we see an issue. SQL sees no data values as NULL, but this dataset has it as NA 
-- we can fix it in the COPY line: 
-- drop table Snow_cover, and then re run table and following line
COPY Snow_cover FROM '../ASDN_csv/snow_survey_fixed.csv' (header TRUE, nullstr "NA");

-- view that it worked 
SELECT * FROM Snow_cover LIMIT 10;


------- Query practice time! ----------

-- What is the average snow cover at each site? 
SELECT Site, AVG(Snow_cover) AS avg_snowcover FROM Snow_cover
  GROUP BY Site;


-- What are the top most snowy sites? 
SELECT Site, AVG(Snow_cover) AS avg_snowcover FROM Snow_cover
  GROUP BY Site
  ORDER BY avg_snowcover DESC
  LIMIT 5;

-- Save this as a view 
CREATE VIEW Site_avg_snowcover AS (
    SELECT Site, AVG(Snow_cover) AS avg_snowcover FROM Snow_cover
    GROUP BY Site
    ORDER BY avg_snowcover DESC
    LIMIT 5
);

-- you should now see Site_avg_snowcover in list of tables 
.tables 

--- DANGER ZONE !!!! updating data
-- We found that 0s at Plot = `brw0` with snow_cover == 0 are actually no data (NULL)

-- step 1: create temp table of data as backup
CREATE TEMP TABLE Snow_cover_backup AS (SELECT * FROM Snow_cover);
.tables

-- look at data before making the update 
SELECT * FROM Snow_cover_backup WHERE Plot = 'brw0';

-- step 2: back update to backup table 
UPDATE Snow_cover_backup SET Snow_cover = NULL WHERE Plot = 'brw0' AND Snow_cover = 0;

-- See updates 
SELECT * FROM Snow_cover_backup;

-- step 3: make update on real data 
UPDATE Snow_cover SET Snow_cover = NULL WHERE Plot = 'brw0' AND Snow_cover = 0;


-- Lets see how this impacted the view we created 
SELECT * FROM Site_avg_snowcover;

