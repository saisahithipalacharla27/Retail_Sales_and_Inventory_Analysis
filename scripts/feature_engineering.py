# =====================================================
# Retail Sales & Inventory Analysis
# Feature Engineering
# =====================================================

import pandas as pd
import numpy as np
import os

# =====================================================
# Paths
# =====================================================

CLEAN_PATH = "../data/cleaned/"
FINAL_PATH = "../data/final/"

os.makedirs(FINAL_PATH, exist_ok=True)

# =====================================================
# Load Cleaned Files
# =====================================================

products = pd.read_csv(CLEAN_PATH + "Products_Cleaned.csv")
customers = pd.read_csv(CLEAN_PATH + "Customers_Cleaned.csv")
stores = pd.read_csv(CLEAN_PATH + "Stores_Cleaned.csv")
inventory = pd.read_csv(CLEAN_PATH + "Inventory_Cleaned.csv")
sales = pd.read_csv(CLEAN_PATH + "Retail_Sales_Cleaned.csv")

print("=" * 60)
print("CLEANED FILES LOADED")
print("=" * 60)

# =====================================================
# Convert Date
# =====================================================

sales["Date"] = pd.to_datetime(sales["Date"])

# =====================================================
# Merge Datasets
# =====================================================

df = sales.merge(
    products,
    on="Product_ID",
    how="left"
)

df = df.merge(
    customers,
    on="Customer_ID",
    how="left"
)

df = df.merge(
    stores,
    on="Store_ID",
    how="left"
)

df = df.merge(
    inventory,
    on=["Product_ID", "Store_ID"],
    how="left"
)

print("\nMerged Dataset Shape:", df.shape)

# =====================================================
# Feature Engineering
# =====================================================

# Gross Sales
df["Sales Value"] = df["Quantity"] * df["Price"]

# Discount Amount
df["Discount Amount"] = (
    df["Sales Value"] * df["Discount"] / 100
)

# Revenue (Net Sales)
df["Revenue"] = (
    df["Sales Value"] - df["Discount Amount"]
)

# Cost of Goods Sold
df["COGS"] = (
    df["Quantity"] * df["Cost"]
)

# Profit
df["Profit"] = (
    df["Revenue"] - df["COGS"]
)

# Profit Margin
df["Profit Margin (%)"] = np.where(
    df["Revenue"] > 0,
    (df["Profit"] / df["Revenue"]) * 100,
    0
)

# Average Selling Price
df["ASP"] = np.where(
    df["Quantity"] > 0,
    df["Revenue"] / df["Quantity"],
    0
)

# =====================================================
# Date Features
# =====================================================

df["Year"] = df["Date"].dt.year

df["Quarter"] = "Q" + df["Date"].dt.quarter.astype(str)

df["Month"] = df["Date"].dt.month_name()

df["Month Number"] = df["Date"].dt.month

df["Week"] = df["Date"].dt.isocalendar().week.astype(int)

df["Weekday"] = df["Date"].dt.day_name()

# =====================================================
# Season
# =====================================================

def season(month):

    if month in [12,1,2]:
        return "Winter"

    elif month in [3,4,5]:
        return "Summer"

    elif month in [6,7,8]:
        return "Monsoon"

    return "Festive"

df["Season"] = df["Month Number"].apply(season)

# =====================================================
# Inventory Features
# =====================================================

df["Inventory Status"] = np.where(
    df["Stock"] <= df["Reorder_Level"],
    "Reorder",
    "Available"
)

def stock_status(stock):

    if stock < 20:
        return "Low"

    elif stock < 80:
        return "Medium"

    return "High"

df["Stock Status"] = df["Stock"].apply(stock_status)

df["Inventory Turnover"] = np.where(
    df["Stock"] > 0,
    df["Quantity"] / df["Stock"],
    0
)

# =====================================================
# Order Size
# =====================================================

def order_size(qty):

    if qty <= 2:
        return "Small"

    elif qty <= 5:
        return "Medium"

    return "Large"

df["Order Size"] = df["Quantity"].apply(order_size)

# =====================================================
# Business Validation
# =====================================================

print("\n")
print("=" * 60)
print("FEATURE SUMMARY")
print("=" * 60)

print(df[[
    "Revenue",
    "Profit",
    "Profit Margin (%)",
    "Inventory Turnover"
]].describe())

print("\nMissing Values")

print(df.isnull().sum())

# =====================================================
# Export Final Dataset
# =====================================================

df.to_csv(
    FINAL_PATH + "Retail_Sales_Final.csv",
    index=False
)

print("\n")
print("=" * 60)
print("FEATURE ENGINEERING COMPLETED")
print("=" * 60)

print("\nFinal Dataset Shape:", df.shape)

print("\nSaved To:")

print(FINAL_PATH + "Retail_Sales_Final.csv")