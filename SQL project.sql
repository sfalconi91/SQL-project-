exec WipeDatabase

create table Woods
(Wood VARCHAR(50) not null,
WoodType VARCHAR(50) null
)

create table Wands
(Wood VARCHAR(50) not null,
Length FLOAT not null,
Core VARCHAR(50) not null,
)
create table Dates 
(ActualDate DATE not null,
Season VARCHAR(50) null
)
create table Sales
(FirstName VARCHAR(50) not null,
LastName VARCHAR(50) not null,
Core VARCHAR(50) not null,
Length FLOAT not null,
OrderDate DATE not null,
Wood VARCHAR(50) not null,
DeliveryDate DATE null,
Quantity INT null,
Price FLOAT null,
PaymentType VARCHAR(50) null
)
create table Wizards
(FirstName VARCHAR(50) not null,
LastName VARCHAR(50) not null,
WizardBorn BIT,
Age INT,
FatherFirstName VARCHAR(50),	
FatherLastName VARCHAR(50),
MotherFirstName VARCHAR(50),
MotherLastName VARCHAR(50),
House VARCHAR(50),
HouseWizardId INT
)
create table Spells
(SpellName VARCHAR(50) not null,
Category VARCHAR(50),
Description VARCHAR(200),
)
create table SpellCasts
(CastDate DATE not null,
Wood VARCHAR(50) not null,
Length FLOAT not null,
Core VARCHAR(50) not null,
LocationName VARCHAR(50) not null,
SpellName VARCHAR(50) not null,
Frequency INT,
)
create table Locations
(LocationName VARCHAR(50) not null,
Section VARCHAR(50),
Floor INT, 
)

alter table Woods
add constraint PK_Woods
primary key (Wood)

alter table Wands
add constraint PK_Wands
primary key(Wood,Length,Core)

alter table Dates
add constraint PK_Dates
primary key(ActualDate)

alter table Sales
add constraint PK_Sales
primary key(FirstName, LastName, Core, Length, OrderDate, Wood)

alter table Wizards
add constraint PK_Wizards
primary key(FirstName, LastName)

alter table Spells
add constraint PK_Spells
primary key(SpellName)

alter table SpellCasts
add constraint PK_SpellCasts
primary key(CastDate, Wood, Length, Core, LocationName, SpellName)

alter table Locations
add constraint PK_Locations
primary key(LocationName)

-- FK

alter table Wands
add constraint FK_Wands_Woods_1
foreign key (Wood)
references Woods(Wood)

alter table Sales
add constraint FK_Sales_Wands_1
foreign key (Wood, Length, Core)
references Wands(Wood, Length, Core)

alter table Sales
add constraint FK_Sales_Wizards_1
foreign key (FirstName, LastName)
references Wizards(FirstName, LastName) 

alter table Sales
add constraint FK_Sales_Dates_1
foreign key (OrderDate)
references Dates(ActualDate)

alter table Sales
add constraint FK_Sales_Dates_2
foreign key (DeliveryDate)
references Dates(ActualDate)

alter table SpellCasts
add constraint FK_SpellCasts_Spells_1
foreign key (SpellName)
references Spells(SpellName)

alter table SpellCasts
add constraint FK_SpellCasts_Wands_1
foreign key(Wood, Length, Core)
references Wands(Wood, Length, Core)

alter table SpellCasts
add constraint FK_SpellCasts_Dates_1
foreign key(CastDate)
references Dates(ActualDate)

alter table SpellCasts
add constraint FK_SpellCasts_Locations_1
foreign key(LocationName)
references Locations(LocationName)

alter table Wizards
add constraint FK_Wizards_Wizards_1
foreign key(FatherFirstName, FatherLastName)
references Wizards(FirstName, LastName)

alter table Wizards
add constraint FK_Wizards_Wizards_2
foreign key(MotherFirstName, MotherLastName)
references Wizards(FirstName, LastName)

exec RunSQLTests1

--Index

Create Index IDX_Wands_Wood_1
ON Wands (Wood)

Create Index IDX_Wizards_FatherLastName_1
On Wizards (FatherLastName, MotherLastName)

Create Index IDX_Wizards_House_1
On Wizards (House)

--Constraints 

alter table Woods 
Add constraint CK_Woods_WoodType
check(WoodType = 'Softwood' OR WoodType = 'Hardwood')

alter table Wands
Add constraint CK_Wands_Length
Check (Length >=8 and Length < 13)
 
alter table Wizards
Add constraint U_Wizards_HouseWizardId Unique(HouseWizardId, House)

alter table Sales
Add constraint DF_Sales_DeliveryDate
Default getDate() for DeliveryDate

alter table Wizards
Add constraint DF_Wizards_WizardBorn
default 1 for WizardBorn

exec RunSQLTests2 
exec PopulateData
--Part 3 SQL


GO
CREATE VIEW VIEW1 AS
SELECT*
FROM Sales
GO

CREATE VIEW VIEW2 AS
SELECT FirstName, LastName
FROM wizards
GO  

CREATE VIEW VIEW3 AS
SELECT DISTINCT LastName
FROM Wizards
GO

CREATE VIEW VIEW4 AS
SELECT FirstName, LastName
FROM Wizards 
WHERE LastName = 'Voigt'
GO
 
CREATE VIEW VIEW5 AS
SELECT FirstName, LastName
FROM Wizards
WHERE FirstName LIKE 'H%' AND LastName LIKE 'S%%D'
GO 

CREATE VIEW VIEW6 AS
SELECT FirstName, LastName
FROM Wizards 
WHERE Age IS NULL
GO

CREATE VIEW VIEW7 AS
SELECT DISTINCT FirstName, LastName
FROM Sales
WHERE Core IN ('Dragon heartstring', 'Phoenix Feather')
GO

CREATE VIEW VIEW8 AS
SELECT FirstName, LastName,Length 
FROM Sales  
WHERE YEAR(OrderDate)=2013
GO

CREATE VIEW VIEW9 AS
SELECT Wiz.FirstName as FirstName, Wiz.LastName as LastName, Wiz.House as House, S.Length as Length, S.OrderDate as OrderDate
FROM Wizards as Wiz
Join Sales as S
ON (Wiz.FirstName = S.FirstName
AND Wiz.LastName = S.LastName)
GO

CREATE VIEW VIEW10 AS
SELECT Wiz.FirstName, Wiz.LastName, S.Core 
FROM Wizards as Wiz
LEFT JOIN Sales as S
ON (Wiz.FirstName = S.FirstName
AND Wiz.LastName = S.LastName)
GO

CREATE VIEW VIEW11 As
SELECT Wiz.FirstName, Wiz.LastName, Wiz.House, S.Core,S.Length, S.Wood
FROM Wizards as Wiz
FULL OUTER JOIN Sales as S
ON (Wiz.FirstName = S.FirstName
AND Wiz.LastName = S. LastName)
GO

CREATE VIEW VIEW12 AS
SELECT Core, Length, Wood
FROM Sales
WHERE Length BETWEEN 10 and 11
GO

CREATE VIEW VIEW13 AS
SELECT Wiz.FirstName, Wiz.LastName, Wiz.House, S.Core, S.Length, S.Wood, S.OrderDate, D.Season, Wd.WoodType
FROM Sales as S
JOIN Wizards as Wiz
ON (S.FirstName = Wiz.FirstName 
AND S.LastName = Wiz.LastName)
JOIN Dates as D
ON (S.OrderDate = D.ActualDate)
JOIN Woods as Wd
ON (S.Wood = Wd.Wood)
GO

CREATE VIEW VIEW14 AS
SELECT COUNT (DISTINCT Length) as CountLength
FROM Sales
GO

CREATE VIEW VIEW15 as 
SELECT House
FROM Wizards 
GROUP BY House 
HAVING COUNT(HouseWizardId) >=30
GO

exec RunSQLTests3

exec RunSQLTests