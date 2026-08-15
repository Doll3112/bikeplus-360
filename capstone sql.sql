create database retail_sales;
use retail_sales;
select* from retail_sales.brands1;
select * from retail_sales.order_items1;
select*from retail_sales.categories1;
select*from retail_sales.orders1;
select*from retail_sales.products1;
select*from retail_sales.staff1;
select*from retail_sales.stock1;
select*from retail_sales.stores1;
select*from retail_sales.customers1;

-- task 3(inner joints for order details)
select o.order_id,o.order_date,p.product_name,oi.quantity,oi.list_price,oi.discount
from retail_sales.orders1 as o
inner join retail_sales.order_items1 as oi
on o.order_id=oi.order_id
inner join retail_sales.products1 as p
on oi.product_id=p.product_id;

-- task 4(total sales by store)
select s.store_name,sum(oi.total_price) as total_sales
from retail_sales.stores1 as s
inner join retail_sales.orders1 as o
on s.store_id = o.store_id
inner join retail_sales.order_items1 as oi
on o.order_id = oi.order_id
group by s.store_name
order by total_sales desc;

-- task 5(top 5 selling products)
select p.product_name, sum(oi.quantity) as total_quantity
from retail_sales.products1 as p
inner join retail_sales.order_items1  as oi
on p.product_id = oi.product_id
group by p.product_name
order by total_quantity desc
limit 5;

-- task 6(customer purchase summary)
select c.customer_id,c.first_name,c.last_name,count(distinct o.order_id) as total_orders,sum(oi.quantity) as total_items,sum(oi.total_price) as total_revenue
from retail_sales.customers1 as c
inner join retail_sales.orders1  as o
on c.customer_id = o.customer_id
inner join retail_sales.order_items1 as oi
on o.order_id = oi.order_id
group by c.customer_id,c.first_name,c.last_name;

-- task 8(staff performance analysis)
select s.staff_id,s.first_name,s.last_name,count(distinct o.order_id) as total_orders,sum(oi.total_price) as total_revenue
from retail_sales.staff1 as s
inner join retail_sales.orders1 as o
on s.staff_id = o.staff_id
inner join retail_sales.order_items1 as oi
on o.order_id = oi.order_id
group by s.staff_id,s.first_name,s.last_name
order by total_revenue desc;

-- task 9(stock alert query)
select s.store_name,p.product_name,st.quantity
from retail_sales.stock1 as st
inner join retail_sales.stores1 as s
on st.store_id = s.store_id
inner join retail_sales.products1 as p
on st.product_id = p.product_id
where st.quantity < 10;

-- task 7(customer segmentation)
select c.customer_id,c.first_name,c.last_name,sum(oi.total_price) as total_spend,
    case
        WHEN SUM(oi.total_price) < 1000 THEN 'Low'
        WHEN SUM(oi.total_price) BETWEEN 1000 AND 5000 THEN 'Medium'
        ELSE 'High'
    END AS customer_segment
FROM customers1 AS c
INNER JOIN orders1 AS o
ON c.customer_id = o.customer_id
INNER JOIN order_items1 AS oi
ON o.order_id = oi.order_id
GROUP BY c.customer_id,c.first_name,c.last_name;

-- task 10(segmentation table)
CREATE TABLE customer_segments (
    customer_id INT PRIMARY KEY,
    total_spend DECIMAL(10,2),
    customer_segment VARCHAR(20)
);
INSERT INTO customer_segments (customer_id, total_spend, customer_segment)

SELECT
    c.customer_id,
    SUM(oi.total_price) AS total_spend,
    CASE
        WHEN SUM(oi.total_price) < 1000 THEN 'Low'
        WHEN SUM(oi.total_price) BETWEEN 1000 AND 5000 THEN 'Medium'
        ELSE 'High'
    END AS customer_segment
FROM customers1 AS c
INNER JOIN orders1 AS o
ON c.customer_id = o.customer_id
INNER JOIN order_items1 AS oi
ON o.order_id = oi.order_id
GROUP BY c.customer_id;
SELECT * FROM customer_segments;

