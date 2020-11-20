# main.py
# Zain Ahmed

import mysql.connector as dbconn
from mysql.connector.catch23 import NUMERIC_TYPES
import functions
import os

# offer user a list of main options
def menu0():
    print("\nTOP MENU:")
    print("1. add a customer")
    print("2. add an order")
    print("3. remove an order")
    print("4. ship an order")
    print("5. print pending orders (not shipped yet) with customer information")
    print("6. restock products")
    print("7. exit")
    return input("Please enter your selection (1 - 7): ")

# use the default database settings for class
db = dbconn.connect(host = "localhost", user = "cs4430", passwd = "cs4430", db = "northwind")
cursor = db.cursor(buffered=True)

# run terminal command to use the northwind file
os.system('mysql < northwind.sql')
cursor.execute("use northwind")

# Get top level input
def getMenu0Response():
    resp = -1
    while (resp < 1 or resp > 7):
        try:
            resp = int(menu0())
        except ValueError:
            resp = -1
    return resp

while 1:
    menu0Response = getMenu0Response()

    if (menu0Response == 1):
        functions.addCustomer(cursor)
    elif (menu0Response == 2):
        functions.addOrder(cursor)
    elif (menu0Response == 3):
        functions.removeOrder(cursor)
    elif (menu0Response == 4):
        functions.shipOrder(cursor)
    elif (menu0Response == 5):
        functions.printPendingOrders(cursor)
    elif (menu0Response == 6):
        functions.restockProducts(cursor)
    elif (menu0Response == 7):
        print("exiting program")
        cursor.close()
        db.close()
        exit()
    else:
        print("unsupported response")

    db.commit()