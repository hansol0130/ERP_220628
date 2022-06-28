USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[meta_str_fast_data](@inData [varbinary](8000), @strKey [varbinary](16), @strBlock [nvarchar](2000), @strFreq [nvarchar](2000))
RETURNS [varbinary](8000) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [damosaexp].[DamosaExp].[MetaStrData]
GO
