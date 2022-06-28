USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[encryptmaxbinary2_pe](@spid [smallint], @isNType [smallint], @partEncodeType [smallint], @user [nvarchar](256), @schema [nvarchar](4000), @table [nvarchar](4000), @column [nvarchar](4000), @tid [nvarchar](128), @shid [varbinary](128), @plaindata [varbinary](max))
RETURNS [varbinary](max) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [damosaexp].[DamosaExp].[EncryptImage2_PE]
GO
