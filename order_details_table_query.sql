show tables;

-- Create order_details Table
create table order_details
(
order_detailID int not null,
order_id int not null,
product_id int not null,
price int,
quantity int,
primary key(order_detailID),
constraint fk_order_details_orders
foreign key (order_id)
references orders(orderID),
constraint fk_order_details_products
foreign key (product_id)
references products(productID)
) Engine = InnoDB;

-- Review order_details Table
select * from order_details limit 5; 

-- Describe order_details Table
desc order_details;

-- Show Code of Creating order_details Table
show create table order_details;

-- Delete order_details Table
drop table order_details;