
--CREATE DATABESE 
USE master ;
GO
CREATE DATABASE PMDB 
ON(
NAME=SALES_DATA,
FILENAME = 'D:\data base files\saledata.mdf',
SIZE = 8,
MAXSIZE= UNLIMITED,
FILEGROWTH = 10)
LOG ON(
NAME = SALES_LOG,
FILENAME='D:\data base files\salelog.ldf',
SIZE=8,
MAXSIZE=UNLIMITED,
FILEGROWTH=10);

--CREATE SCHEMA 
USE PMDB;
GO
CREATE SCHEMA SALES ;

GO

--CREATE CUSTOMERS TABLE

CREATE TABLE SALES.Customers (
 Customer_id int primary key identity(1,1),
 firstname varchar(50) not null,
 lastname  varchar(50) not null,
 phone varchar(50) unique not null ,
 email varchar(50) unique not null,
 city varchar(50) not null
 );

 GO 
 -- create orders 
 CREATE TABLE SALES.Orders(
 Order_id int primary key ,
 Customer_id int foreign key REFERENCES  SALES.Customers(Customer_id),
Orderdate DATETIME2 not null,
staff_id int not null,
Store_id int not null
 );

GO 
--create order-items 
CREATE TABLE SALES.Order_Items(
Order_id int not null,
product_id int not null,
Quantity int not null,
liST_Price decimal(18,2) not null,
discount int, 
primary key (Order_id,product_id)
);

--create staffs 
GO
CREATE TABLE SALES.Staffs(
Staff_id int primary key,
first_name varchar(50) not null,
last_name varchar(50) not null,
phone  varchar(50) not null,
email varchar(50) not null,
active bit not null,
store_id int not null,
manager_id int foreign key references SALES.StaffS(Staff_id)
);

GO
--create stores

CREATE TABLE SALES.Stores(
Store_id int primary key ,
store_name varchar(50) not null,
phone varchar(50) not null,
email varchar(50) not null,
city varchar(50) not null
);

-- add foreign keys to orders table 
alter table SALES.Orders
add constraint FK_StoreReferences foreign key (Store_id) references SALES.Stores(Store_id);
go
alter table SAlES.Orders 
add constraint FK_StaffReferences foreign key (Staff_id) references SALES.Staffs(staff_id);

go

alter table SALES.Staffs 
add constraint FK_STORE_staffs_References foreign key (Store_id) references SALES.Stores(Store_id);

-- production SCHEMA 
GO

CREATE SCHEMA PRODUCTION ;

GO 

--create productsTable

CREATE TABLE PRODUCTION.Products
(
Product_id int primary key identity(1,1),
product_name varchar(50) not null,
Brand_id int not null,
Category_id int  not null,
list_price decimal(18,2) not null,
);

go 

--alter order_items
ALTER TABLE SALES.Order_Items
ADD CONSTRAINT FK_OrderItems_products foreign key(product_id) references PRODUCTION.Products(product_id);
 
ALTER TABLE SALES.Order_Items
ADD CONSTRAINT FK_OrderItems_Order foreign key(order_id) references SALES.Orders (order_id);

go
--create categorytable

CREATE TABLE PRODUCTION.Categories(
category_id int primary key ,
categoryname varchar(50) not null
);

go
--create brandtable 
CREATE TABLE PRODUCTION.Brands(
brand_id int primary key,
brandName varchar(50) not null,
);

go
--create stockstable 

Create TABLE PRODUCTION.Stocks(
store_id int foreign key references SALES.Stores(store_id) not null,
product_id int foreign key references PRODUCTION.Products(product_id) not null,
Quantity int null
primary key(store_id,product_id)
);
go
alter TABLE PRODUCTION.Products 
add constraint FK_products_brands foreign key (brand_id) references PRODUCTION.Brands(Brand_Id);
go
alter TABLE PRODUCTION.Products 
add constraint FK_products_categories foreign key (Category_id) references PRODUCTION.Categories(Category_id);
go
--crud on PMDB

USE PMDB;
GO 
INSERT INTO PRODUCTION.Brands(brand_id,brandName)
OUTPUT inserted.brand_id,inserted.brandName
VALUES 
(17900,'Zara'),
(17910,'H&M'),
(17920,'adidas'),
(17930,'Nike'),
(17940,'town team')

GO
UPDATE PRODUCTION.Brands
set	brandName = 'twins',
brand_id= 1950
where brand_id = 17940;
Go
select * from PRODUCTION.Brands;
DELETE FROM PRODUCTION.Brands
WHERE Brand_id =1950;

INSERT INTO PRODUCTION.Categories(category_id,categoryname)
VALUES
(1810,'FEMALE'),
(1820,'MALE'),
(1830,'CHILD')

INSERT INTO PRODUCTION.Products(product_name,list_price,Brand_id,Category_id)
VALUES 
('T-Sheart',180.50,17900,1830),
('dress',60.5,17900,1810),
('jacket',200,17910,1820),
('sport shoes',500,17920,1820)

Select P.product_name,c.categoryname,B.brandName
from PRODUCTION.Brands B inner join PRODUCTION.Products P on  B.brand_id=P.Brand_id inner join PRODUCTION.Categories C ON 
C.category_id=P.Category_id;

INSERT INTO PRODUCTION.Products(product_name,list_price,Brand_id,Category_id)
VALUES
('T-Sheart',400,17910,1810),
('dress',500,17920,1810),
('jacket',700,17910,1820),
('sport shoes',500,17930,1830)

select * from PRODUCTION.Categories
select * from PRODUCTION.Products
--categoryname , productname , count, maxprice , minprice , averageprice 
SELECT C.categoryname ,P.product_name,count(P.product_name) AS N'Number of products',max(P.list_price) AS N'Max price',min(P.list_price) AS N'min price',AVG(P.list_price) AS N'avarge price'
FROM PRODUCTION.Categories C inner join PRODUCTION.Products P
on C.category_id=P.Category_id
GROUP BY C.categoryname ,P.product_name;


-- CREATE INDEX 'INDEX_NAME_CONVENSION' 
-- ON TABLENAME (COLUNM NAME)
use PMDB
go
select * from PRODUCTION.Categories;


INSERT INTO SALES.Customers(firstname,lastname,email,phone,city)
VALUES 
('MOHAMED','.A','ma24560720@gmail.com','01224599754','SHIBIN ELKOUM'),
('MOHAMED','.M','ma25560720@gmail.com','01234599754','SHIBIN ELKOUM'),
('MOHAMED','.S','ma24660720@gmail.com','01244599754','SHIBIN ELKOUM'),
('MOHAMED','.kh','ma249660720@gmail.com','01274599754','SHIBIN ELKOUM'),
('AHMED','.A','ma24561720@gmail.com','01224699754','SHIBIN ELKOUM'),
('AHMED','.M','ma24569720@gmail.com','01224589754','SHIBIN ELKOUM'),
('ALI','.A','ma24560770@gmail.com','01224599154','SHIBIN ELKOUM'),
('HOSSAM','.A','ma24560780@gmail.com','01224598754','SHIBIN ELKOUM'),
('SAMIR','.A','ma24560790@gmail.com','01224597754','SHIBIN ELKOUM'),
('SARA','.A','ma24560700@gmail.com','01224599454','SHIBIN ELKOUM')
CREATE INDEX Customers_LastName_IX ON SALES.Customers(lastname);

DROP INDEX Customers_LastName_IX ON SALES.Customers;
select * from SALES.Customers where lastname ='.A';

dbcc freeproccache;
set statistics time ,io on

use PMDB;
go 

--scaler function 

-- create or alter function "function name "(@varname datatype)
--returns money
--As

--BEGIN



--END 

--table-valued-function
--create or alter function "FN"(@varname datatype)
--returns Table 
--AS 
--return ();


--procedure 

--create or alter procedure "procedure name" (@varname datatype)
--as
--begin 
--end


--view
--create or alter view 
--as 
use SampleDB
CREATE OR ALTER PROCEDURE GetAllBoughtProductsForClient(@CutomerName Varchar(100))
as 
BEGIN
SELECT C.First_name+ ' '+ C.last_name AS "Customer Name"  , P.product_name  ,p.list_price , oi.Quantity ,oi.discount  from 
SALES.Customers C inner join SALES.Orders O
on c.Customer_id = O.Customer_id
inner join SALES.Order_Items OI
on O.Order_id = oi.Order_id
inner join PRODUCTION.Products P
on oi.product_id = p.Product_id
where C.first_name+' '+ C.last_name  = @CutomerName;

END

select * from SALES.Customers
select * from SALES.Orders
select * from SALES.Order_Items
select* from PRODUCTION.Products

Exec GetAllBoughtProductsForClient 'Lyndsey Bean'



RESTORE HEADERONLY FROM DISK = 'C:\backup\CRMDB_AUTO.BAK'



SELECT  CHARINDEX('H','HELLO EVERY ONE IN THIS WORLD')
AS [INDEX]