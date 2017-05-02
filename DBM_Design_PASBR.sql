--Sean Huban
--Database Design Project
--PlayStation All-Stars Battle Royale
--Database Management 
--Professor Labouseur 
--5/2/2017


--CREATE TABLE STATEMENTS

--1
--Attack Table
CREATE TABLE Attack (
 attackID CHAR(4) UNIQUE NOT NULL,
 cID CHAR(4) NOT NULL REFERENCES Characters(cID),
 attackName TEXT NOT NULL,
 damage INTEGER,
 CHECK(damage > 0),
 Primary key(attackID, cID)
);

--2
--Characters Table
CREATE TABLE Characters (
 cID CHAR(4) UNIQUE NOT NULL,
 cName TEXT NOT NULL,
 description TEXT,
 type TEXT NOT NULL,
 lore TEXT NOT NULL,
 PRIMARY KEY(cID)
);

--3
--First_Stage Table
Create table First_Stage (
 sID CHAR(4) NOT NULL REFERENCES Stages(sID),
 aID CHAR(4) NOT NULL REFERENCES Map_Attributes(aID),
 PRIMARY KEY(sID)
);

--4
--Second_Stage Table
Create table Second_Stage (
 sID CHAR(4) NOT NULL REFERENCES Stages(sID),
 aID CHAR(4) NOT NULL REFERENCES Map_Attributes(aID),
 PRIMARY KEY(sID)
);

--5
--Map_Attributes Table
CREATE TABLE Map_Attributes (
 aID CHAR(4) UNIQUE NOT NULL,
 sID CHAR(4) NOT NULL REFERENCES Stages(sID),
 aName TEXT,
 description TEXT,
 damage INTEGER,
 CHECK (damage > 0),
 PRIMARY KEY(aID)
);

--5
--Map_Attributes Table
REATE TABLE Map_Attributes (
 aID CHAR(4) UNIQUE NOT NULL,
 sID CHAR(4) NOT NULL REFERENCES Stages(sID),
 aName TEXT,
 description TEXT,
 damage INTEGER,
 CHECK (damage > 0),
 PRIMARY KEY(aID)
);

--6
--Tier Table
CREATE TABLE Tier (
 tID CHAR(4) NOT NULL,
 level TEXT NOT NULL,
 cID CHAR(4) NOT NULL REFERENCES Characters(cID),
 PRIMARY KEY(tID, cID)
);

--7
--Player_Character Table
CREATE TABLE Player_Character (
 pID CHAR(4) NOT NULL REFERENCES Players(pID),
 cID CHAR(4) NOT NULL REFERENCES Characters(cID),
 PRIMARY KEY(pID, cID)
);

--8
--Players Table
CREATE TABLE Players (
 pID CHAR(4) UNIQUE NOT NULL,
 psnID TEXT NOT NULL,
 password VARCHAR(20) NOT NULL,
 fName TEXT,
 lName TEXT,
 DOB DATE NOT NULL,
 favCharacter TEXT,
 favStage TEXT,
 PRIMARY KEY (pID)
);

--9
--Player_Match Table
CREATE TABLE Player_Match (
 pID CHAR(4) NOT NULL REFERENCES Players(pID),
 matchID CHAR(4) NOT NULL REFERENCES Match(matchID),
 PRIMARY KEY(pID, matchID)
);

--10
--Character_Match Table
CREATE TABLE Character_Match (
 cID CHAR(4) NOT NULL REFERENCES Characters(cID),
 matchID CHAR(4) NOT NULL REFERENCES Match(matchID),
 PRIMARY KEY(cID, matchID)
);

--11
--Match Table
CREATE TABLE Match (
 matchID CHAR(4) UNIQUE NOT NULL,
 date DATE NOT NULL,
 time INTEGER,
 type TEXT NOT NULL,
 stockLives INTEGER,
 playerCount INTEGER NOT NULL,
 sID CHAR(4) UNIQUE NOT NULL REFERENCES Stages(sID),
 CHECK (time > 0),
 CHECK(stockLives > 0),
 CHECK(playerCount >= 1),
 PRIMARY KEY(matchID,sID)
);

--12
--Items Table
CREATE TABLE Items (
 itemID CHAR(4) UNIQUE NOT NULL,
 name TEXT NOT NULL,
 description TEXT,
 damageGiven INTEGER NOT NULL,
 matchID CHAR(4) NOT NULL REFERENCES Match(matchID),
 CHECK (damageGiven > 0),
 Primary key(itemID, matchID)
);

--13
--Stages Table
CREATE TABLE Stages (
 sID CHAR(4) UNIQUE NOT NULL,
 sName TEXT NOT NULL,
 description TEXT,
 sLore TEXT,
 song TEXT NOT NULL,
 PRIMARY KEY(sID)
);


--
--VIEWS
--

--CharacterPlayer View
CREATE view CharacterPlayer AS
SELECT Characters.*, psnID, fName, favCharacter
FROM Players, Characters, Player_Character
	WHERE Players.pID = Player_Character.pID
	AND Characters.cID = Player_Character.cID
;

--Match View
CREATE view matchView AS
SELECT m.matchID, m.date, m.time, m.type, m.stockLives,m.playerCount,
s.sid, s.sName, s.description, s.sLore, c.cName, p.lName
	FROM match m, Stages s, Characters c, Character_Match cm,Players p, Player_Match pm
		WHERE m.sID = s.sID
			AND c.cID = cm.cID
			AND cm.matchID = m.matchID
			AND p.pID = pm.pID
			AND pm.matchID = m.matchID
			;
			
--Database View 
CREATE view dbView AS
SELECT p.pID, p.fName, p.lName, p.dob, p.favCharacter,p.favStage,
	m.matchID, m.date, m.time, m.type, m.stockLives, m.playerCount, s.*, c.*,
	i.itemID, i.Name, i.Description, i.damageGiven,t.tID, t.level,
	a.sID, a.attackName, a.damage
FROM Players p, Match m, Player_Match pm, Stages s, Characters
	c, Player_Character pc, Character_Match cm,Items i, Tier t, Attack a
WHERE p.pID = pm.pID
	AND pm.matchID = m.matchID
	AND m.sID = s.sID
	AND c.cID = cm.cID
	AND p.pID = pc.pID
	AND c.cID = pc.cID
	AND c.cID = cm.cID
	AND i.matchID = m.matchID
	AND t.cID = c.cID
	AND a.cID = c.cID
;

--
--QUERIES AND REPORTS
--

--Strongest Attack
SELECT c.cID, c.cName, a.attackName, a.damage 
	AS highestDamage
		FROM Characters c, Attack a
			WHERE c.cid = a.cID
ORDER BY a.damage DESC
limit 1
;

--WhoAttack
SELECT p.pid, p.firstName, c.cid, c.cName, a.attackName, a.damage
	FROM Characters c, Players p, Player_Character pc, Attack a
		WHERE p.pID = pc.pID
			AND pc.cID = c.cID
			AND c.cID = mo.cID
ORDER BY a.damage DESC
limit 1
;

--
--STORED PROCEDURES
--

--Player-Character/Stage
CREATE OR REPLACE function playerCharacterStage(text,REFCURSOR) 
RETURNS REFCURSOR AS
$$
DECLARE
 stage text := $1;
 resultSet REFCURSOR := $2;
BEGIN
 OPEN resultSet FOR
 select p.pID, p.psnID, c.cID, c.cName
from Players p, Characters c, Player_Match pm,Character_Match cm, Match m, Stages s
	where p.pID = pm.pID
		and pm.matchID = m.matchID
		and c.cID = cm.cID
		and cm.matchID = m.matchID
		and m.sID = s.sID
		and s.sName = stage;
 RETURN resultSet;
END;
$$
language plpgsql;

--Character-Attacks
CREATE OR REPLACE function characterAttacks(text, REFCURSOR)
	RETURN REFCURSOR as
$$
DECLARE
	character text := $1;
	resultSet REFCURSOR := $2;
BEGIN
 OPEN resultSet FOR
 SELECT c.cName, a.attackID, a.attackName, a.damage, c.cid
	FROM Attack a, Characters c
	WHERE c.cID = a.ciID
		AND c.cName = character;
RETURN resultSet;
END;
$$
language plpgsql;

--
--TRIGGERS
--

--Add Player
CREATE OR REPLACE FUNCTION addPlayer() RETURNS trigger AS
$$
BEGIN
IF NEW.pID is null THEN
	raise exception 'Invalid pid';
 END IF;
IF NEW.psnID IS NULL THEN
	raise exception 'Invalid PlayStation Network ID';
 END IF;
IF NEW.password IS NUL THEN
	raise exception 'Invalid password';
 END IF;
INSER INTO Players(pID, psdID, password, fName,lName, dob, favCharacter, favStage)
values (NEW.pID, NEW.psnID, NEW.password,NEW.fName, NEW.lName, NEW.dob, NEW.favCharacter,NEW.favStage);
RETURN new;
END;
$$ language plpgsql;

CREATE trigger addPlayer
AFTER INSERT ON Players
FOR EACH ROW EXECUTE procedure addPlayer();

--
--SECURITY
--

--Admin
CREATE role admin
GRANT SELECT, INSERT, UPDATE, DELETE
ON all tables IN schema PUBLIC
to admin
;

--Player
CREATE role player
GRANT SELECT
on Players, Stages, first_Stage, Second_Stage, Map_Attributes,
Match, Characters, Attack, Tier, Items
to player

































