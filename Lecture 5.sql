-- Lecture 5 Data extraction
-- 1. list of customers
select * from customers c ;
-- 2. number of different products?
select count(product_id) from products p ;
-- 3. count of employees
select count(1) from employees e ;
-- 4. total overall revenue
--quantity * unit_price - (quantity * unit_price * discount)
-- more simple -> sum(quantity * unit_price * (1-discount))
select sum(quantity * unit_price * (1- discount)) from order_details od ;
-- 5. total revenue for one specific year
select sum(quantity * unit_price * (1- discount)) from order_details od 
left join orders o on od.order_id = o.order_id
where extract (year from o.order_date ) = '1996';
-- 6. list of countries covered by delivery
select distinct ship_country from orders o ;
-- 7. list of available transporters
select * from shippers s ;
-- 8. number of customer per countries
select count(customer_id), country from customers group by country ;
-- 9. number of orders which are "ordered" but not shipped
select count(order_id) from orders o where shipped_date is null  ;
-- 10. all the orders from france and belgium
select * from orders o where ship_country in ('France', 'Belgium');
-- 11. most expensive products
select * from products p order by unit_price desc limit 5;
-- 12. list of discontinued products
select * from products p where discontinued = 1;
-- 13. count of product per category
select count(product_id) , category_id from products p  group by category_id ; -- OR
select count(product_id), c.category_id from products p left join categories c on c.category_id = p.category_id group by c.category_id ;
-- 14. average order price
select avg(unit_price) , order_id from order_details od group by order_id ;
-- 15. revenue per category
select sum(unit_price * units_on_order) , c.category_id from products p 
left join categories c on c.category_id = p.category_id group by c.category_id ;
-- 16. number of orders per shipper
select count(o.ship_via) , s.shipper_id from orders o left join shippers s on s.shipper_id = o.ship_via group by s.shipper_id ;
-- 17. number of orders per employee
select count(o.order_id) , e.employee_id from orders o left join employees e on e.employee_id = o.employee_id group by e.employee_id;
-- 18. total revenue per supplier
select sum(od.quantity * od.unit_price * (1- od.discount)) as total_rev_per_supp, s.supplier_id from order_details od inner join products p on od.product_id = p.product_id inner join suppliers s on p.supplier_id = s.supplier_id group by s.supplier_id ;
-- 18-b. find the total revenue per region
-- tried region from suppliers table
select sum(od.quantity * od.unit_price * (1- od.discount)) as total_rev_per_supplier_region, s.region from order_details od inner join products p on od.product_id = p.product_id inner join suppliers s on p.supplier_id = s.supplier_id group by s.region  ;
-- tried region from region table
select sum(od.quantity * od.unit_price * (1- od.discount)) as total_rev_per_region, r.region_id, r.region_description from order_details od inner join orders o on o.order_id = od.order_id inner join employees e on e.employee_id = o.employee_id inner join employee_territories et on et.employee_id = e.employee_id inner join territories t on t.territory_id = et.territory_id inner join region r on r.region_id = t.region_id group by r.region_id;
-- tried ship_region from orders table
select sum(od.quantity * od.unit_price * (1- od.discount)) as total_rev_per_ship_region, o.ship_region from order_details od left join orders o on o.order_id = od.order_id group by o.ship_region ; 

-- All of these results give unaccurate values and my guess is that it's because of the NULL values (in the region field) in the table which are not being counted
-- If we change to country instead of region it'll work 