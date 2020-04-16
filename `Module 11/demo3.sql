
USE tempdb;
GO


CREATE TABLE dbo.CurrentPrice
(
	CurrentPriceID int IDENTITY(1,1) 
	  CONSTRAINT PK_CurrentPrice PRIMARY KEY,
	SellingPrice decimal(18,2) NOT NULL,
	LastModified datetime2 NOT NULL
	  CONSTRAINT DF_CurrentPrice_LastModified
	  DEFAULT (SYSDATETIME()),
	ModifiedBy sysname NOT NULL
	  CONSTRAINT DF_CurrentPrice_ModifiedBy
	  DEFAULT (ORIGINAL_LOGIN())
);
GO


INSERT INTO dbo.CurrentPrice 
  (SellingPrice)
  VALUES (2.3), (4.3), (5);
GO

SELECT * FROM dbo.CurrentPrice;
GO
  

UPDATE dbo.CurrentPrice 
SET SellingPrice = 10 
WHERE CurrentPriceID = 2;
GO


SELECT * FROM dbo.CurrentPrice;
GO


CREATE TRIGGER TR_CurrentPrice_Update
ON dbo.CurrentPrice
AFTER UPDATE AS BEGIN
  SET NOCOUNT ON;
  UPDATE cp
  SET cp.LastModified = SYSDATETIME(),
      cp.ModifiedBy = ORIGINAL_LOGIN()
  FROM dbo.CurrentPrice AS cp
  INNER JOIN inserted AS i
  ON cp.CurrentPriceID = i.CurrentPriceID;
END;
GO


UPDATE dbo.CurrentPrice 
SET SellingPrice = 20 
WHERE CurrentPriceID = 2;
GO

SELECT * FROM dbo.CurrentPrice;
GO

SELECT * FROM sys.triggers;
GO


DROP TABLE dbo.CurrentPrice;
GO


SELECT * FROM sys.triggers;
GO
