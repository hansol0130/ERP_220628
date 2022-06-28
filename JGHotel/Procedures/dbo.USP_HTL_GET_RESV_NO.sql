USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_GET_RESV_NO]

/*
USP_HTL_GET_RESV_NO
*/

AS

SELECT
	CONVERT(VARCHAR, MAX(CONVERT(INT, RESV_NO))+1) AS RESV_NO
FROM HTL_RESV_MAST
WHERE ISNUMERIC(RESV_NO) = 1


GO