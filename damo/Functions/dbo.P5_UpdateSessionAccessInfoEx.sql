USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[P5_UpdateSessionAccessInfoEx]()
RETURNS [bit] WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [damosaexp].[DamosaExp].[P5_UpdateSessionAccessInfoEx]
GO
