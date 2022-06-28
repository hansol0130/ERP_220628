USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[decryptmaxbinary_hex](@spid [smallint], @schema [nvarchar](4000), @table [nvarchar](4000), @column [nvarchar](4000), @tid [nvarchar](128), @shid [varbinary](128), @encdata [varbinary](max))
RETURNS [varbinary](max) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [damosaexp].[DamosaExp].[DecryptImage_HEX]
GO
