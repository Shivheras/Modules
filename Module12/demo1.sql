-- Create a memory-optimized table
USE MemDemo
GO
CREATE TABLE dbo.MemoryTable
(id INTEGER NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 1000000),
 date_value DATETIME NULL)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);


-- Create a disk-based table
CREATE TABLE dbo.DiskTable
(id INTEGER NOT NULL PRIMARY KEY NONCLUSTERED,
 date_value DATETIME NULL);


-- Insert 500,000 rows into DiskTable
BEGIN TRAN
	DECLARE @Diskid int = 1
	WHILE @Diskid <= 500000
	BEGIN
		INSERT INTO dbo.DiskTable VALUES (@Diskid, GETDATE())
		SET @Diskid += 1
	END
COMMIT;

-- Verify DiskTable contents 
-- Confirm that the table now contains 500,000 rows
SELECT COUNT(*) FROM dbo.DiskTable;

-- Insert 500,000 rows into MemoryTable 

BEGIN TRAN
	DECLARE @Memid int = 1
	WHILE @Memid <= 500000
	BEGIN
		INSERT INTO dbo.MemoryTable VALUES (@Memid, GETDATE())
		SET @Memid += 1
	END
COMMIT;

-- Verify MemoryTable contents
SELECT COUNT(*) FROM dbo.MemoryTable;

-- Delete rows from DiskTable 
DELETE FROM DiskTable;

--Delete rows from MemoryTable 
DELETE FROM MemoryTable;

-- View memory-optimized table stats
SELECT o.Name, m.* FROM sys.dm_db_xtp_table_memory_stats m
JOIN sys.sysobjects o ON m.object_id = o.id