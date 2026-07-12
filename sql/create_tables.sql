CREATE TABLE Products (
    Product_ID VARCHAR(20) PRIMARY KEY,
    Product_Name VARCHAR(150),
    Category VARCHAR(100),
    Brand VARCHAR(100),
    Cost DECIMAL(10,2),
    Price DECIMAL(10,2)
);

CREATE TABLE Customers (
    Customer_ID VARCHAR(20) PRIMARY KEY,
    Gender VARCHAR(20),
    Age INT,
    City VARCHAR(100),
    Segment VARCHAR(50)
);

CREATE TABLE Stores (
    Store_ID VARCHAR(20) PRIMARY KEY,
    Region VARCHAR(100),
    Manager VARCHAR(100),
    Store_Size VARCHAR(50)
);

CREATE TABLE Inventory (
    Product_ID VARCHAR(20),
    Store_ID VARCHAR(20),
    Stock INT,
    Reorder_Level INT,
    Supplier VARCHAR(100),

    PRIMARY KEY(Product_ID, Store_ID),

    FOREIGN KEY(Product_ID)
        REFERENCES Products(Product_ID),

    FOREIGN KEY(Store_ID)
        REFERENCES Stores(Store_ID)
);

CREATE TABLE Sales (
    Transaction_ID VARCHAR(20) PRIMARY KEY,

    Date DATE,

    Product_ID VARCHAR(20),

    Customer_ID VARCHAR(20),

    Store_ID VARCHAR(20),

    Quantity INT,

    Sales DECIMAL(10,2),

    Discount DECIMAL(5,2),

    FOREIGN KEY(Product_ID)
        REFERENCES Products(Product_ID),

    FOREIGN KEY(Customer_ID)
        REFERENCES Customers(Customer_ID),

    FOREIGN KEY(Store_ID)
        REFERENCES Stores(Store_ID)
);