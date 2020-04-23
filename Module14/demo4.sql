USE AdventureWorks;


SELECT * FROM dbo.DatabaseLog;

SELECT EventDetail.value('PostTime[1]','datetime2') AS PostTime,EventDetail.value('SPID[1]', 'int') AS SPID,
       EventDetail.value('ObjectType[1]','sysname') AS ObjectType,EventDetail.value('ObjectName[1]','sysname') AS ObjectName
FROM dbo.DatabaseLog AS dl
CROSS APPLY dl.XmlEvent.nodes('/EVENT_INSTANCE') AS EventInfo(EventDetail) ORDER BY PostTime;

SELECT dl.DatabaseLogID,
       EventDetail.value('PostTime[1]','datetime2') AS PostTime,EventDetail.value('SPID[1]', 'int') AS SPID,
       EventDetail.value('ObjectType[1]','sysname') AS ObjectType,EventDetail.value('ObjectName[1]','sysname') AS ObjectName,dl.TSQL 
FROM dbo.DatabaseLog AS dl
CROSS APPLY dl.XmlEvent.nodes('/EVENT_INSTANCE') AS EventInfo(EventDetail) ORDER BY PostTime;


-- one of the downsides is that it's not easy to run OPENXML against multiple XML documents.

DECLARE @xmldoc AS int, @xml AS xml;
SELECT @xml=XmlEvent FROM dbo.DatabaseLog;
SELECT @xml;
EXEC sp_xml_preparedocument @xmldoc OUTPUT, @xml; 
 
SELECT * FROM OPENXML(@xmldoc, '/EVENT_INSTANCE', 2)
WITH ([PostTime] datetime2, [SPID] int , [ObjectType] sysname, [ObjectName] sysname); 
 
EXEC sp_xml_removedocument @xmldoc;