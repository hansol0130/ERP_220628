USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_INFO_MAST_DELETE]

/*
USP_HTL_INFO_MAST_DELETE '9000002'
*/

@HOTEL_CODE VARCHAR(50)

AS

DELETE FROM HTL_INFO_MAST_HOTEL WHERE HOTEL_CODE=@HOTEL_CODE

DELETE FROM HTL_INFO_MAST_DESC WHERE HOTEL_CODE=@HOTEL_CODE

DELETE FROM HTL_INFO_MAST_IMAGE WHERE HOTEL_CODE=@HOTEL_CODE

DELETE FROM HTL_MAPP_HOTEL WHERE HOTEL_CODE=@HOTEL_CODE


GO
