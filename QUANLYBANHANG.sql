CREATE DATABASE QUANLYBANHANG;
USE QUANLYBANHANG;

CREATE TABLE CUSTOMERS(
customer_id VARCHAR(4) NOT NULL PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL,
phone VARCHAR(25) NOT NULL UNIQUE,
address VARCHAR(255) NOT NULL
);

CREATE TABLE ORDERS(
order_id VARCHAR(4) NOT NULL PRIMARY KEY,
customer_id VARCHAR(4) NOT NULL,
FOREIGN KEY(customer_id)REFERENCES CUSTOMERS(customer_id),
order_date DATE NOT NULL,
total_amont DOUBLE NOT NULL
);

CREATE TABLE PRODUCTS(
product_id VARCHAR(4) NOT NULL PRIMARY KEY,
name VARCHAR(255) NOT NULL,
description TEXT,
price DOUBLE NOT NULL,
status BIT(1) NOT NULL default(1)
);

CREATE TABLE ORDERS_DETAILS(
order_id VARCHAR(4) NOT NULL,
FOREIGN KEY(order_id) REFERENCES ORDERS(order_id),
product_id VARCHAR(4) NOT NULL,
FOREIGN KEY(product_id) REFERENCES PRODUCTS(product_id),
PRIMARY KEY(order_id,product_id),
quantity INT(11) NOT NULL,
price DOUBLE NOT NULL
);

INSERT INTO customers(customer_id,name,email,phone,address) VALUES
('C001','Nguyễn Trung Mạnh','manhnt@gmail.com','984756322','Cầu giấy, Hà Nội'),
('C002','Hồ Hải Nam','namhh@gmail.com','984875926','Ba Vì, Hà Nội'),
('C003','Tô Ngọc Vũ','vutn@gmail.com','904725784','Mộc Châu, Sơn La'),
('C004','Phạm Ngọc Anh','anhpn@gmail.com','984635365','Vinh, Nghệ An'),
('C005','Trương Minh Cường','cuongtm@gmail.com','989735624','Hai Bà Trưng, Hà Nội');

INSERT INTO products(product_id,name,description,price) VALUES
('P001','Iphone 13 ProMax','Bản 512Gb, Xanh lá','22999999'),
('P002','Dell Vostro V3510','Core i5, RAM 8GB, Xanh lá','14999999'),
('P003','Macbook Pro M2','8CPU 10GPU 8GB 256GB, Xanh lá','28999999'),
('P004','Apple Watch Ultra','Titan Alpine Loop Small','18999999'),
('P005','Airpods 2 2022','Spatial Audio','4090000');

INSERT INTO ORDERS (order_id,customer_id,total_amont,order_date) VALUES
	('H001','C001',52999997,'2023/2/22'),
    ('H002','C001',80999997,'2023/3/11'),
    ('H003','C002',54359998,'2023/1/22'),
    ('H004','C003',102999995,'2023/3/14'),
    ('H005','C003',80999997,'2022/3/12'),
    ('H006','C004',110449994,'2023/2/1'),
    ('H007','C004',79999996,'2023/3/29'),
    ('H008','C005',29999998,'2023/2/14'),
    ('H009','C005',28999999,'2023/1/10'),
    ('H010','C005',149999994,'2023/4/1');
    
INSERT INTO ORDERS_DETAILS (order_id,product_id,price,quantity) VALUES
	('H001','P002',14999999,1),
    ('H001','P004',18999999,2),
    ('H002','P001',22999999,1),
    ('H002','P003',28999999,2),
    ('H003','P004',18999999,2),
    ('H003','P005',4090000,4),
    ('H004','P002',14999999,3),
    ('H004','P003',28999999,2),
    ('H005','P001',22999999,1),
    ('H005','P003',28999999,2),
    ('H006','P005',4090000,5),
    ('H006','P002',14999999,6),
    ('H007','P004',18999999,3),
    ('H007','P001',22999999,1),
    ('H008','P002',14999999,2),
    ('H009','P003',28999999,1),
    ('H010','P003',28999999,2),
    ('H010','P001',22999999,4);
    
    
-- Bài 3: Truy vấn dữ liệu [30 điểm]:
-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .[4 điểm]
select name,email,phone,address from customers;

-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng). [4 điểm]
select c.name,c.phone,c.address
from customers c
join orders o on c.customer_id=o.customer_id
where month(o.order_date)=3 and year(o.order_date)=2023;

-- 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu ). [4 điểm]
select month(order_date) as 'Tháng',sum(total_amont) as 'Tổng doang thu'
from orders
where year(order_date)=2023
group by month(order_date);

-- 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại). [4 điểm]
select c.name,c.phone,c.address
from customers c
left join orders o on c.customer_id=o.customer_id and month(o.order_date)=2 and year(o.order_date)=2023
where o.customer_id is null;

-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra). [4 điểm]
select p.product_id,p.name,sum(od.quantity)as 'Số lượng bán ra'
from products p
join orders_details od on p.product_id=od.product_id
join orders o on od.order_id = o.order_id
where month(o.order_date)=3 and year(o.order_date)=2023
group by p.product_id,p.name;

-- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm]
select c.customer_id, c.name as 'Tên khách hàng', SUM(o.total_amont) AS 'Mức chi tiêu'
from customers c
left join orders o on c.customer_id = o.customer_id
where year(o.order_date) = 2023
group by c.customer_id, c.name
order by 'Mức chi tiêu' DESC;

-- 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . [5 điểm]
select c.name,o.total_amont,o.order_date, SUM(od.quantity) AS total_quantity
from CUSTOMERS c
join ORDERS o on c.customer_id = o.customer_id
join ORDERS_DETAILS od on o.order_id = od.order_id
group by c.name, o.order_id
having total_quantity >= 5;

-- Bài 4: Tạo View, Procedure [30 điểm]:
-- 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn . [3 điểm]
create view vw_order_info as
select c.name as 'Tên khách hàng', c.phone as 'Số điện thoại', c.address as 'Địa chỉ', o.total_amont as 'Tổng tiền', o.order_date AS 'Ngày tạo hoá đơn'
from customers c
join orders o on c.customer_id = o.customer_id;
-- 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt. [3 điểm]
create view vw_customers_info as
select c.name as 'Tên khách hàng', c.address as 'Địa chỉ', c.phone as 'Số điện thoại', COUNT(o.order_id) as 'Tổng số đơn đã đặt'
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.name, c.address, c.phone;

select * from vw_customers_info;

-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm.[3 điểm]
create view vw_products_info as
select p.name as 'Tên sản phẩm', p.description AS 'Mô tả', p.price AS 'Giá', SUM(od.quantity) AS 'Tổng số đã bán'
from products p
left join orders_details od on p.product_id = od.product_id
group by p.product_id, p.name, p.description, p.price;

select * from vw_products_info;
-- 4. Đánh Index cho trường `phone` và `email` của bảng Customer. [3 điểm]
create INDEX idx_phone ON customers (phone);

-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.[3 điểm]
delimiter &&
create procedure getCustomerInfo(in id varchar(4))
begin
    select * from customers
    where customer_id = id;
end;
&&

call getCustomerInfo('C002');
-- 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. [3 điểm]
delimiter &&
create procedure getProductInfo(in id varchar(4))
begin
    select * from products
    where product_id = id;
end;
&&

-- 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. [3 điểm]
delimiter &&
create procedure getOrderInfo(in id varchar(4))
begin
    select o.order_id, o.order_date, o.total_amont
    from orders o
    where o.customer_id = id;
end;
&&
call getOrderInfo('C002');
-- 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. [3 điểm]
delimiter &&
create procedure newOrder(
	in order_id VARCHAR(4),
    in customer_id VARCHAR(4),
    in p_total_amount DOUBLE,
    in p_order_date DATE)
begin
     INSERT INTO orders (order_id,customer_id, total_amont, order_date) values (order_id,customer_id, p_total_amount, p_order_date);
     select  order_id AS 'New Order ID';
end;
&&

call newOrder('H011','C001','999999','2023-11-23');

-- 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc. [3 điểm]
delimiter &&
create procedure quantity_sold_of_each_product(
    in start_date date,
    in end_date date
)
begin
    select p.product_id,p.name,SUM(od.quantity) AS total_quantity
    from products p
    join orders_details od ON p.product_id = od.product_id
    join orders o ON od.order_id = o.order_id
    where o.order_date >= start_date AND o.order_date <= end_date
    group by p.product_id, p.name;
end;
&&

call quantity_sold_of_each_product('2023-01-01', '2023-12-31');
-- 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê. [3 điểm]
delimiter &&
create procedure quantity_sold_of_each_product_ranker(
    in p_month INT,
    in p_year INT
)
begin
    select p.product_id,p.name,SUM(od.quantity) AS total_quantity
    from products p
    join orders_details od ON p.product_id = od.product_id
    join orders o ON od.order_id = o.order_id
    where month(o.order_date) = p_month and year(o.order_date) = p_year
    group by p.product_id, p.name
    order by total_quantity DESC;
end;
&&
call quantity_sold_of_each_product_ranker(3, 2023);