

USE AdventureWorks;
GO



EXEC sp_configure;
GO


EXEC xp_dirtree "D:\DemoFiles\Mod09",0,1;
GO