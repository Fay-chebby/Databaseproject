Inventory Management System
Description
The Inventory Management System is a relational database application designed to help businesses track products, suppliers, and purchase orders in real-time. It provides functionality to manage products, monitor inventory levels, handle purchase orders, track supplier details, and more.

The system allows administrators to perform CRUD operations (Create, Read, Update, Delete) on products, suppliers, and orders. It also enables inventory management by automatically calculating reorder levels and sales data.

Key Features:
Manage products with details such as category, price, and stock quantity.

Track suppliers and their contact details.

Handle purchase orders and order details, including product quantities and pricing.

Maintain audit logs of user actions for better accountability.

Users can have different roles (e.g., Admin, Staff) with appropriate access privileges.

: Import SQL Schema
Once the database is created, you can import the provided SQL schema to set up the tables:

Save your SQL schema (the CREATE TABLE statements) in a file called inventorydb_schema.sql.

In your MySQL client, select the inventorydb database:

sql
Copy
Edit
USE inventorydb;
Import the SQL schema:

sql
Copy
Edit
SOURCE /path/to/inventorydb_schema.sql;
