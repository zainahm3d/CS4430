# functions.py
# Zain Ahmed

from mysql.connector import cursor
from datetime import datetime

# makes sure there are no letters in input
def validateInteger(inStr):
    if (type(inStr) == str):
        try:
            int(inStr)
        except ValueError:
            inStr = input("not an integer, try again: ")
    return inStr

def addCustomer(cursor):
    id = input("Enter 5 digit customer ID: ")

    # ensure customer ID is not used
    cursor.execute(f'select companyName from customers where CustomerID = \'{id}\'')
    cName = cursor.fetchone()
    while cName is not None:
        id = input("ID already taken. Please enter another 5 digit customer ID: ")
        cursor.reset()
        cursor.execute(f'select companyName from customers where CustomerID = \'{id}\'')
        cName = cursor.fetchone()
    cursor.reset()

    companyName = input("Enter company name: ")
    contact = input("Enter contact name: ")
    contactTitle = input("Enter contact title: ")
    address = input("Enter address: ")
    city = input("Enter city: ")
    region = input("Enter region: ")
    postalCode = input("Enter postal code: ")
    country = input("Enter country: ")
    phone = input("Enter phone number: ")
    fax = input("Enter fax number: ")

    # add in customer
    cursor.execute(f'INSERT INTO customers VALUES (\'{id}\',\'{companyName}\',\'{contact}\',\'{contactTitle}\',\'{address}\',\'{country}\',\'{region}\',\'{postalCode}\',\'{country}\',\'{phone}\',\'{fax}\')')


    print("Successfully added customer")

def addOrder(cursor):
    # start transaction
    cursor.execute('start transaction')
    cursor.reset();

    # get next available order ID
    cursor.execute('select max(orderID) from orders')
    orderID = int(cursor.fetchone()[0]) + 1;
    print(f'New order ID will be: {orderID}')
    productID = input("Enter product ID: ")
    customerID = input("Enter customer ID: ")

    # get next available employee ID (according to requirements doc)
    cursor.execute('select max(employeeID) from orders')
    employeeID = int(cursor.fetchone()[0]) + 1;
    print(f'New employee ID will be: {employeeID}')

    orderDate = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f'Order date: {orderDate}')

    requiredDate = input("Enter required date (YYYY-MM-DD HH-MM-SS): ")
    shippedDate = input("Enter shipped date (YYYY-MM-DD HH-MM-SS): ")
    shipVia = input("Enter ship via: ")
    freight = float(input("Enter freight: "))
    shipName = input("Enter name to ship to: ")
    address = input("Enter address: ")
    city = input("Enter city: ")
    region = input("Enter region: ")
    postalCode = input("Enter postal code: ")
    country = input("Enter country: ")

    cursor.execute(f'insert into order_details values ()')
    cursor.execute(f'insert into orders values ( \'{orderID}\',\'{customerID}\',\'{employeeID}\',\'{orderDate}\',\'{requiredDate}\',\'{shippedDate}\',\'{shipVia}\',\'{freight}\'\'{shipName}\',\'{address}\',\'{city}\',\'{region}\',\'{postalCode}\',\'{country}\')')

    print("Adding order and committing transaction")
    # end transaction
    cursor.execute('commit')
    cursor.reset();

    print("done")

def removeOrder(cursor):
    id = validateInteger(input("Please enter an order ID to remove: "))

    # see if order exists
    cursor.execute(f'select * from orders where orderID = \'{id}\'')
    order = cursor.fetchone()
    if order is None:
        print("Order does not exist.")
    else:
        print("Order found, deleting...")
    cursor.reset()

    cursor.execute(f'select productID from order_details where orderID = {id}')
    productID = cursor.fetchone()
    productID = productID[0]
    cursor.reset()

    # get order quantity
    cursor.execute(f'select quantity from order_details where orderID = {id}')
    orderQuantity = cursor.fetchone()
    orderQuantity = int(orderQuantity[0])
    print(f'Current order quantity: {orderQuantity}')
    cursor.reset()

    # get original units on order order quantity
    cursor.execute(f'select max(UnitsOnOrder) from products where productID = {productID}')
    unitsOnOrder = int(cursor.fetchone()[0])
    print(f'Current units on order: {unitsOnOrder}')
    cursor.reset()

    newUnitsOnOrder = unitsOnOrder - orderQuantity
    if (newUnitsOnOrder < 0):
        newUnitsOnOrder = 0
    print(f'New units on order count: {newUnitsOnOrder}')

    # update units on order attribute
    cursor.execute(f'update products set UnitsOnOrder = {newUnitsOnOrder} where productID = {productID}')
    cursor.reset()

    cursor.execute(f'delete from order_details where orderID = \'{id}\'')
    cursor.execute(f'delete from orders where orderID = \'{id}\'')

def shipOrder(cursor):
    id = validateInteger(input("Please enter an order ID to ship: "))

    # see if order exists
    cursor.execute(f'select shippedDate, orderID from orders where orderID = \'{id}\'')
    order = cursor.fetchone()
    if order is None:
        print("Order does not exist.")
        return
    else:
        if order[0] is not None:
            print("order has already been shipped!")
            return
    cursor.reset()

    shipDate = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f'Shipping order now. Ship date: {shipDate}')
    cursor.execute(f'update orders set shippedDate = \'{shipDate}\' where orderID = \'{id}\'')

def printPendingOrders(cursor):
    cursor.execute("""select OrderDate, OrderID, CustomerID
                    from orders where ShippedDate is NULL
                    order by OrderDate""")

    print("Pending orders: ")

    pendingOrders = cursor.fetchall()
    for i in pendingOrders:

        # grab company name
        cursor.execute(f'select companyName from customers where CustomerID = \'{i[2]}\'')
        cName = cursor.fetchone()
        cursor.reset()

        # grab company contact name
        cursor.execute(f'select ContactName from customers where CustomerID = \'{i[2]}\'')
        cContact = cursor.fetchone()
        cursor.reset()

        print(f'Date: {i[0]}, Order ID: {i[1]}, Customer ID: {i[2]}, Company Name: {cName[0]}, Company Contact: {cContact[0]}')

def restockProducts(cursor):
    productID = input("Enter a product ID to restock: ")
    productName = ''
    oldCount = 0

    # start transaction
    cursor.execute('start transaction')
    cursor.reset();

    # see if product exists
    cursor.execute(f'select productName, UnitsInStock from products where productID = \'{productID}\'')
    product = cursor.fetchone()
    if product is None:
        print("Product does not exist.")
        return
    else:
        if product[0] is not None:
            print(f'We will be restocking "{product[0]}". There are currently {product[1]} in stock.')
            productName = product[0]
            oldCount = int(product[1])
    cursor.reset()

    numItems = int(input("Number of new stock items to add: "))

    # add in the new items
    newCount = numItems + oldCount
    cursor.execute(f'update products set UnitsInStock = {newCount} where productID = \'{productID}\'')
    cursor.reset()

    # get new count
    cursor.execute(f'select UnitsInStock from products where productID = \'{productID}\'')
    product = cursor.fetchone()
    newCount = int(product[0])
    cursor.reset()

    print(f'Restock complete, there are now {newCount} "{productName}" in stock')

    # end transaction
    cursor.execute('commit')
    cursor.reset();
    print("Transaction committed")
