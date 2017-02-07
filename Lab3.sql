-- Sean Huban
-- Lab 3
-- Professor Labouseur
-- Due 2/7/2017 @ 11:00 am
-- Basic CAP Database Queries

-- 1. List	the	order	number	and	total	dollars	of	all	orders.	

select ordNumber, 
		totalUSD
	from Orders;

-- 2. List	the	name	and	city	of	agents	named	Smith.	

select name,
		city
	from agents
    where name = 'Smith';

-- 3. List	the	id,	name,	and	price	of	products	with	quantity	more	than	200,100.	

select pid,
		name,
        priceUSD
from Products
	where quantity > 200100;

-- 4. List	the	names	and	cities	of	customers	in	Duluth.	

select name,
		city
from Customers
	where city = 'Duluth';

-- 5. List	the	names	of	agents	not	in	New	York	and	not	in	Duluth.	

select name
from agents
    where city not in ('Dallas', 'Duluth'); 
	
-- 6. List	all	data	for	products	in	neither	Dallas	nor	Duluth	that	cost	US$1	or	more.	

select *
from products
    where city not in ('Dallas', 'Duluth') AND priceUSD > 1; 

-- 7. List	all	data	for	orders	in	February	or	May.	

select *
from orders
	where month in ('Feb','May');

-- 8. List	all	data	for	orders	in	February	of	US$600	or	more.	
--		NOTE: In current CAP database this returns 0 results as no current order fits these specifications

select *
from orders
	where month = 'Feb' AND totalUSD > 600;

-- 9. List	all	orders	from	the	customer	whose	cid	is	C005.
--		NOTE: In current CAP database this returns 0 results as no current order fits these specifications

select *
from orders
	where cid = 'C005';


