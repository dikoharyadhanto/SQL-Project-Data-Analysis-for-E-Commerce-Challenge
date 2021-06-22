show tables;

-- Create users Table
create table users
(
userID int,
nama_user varchar(1000),
kodepos int,
email varchar(1000),
primary key(userID),
fulltext(nama_user, email)
) Engine = InnoDB;

-- Review users Table 
select * from users limit 5; 

-- Describe users Table
desc users;

-- Show Code of Creating users Table
show create table users;

-- Delete users Table
drop table users;
