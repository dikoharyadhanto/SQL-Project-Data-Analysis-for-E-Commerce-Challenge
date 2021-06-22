show tables;

-- Create products Table
create table products
(
productID int,
desc_product varchar(1000),
category varchar(1000),
base_price int,
primary key(productID),
fulltext (desc_product)
) Engine = InnoDB;

-- Review products Table 
select * from products limit 5; 

-- Describe products Table
desc products;

-- Show Code of Creating products Table
show create table products;

-- Delete products Table
drop table products;
