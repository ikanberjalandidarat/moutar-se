CREATE TABLE customers (
    cust_id INT PRIMARY KEY AUTO_INCREMENT,
    name varchar(80) NOT NULL,
    birthdate DATE NOT NULL,
    cust_email varchar(50) NOT NULL,
    cust_phone varchar(15) NOT NULL,
    cust_addr varchar(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    cust_id INT NOT NULL,
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id),
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    order_price double NOT NULL,
    payment_opt char(50) NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name varchar(80) NOT NULL,
    product_stock INT,
    product_storage_loc varchar(50) NOT NULL,
    product_price double NOT NULL,
    product_gender char NOT NULL
);

CREATE TABLE receipt (
    receipt_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT not null,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    order_id INT not null,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    quantity_order INT not null,
    receipt_log_time TIME not null

)

-- DATA DUMP -- 
-- Can add more if you'd like -- 

INSERT into customers (name, birthdate, cust_email, cust_phone, cust_addr)
VALUES ('John', '2000-06-24', 'john@apple.com', '62878751820', 'Jl. Bekasi'), 
('Mina','1995-12-12','mina@google.com', '617789201', 'Jl. Jakarta'), 
('Alia','2001-06-04','alia@gmail.com','6728192201', 'Jl. Bandung'),
('Patrick','1997-03-01','patrick@live.com','62878752210', 'Jl. Medan'),
('Syah', '1990-08-09', 'syah@yahoo.com','62789264141','Jl. Senayan'),
('Iskandar','1989-10-11','iskandar@outlook.com','62718391029','Jl. Dharmawangsa');


INSERT into products(product_name, product_stock, product_storage_loc, product_price, product_gender) 
VALUES ('Brown Bag', 20, 'JKT', 100000, 'F'), 
('Leather Jacket', 4, 'BDG', 200000, 'M'), 
('Crocs', 30, 'JKT', 50000, 'F'),
('Outershirt Purple', 5, 'JKT', 75000, 'F'),
('Sundress', 10, 'BDG', 100000, 'F'),
('Suit Tie', 9, 'JKT', 200000, 'M'),
('Watch Sporty', 3, 'JKT', 30000, 'M');

INSERT into orders(cust_id, order_date, order_time, order_price, payment_opt) 
VALUES (1, '2021-05-04', '18:05:01',50000, 'CC'), 
(2, '2021-05-04', '18:00:15', 200000, 'COD'),
(3, '2021-05-04', '18:00:00', 75000, 'DC');

INSERT into orders(cust_id, order_date, order_time, order_price, payment_opt) 
VALUES (1, '2021-05-04', '18:15:01',50000, 'CC'), 
(3, '2021-05-04', '18:08:15', 200000, 'COD');

INSERT into receipt(product_id, order_id, quantity_order, receipt_log_time)
VALUES (3, 1, 1, '18:10:10'), (2,2,1,'18:05:06'), (4, 3, 1, '18:03:10');

INSERT into receipt(product_id, order_id, quantity_order, receipt_log_time)
VALUES (3, 4, 1, '18:16:10'), (2,3,1,'18:15:06');


-- Best seller product male and female -- 

-- Female:

select products.product_id, products.product_name, count(products.product_id) from products join receipt on products.product_id = receipt.product_id
where products.product_gender = 'F' 
group by product_id
order by count(products.product_id) desc limit 1; 

-- Male:

select products.product_id, products.product_name, count(products.product_id) from products join receipt on products.product_id = receipt.product_id
where products.product_gender = 'M' 
group by product_id
order by count(products.product_id) desc limit 1; 


-- Customer that spends most money: -- 
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY','')); --> Had to setup something 

select customers.cust_id, customers.name, sum(orders.order_price) as 'total purchase' from orders join customers where orders.cust_id = customers.cust_id group by orders.cust_id desc limit 1; 


-- Show number of transaction every two hours: -- 

select date_sub(NOW(), interval 2 hour); --> Just checking

-- Manually: -- 

select count(receipt.receipt_id) from orders join receipt on orders.order_id = receipt.order_id
where receipt.receipt_log_time >= (select date_sub(NOW(), interval 2 hour)); --> This returns all tx before NOW()-2 hours

SELECT receipt_log_time FROM receipt GROUP BY receipt_log_time DIV 2;

SELECT receipt_log_time as Time, COUNT(receipt_id) as total
From receipt join orders on receipt.order_id = orders.order_id
where orders.order_date =  CURDATE() --> This will return null, since I have no data dump today
group by receipt_log_time; 


-- REVISE -- 

GROUP BY hour(time), floor(minute(time)/30)

SELECT receipt_log_time as Time, COUNT(receipt_id) as total
From receipt join orders on receipt.order_id = orders.order_id
where orders.order_date =  '2021-05-04' and receipt.receipt_log_time <
group by receipt_log_time;

SELECT receipt_log_time 'time',
HOUR('24:00:00')/12 'hr', COUNT(DISTINCT receipt_id) 
FROM receipt join orders on receipt.order_id = orders.order_id
where orders.order_date =  '2021-05-04' 
GROUP BY hr;

SELECT h.theHour, COUNT(receipt_id) AS numberoftx
  FROM ( SELECT 0 AS theHour
         UNION ALL SELECT 1
         UNION ALL SELECT 2
         UNION ALL SELECT 3
         UNION ALL SELECT 4
         UNION ALL SELECT 5
         UNION ALL SELECT 6
         UNION ALL SELECT 7
         UNION ALL SELECT 8
         UNION ALL SELECT 9
         UNION ALL SELECT 10
         UNION ALL SELECT 11 ) AS h
LEFT OUTER
  JOIN receipt 
    ON EXTRACT(HOUR FROM receipt.receipt_log_time) = h.theHour
GROUP BY h.theHour; --> Since no data dump all return 0.


-- Make it into two hours --

SELECT h.theHour, COUNT(receipt_id) AS numberoftx
  FROM ( SELECT 0 AS theHour
         UNION ALL SELECT 2
         UNION ALL SELECT 4
         UNION ALL SELECT 6
         UNION ALL SELECT 8
         UNION ALL SELECT 10 ) AS h
LEFT OUTER
  JOIN receipt 
    ON EXTRACT(HOUR FROM receipt.receipt_log_time) = h.theHour
GROUP BY h.theHour;
