USE AdventureWorks;

- Step 2 - Execute RAW mode queries

SELECT ProductModelID, Name FROM Production.ProductModel WHERE ProductModelID=122 or ProductModelID=119 FOR XML RAW;

SELECT ProductModelID, Name FROM Production.ProductModel WHERE ProductModelID=122 or ProductModelID=119 FOR XML RAW('Model');

SELECT ProductModelID, Name FROM Production.ProductModel WHERE ProductModelID=122 or ProductModelID=119 FOR XML RAW('Model'), ROOT('Models');


SELECT pm.ProductModelID, pm.Name AS ProductModel,p.Name AS ProductName FROM Production.ProductModel AS pm INNER JOIN Production.Product AS p
ON pm.ProductModelID = p.ProductModelID WHERE pm.ProductModelID=122 or pm.ProductModelID=119 FOR XML AUTO;


SELECT 1 AS Tag, NULL AS Parent,ProductID AS [Product!1!ProductID],Color AS [Product!1!Color!Element]
FROM Production.Product ORDER BY ProductID FOR XML EXPLICIT;

SELECT ProductModelID,Name FROM Production.ProductModel WHERE ProductModelID IN (119,122) FOR XML PATH ('ProductModel');

SELECT ProductModelID AS "@ProductModelID",Name FROM Production.ProductModel WHERE ProductModelID IN (119,122) FOR XML PATH ('ProductModel');


SELECT Customer.CustomerID, Customer.TerritoryID, 
       (SELECT SalesOrderID, [Status] FROM Sales.SalesOrderHeader AS soh WHERE Customer.CustomerID = soh.CustomerID FOR XML AUTO, TYPE) as Orders
FROM Sales.Customer as Customer
WHERE EXISTS (SELECT 1 FROM Sales.SalesOrderHeader AS soh WHERE soh.CustomerID = Customer.CustomerID) ORDER BY Customer.CustomerID;



SELECT Customer.CustomerID, Customer.TerritoryID, 
       (SELECT SalesOrderID, soh.Status FROM Sales.SalesOrderHeader AS soh WHERE soh.CustomerID = Customer.CustomerID FOR XML AUTO) as Orders
FROM Sales.Customer as Customer
WHERE EXISTS (SELECT 1 FROM Sales.SalesOrderHeader AS soh WHERE soh.CustomerID = Customer.CustomerID) ORDER BY Customer.CustomerID;