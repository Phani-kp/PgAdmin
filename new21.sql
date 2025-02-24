-- Relational database using DDL
-- Create Manager Table
CREATE TABLE Manager (
    managerid CHAR(4) PRIMARY KEY,
    mFirstname VARCHAR(15),
    mLastname VARCHAR(15),
    mBirthdate DATE,
    mSalary NUMERIC(9,2),
    mBonus NUMERIC(9,2),
    mredbuildingid CHAR(3) -- Initially without FK due to circular dependency
);

-- Create Inspector Table
CREATE TABLE Inspector (
    inspectorid CHAR(3) PRIMARY KEY,
    insname VARCHAR(15)
);

-- Create Building Table
CREATE TABLE Building (
    buildingid CHAR(4) PRIMARY KEY,
    bnooffloors INT,
    managerid CHAR(4),
    FOREIGN KEY (managerid) REFERENCES Manager(managerid)
);

-- Create ManagerPhone Table
CREATE TABLE ManagerPhone (
    managerid CHAR(4),
    mPhone CHAR(11),
    PRIMARY KEY (managerid, mPhone), -- Ensuring uniqueness
    FOREIGN KEY (managerid) REFERENCES Manager(managerid)
);

-- Create CorpClient Table
CREATE TABLE CorpClient (
    CCID CHAR(4) PRIMARY KEY,
    CCName VARCHAR(25) UNIQUE,
    CCIndustry VARCHAR(25),
    CCLocation VARCHAR(25),
    CCIDReferredBy CHAR(4),
    FOREIGN KEY (CCIDReferredBy) REFERENCES CorpClient(CCID)
);

-- Create Apartment Table
CREATE TABLE Apartment (
    buildingid CHAR(4),
    aptno CHAR(4),
    anoofbedrooms INT,
    ccid CHAR(4),
    PRIMARY KEY (buildingid, aptno), -- Composite primary key
    FOREIGN KEY (buildingid) REFERENCES Building(buildingid), -- Foreign key referencing Building table
    FOREIGN KEY (ccid) REFERENCES CorpClient(CCID) -- Foreign key referencing CorpClient table
);

-- Create Inspecting Table
CREATE TABLE Inspecting (
    inspectorid CHAR(3),
    buildingid CHAR(4),
    datelast DATE,
    datenext DATE,
    PRIMARY KEY (inspectorid, buildingid), -- Composite key to ensure unique inspections
    FOREIGN KEY (inspectorid) REFERENCES Inspector(inspectorid),
    FOREIGN KEY (buildingid) REFERENCES Building(buildingid)
);

-- Loading the given data into tables
-- Insert values into Manager table
INSERT INTO Manager (managerid, mFirstname, mLastname, mBirthdate, mSalary, mBonus, mredbuildingid) VALUES 
('M12', 'Boris', 'Grant', TO_DATE('1988-06-06', 'YYYY-MM-DD'), 60000, NULL, 'B1'), 
('M23', 'Austin', 'Lee', TO_DATE('1983-02-02', 'YYYY-MM-DD'), 50000, 5000, 'B2'), 
('M34', 'George', 'Sherman', TO_DATE('1984-07-08', 'YYYY-MM-DD'), 52000, 2000, 'B4');

-- Insert values into Building table
INSERT INTO Building (buildingid, bnooffloors, managerid) VALUES 
('B1', 5, 'M12'), 
('B2', 6, 'M23'), 
('B3', 4, 'M23'), 
('B4', 4, 'M34');

-- Insert values into ManagerPhone
INSERT INTO ManagerPhone (managerid, mPhone) VALUES
('M12', '555-2222'),
('M12', '555-3232'),
('M23', '555-9988'),
('M34', '555-9999');

-- Insert values into Inspector table
INSERT INTO Inspector (inspectorid, insname) VALUES 
('I11', 'Jane'), 
('I22', 'Niko'), 
('I33', 'Mick');

-- Insert values into CorpClient table
INSERT INTO CorpClient (CCID, CCName, CCIndustry, CCLocation, CCIDReferredBy) VALUES 
('C111', 'BlingNotes', 'Music', 'Chicago', NULL), 
('C222', 'Skyjet', 'Airline', 'Oak Park', 'C111'), 
('C777', 'WindyCT', 'Music', 'Chicago', 'C222'), 
('C888', 'SouthAlps', 'Sports', 'Rosemont', 'C777');

-- Insert values into Apartment
INSERT INTO Apartment (buildingid, aptno, anoofbedrooms, ccid) VALUES
('B1', '41', 1, NULL),
('B1', '21', 1, 'C111'),
('B2', '11', 2, 'C222'),
('B2', '31', 2, NULL),
('B3', '11', 2, 'C777'),
('B4', '11', 2, 'C777');

-- Insert values into Inspecting
INSERT INTO Inspecting (inspectorid, buildingid, datelast, datenext) VALUES
('I11', 'B1', TO_DATE('2019-05-05', 'YYYY-MM-DD'), TO_DATE('2020-05-05', 'YYYY-MM-DD')),
('I11', 'B2', TO_DATE('2019-02-02', 'YYYY-MM-DD'), TO_DATE('2020-02-02', 'YYYY-MM-DD')),
('I22', 'B2', TO_DATE('2019-03-04', 'YYYY-MM-DD'), TO_DATE('2020-02-02', 'YYYY-MM-DD')),
('I22', 'B3', TO_DATE('2019-09-08', 'YYYY-MM-DD'), TO_DATE('2020-03-03', 'YYYY-MM-DD')),
('I33', 'B3', TO_DATE('2019-04-04', 'YYYY-MM-DD'), TO_DATE('2020-04-04', 'YYYY-MM-DD')),
('I33', 'B4', TO_DATE('2019-05-05', 'YYYY-MM-DD'), TO_DATE('2020-04-04', 'YYYY-MM-DD'));

-- Queries answer for following questions:

-- 1. Return the first and last name of the manager that doesn't have a bonus
SELECT mFirstname, mLastname
FROM Manager
WHERE mBonus IS NULL;

-- 2. Return the CCID, CCName, and CCIndustry of all of our clients that have referred another one of our clients
SELECT c.CCID, c.CCName, c.CCIndustry
FROM CorpClient c
WHERE c.CCID IN (
    SELECT DISTINCT CCIDReferredBy
    FROM CorpClient
    WHERE CCIDReferredBy IS NOT NULL
);

-- 3. For all the inspections that took place on 2019-05-05, return the building ID, name of the manager who manages the building, and all of their phone numbers
SELECT 
    (SELECT b.buildingid FROM Building b WHERE b.buildingid = i.buildingid) AS buildingid, 
    (SELECT m.mFirstname FROM Manager m WHERE m.managerid = (SELECT b.managerid FROM Building b WHERE b.buildingid = i.buildingid)) AS mFirstname, 
    (SELECT m.mLastname FROM Manager m WHERE m.managerid = (SELECT b.managerid FROM Building b WHERE b.buildingid = i.buildingid)) AS mLastname, 
    (SELECT mp.mPhone FROM ManagerPhone mp WHERE mp.managerid =  
        (SELECT b.managerid FROM Building b WHERE b.buildingid = i.buildingid)  
        FETCH FIRST 1 ROW ONLY) AS mPhone  
FROM Inspecting i  
WHERE i.datelast = TO_DATE('2019-05-05', 'YYYY-MM-DD');

-- 4. Return the names of all the inspectors that have inspected building B3 in order of most recent inspection to least
SELECT insname
FROM Inspector
WHERE inspectorid IN (
    SELECT inspectorid 
    FROM Inspecting 
    WHERE buildingid = 'B3'
)
ORDER BY (
    SELECT datelast 
    FROM Inspecting 
    WHERE buildingid = 'B3' 
      AND Inspecting.inspectorid = Inspector.inspectorid
) DESC;
