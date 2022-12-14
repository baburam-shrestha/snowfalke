--using https://codebeautify.org/sqlformatter

--CREATING THE DATA WAREHOUSE NAMED AS TASK_WAREHOUSE
CREATE 
OR REPLACE WAREHOUSE TASK_WAREHOUSE;

-- USING THE DATA WAREHOUSE NAMED AS TASK_WAREHOUSE
USE WAREHOUSE TASK_WAREHOUSE;

--CREATING DATABASE NAMED AS TASK_DATABASE
CREATE 
OR REPLACE DATABASE TASK_DATABASE;

-- USING THE DATABASES NAMED AS TASK_DATABASE
USE DATABASE TASK_DATABASE;

--CREATING THE SCHEMA NAMED AS TASK_SCHEMA
CREATE 
OR REPLACE SCHEMA TASK_SCHEMA;

-- USING THE SCHEMA NAMED AS STAGE_SCHEMA
USE SCHEMA TASK_SCHEMA;

--CREATING TABLE SALARY
CREATE 
OR REPLACE TABLE "TASK_DATABASE"."TASK_SCHEMA"."SALARY"(
  "ID" INTEGER, "WORK_YEAR" INTEGER, 
  "EXPERIENCE_LEVEL" STRING, "EMPLOYMENT_TYPE" STRING, 
  "JOB_TITLE" STRING, "SALARY_AMOUNT" INTEGER, 
  "SALARY_CURRENCY" STRING, "SALARY_IN_USD" INTEGER, 
  "EMPLOYEE_RESIDENCE" STRING, "REMOTE_RATIO" INTEGER, 
  "COMPANY_LOCATION" STRING, "COMPANY_SIZE" STRING
);

--selecting the data from SALARY table
SELECT 
  * 
FROM 
  "TASK_DATABASE"."TASK_SCHEMA"."SALARY";
  
  
--------------------- stored Procedures--------------------------
--creating the stored procedure named as sp_pi o return tehe value of pi
create 
or replace procedure sp_pi() returns float not null language javascript as $$ return 3.1415926;
$$;

-- calling the sp_pi stored_procedure
call sp_pi();

--creating the stored procedure named as sp_sec
create 
or replace procedure sp_sec() returns string language javascript as $$ const my_date = new Date();
let current_second = my_date.getSeconds();
var even_odd = '';
if(current_second % 2 == 0) {even_odd = 'even' } else even_odd = 'odd' return even_odd;
$$;

-- calling the sp_sec stored_procedure
call sp_sec();

--creating the stored procedure named as sp_job
create 
or replace procedure sp_job(table_name VARCHAR) returns string language javascript as $$ var sql_query_command = "SELECT JOB_TITLE FROM " + TABLE_NAME;
var sql_statement = snowflake.createStatement({ sqlText : sql_query_command });
var result = sql_statement.execute();
result.next();
values 
  = result.getColumnValue(1);
return 
values 
  ;
$$;

-- calling the sp_job stored_procedure
CALL sp_job('SALARY');

--creating the stored procedure named as sp_count_employee
create 
or replace procedure sp_count_employee(table_name VARCHAR) returns string language javascript as $$ var sql_query_command = "SELECT COUNT(ID) FROM " + TABLE_NAME;
var sql_statement = snowflake.createStatement({ sqlText : sql_query_command });
var result = sql_statement.execute();
result.next();
values 
  = result.getColumnValue(1);
return 
values 
  ;
$$;

-- calling the sp_count_employee stored_procedure
CALL sp_count_employee('SALARY');

--creating the stored procedure named as sp_count_employment_type
create 
or replace procedure sp_count_employment_type(table_name VARCHAR) returns string language javascript as $$ var sql_query_command = "SELECT COUNT(DISTINCT EMPLOYMENT_TYPE ) FROM " + TABLE_NAME;
var sql_statement = snowflake.createStatement({ sqlText : sql_query_command });
var result = sql_statement.execute();
result.next();
values 
  = result.getColumnValue(1);
return 
values 
  ;
$$;

-- calling the sp_count_employment_type stored_procedure
CALL sp_count_employment_type('SALARY');


--creating the stored procedure named as sp_count_experience_level
create 
or replace procedure sp_count_experience_level(table_name VARCHAR) returns string language javascript as $$ var sql_query_command = "SELECT COUNT(DISTINCT EXPERIENCE_LEVEL ) FROM " + TABLE_NAME;
var sql_statement = snowflake.createStatement({ sqlText : sql_query_command });
var result = sql_statement.execute();
result.next();
values 
  = result.getColumnValue(1);
return 
values 
  ;
$$;

-- calling the sp_count_experience_level stored_procedure
CALL sp_count_experience_level('SALARY');


-- stored procedure  to find the lowest, average and highest salary
create 
or replace procedure sp_salary(table_name VARCHAR) returns string language javascript as $$ var sql_query_command = "SELECT MIN(SALARY_IN_USD),AVG(SALARY_IN_USD),MAX(SALARY_IN_USD) FROM " + TABLE_NAME;
var sql_statement = snowflake.createStatement({ sqlText : sql_query_command });
var result = sql_statement.execute();
result.next();
values 
  = [result.getColumnValue(1), 
  result.getColumnValue(2), 
  result.getColumnValue(3) ];
return 
values 
  ;
$$;
CALL sp_salary('SALARY');

