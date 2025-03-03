--Display all the information for all stores whose RegionID value is 'C'(1).
SELECT *  FROM store
WHERE RegionID = 'C';

--Display CustomerID and CustomerName for all customers whose CustomerName begins with a letter 'T'(2).
SELECT CustomerID, CustomerName 
FROM customer
WHERE CustomerName LIKE 'T%';

--Display the ProductID, ProductName, and ProductPrice for products with a Product Price of $100 or higher(3).
SELECT ProductID, ProductName, ProductPrice 
FROM Products
WHERE ProductPrice >= 100;

--Display the ProductID, ProductName, and ProductPrice for products that were sold in the zip code 60600. Sort the results by ProductID(4).
SELECT productid, productname, productprice
FROM product
WHERE productid IN (SELECT productid FROM includes
WHERE tid IN (SELECT tid FROM salestransaction
WHERE storeid IN (SELECT storeid FROM store
WHERE storezip = '60600')))
ORDER BY productid;

--Display the TID, CustomerName, and TDate for sales transactions involving a customer buying a product whose ProductName is 'Easy Boot'(5).
SELECT tid, 
(SELECT customername FROM customer WHERE customerid = st.customerid) AS customername, tdate
FROM salestransaction st
WHERE tid IN (SELECT tid FROM includes WHERE 
productid = (SELECT productid FROM product WHERE productname = 'Easy Boot'));

-- Display the ProductID, ProductName, ProductPrice, and VendorName for all products. Sort the results by ProductID(6).
SELECT productid, productname, productprice, 
(SELECT vendorname FROM vendor WHERE vendorid = p.vendorid) AS vendorname
FROM product p
ORDER BY productid;





