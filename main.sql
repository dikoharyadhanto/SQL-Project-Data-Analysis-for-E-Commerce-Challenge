use project1;

-- List Tables on Database
show tables;

-- order_details
select * from order_details limit 5; 
desc order_details;

-- orders
select * from orders limit 5; 
desc orders;

-- products
select * from products limit 5; 
desc products;

-- users
select * from users limit 5; 
desc users;

-- CHECKING DATASET ---------------------------------------------------------------

-- products table -----------------------------------------------------------------
# checking null and total records
select count(productID)
from products;

select * from products
where base_price is null;

select category, count(productID)
from products
group by category;

-- orders table ----------------------------------------------------------------
# creating new columns as status_order
select orderID, created_at, paid_at, delivery_at,
CASE
    WHEN paid_at is not null and delivery_at is not null then 'Completed'
    WHEN paid_at is null and delivery_at is null then 'Unpaid'
    WHEN paid_at is not null and delivery_at is null then 'Paid & Undelivered'
    ELSE 'None'
END AS status
from orders;

# checking null and total records
select count(orderID)
from orders;
select count(orderID) from orders
where created_at is null;
select count(orderID) from orders
where paid_at is null;
select count(orderID) from orders
where delivery_at is null;
select count(orderID) from orders
where paid_at is not null and delivery_at is null;

#created order table based on create_at
select orderID, created_at
from orders
order by created_at;

-- users table ------------------------------------------------
# checking null and total records
select count(distinct userID)
from users;

-- order_details table ------------------------------------------------
# checking null and total records
select count(order_detailID)
from order_details;

-- orders table -------------------------------------------------------
# number of users who are buyer or/and seller, or neither
select count(orderID)
from orders
where paid_at is null;

select count(orderID)
from orders
where paid_at is not null AND delivery_at is null;

select count(orderID)
from orders
where delivery_at = paid_at;

select count(distinct buyer_id)
from orders
where buyer_id is not null;

select count(distinct seller_id)
from orders
where seller_id is not null;

select count(distinct seller_id)
from orders
where buyer_id is not null;


-- ANALYSIS ------------------------------------------------------------
# Who are the 5 users with the highest purchase value?
select userID, nama_user, sum(total) as total
from users
join orders
on (userID = buyer_id)
group by userID
order by total desc limit 5;


# Users with the highest number of transactions but never use discounts
select userID, nama_user, count(total) as total
from users
join orders
on (userID = buyer_id)
group by userID
having sum(discount) = 0
order by total desc limit 5;


# Particular Email domain of seller
select distinct seller_id, substring_index(email, '@', -1) as domain_name
from users
join orders
on(seller_id = userID)
where substring_index(email, '@', -1) = 'cv.web.id' or
	  substring_index(email, '@', -1) = 'cv.com' or
	  substring_index(email, '@', -1) = 'cv.net.id' or
      substring_index(email, '@', -1) = 'pt.net.id' or
      substring_index(email, '@', -1) = 'ud.co.id'
order by domain_name;


# Top 5 best selling products in December 2019
select desc_product, sum(quantity) as total_quantity
from  order_details
join products
on (product_id = productID)
join (select * from orders
where paid_at between '2019-12-01' and '2019-12-31') as orders2
on (orderID = order_id)
group by desc_product
order by total_quantity desc limit 5;


# transaction value per month
select year(created_at) as Y,
	   month(created_at) as M,
       count(paid_at) as number_of_transaction,
	   sum(total) as transaction_value
from orders
group by Y, M
order by Y, M;


# Big Deals in December 2019
select nama_user as nama_pembeli, total as nilai_transaksi, created_at as tanggal_transaksi
from orders
inner join users on (buyer_id = userID)
where created_at>='2019-12-01' and created_at<'2020-01-01'
and total >= 20000000
order by 1;


# Best Selling Product Category in 2019 and 2020
select category, sum(quantity) as total_quantity, sum(price) as total_price
from orders
inner join order_details on(orders.orderID = order_details.order_id)
inner join products on(order_details.product_id = products.productID)
where created_at>='2020-01-01'
and delivery_at is not null
group by 1
order by 2 desc
limit 5;

select category, sum(quantity) as total_quantity, sum(price) as total_price
from orders
inner join order_details on(orders.orderID = order_details.order_id)
inner join products on(order_details.product_id = products.productID)
where created_at between '2019-01-01' and '2020-01-01'
and delivery_at is not null
group by 1
order by 2 desc
limit 5;

# Looking for high-value buyers
select nama_user as nama_pembeli, count(1) as jumlah_transaksi, sum(total) as total_nilai_transaksi, min(total) as min_nilai_transaksi 
from orders
inner join users on buyer_id = userID
group by userID, nama_user
having count(nama_pembeli) > 5 and min(total) > 2000000
order by total_nilai_transaksi desc;

# Looking for Dropshipper
SELECT
 nama_user AS nama_pembeli,
 count(1) AS jumlah_transaksi,
 count(DISTINCT orders.kodepos) AS distinct_kodepos,
 sum(total) AS total_nilai_transaksi,
 avg(total) AS avg_nilai_transaksi
FROM
 orders 
INNER JOIN
 users
 ON buyer_id = userID
GROUP BY
 userID,
 nama_user
HAVING
 count(1) >= 10 AND count(1) = count(DISTINCT orders.kodepos)
ORDER BY
 2 DESC;
 
# Looking for Reseller Offline
SELECT
 nama_user AS nama_pembeli,
 count(1) AS jumlah_transaksi,
 sum(total) AS total_nilai_transaksi,
 avg(total) AS avg_nilai_transaksi,
 avg(total_quantity) AS avg_quantity_per_transaksi
FROM
 orders
INNER JOIN
 users
 ON buyer_id = userID
INNER JOIN
 (
  SELECT order_id, sum(quantity) AS total_quantity
  FROM order_details
  GROUP BY 1
 ) AS summary_order
 ON orderID = order_id
WHERE
 orders.kodepos = users.kodepos
GROUP BY
 userID,
 nama_user
HAVING
 count(1) >= 8 AND avg(total_quantity) > 10
ORDER BY
 3 DESC;

#user who are both buyer and seller
SELECT
 nama_user AS nama_pengguna,
 jumlah_transaksi_beli,
 jumlah_transaksi_jual
FROM
 users
INNER JOIN
 (
  SELECT buyer_id, count(1) AS jumlah_transaksi_beli
  FROM orders
  GROUP BY 1
 ) AS buyer
 ON buyer_id = userID
INNER JOIN
 (
  SELECT seller_id, count(1) AS jumlah_transaksi_jual
  FROM orders
  GROUP BY 1
 ) AS seller
 ON seller_id = userID
WHERE
 jumlah_transaksi_beli >= 7
ORDER BY
 1;