USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[encryptfixbinary3_api](@isNType [bit], @encodeType [nvarchar](30), @spid [smallint], @user [nvarchar](256), @hostName [nvarchar](256), @hostProcessId [int], @spAlias [nvarchar](4000), @comment [nvarchar](4000), @tid [nvarchar](128), @shid [varbinary](128), @plaindata [varbinary](8000))
RETURNS [varbinary](8000) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [damosaexp].[DamosaExp].[encryptbinary3_api]
GO
