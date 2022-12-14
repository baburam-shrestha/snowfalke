wild formater: https://www.dpriver.com/pp/sqlformat.htm 
 
 
 --CREATING THE DATA WAREHOUSE NAMED AS TABLE_WAREHOUSE
CREATE
OR
replace warehouse table_warehouse;
-- USING THE DATA WAREHOUSE NAMED AS TABLE_WAREHOUSEUSE warehouse table_warehouse;
--CREATING DATABASE NAMED AS TABLE_DATABASECREATE
OR
replace DATABASE table_database;
-- USING THE DATABASES NAMED AS TABLE_DATABASEUSE database table_database;
--CREATING THE SCHEMA NAMED TABLE_SCHEMACREATE
OR
replace SCHEMA table_schema;
-- USING THE SCHEMA NAMED AS TABLE_SCHEMAUSE SCHEMA table_schema;
--CREATING TABLE NAMED AS TABLE_1CREATE OR replace TABLE "TABLE_DATABASE"."TABLE_SCHEMA"."TABLE_1"
                        (
                                                "NAME" string,
                                                "EMAIL" string,
                                                "NUMBER" integer
                        );INSERT INTO "TABLE_DATABASE"."TABLE_SCHEMA"."table_1"
            (
                        "name",
                        "email",
                        "number"
            )
            VALUES
            (
                        'AP',
                        'ap@gmail.com',
                        9840449184
            )
            ,
            (
                        'AP',
                        'ap@gmail.com',
                        9840449184
            )
            ,
            (
                        'AP',
                        'apaaa@gmail.com',
                        9840373649
            )
            ,
            (
                        'AP',
                        'apppp@gmail.com',
                        9840128367
            )
            ,
            (
                        'BC',
                        'bc@gmail.com',
                        9840337266
            )
            ,
            (
                        'BC',
                        'cb@gmail.com',
                        9840337266
            )
            ,
            (
                        'BC',
                        'bcb@gmail.com',
                        9840333323
            )
            ,
            (
                        'BD',
                        'bd@gmail.com',
                        9840098779
            )
            ,
            (
                        'BD',
                        'db@gmail.com',
                        9840336387
            )
            ,
            (
                        'BD',
                        'bdbd@gmail.com',
                        9840388273
            )
            ,
            (
                        'BA',
                        'ba@gmail.com',
                        9840456789
            )
            ,
            (
                        'BA',
                        'bababa@gmail.com',
                        9840456789
            )
            ,
            (
                        'BA',
                        'bababa@gmail.com',
                        9840377689
            );

--SELECTING THE DATA FROM THE TABLESELECT *
FROM   "TABLE_DATABASE"."TABLE_SCHEMA"."table_1";

--SELECTING THE UNIQUE EMAIL FROM THE TABLESELECT DISTINCT("email")
FROM            "TABLE_DATABASE"."TABLE_SCHEMA"."table_1";

--SELECTING THE UNIQUE NUMBER FROM THE TABLESELECT DISTINCT("number")
FROM            "TABLE_DATABASE"."TABLE_SCHEMA"."table_1";

-- TABLE_1 TO TABLE_2
--SELECTING THE DATA FROM THE TABLE
--ARRAY_AGG
--https://docs.snowflake.com/en/sql-reference/functions/array_agg.html
--ARRAY_TO_STRING
-- https://docs.snowflake.com/en/sql-reference/functions/array_to_string.htmlSELECT   "name",
         Array_to_string(Array_agg(DISTINCT "email"),',') "EMAIL",
         Array_to_string(Array_agg(DISTINCT "number"),',') "NUMBER"
FROM     "TABLE_DATABASE"."TABLE_SCHEMA"."table_1"
GROUP BY "name";

--CREATING TABLE NAMED AS TABLE_2
-- ALL FIELD ARE VARCHAR BECAUSE ARRAY_TO_STRING FUNCTION RETURNS ALL VALUE OF TYPE VARCHARCREATE OR replace TABLE "TABLE_DATABASE"."TABLE_SCHEMA"."TABLE_2"
                        (
                                                "NAME"   varchar(255),
                                                "EMAIL"  varchar(255),
                                                "NUMBER" varchar(255)
                        );

-- INSERTING THE VALUE TO TABLE_2INSERT INTO "TABLE_DATABASE"."TABLE_SCHEMA"."table_2"
            (
                        "name",
                        "email",
                        "number"
            )
SELECT   "name",
         Array_to_string(Array_agg(DISTINCT email),',') "EMAIL",
         Array_to_string(Array_agg(DISTINCT number),',') "NUMBER"
FROM     "TABLE_DATABASE"."TABLE_SCHEMA"."table_1"
GROUP BY "name";

--SELECTING THE DATE FROM THE TABLE_2SELECT *
FROM   "TABLE_DATABASE"."TABLE_SCHEMA"."table_2";

-------------------------- VICE VERSA TASK------------
-- TABLE_2 TO TABLE_3SELECT "name",
       "email",
       "number"
FROM   "TABLE_DATABASE"."TABLE_SCHEMA"."table_2";

--STRING_TO_ARRAY
-- https://docs.snowflake.com/en/sql-reference/functions/strtok_to_array.htmlSELECT "name",
       Strtok_to_array(email,',')  AS "EMAIL",
       Strtok_to_array(number,',') AS "NUMBER"
FROM   "TABLE_DATABASE"."TABLE_SCHEMA"."table_2";

-- selecting the data from table_2SELECT "NAME",
       f1.value::string AS "EMAIL",
       f2.value::string AS "NUMBER"
FROM   "TABLE_2",
       lateral flatten(input => split(email, ',')) f1,
       lateral flatten(input => split(number, ',')) f2;SELECT "NAME",
       f1.value::string AS "EMAIL",
       f2.value::string AS "NUMBER"
FROM   "TABLE_2",
       lateral flatten(input => split(email,',')) f1,
       lateral flatten(input => split(number, ',')) f2;

--CREATING TABLE NAMED AS TABLE_3CREATE OR replace TABLE "TABLE_DATABASE"."TABLE_SCHEMA"."TABLE_3"
                        (
                                                "NAME" string,
                                                "EMAIL" string,
                                                "NUMBER" number
                        );

--INSERTING THE DATA INT0 TABLE_3INSERT INTO "TABLE_DATABASE"."TABLE_SCHEMA"."TABLE_3"
SELECT "NAME",
       f1.value::string AS "EMAIL",
       f2.value::string AS "NUMBER"
FROM   "TABLE_2",
       lateral flatten(input => split(email,',')) f1,
       lateral flatten(input => split(number, ',')) f2;

--SELECTING THE DATA FROM TABLE_3SELECT *
FROM   "TABLE_DATABASE"."TABLE_SCHEMA"."table_3"
-- selecting the data from table_2SELECT "NAME",
       f1.value::string AS "EMAIL",
       f2.value::string AS "NUMBER"
FROM   "TABLE_2",
       lateral split_to_table("EMAIL", ',') f1,
       lateral split_to_table("NUMBER", ',') f2;

--CREATING TABLE NAMED AS TABLE_4CREATE OR replace TABLE "TABLE_DATABASE"."TABLE_SCHEMA"."TABLE_4"
                        (
                                                "NAME" string,
                                                "EMAIL" string,
                                                "NUMBER" number
                        );

--INSERTING THE DATA INT0 TABLE_3INSERT INTO "TABLE_DATABASE"."TABLE_SCHEMA"."TABLE_4"
SELECT "NAME",
       f1.value::string AS "EMAIL",
       f2.value::string AS "NUMBER"
FROM   "TABLE_2",
       lateral split_to_table("EMAIL", ',') f1,
       lateral split_to_table("NUMBER", ',') f2;

--selecting THE DATA from TABLE_4SELECT *
FROM   "TABLE_DATABASE"."TABLE_SCHEMA"."table_4"; 
