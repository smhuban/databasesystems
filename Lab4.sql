-- Sean Huban
-- Lab 4
-- Professor Labouseur
-- Due 2/14/2017 @ 11:00 am
-- SQL Queries- The Subqueries Sequel

-- 1. Get	the	cities	of	agents	booking	an	order	for	a	customer	whose	cid	is	'c006'.	
SELECT city
	FROM agents
WHERE aid in (
  SELECT aid
  FROM orders
  WHERE cid = 'c006'
  );

-- 2. Get	the	distinct	ids	of	products	ordered	through	any	agent	who	takes	at	least	one	
-- order	from	a	customer	in	Kyoto,	sorted	by	pid	from	highest	to	lowest.	(This	is	not	the	
-- same	as	asking	for	ids	of	products	ordered	by	customers	in	Kyoto.)
SELECT distinct pid
	FROM orders
WHERE aid in (
  SELECT aid
	FROM orders
  WHERE cid in (
    SELECT cid
    FROM customers
    WHERE city = 'Kyoto'
  )
)
ORDER BY pid DESC;

-- 3. Get	the	ids	and	names	of	customers	who	did	not	place	an	order	through	agent	a01.	
SELECT cid, name
	FROM customers
WHERE cid not in (
  SELECT distinct cid
  FROM orders
  WHERE aid = 'a01'
  );

-- 4. Get	the	ids	of	customers	who	ordered	both	product	p01	and	p07.	
SELECT cid
	FROM customers
WHERE cid in (
  SELECT distinct cid
	FROM orders
  WHERE pid = 'p01' and cid in (
    SELECT cid
		FROM orders
    WHERE pid = 'p07'
    )
);

-- 5. Get	the	ids	of	products	not	ordered	by	any	customers	who	placed	any	order	through	
-- agent	a08	in	pid	order	from	highest	to	lowest.	
SELECT distinct pid
	FROM products
WHERE pid not in (
  SELECT pid
	FROM orders
  WHERE aid = 'a08'
)
ORDER BY pid DESC


-- 6. Get	the	name,	discount,	and	city	for	all	customers	who	place	orders	through	agents	in	
-- Tokyo	or	New	York.	
SELECT name, discount, city
	FROM customers
WHERE cid in (
  SELECT distinct cid
	FROM orders
  WHERE aid in (
    SELECT aid
    FROM agents
    WHERE city = 'Tokyo' or city = 'New York'
  )
);


-- 7. Get	all	customers	who	have	the	same	discount	as	that	of	any	customers	in	Duluth	or	
-- London
SELECT *
	FROM customers
WHERE cid not in (
  SELECT cid
	FROM customers
  WHERE city = 'Duluth' or city = 'London'
)
AND discount in (
  SELECT discount
	FROM customers
  WHERE city = 'Duluth' or city = 'London'
);


-- 8. Tell	me	about	check	constraints:	What	are	they?	What	are	they	good	for?	What’s	the	
-- advantage	of	putting	that	sort	of	thing	inside	the	database?	Make	up	some	examples	
-- of	good	uses	of	check	constraints	and	some	examples	of	bad	uses	of	check	constraints.	
-- Explain	the	differences	in	your	examples	and	argue	your	case.

-- Contraints are steps that you can put in place in a database to make sure your data is valid for your databse purposes.
-- You can implement them to check, confirm, and limit the types of data that can be entered into a database.
-- These are useful because it helps prevent user error, as well as helps keep your database valid and safe from possible exploitation.
-- A good example would be too add a 'NOT NULL' constraint for a customers age, so that the field must be completed and filled out before the form 
-- could be complete. Another good example is to assign a 'unique' contraint to a catagory like customer address so that two customers could not
-- register under the same address. You can use 'check' constraints to check for something specific, for example in a database defining a workers 
-- shift, you could implement a check so that they could only enter the phrase "Opening Shift" or "Closing Shift". A poor use of a check constraint 
-- would be if you implemented a bunch of 'foreign keys' connecting tables across a very large database. Every time an entry was queried or changed 
-- it would result in a very large amount of computing as it would have to check every foreign key for consistensy every time.































