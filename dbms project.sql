CREATE DATABASE tms
use tms

CREATE TABLE Roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role_id INT NOT NULL,
    is_active BIT DEFAULT 1,

    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

CREATE TABLE Ticket_Status (
    status_id INT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Ticket_Priority (
    priority_id INT PRIMARY KEY,
    level VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE SLA (
    sla_id INT PRIMARY KEY,
    priority_id INT NOT NULL,
    response_time_limit INT NOT NULL,
    resolution_time_limit INT NOT NULL,

    FOREIGN KEY (priority_id) REFERENCES Ticket_Priority(priority_id)
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    priority_id INT NOT NULL,
    status_id INT NOT NULL,
    sla_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (priority_id) REFERENCES Ticket_Priority(priority_id),
    FOREIGN KEY (status_id) REFERENCES Ticket_Status(status_id)
);

CREATE TABLE Ticket_Assignments (
    assignment_id INT PRIMARY KEY,
    ticket_id INT NOT NULL,
    agent_id INT NOT NULL,
    assigned_at DATETIME DEFAULT GETDATE(),
    unassigned_at DATETIME NULL,
    is_active BIT DEFAULT 1,

    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id),
    FOREIGN KEY (agent_id) REFERENCES Users(user_id)
);

CREATE TABLE Responses (
    response_id INT PRIMARY KEY,
    ticket_id INT NOT NULL,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    is_internal BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Ticket_History (
    history_id INT PRIMARY KEY,
    ticket_id INT NOT NULL,
    status_id INT NOT NULL,
    changed_by INT NOT NULL,
    changed_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id),
    FOREIGN KEY (status_id) REFERENCES Ticket_Status(status_id),
    FOREIGN KEY (changed_by) REFERENCES Users(user_id)
);

INSERT INTO Roles (role_id, role_name) VALUES
(1, 'Admin'),
(2, 'Agent'),
(3, 'Customer');

INSERT INTO Users (user_id, name, email, role_id) VALUES
(1, 'Ali Khan', 'ali@example.com', 3),
(2, 'Sara Ahmed', 'sara@example.com', 3),
(3, 'Usman Tariq', 'usman@example.com', 2),
(4, 'Hina Malik', 'hina@example.com', 2),
(5, 'Admin User', 'admin@example.com', 1);

INSERT INTO Ticket_Status (status_id, status_name) VALUES
(1, 'New'),
(2, 'Assigned'),
(3, 'In Progress'),
(4, 'Resolved'),
(5, 'Closed');

INSERT INTO Ticket_Priority (priority_id, level) VALUES
(1, 'Low'),
(2, 'Medium'),
(3, 'High');

INSERT INTO Categories (category_id, category_name) VALUES
(1, 'Technical Issue'),
(2, 'Billing'),
(3, 'Account Problem');

INSERT INTO SLA (sla_id, priority_id, response_time_limit, resolution_time_limit) VALUES
(1, 1, 48, 72),   -- Low
(2, 2, 24, 48),   -- Medium
(3, 3, 12, 24);   -- High

INSERT INTO Tickets
(ticket_id, subject, description, user_id, category_id, priority_id, status_id, sla_id)
VALUES
(1, 'Login Issue', 'Unable to login to account', 1, 3, 2, 1, 2),
(2, 'Payment Failed', 'Payment not going through', 2, 2, 3, 1, 3),
(3, 'App Crash', 'Application crashes on startup', 1, 1, 3, 2, 3);

INSERT INTO Ticket_Assignments (assignment_id, ticket_id, agent_id, is_active) VALUES
(1, 1, 3, 1),
(2, 2, 4, 1),
(3, 3, 3, 1);

INSERT INTO Responses (response_id, ticket_id, user_id, message, is_internal) VALUES
(1, 1, 1, 'I cannot access my account.', 0),
(2, 1, 3, 'We are looking into the issue.', 0),
(3, 2, 2, 'Payment keeps failing.', 0),
(4, 2, 4, 'Please try again after some time.', 0),
(5, 3, 3, 'Investigating crash logs.', 1);

INSERT INTO Ticket_History (history_id, ticket_id, status_id, changed_by) VALUES
(1, 1, 1, 1),
(2, 1, 2, 3),
(3, 2, 1, 2),
(4, 2, 2, 4),
(5, 3, 1, 1);

SELECT * FROM Users;

SELECT * FROM Tickets;

SELECT * 
FROM Tickets
WHERE status_id = 1;


SELECT T.ticket_id, T.subject, U.name
FROM Tickets T
JOIN Users U
ON T.user_id = U.user_id;

SELECT T.ticket_id, T.subject, TS.status_name
FROM Tickets T
JOIN Ticket_Status TS
ON T.status_id = TS.status_id;

SELECT T.ticket_id, T.subject,
       C.category_name,
       TP.level
FROM Tickets T
JOIN Categories C
ON T.category_id = C.category_id
JOIN Ticket_Priority TP
ON T.priority_id = TP.priority_id;

SELECT T.ticket_id,
       T.subject,
       U.name AS Agent_Name
FROM Ticket_Assignments TA
JOIN Tickets T
ON TA.ticket_id = T.ticket_id
JOIN Users U
ON TA.agent_id = U.user_id;

SELECT COUNT(*) AS Total_Tickets
FROM Tickets;

SELECT TS.status_name,
       COUNT(*) AS Total
FROM Tickets T
JOIN Ticket_Status TS
ON T.status_id = TS.status_id
GROUP BY TS.status_name;

SELECT TP.level,
       COUNT(*) AS Total
FROM Tickets T
JOIN Ticket_Priority TP
ON T.priority_id = TP.priority_id
GROUP BY TP.level;

SELECT T.subject,
       R.message,
       U.name
FROM Responses R
JOIN Tickets T
ON R.ticket_id = T.ticket_id
JOIN Users U
ON R.user_id = U.user_id;

SELECT *
FROM Responses
WHERE is_internal = 1;

SELECT *
FROM Tickets
ORDER BY created_at DESC;

SELECT *
FROM Tickets
ORDER BY subject ASC;

UPDATE Tickets
SET status_id = 3
WHERE ticket_id = 1;

SELECT * 
FROM Tickets
WHERE ticket_id = 1;

DELETE FROM Responses
WHERE response_id = 5;

SELECT * 
FROM Responses;

SELECT name
FROM Users
WHERE user_id IN (
    SELECT user_id
    FROM Tickets
);

SELECT *
FROM Tickets
WHERE priority_id = (
    SELECT priority_id
    FROM Ticket_Priority
    WHERE level = 'High'
);

SELECT AVG(resolution_time_limit) AS Average_Hours
FROM SLA;

SELECT U.name,
       COUNT(*) AS Assigned_Tickets
FROM Ticket_Assignments TA
JOIN Users U
ON TA.agent_id = U.user_id
GROUP BY U.name;


















