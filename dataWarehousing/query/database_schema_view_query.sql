--using https://codebeautify.org/sqlformatter
 CREATE WAREHOUSE STORE_WAREHOUSE;
 
 CREATE DATABASE STORE_DATABASE;
 
 USE DATABASE STORE_DATABASE;
 
 CREATE SCHEMA STORE_SCHEMA;

 CREATE OR REPLACE TABLE "STORE_DATABASE"."STORE_SCHEMA".STORES(
   "STORE" INTEGER,
   "TYPE" STRING,
   "SIZE" INTEGER
 );
 
 
 SELECT * FROM "STORE_DATABASE"."STORE_SCHEMA"."STORES";
 
  SELECT "STORE","TYPE","SIZE" FROM "STORE_DATABASE"."STORE_SCHEMA"."STORES";

 CREATE OR REPLACE TABLE "STORE_DATABASE"."STORE_SCHEMA"."FEATURES"(
    "STORE" INTEGER,
    "DATE" DATE,
    "TEMPERATURE" FLOAT,
    "FUEL_PRICE" FLOAT,
    "MARKDOWN1" STRING,
    "MARKDOWN2" STRING,
    "MARKDOWN3" STRING,
    "MARKDOWN4" STRING,
    "MARKDOWN5" STRING,
    "CPI" STRING,
    "UNEMPLOYMENT" STRING,
    "ISHOLIDAY" STRING
);

SELECT * FROM "STORE_DATABASE"."STORE_SCHEMA"."FEATURES";

SELECT "STORE","DATE","TEMPERATURE", "FUEL_PRICE","CPI","ISHOLIDAY" FROM "STORE_DATABASE"."STORE_SCHEMA"."FEATURES";

CREATE OR REPLACE TABLE "STORE_DATABASE"."STORE_SCHEMA"."SALES"(
    "STORE" INTEGER,
    "DEPT" INTEGER ,
    "DATE" DATE,
    "WEEKLY_SALES" FLOAT,
    "ISHOLIDAY" STRING
);

SELECT * FROM "STORE_DATABASE"."STORE_SCHEMA"."SALES";


SELECT "STORE","DEPT","DATE", "WEEKLY_SALES","ISHOLIDAY" FROM "STORE_DATABASE"."STORE_SCHEMA"."SALES";


CREATE OR REPLACE VIEW "STORE_DATABASE"."STORE_SCHEMA"."STORES_VIEW" AS(
    SELECT * 
        FROM "STORE_DATABASE"."STORE_SCHEMA"."STORES" 
        WHERE SIZE>2000 AND TYPE='A'
);

SELECT * 
    FROM "STORE_DATABASE"."STORE_SCHEMA"."STORES_VIEW";



CREATE OR REPLACE VIEW "STORE_DATABASE"."STORE_SCHEMA"."SALES_VIEW" AS(
    SELECT "STORE","DEPT","DATE", "WEEKLY_SALES" 
    FROM "STORE_DATABASE"."STORE_SCHEMA"."SALES"
    WHERE WEEKLY_SALES>100000 AND DEPT=3
);

SELECT *  
    FROM "STORE_DATABASE"."STORE_SCHEMA"."SALES_VIEW";

CREATE OR REPLACE VIEW "STORE_DATABASE"."STORE_SCHEMA"."FEATUES_VIEW" AS(
    SELECT "STORE","DATE","TEMPERATURE", "FUEL_PRICE","CPI","ISHOLIDAY" 
        FROM "STORE_DATABASE"."STORE_SCHEMA"."FEATURES"
        WHERE TEMPERATURE>70 AND ISHOLIDAY='TRUE' AND DATE='2012-07-09'
);

SELECT *
    FROM "STORE_DATABASE"."STORE_SCHEMA"."FEATUES_VIEW";


CREATE OR REPLACE VIEW "STORE_DATABASE"."STORE_SCHEMA"."STORE_SALES_VIEW" AS(
    SELECT *
        FROM "STORE_DATABASE"."STORE_SCHEMA"."STORES" AS ST
        INNER JOIN  "STORE_DATABASE"."STORE_SCHEMA"."SALES" AS SA
        ON ST."STORE_ID"=SA."STORE"
        WHERE WEEKLY_SALES>100000 AND ISHOLIDAY='TRUE'
);

SELECT STORE_ID,TYPE,SIZE,DEPT,DATE,WEEKLY_SALES,ISHOLIDAY 
    FROM "STORE_DATABASE"."STORE_SCHEMA"."STORE_SALES_VIEW";

CREATE OR REPLACE VIEW "STORE_DATABASE"."STORE_SCHEMA"."STORE_FEATURES_VIEW" AS(
    SELECT * FROM "STORE_DATABASE"."STORE_SCHEMA"."STORES" AS ST
    INNER JOIN  "STORE_DATABASE"."STORE_SCHEMA"."FEATURES" AS FE
    ON ST."STORE_ID"=FE."STORE"
);

SELECT STORE_ID,TYPE,SIZE,DATE,TEMPERATURE,FUEL_PRICE,CPI,ISHOLIDAY 
    FROM "STORE_DATABASE"."STORE_SCHEMA"."STORE_FEATURES_VIEW"
    WHERE CPI>100 AND CPI!='NA'
    ORDER BY CPI;
    
    



