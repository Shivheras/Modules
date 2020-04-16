
USE AdventureWorks;
GO


SELECT * FROM Sales.SalesTerritoryHistory;
GO


CREATE TRIGGER TR_SalesTerritoryHistory_Delete
ON Sales.SalesTerritoryHistory
AFTER DELETE AS BEGIN
  IF EXISTS(SELECT 1
            FROM deleted AS d
            WHERE d.EndDate IS NULL) BEGIN
    PRINT 'Current Sales Territory History rows cannot be deleted';
    ROLLBACK;
  END;
END;
GO


SELECT * FROM Sales.SalesTerritoryHistory WHERE BusinessEntityID = 283;
GO

DELETE FROM Sales.SalesTerritoryHistory 
WHERE BusinessEntityID = 283;
GO

DROP TRIGGER Sales.TR_SalesTerritoryHistory_Delete;
GO

