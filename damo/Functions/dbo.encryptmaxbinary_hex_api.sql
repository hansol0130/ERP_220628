USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[encryptmaxbinary_hex_api](@spid [smallint], @spAlias [nvarchar](4000), @comment [nvarchar](4000), @tid [nvarchar](128), @shid [varbinary](128), @plaindata [varbinary](max))
RETURNS [varbinary](max) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [damosaexp].[DamosaExp].[EncryptImage_HEX_API]
GO
