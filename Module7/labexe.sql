use AdventureWorksDW

SET STATISTICS TIME OFF
GO
--create nonclusterd index
CREATE NONCLUSTERED COLUMNSTORE INDEX NCI_FactProductInventory_UnitCost_UnitsOut ON FactProductInventory
(
	ProductKey,
	DateKey,
	UnitCost,
	UnitsOut
)
GO

--create clustered index
CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactInternetSales ON FactInternetSales
GO

--add filegroup
ALTER DATABASE AdventureWorksDW
ADD FILEGROUP  AdventureWorksDW_Memory_Optimized_Data CONTAINS MEMORY_OPTIMIZED_DATA
GO

--create filegroup for memory optimized data
ALTER DATABASE AdventureWorksDW ADD 
FILE (name='AdventureworksDW_MOD', filename='D:\LabFiles\Lab04\Starter\SetupFiles\AdventureworksDW_MOD') 
TO FILEGROUP AdventureWorksDW_Memory_Optimized_Data
GO

--enable memory optimized option
CREATE TABLE [dbo].[FactInternetSales]
(
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float](53) NOT NULL,
	[DiscountAmount] [float](53) NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CustomerPONumber] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ShipDate] [datetime] NULL,

 CONSTRAINT [FactInternetSales_primaryKey]  PRIMARY KEY NONCLUSTERED HASH 
(
	[SalesOrderNumber],
	[SalesOrderLineNumber]
)WITH ( BUCKET_COUNT = 2097152)
,INDEX CCI_OnlineFactInternetSales CLUSTERED COLUMNSTORE
)WITH ( MEMORY_OPTIMIZED = ON , DURABILITY = SCHEMA_AND_DATA )

GO