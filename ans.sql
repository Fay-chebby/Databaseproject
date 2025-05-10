-- creatind db
 CREATE DATABASE Inventorydb;
 -- using the created Database
USE Inventorydb;

-- adding tables with constraints and relationship

CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);