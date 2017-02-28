-- Sean Huban
--Lab 6
-- Database Systems
-- 2/28/17



--1. Display	the	name	and	city	of	customers	who	live	in	any	city	that	makes	the	most
--different	kinds	of	products.	(There	are	two	cities	that	make	the	most	different	
--products.	Return	the	name	and	city	of	customers	from	either	one	of	those.)	
SELECT name, city 
	FROM customers
WHERE city IN (SELECT city 
					FROM products
				GROUP BY city
				ORDER BY count(pid) DESC 
				limit 1
              );


--2. Display	the	names	of	products	whose	priceUSD	is	strictly	above	the	average	priceUSD,	
--in	reverse-alphabetical	order.	
SELECT name
	FROM products
WHERE priceusd > (SELECT avg(priceusd)
					FROM products
                 )
ORDER BY name DESC;

--3. Display	the	customer	name,	pid	ordered,	and	the	total	for	all	orders,	sorted	by	total	
--from	low	to	high.	
SELECT customers.name, 
		orders.pid, 
			orders.totalusd
	FROM customers, orders
WHERE orders.cid = customers.cid
ORDER BY orders.totalusd ASC;


--4. Display	all	customer	names	(in	alphabetical	order)	and	their	total	ordered,	and	
--nothing	more.	Use	coalesce	to	avoid	showing	NULLs.	
SELECT customers.name, 
			coalesce(sum(orders.qty), 0) 
	FROM customers
LEFT OUTER JOIN orders ON customers.cid = orders.cid
GROUP BY customers.name
ORDER BY customers.name ASC;

--5. Display	the	names	of	all	customers	who	bought	products	from	agents	based	in	
--Newark	along	with	the	names	of	the	products	they	ordered,	and	the	names	of	the	
--agents	who	sold	it	to	them.	
SELECT customers.name, 
			products.name, 
				agents.name
	FROM customers, 
			orders, 
				products, 
					agents
WHERE orders.cid = customers.cid
  AND orders.pid = products.pid
  AND orders.aid = agents.aid
  AND agents.city = 'Newark';

--6. Write	a	query	to	check	the	accuracy	of	the	totalUSD	column	in	the	Orders	table.	This	
--means	calculating	Orders.totalUSD	from	data	in	other	tables	and	comparing	those	
--values	to	the	values	in	Orders.totalUSD.	Display	all	rows	in	Orders	WHERE	
--Orders.totalUSD	is	incorrect,	if	any.	
SELECT *
	FROM orders, customers, products
WHERE orders.cid = customers.cid
  AND orders.pid = products.pid
  AND orders.totalusd != (products.priceusd * orders.qty * ((100 - customers.discount) / 100));


--7. What’s	the	difference	between	a	LEFT	OUTER	JOIN	and	a	RIGHT	OUTER	JOIN?	Give	
--example	queries	in	SQL	to	demonstrate.	(Feel	free	to	use	the	CAP	database	to	make	
--your	points	here.)

--a left outer join takes and displays all of the rows from the left bound table that have  a match 
-- in the right bound table
SELECT agents.aid
	FROM orders
LEFT OUTER JOIN agents ON orders.aid = agents.aid;

--a right outer join takes and displays all of the rows from the right bound table that have  a match 
-- in the left bound table
SELECT agents.aid
	FROM agents
RIGHT OUTER JOIN orders ON agents.aid = orders.aid;







































