USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[P5_VerifyResponseEx](@spid [smallint], @user [nvarchar](256), @hostName [nvarchar](256), @hostProcessId [int])
RETURNS [bit] WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [damosaexp].[DamosaExp].[P5_VerifyResponseEx]
GO
