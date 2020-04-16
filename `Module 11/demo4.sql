
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
	  DEFAULT (ORIGINAL_LOGIN()),
	IsValid bit NOT NULL
	  CONSTRAINT DF_CurrentPrice_IsValid
	  DEFAULT (1)
);
GO

INSERT INTO dbo.CurrentPrice 
  (SellingPrice)
  VALUES (2.3), (4.3), (5);
GO

SELECT * FROM dbo.CurrentPrice;
GO


CREATE TRIGGER TR_CurrentPrice_Delete
ON dbo.CurrentPrice
INSTEAD OF DELETE AS BEGIN
  SET NOCOUNT ON;
  UPDATE cp
  SET cp.IsValid = 0
  FROM dbo.CurrentPrice AS cp
  INNER JOIN deleted AS d
  ON cp.CurrentPriceID = d.CurrentPriceID;
END;
GO


DELETE dbo.CurrentPrice
WHERE CurrentPriceID = 2;
GO


SELECT * FROM dbo.CurrentPrice;
GO


SELECT * FROM sys.triggers;
GO



DROP TABLE dbo.CurrentPrice;
GO



CREATE TABLE dbo.PostalCode
( CustomerID int PRIMARY KEY,
  PostalCode nvarchar(5) NOT NULL,
  PostalSubCode nvarchar(5) NULL
);
GO

CREATE VIEW dbo.PostalRegion
AS
SELECT CustomerID,
       PostalCode + COALESCE('-' + PostalSubCode,'') AS PostalRegion
FROM dbo.PostalCode;
GO

INSERT dbo.PostalCode (CustomerID,PostalCode,PostalSubCode)
VALUES (1,'23422','234'),
       (2,'23523',NULL),
       (3,'08022','523');
GO
       

SELECT * FROM dbo.PostalRegion;
GO


INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (4,'09232-432');
GO


UPDATE dbo.PostalRegion SET PostalRegion = '23234-523' WHERE CustomerID = 3;
GO


DELETE FROM dbo.PostalRegion WHERE CustomerID = 3;
GO



CREATE TRIGGER TR_PostalRegion_Insert
ON dbo.PostalRegion
INSTEAD OF INSERT
AS
INSERT INTO dbo.PostalCode 
SELECT CustomerID, 
       SUBSTRING(PostalRegion,1,5),
       CASE WHEN SUBSTRING(PostalRegion,7,5) <> '' THEN SUBSTRING(PostalRegion,7,5) END
FROM inserted;
GO


INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (4,'09232-432');
GO

ALTER TRIGGER TR_PostalRegion_Insert
ON dbo.PostalRegion
INSTEAD OF INSERT
AS
SET NOCOUNT ON;
INSERT INTO dbo.PostalCode 
SELECT CustomerID, 
       SUBSTRING(PostalRegion,1,5),
       CASE WHEN SUBSTRING(PostalRegion,7,5) <> '' THEN SUBSTRING(PostalRegion,7,5) END
FROM inserted;
GO


INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (5,'92232-142');
GO


INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (6,'11111-111'),
       (7,'99999-999');
GO

SELECT * FROM dbo.PostalRegion;
GO



DROP VIEW dbo.PostalRegion;
GO
DROP TABLE dbo.PostalCode;
GO
