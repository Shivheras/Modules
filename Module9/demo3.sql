USE tempdb;
GO



CREATE PROC dbo.DisplayExecutionContext
AS
SET NOCOUNT ON;
BEGIN
  SELECT * FROM sys.login_token;
  SELECT * FROM sys.user_token;
END
GO



EXEC dbo.DisplayExecutionContext;
GO



EXECUTE AS User = 'SecureUser';
GO



EXEC dbo.DisplayExecutionContext;
GO


REVERT;
GO



GRANT EXECUTE ON dbo.DisplayExecutionContext TO SecureUser;
GO



EXECUTE AS User = 'SecureUser';
GO

EXEC dbo.DisplayExecutionContext;
GO

REVERT;
GO



ALTER PROC dbo.DisplayExecutionContext
WITH EXECUTE AS OWNER
AS
SET NOCOUNT ON;
BEGIN
  SELECT * FROM sys.login_token;
  SELECT * FROM sys.user_token;
END
GO



EXECUTE AS User = 'SecureUser';
GO

EXEC dbo.DisplayExecutionContext;
GO

REVERT;
GO



DROP PROC dbo.DisplayExecutionContext;
GO