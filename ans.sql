-- creatind db
 CREATE DATABASE Inventorydb;
 -- using the created Database
USE Inventorydb;

-- adding tables with constraints and relationship

CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL UNIQUE,
    ContactName VARCHAR(100),
    Phone VARCHAR(20),
    Email VARCHAR(100) UNIQUE,
    Address TEXT
);

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT,
    SupplierID INT,
    QuantityInStock INT DEFAULT 0,
    ReorderLevel INT DEFAULT 10,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE StockTransactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT NOT NULL,
    TransactionType ENUM('IN', 'OUT') NOT NULL,
    Quantity INT NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Notes TEXT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE PurchaseOrders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierID INT NOT NULL,
    OrderDate DATE NOT NULL,
    Status ENUM('Pending', 'Received', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);


CREATE TABLE PurchaseOrderDetails (
    DetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES PurchaseOrders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    UNIQUE (OrderID, ProductID)  
);

CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Role ENUM('Admin', 'Staff') DEFAULT 'Staff',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE AuditLogs (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    Action VARCHAR(255) NOT NULL,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
 -- adding data to tables
-- Suppliers table
ALTER TABLE Suppliers DROP INDEX SupplierName;

INSERT INTO Suppliers (SupplierName, ContactName, Phone)
VALUES
    ('Refab Ltd.', 'Alice Johnson', '123-456-7890'),
    ('TGS Bible', 'Bob Smith', '987-654-3210'),
    ('Zoe global', 'Charlie Lee', '555-789-0123');
-- Categories table
INSERT INTO Categories (CategoryName)
VALUES
    ('Electronics'),
    ('Furniture'),
    ('Clothing'),
    ('Books'),
    ('Sports Equipment');
 -- products table
INSERT INTO Products (ProductID, ProductName, CategoryID, SupplierID, QuantityInStock, ReorderLevel, UnitPrice)
VALUES
    (1, 'Laptop', 1, 1, 50, 10, 20000),   
    (2, 'KJV Bible', 2, 2, 20, 5, 14000),   
    (3, 'T-shirt', 3, 3, 100, 20, 450), 
    (4, 'Novel Book', 4, 3, 150, 30, 200),  
    (5, 'NIV bible', 5, 2, 30, 15, 500);
 -- purchaseOrders
    INSERT INTO PurchaseOrders (SupplierID, OrderDate, Status)
VALUES
    (1, '2023-12-01', 'Pending'),   
    (2, '2023-12-05', 'Received'),    
    (3, '2023-12-10', 'Pending'),     
    (1, '2023-12-12', 'Cancelled'); 

INSERT INTO PurchaseOrderDetails (OrderID, ProductID, Quantity, UnitPrice)
VALUES
    (1, 1, 10, 20000.00), 
    (1, 2, 5, 1400.00),   
    (2, 3, 20, 450.00),    
    (2, 4, 15, 200.00),    
    (3, 5, 8, 500.00); 


-- grant
CREATE USER 'luke'@'localhost' IDENTIFIED BY 'luke_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON inventorydb.* TO 'luke'@'localhost';
FLUSH PRIVILEGES;

CREATE USER 'chebby'@'localhost' IDENTIFIED BY 'chebby_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON inventorydb.* TO 'chebby'@'localhost';
FLUSH PRIVILEGES;


 INSERT INTO Users (Username, PasswordHash, Role)
VALUES
    ('admin', 'hashed_password_for_admin', 'Admin'),
    ('chebby', 'hashed_password_for_john', 'Staff'),
    ('luke', 'hashed_password_for_jane', 'Staff');


REPLACE INTO Users (Username, PasswordHash, Role)
VALUES
    ('chebby', 'newpass123', 'Staff'),
    ('luke', '35pass', 'Staff');

    UPDATE Users
SET PasswordHash = 'newpass123', Role = 'Admin'
WHERE Username = 'admin';

-- sample query
-- query1 
SELECT p.ProductID, p.ProductName, c.CategoryName, s.SupplierName, p.QuantityInStock, p.UnitPrice
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN Suppliers s ON p.SupplierID = s.SupplierID;

-- query2
SELECT po.OrderID, po.OrderDate, po.Status, s.SupplierName
FROM PurchaseOrders po
JOIN Suppliers s ON po.SupplierID = s.SupplierID
WHERE po.SupplierID = 2;

--query3
SELECT c.CategoryName, SUM(pod.Quantity * pod.UnitPrice) AS TotalOrderValue
FROM PurchaseOrderDetails pod
JOIN Products p ON pod.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName;

-- query4
SELECT ProductName, QuantityInStock, ReorderLevel
FROM Products
WHERE QuantityInStock <= ReorderLevel;

-- query5
SELECT Username, Role
FROM Users;

