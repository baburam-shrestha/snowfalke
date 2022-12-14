--CREATING THE DATA WAREHOUSE NAMED AS FLATTEN_WAREHOUSE
CREATE 
OR REPLACE WAREHOUSE FLATTEN_WAREHOUSE;

-- USING THE DATA WAREHOUSE NAMED AS FLATTEN_WAREHOUSE
USE WAREHOUSE FLATTEN_WAREHOUSE;

--CREATING DATABASE NAMED AS FLATTEN_DATABASE
CREATE 
OR REPLACE DATABASE FLATTEN_DATABASE;

-- USING THE DATABASES NAMED AS FLATTEN_DATABASE
USE DATABASE FLATTEN_DATABASE;

--CREATING THE SCHEMA NAMED FLATTEN_SCHEMA
CREATE 
OR REPLACE SCHEMA FLATTEN_SCHEMA;

-- USING THE SCHEMA NAMED AS FLATTEN_SCHEMA
USE SCHEMA FLATTEN_SCHEMA;


--CREATING THE STAGE NAMED AS STORE_STAGE 
CREATE 
OR REPLACE STAGE QUIZ_STAGE COPY_OPTIONS =(on_error = 'skip_file');

-- SHOWING THE LIST OF STAGES
SHOW STAGES;

-- SHOWING THE FILES IN THE STAGES NAMED AS STORE_STAGE
LIST @QUIZ_STAGE;


-- FROM SNOWSQL COMMAND LINE:
-------------------------- # snowsql -a pprzfza-hi03530 -u fuseBaburam
-------------------------- # enter the password and hit enter
-------------------------- # USE WAREHOUSE FLATTEN_WAREHOUSE;
-------------------------- # USE DATABASE FLATTEN_DATABASE;
-------------------------- # USE SCHEMA FLATTEN_SCHEMA;
-------------------------- # SHOW STAGES;
-------------------------- # LIST @QUIZ_STAGE;

-----------------------------------FIRST JSON FILE: json_flatten_quiz.json -------------------------------------------


-------------------------- # PUT FILE://Fuse/snowfalke/snowsql_project/datas/json_flatten_quiz.json @QUIZ_STAGE;   

-- SELECTING THE DATA FROM STAGE NAMED AS QUIZ_STAGE
SELECT * FROM @QUIZ_STAGE/json_flatten_quiz.json.gz;
-- GENERATES ERROR: SQL compilation error: error line 1 at position 0 SELECT with no columns

-- CREATE TABLE WITH VARIANT COLUMN TO STORE THE JSON FILE
CREATE OR REPLACE TABLE
JSON_QUIZ_TABLE(QUESTION_OPTIONS_ANSWER VARIANT);


-- LOAD RAW DATA INTO UNFORMATTED TABLE NAMED AS JSON_QUIZ_TABLE
COPY INTO JSON_QUIZ_TABLE
FROM @QUIZ_STAGE/json_flatten_quiz.json.gz
FILE_FORMAT = (TYPE = JSON);

-- CHECK  BY SELECTING THE DATA FROM THE TABLE
SELECT * FROM JSON_QUIZ_TABLE;


-- QUERY TABLE
SELECT 
QUESTION_OPTIONS_ANSWER
FROM JSON_QUIZ_TABLE;

SELECT 
QUESTION_OPTIONS_ANSWER:quiz
FROM JSON_QUIZ_TABLE;

-- QUERY QUERY NESTED DATA FROM TABEL (nesting)
SELECT 
QUESTION_OPTIONS_ANSWER:quiz:general
FROM JSON_QUIZ_TABLE;

SELECT 
QUESTION_OPTIONS_ANSWER:quiz:science
FROM JSON_QUIZ_TABLE;

SELECT 
QUESTION_OPTIONS_ANSWER:quiz:sport
FROM JSON_QUIZ_TABLE;

SELECT 
QUESTION_OPTIONS_ANSWER:quiz:math
FROM JSON_QUIZ_TABLE;

-- GETTING  REQUIRED VALUE AND CASTING AS PER THE REQUIREMENT
SELECT 
QUESTION_OPTIONS_ANSWER:quiz:math:q1:question::STRING,
QUESTION_OPTIONS_ANSWER:quiz:math:q2:question::STRING,
QUESTION_OPTIONS_ANSWER:quiz:math:q3:question::STRING,
QUESTION_OPTIONS_ANSWER:quiz:math:q3:question::STRING
FROM JSON_QUIZ_TABLE;

SELECT 
QUESTION_OPTIONS_ANSWER:quiz:math:q1:question::STRING,
QUESTION_OPTIONS_ANSWER:quiz:math:q1:options::STRING,
QUESTION_OPTIONS_ANSWER:quiz:math:q1:answer::STRING
FROM JSON_QUIZ_TABLE;

SELECT 
QUESTION_OPTIONS_ANSWER:quiz:science:q3:question::STRING AS QUESTION,
QUESTION_OPTIONS_ANSWER:quiz:science:q3:options[0]::STRING AS OPTION1,
QUESTION_OPTIONS_ANSWER:quiz:science:q3:options[1]::STRING AS OPTION2,
QUESTION_OPTIONS_ANSWER:quiz:science:q3:options[2]::STRING AS OPTION3,
QUESTION_OPTIONS_ANSWER:quiz:science:q3:options[3]::STRING AS OPTION4,
QUESTION_OPTIONS_ANSWER:quiz:science:q3:answer::STRING AS ANSWER
FROM JSON_QUIZ_TABLE;


-- GETTING GENERAL QUESTIONS
SELECT
VALUE:question::VARCHAR GERERAL_QUESTIONS
FROM JSON_QUIZ_TABLE,
LATERAL FLATTEN(INPUT => QUESTION_OPTIONS_ANSWER:quiz:general);

-- GETTING SCIENCE QUESTIONS WITH CORRECT ANSWER
SELECT
VALUE:question::VARCHAR SCIENCE_QUESTION,
VALUE:options::VARCHAR ANSWER_OPTIONS,
VALUE:answer::VARCHAR CORRECT_ANSWER
FROM JSON_QUIZ_TABLE,
LATERAL FLATTEN(INPUT => QUESTION_OPTIONS_ANSWER:quiz:science);


-- GET SPORT QUESTIONS, SEPERATED OPTIONS AND CORRECT ANSWER
SELECT
VALUE:question::VARCHAR SPORT_QUESTION,
VALUE:options[0]::STRING OPTIONS_1,
VALUE:options[1]::STRING OPTIONS_2,
VALUE:options[2]::STRING OPTIONS_3,
VALUE:options[3]::STRING OPTIONS_4,
VALUE:answer::VARCHAR CORRECT_ANSWER
FROM JSON_QUIZ_TABLE,
LATERAL FLATTEN(INPUT => QUESTION_OPTIONS_ANSWER:quiz:sport:q1);


-- OUTPUT OF FLATTEN => SEQ |  KEY | PATH | INDEX | VALUE | THIS 
SELECT *
FROM JSON_QUIZ_TABLE,
LATERAL FLATTEN(INPUT => QUESTION_OPTIONS_ANSWER:quiz);

SELECT *
FROM JSON_QUIZ_TABLE,
LATERAL FLATTEN(INPUT => QUESTION_OPTIONS_ANSWER:quiz:math);

SELECT *
FROM JSON_QUIZ_TABLE,
LATERAL FLATTEN(INPUT => QUESTION_OPTIONS_ANSWER:quiz:math:q1:options);


-- RECURSIVE FLATTEN TO SELECT ALL THE INFROMATION
SELECT *
FROM JSON_QUIZ_TABLE,
LATERAL FLATTEN(INPUT => QUESTION_OPTIONS_ANSWER:quiz, RECURSIVE => TRUE);

-- RECURSIVE FLATTEN TO SELECT ALL THE INFROMATION
SELECT *
FROM JSON_QUIZ_TABLE,
LATERAL FLATTEN(INPUT => QUESTION_OPTIONS_ANSWER:quiz:math, RECURSIVE => TRUE);

SELECT *
FROM JSON_QUIZ_TABLE,
LATERAL FLATTEN(INPUT => QUESTION_OPTIONS_ANSWER:quiz:math:q1, RECURSIVE => TRUE);

SELECT *
FROM JSON_QUIZ_TABLE,
LATERAL FLATTEN(INPUT => QUESTION_OPTIONS_ANSWER:quiz:math:q2:options, RECURSIVE => TRUE);


-- GET ALL QUESTIONS ONLY, METHOD 1
SELECT
VALUE:question AS QUESTION
FROM JSON_QUIZ_TABLE,
LATERAL FLATTEN(INPUT => QUESTION_OPTIONS_ANSWER:quiz, RECURSIVE => TRUE)
WHERE QUESTION IS NOT NULL;

SELECT
VALUE:question AS QUESTION,
VALUE:options[0] AS OPTION_1,
VALUE:options[1] AS OPTION_2,
VALUE:options[2] AS OPTION_3,
VALUE:options[3] AS OPTION_4,
VALUE:answer AS ANSWER
FROM JSON_QUIZ_TABLE,
LATERAL FLATTEN(INPUT => QUESTION_OPTIONS_ANSWER:quiz, RECURSIVE => TRUE)
WHERE QUESTION IS NOT NULL;

--CREATING TABLE NAMED AS QUESTION_ANSWER
CREATE 
OR REPLACE TABLE "FLATTEN_DATABASE"."FLATTEN_SCHEMA"."QUESTION_ANSWER"(
    "QUESTION_ID" INTEGER PRIMARY KEY,
    "QUESTION" STRING,
    "OPTION_1" STRING,
    "OPTION_2" STRING,
    "OPTION_3" STRING,
    "OPTION_4" STRING,
    "ANSWER" STRING
);


-- INSERTING THE VALUE FROM SALES TABLE TO QUESTION_ANSWER TABLE
INSERT INTO  "FLATTEN_DATABASE"."FLATTEN_SCHEMA"."QUESTION_ANSWER" 
("QUESTION_ID","QUESTION","OPTION_1","OPTION_2" ,"OPTION_3","OPTION_4","ANSWER")
SELECT HASH(VALUE:question),
VALUE:question AS QUESTION,
VALUE:options[0] AS OPTION_1,
VALUE:options[1] AS OPTION_2,
VALUE:options[2] AS OPTION_3,
VALUE:options[3] AS OPTION_4,
VALUE:answer AS ANSWER
FROM JSON_QUIZ_TABLE,
LATERAL FLATTEN(INPUT => QUESTION_OPTIONS_ANSWER:quiz, RECURSIVE => TRUE)
WHERE QUESTION IS NOT NULL;

SELECT
  *
FROM "FLATTEN_DATABASE"."FLATTEN_SCHEMA"."QUESTION_ANSWER";


