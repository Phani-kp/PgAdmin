-- created Tables by using CREATE Key
--Employee Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(50)
);

--Projects Table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    StartDate DATE,
    EndDate DATE
);

--Assignments Table
CREATE TABLE Assignments (
    AssignmentID INT PRIMARY KEY,
    EmployeeID INT,
    ProjectID INT,
    Role VARCHAR(100),
    CONSTRAINT fk_employee FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    CONSTRAINT fk_project FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);


-- Inserted values in Table by using INSERT key

--Employees Table
INSERT INTO Employees (EmployeeID, FirstName, LastName) VALUES
(1, 'Alice', 'Johnson'),
(2, 'Bob', 'Smith'),
(3, 'Charlie', 'Brown'),
(4, 'Diana', 'Green'),
(5, 'Ethan', 'White');

--Projects Table
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate) VALUES
(101, 'Cloud Migration', TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-06-30', 'YYYY-MM-DD')),
(102, 'Data Pipeline Optimization', TO_DATE('2025-02-01', 'YYYY-MM-DD'), TO_DATE('2025-08-31', 'YYYY-MM-DD')),
(103, 'Security Enhancement', TO_DATE('2025-03-01', 'YYYY-MM-DD'), TO_DATE('2025-09-30', 'YYYY-MM-DD')),
(104, 'AI Model Development', TO_DATE('2025-04-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD')),
(105, 'Infrastructure Automation', TO_DATE('2025-05-01', 'YYYY-MM-DD'), TO_DATE('2025-11-30', 'YYYY-MM-DD'));

--Assignments Table
INSERT INTO Assignments (AssignmentID, EmployeeID, ProjectID, Role) VALUES
(100, 1, 101, 'Project Manager'),
(200, 2, 102, 'Data Engineer'),
(300, 3, 103, 'Security Analyst'),
(400, 4, 104, 'AI Researcher'),
(500, 5, 105, 'Automation Specialist');

--query for returning the Employee Name, their role on the project, and the project name.
SELECT 
    e.FirstName AS EmployeeFirstName, e.LastName AS EmployeeLastName,
    a.Role AS ProjectRole, 
    p.ProjectName  
FROM Assignments a, Employees e, Projects p
WHERE a.EmployeeID = e.EmployeeID
  AND a.ProjectID = p.ProjectID;
