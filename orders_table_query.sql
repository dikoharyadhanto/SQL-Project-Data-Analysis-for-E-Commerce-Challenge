show tables;

-- Create order Table
create table orders
(
orderID int not null,
seller_id int not null,
buyer_id int not null,
kodepos int,
subtotal int,
discount int,
total int,
created_at date,
paid_at date,
delivery_at date,
primary key (orderID),
constraint fk_products_users
foreign key (buyer_id)
references users(userID),
constraint fk_products_users2
foreign key (seller_id)
references users(userID)
) engine innoDB;

-- Review orders Table 
select * from orders limit 5; 

-- Describe orders Table
desc orders;

-- Show Code of Creating orders Table
show create table orders;

-- Changing "NA" values to become null
update orders
set delivery_at = null
where delivery_at = "NA";

-- Delete orders Table
drop table orders;