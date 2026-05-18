-- Table Creation

CREATE TABLE sales_store (
transaction_id varchar(15),
customer_id VARCHAR(15),
customer_name VARCHAR(30),
customer_age INT,
gender VARCHAR(15),
product_id VARCHAR(15),
product_name VARCHAR(15),
product_category VARCHAR(15),
quantiy INT,
prce FLOAT,
payment_mode VARCHAR(15),
purchase_date DATE,
time_of_purchase TIME,
status VARCHAR(15)
);


Select * from sales_store;

-- Bulk Data Insertion to the Table

Set Dateformat dmy

Bulk insert sales_store 

from 'D:\sales_store\sales_store.csv'
with (
        Firstrow = 2,
		FieldTerminator = ',',
		Rowterminator ='\n'
		);


Select * from sales_store;

-- Copy of the dataset

Select * Into sales from sales_store
select * from sales

-- Data Cleaning

 -- step 1. Check Duplicates

 select transaction_id, count(*)
 from sales
 Group By transaction_id
 having count(transaction_id) > 1;



 ;
 With CTE AS (
 Select *,
  ROW_NUMBER() over ( 
  PARTITION BY transaction_id 
  ORDER By transaction_id
  ) AS Row_Num
  From sales 
  )

  -- to delete duplicates 

 Delete from CTE 
where Row_Num > 1

  -- to find the entire records

 Select * FROM CTE
WHERE transaction_id IN ('TXN240646', 'TXN342128', 'TXN855235', 'TXN981773')

Select * FROM CTE
WHERE Row_Num>1

-- step 2: Correction of Headers

Exec sp_rename'sales.quantiy', 'quantity', 'column'

Exec sp_rename 'sales.prce', 'price', 'COLUMN'

select * from sales;

-- step 3: Check Datatype

SELECT Column_Name, DATA_TYPE
from Information_Schema.COLUMNS
Where Table_name ='sales' ;

-- Step 4 : Check Null Values

   -- to check null count

DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql +=
'SELECT ''' + COLUMN_NAME + ''' AS column_name,
        COUNT(*) - COUNT([' + COLUMN_NAME + ']) AS null_count
 FROM sales
 UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sales';

SET @sql = LEFT(@sql, LEN(@sql) - 10);

EXEC sp_executesql @sql;


 -- treating null values

 SELECT *
FROM sales 
WHERE transaction_id IS NULL
OR
customer_id IS NULL
OR
customer_name IS NULL
OR
customer_age IS NULL
OR
gender IS NULL
OR
product_id IS NULL
OR
product_name IS NULL
OR
product_category IS NULL
OR
quantity IS NULL
or
payment_mode is null
or
purchase_date is null
or 
status is null
or 
price is null


-- Deleting 
Delete from sales
where transaction_id IS NULL

-- Updating the null values
select * from sales
where customer_name = 'Ehsaan Ram'

update sales
set customer_id='CUST9494'
where transaction_id = 'TXN977900';

select * from sales
where customer_name = 'Damini Raju'

update sales
set customer_id='CUST1401'
where transaction_id = 'TXN985663';

select * from sales
where customer_id = 'CUST1003';

update sales
set customer_name = 'Mahika Saini', customer_age = 35, gender = 'Male'
where transaction_id = 'TXN432798';


-- Step: 5 Data Cleaning

-- FOr gender
select distinct gender
from sales;

Update sales 
set gender = 'M'
where gender = 'Male';

Update sales 
set gender = 'F'
where gender = 'Female';


 -- for payment_mode

 select distinct payment_mode
from sales;


Update sales 
set payment_mode = 'Credit Card'
where payment_mode = 'CC';
