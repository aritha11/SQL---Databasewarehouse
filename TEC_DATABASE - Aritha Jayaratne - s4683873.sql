CREATE DATABASE TEC_Database;
use TEC_Database;

# create the tables in the database according to the ER diagram.  

CREATE TABLE Company (
    Company_ID INT PRIMARY KEY,
    Company_name VARCHAR(100),
    Sector VARCHAR(100),
    Address VARCHAR(255),
    Contact_info VARCHAR(100)
);

CREATE TABLE Opening (
    Opening_number INT PRIMARY KEY,
    Hourly_pay DECIMAL(10, 2),
    Required_qualification VARCHAR(100),
    Start_date DATE,
    End_date DATE,
    Company_name VARCHAR(100),
    Company_ID INT,
    FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID)
);

CREATE TABLE Candidate (
    Candidate_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(255),
    Contact_number VARCHAR(20)
);

CREATE TABLE JobHistory (
    JobHistory_ID INT PRIMARY KEY,
    Job_title VARCHAR(100),
    Start_date DATE,
    End_date DATE,
    Candidate_ID INT,
    FOREIGN KEY (Candidate_ID) REFERENCES Candidate(Candidate_ID)
);



CREATE TABLE Qualifications (
    Qualification_code varchar(100) PRIMARY KEY,
    Qualification_description VARCHAR(255)
);



CREATE TABLE Courses (
    Course_ID INT PRIMARY KEY,
    Course_name VARCHAR(100),
    Qualification_code VARCHAR(100),
    Prerequisites VARCHAR(255),
    FOREIGN KEY (Qualification_code) REFERENCES Qualifications(Qualification_code)
);
                                                                                

CREATE TABLE Sessions (
    Session_ID INT PRIMARY KEY,
    Location VARCHAR(100),
    Time TIME,
    Course_ID INT,
    Date DATE,
    FOREIGN KEY (Course_ID) REFERENCES Courses(Course_ID)
);

CREATE TABLE Placement (
    Placement_ID INT PRIMARY KEY,
    Total_hours_worked INT,
    Candidate_ID INT,
    Opening_number INT,
    FOREIGN KEY (Candidate_ID) REFERENCES Candidate(Candidate_ID),
    FOREIGN KEY (Opening_number) REFERENCES Opening(Opening_number)
);


#After creating the tables. Next part is to add the data into the columns using the Insert function. A total of two rows of data has been added to each table created and for the qualification column the given data was uploaded.

# adding values to Company table 


INSERT INTO Company (Company_ID, Company_name, Sector, Address, Contact_info)
VALUES  
(1001, 'ABC Corp', 'Technology', '123 Main St, Cityville', '123-456-7890'),
(1002, 'XYZ Inc', 'Finance', '456 Elm St, Townsville', '987-654-3210');

select * from Company;

# adding values to Opening table 

INSERT INTO Opening (Opening_number, Hourly_pay, Required_qualification, Start_date, End_date, Company_name, Company_ID) 
VALUES 
(101, 25.00, 'PRG-VB', '2024-02-15', '2024-05-15', 'ABC Corp', 1001),
(102, 30.00, 'DBA-ORA', '2024-03-01', '2024-06-01', 'XYZ Inc', 1002);

select * from Opening;

# Inserting values candidate table.

INSERT INTO Candidate (Candidate_ID, Name, Address, Contact_number) 
VALUES 
(25, 'John Doe', '789 Oak St, Villageton', '555-1234'),
(37, 'Jane Smith', '456 Pine St, Hamletville', '555-5678');

select * from Candidate;

# Inserting values to Jobhistory  table.

INSERT INTO JobHistory (JobHistory_ID, Job_title, Start_date, End_date, Candidate_ID) 
VALUES 
(201, 'Software Engineer - Visal Basic', '2023-01-01', '2024-02-01', 25),
(202, 'Database Administrator - Oracle', '2023-03-01', '2024-04-01', 37);

select * from JobHistory;

#Insert data into the qualifications table 

INSERT INTO Qualifications (Qualification_code, Qualification_description) 
VALUES 
    ('SEC-45', 'Secretarial work, at least 45 words per minute'),
    ('SEC-60', 'Secretarial work, at least 60 words per minute'),
    ('CLERK', 'General clerking work'),
    ('PRG-VB', 'Programmer, Visual Basic'),
    ('PRG-C++', 'Programmer, C++'),
    ('DBA-ORA', 'Database Administrator, Oracle'),
    ('DBA-DB2', 'Database Administrator, IBM DB2'),
    ('DBA-SQLSERV', 'Database Administrator, MS SQL Server'),
    ('SYS-1', 'Systems Analyst, level 1'),
    ('SYS-2', 'Systems Analyst, level 2'),
    ('NW-NOV', 'Network Administrator, Novell experience'),
    ('WD-CF', 'Web Developer, ColdFusion');

select * from Qualifications;

# Insert data into the course table 

INSERT INTO Courses (Course_ID, Course_name, Qualification_code, Prerequisites) 
VALUES 
(101, 'Computer Programming','PRG-VB', 'JAVA & Python basics'),
(102, 'Database Design & Analysis', 'SYS-1', 'Foundation to SQL');

select * from Courses;

#Insert data into the Session table.

INSERT INTO Sessions (Session_ID, Location, Time, Course_ID, Date) 
VALUES 
(501, 'Online', '10:00:00', 101, '2024-03-10'),
(502, 'Building A - Boardroom 01', '14:00:00', 102, '2024-03-15');

select * from Sessions;

#Insert data into the placement table 

INSERT INTO Placement (Placement_ID, Total_hours_worked, Candidate_ID, Opening_number) 
VALUES 
(53, 50, 25, 101),
(67, 75, 37, 102);

select * from Placement;


#Resolving the many to many using associative tables. creatin a new table as coursequlification by refrencing the primary keys of course and qulaification table as foreing keys in the new table.

# Creating the coursequlification table.

CREATE TABLE CourseQualifications (
    Course_ID INT,
    Qualification_code VARCHAR(100),
    PRIMARY KEY (Course_ID, Qualification_code),
    FOREIGN KEY (Course_ID) REFERENCES Courses(Course_ID),
    FOREIGN KEY (Qualification_code) REFERENCES Qualifications(Qualification_code)
);


# Creating the CandidateQualifications table.

CREATE TABLE CandidateQualifications (
    Candidate_ID INT,
    Qualification_code VARCHAR(100),
    PRIMARY KEY (Candidate_ID, Qualification_code),
    FOREIGN KEY (Candidate_ID) REFERENCES Candidate(Candidate_ID),
    FOREIGN KEY (Qualification_code) REFERENCES Qualifications(Qualification_code)
);

# Scenario - Retrieve information about candidates who are eligible for job openings based on their qualifications and job history

SELECT DISTINCT c.Candidate_ID, c.Name, o.Opening_number, o.Required_qualification
FROM Candidate c
JOIN JobHistory j ON c.Candidate_ID = j.Candidate_ID
JOIN Placement p ON c.Candidate_ID = p.Candidate_ID
JOIN Opening o ON p.Opening_number = o.Opening_number
JOIN Courses co ON co.Qualification_code = o.Required_qualification
JOIN CourseQualifications cq ON cq.Course_ID = co.Course_ID
JOIN Qualifications q ON cq.Qualification_code = q.Qualification_code
WHERE j.End_date >= CURDATE() # Making sure candidate's job history is current
AND p.Total_hours_worked >= 40; # Ensuring candidate has worked for at least 40 hours


