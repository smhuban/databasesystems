--Sean Huban
--Professor Labouseur
--3/28/17
--Lab 8:Normalization Two





--PART 2: SQL CREATE STATEMENTS

CREATE TABLE CastandCrew (
  PID		CHAR(10) REFERENCES People(PID),
  MID		CHAR(10),
  GivenTitle		TEXT,
 primary key(PID, MID, Title)
);

CREATE TABLE People (
  PID      	CHAR(10),
  Name		TEXT,
  Address	CHAR(50),
 primary key(PID)
);

CREATE TABLE Movies (
  MID		CHAR(10),
  Title		TEXT,	
  YearReleased	DATE,
  MPAA		INT,
  SalesDomestic	DECIMAL(15,2),
  SalesForeign	DECIMAL(15,2),
  SalesDVD	DECIMAL(15,2),
 primary key(MID)
);

CREATE TABLE Actors (
  PID      	CHAR(10) REFERENCES People(PID),
  BirthDate	DATE,
  HairColor	CHAR(25),
  EyeColor	CHAR(25),
  Height	INT,
  Weight	INT,
  SpouseName	TEXT,
  FavoriteColor	CHAR(25),
  SAGAnniversary	DATE,
 primary key(PID)
);

CREATE TABLE Directors (
  PID		CHAR(10) REFERENCES People(PID),
  SpouseName	TEXT,
  FilmSchool	TEXT,
  DGAnniversary	DATE,
  FavoriteLens	CHAR(50),
 primary key(PID)
);

--PART 4: SQL QUERY

select p.Name
FROM People p INNER JOIN CastandCrew c ON p.PID = c.PID
WHERE GivenTitle = 'Director'
and c.MID IN (SELECT c.MID
	   FROM CastandCrew c INNER JOIN People p on c.PID = p.PID
	   WHERE p.Name = 'Sean Connery');