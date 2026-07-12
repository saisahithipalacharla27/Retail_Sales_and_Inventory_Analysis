# =====================================================
# Retail Sales & Inventory Analysis
# Data Cleaning Script
# =====================================================

import pandas as pd
import numpy as np
import os

# -----------------------------------------------------
# File Paths
# -----------------------------------------------------

RAW_PATH = "../data/raw/"
CLEAN_PATH = "../data/cleaned/"

os.makedirs(CLEAN_PATH, exist_ok=True)

# -----------------------------------------------------
# Load Datasets
# -----------------------------------------------------

products = pd.read_csv(RAW_PATH + "Products.csv")
customers = pd.read_csv(RAW_PATH + "Customers.csv")
stores = pd.read_csv(RAW_PATH + "Stores.csv")
inventory = pd.read_csv(RAW_PATH + "Inventory.csv")
sales = pd.read_csv(RAW_PATH + "Retail_Sales.csv")

print("=" * 60)
print("DATASETS LOADED")
print("=" * 60)

# -----------------------------------------------------
# Function : Dataset Summary
# -----------------------------------------------------

def dataset_summary(df, name):
    print("\n" + "="*60)
    print(name.upper())
    print("="*60)

    print("\nShape:")
    print(df.shape)

    print("\nMissing Values:")
    print(df.isnull().sum())

    print("\nDuplicate Rows:")
    print(df.duplicated().sum())

    print("\nData Types:")
    print(df.dtypes)

# -----------------------------------------------------
# Initial Inspection
# -----------------------------------------------------

dataset_summary(products, "Products")
dataset_summary(customers, "Customers")
dataset_summary(stores, "Stores")
dataset_summary(inventory, "Inventory")
dataset_summary(sales, "Sales")

# =====================================================
# PRODUCTS
# =====================================================

products.drop_duplicates(inplace=True)

products["Product_Name"] = products["Product_Name"].str.strip()

products["Category"] = products["Category"].str.strip()

products["Brand"] = products["Brand"].str.strip()

products["Cost"] = products["Cost"].fillna(products["Cost"].median())

products["Price"] = products["Price"].fillna(products["Price"].median())

products["Cost"] = products["Cost"].astype(float)

products["Price"] = products["Price"].astype(float)

# =====================================================
# CUSTOMERS
# =====================================================

customers.drop_duplicates(inplace=True)

customers["Gender"] = customers["Gender"].fillna("Unknown")

customers["Segment"] = customers["Segment"].fillna("Unknown")

customers["City"] = customers["City"].fillna("Unknown")

customers["Age"] = customers["Age"].fillna(customers["Age"].median())

customers["Age"] = customers["Age"].astype(int)

customers["Gender"] = customers["Gender"].str.title()

customers["Segment"] = customers["Segment"].str.title()

# =====================================================
# STORES
# =====================================================

stores.drop_duplicates(inplace=True)

stores["Region"] = stores["Region"].str.strip()

stores["Manager"] = stores["Manager"].fillna("Unknown")

stores["Store_Size"] = stores["Store_Size"].fillna("Medium")

# =====================================================
# INVENTORY
# =====================================================

inventory.drop_duplicates(inplace=True)

inventory["Stock"] = inventory["Stock"].fillna(0)

inventory["Reorder_Level"] = inventory["Reorder_Level"].fillna(20)

inventory["Supplier"] = inventory["Supplier"].fillna("Unknown")

inventory["Stock"] = inventory["Stock"].astype(int)

inventory["Reorder_Level"] = inventory["Reorder_Level"].astype(int)

# =====================================================
# SALES
# =====================================================

sales.drop_duplicates(inplace=True)

sales["Discount"] = sales["Discount"].fillna(0)

sales["Quantity"] = sales["Quantity"].fillna(sales["Quantity"].median())

sales["Sales"] = sales["Sales"].fillna(sales["Sales"].median())

sales["Quantity"] = sales["Quantity"].astype(int)

sales["Discount"] = sales["Discount"].astype(float)

sales["Sales"] = sales["Sales"].astype(float)

# -----------------------------------------------------
# Date Conversion
# -----------------------------------------------------

sales["Date"] = pd.to_datetime(
    sales["Date"],
    errors="coerce"
)

# -----------------------------------------------------
# Remove Invalid Dates
# -----------------------------------------------------

sales = sales.dropna(subset=["Date"])

# =====================================================
# Outlier Detection (IQR Method)
# =====================================================

def remove_outliers(df, column):

    Q1 = df[column].quantile(.25)

    Q3 = df[column].quantile(.75)

    IQR = Q3 - Q1

    lower = Q1 - 1.5 * IQR

    upper = Q3 + 1.5 * IQR

    return df[
        (df[column] >= lower) &
        (df[column] <= upper)
    ]

sales = remove_outliers(sales, "Quantity")

sales = remove_outliers(sales, "Sales")

# =====================================================
# Data Validation
# =====================================================

print("\n")
print("="*60)
print("FINAL DATA VALIDATION")
print("="*60)

for name, df in {
    "Products":products,
    "Customers":customers,
    "Stores":stores,
    "Inventory":inventory,
    "Sales":sales
}.items():

    print(f"\n{name}")

    print("-"*40)

    print("Rows :",len(df))

    print("Missing Values")

    print(df.isnull().sum())

    print()

# =====================================================
# Export Cleaned Files
# =====================================================

products.to_csv(
    CLEAN_PATH + "Products_Cleaned.csv",
    index=False
)

customers.to_csv(
    CLEAN_PATH + "Customers_Cleaned.csv",
    index=False
)

stores.to_csv(
    CLEAN_PATH + "Stores_Cleaned.csv",
    index=False
)

inventory.to_csv(
    CLEAN_PATH + "Inventory_Cleaned.csv",
    index=False
)

sales.to_csv(
    CLEAN_PATH + "Retail_Sales_Cleaned.csv",
    index=False
)

print("\n")
print("="*60)
print("DATA CLEANING COMPLETED SUCCESSFULLY")
print("="*60)

print("\nCleaned files saved to:")

print(CLEAN_PATH)