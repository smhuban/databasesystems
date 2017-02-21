-- Sean Huban
-- Lab 5
-- Professor Labouseur
-- Due 2/21/2017 @ 11:00 am
-- SQL Queries: the joins Three-quel

-- 1. Show	the	cities	of	agents	booking	an	order	for	a	customer	whose	id	is	'c006'.	Use	joins	
-- this	time;	no	subqueries.	
SELECT agents.city
	FROM customers, 
			agents, 
				orders
	WHERE orders.aid = agents.aid
		AND orders.cid = customers.cid
		AND customers.cid = 'c006';

-- 2. Show	the	ids	of	products	ordered	through	any	agent	who	makes	at	least	one	order	for	
-- a	customer	in	Kyoto,	sorted	by	pid	from	highest	to	lowest.	Use	joins;	no	subqueries.	
SELECT distinct products.pid
	FROM orders 
			INNER JOIN agents ON orders.aid = agents.aid
            INNER JOIN customers ON orders.cid = customers.cid
            INNER JOIN products ON orders.pid = products.pid
		WHERE customers.city = 'Kyoto'
            ORDER BY pid DESC;

-- 3. Show	the	names	of	customers	who	have	never	placed	an	order.	Use	a	subquery.	
SELECT Name
	FROM customers
	WHERE cid NOT IN (
		SELECT cid
			FROM orders);

-- 4. Show	the	names	of	customers	who	have	never	placed	an	order.	Use	an	outer	join.	
SELECT name
	FROM customers
	WHERE cid NOT IN (
		SELECT customers.cid
            FROM customers RIGHT OUTER JOIN orders ON orders.cid = customers.cid
                  );


-- 5. Show	the	names	of	customers	who	placed	at	least	one	order	through	an	agent	in	their	
-- own	city,	along	with	those	agent(s')	names.	
SELECT agents.name, 
		customers.name
	FROM  orders INNER JOIN customers ON orders.cid = customers.cid
            INNER JOIN agents ON orders.aid = agents.aid
    WHERE agents.city = customers.city;

-- 6. Show	the	names	of	customers	and	agents	living	in	the	same	city,	along	with	the	name	
-- of	the	shared	city,	regardless	of	whether	or	not	the	customer	has	ever	placed	an	order	
-- with	that	agent.	
SELECT customers.name, 
		customers.city,
			agents.name,
				agents.city
	FROM customers, agents
	WHERE customers.city = agents.city;

-- 7. Show	the	name	and	city	of	customers	who	live	in	the	city	that	makes	the	fewest
-- different	kinds	of	products.	(Hint:	Use	count	and	group	by	on	the	Products	table.)
SELECT name, 
		city
	FROM customers
	WHERE city IN (
        SELECT city
            FROM products
               	GROUP BY city
               	ORDER BY count(pid)
        		limit 1
               );












