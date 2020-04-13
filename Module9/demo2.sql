USE AdventureWorks;
GO



CREATE PROC Production.GetBlueProducts
AS
SET NOCOUNT ON;
BEGIN
  SELECT p.ProductID,
         p.Name,
         p.Size,
         p.ListPrice 
  FROM Production.Product AS p
  WHERE p.Color = N'Blue'
  ORDER BY p.ProductID;
END;
GO



EXEC Production.GetBlueProducts;
GO



CREATE PROC Production.GetBlueProductsAndModels
AS
SET NOCOUNT ON;
BEGIN
  SELECT p.ProductID,
         p.Name,
         p.Size,
         p.ListPrice 
  FROM Production.Product AS p
  WHERE p.Color = N'Blue'
  ORDER BY p.ProductID;
  
  SELECT p.ProductID,
         pm.ProductModelID,
         pm.Name AS ModelName
  FROM Production.Product AS p
  INNER JOIN Production.ProductModel AS pm
  ON p.ProductModelID = pm.ProductModelID 
  ORDER BY p.ProductID, pm.ProductModelID;
END;
GO



EXEC Production.GetBlueProductsAndModels;
GO




ALTER PROC Production.GetBlueProductsAndModels
AS
SET NOCOUNT ON;
BEGIN
  SELECT p.ProductID,
         p.Name,
         p.Size,
         p.ListPrice 
  FROM Production.Product AS p
  WHERE p.Color = N'Blue'
  ORDER BY p.ProductID;
  
  SELECT p.ProductID,
         pm.ProductModelID,
         pm.Name AS ModelName
  FROM Production.Product AS p
  INNER JOIN Production.ProductModel AS pm
  ON p.ProductModelID = pm.ProductModelID 
  WHERE p.Color = N'Blue'
  ORDER BY p.ProductID, pm.ProductModelID;
END;
GO



EXEC Production.GetBlueProductsAndModels;
GO



SELECT SCHEMA_NAME(schema_id) AS SchemaName,
       name AS ProcedureName
FROM sys.procedures;
GO