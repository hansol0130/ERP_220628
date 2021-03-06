USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SET_ZZIM]

/*
USP_SET_ZZIM 'D', 'JACKSMT', '2', 'AAAA'
*/

@TYPE VARCHAR(1),
@USER_ID VARCHAR(50),
@HOTEL_CODE INT,
@CITY_CODE INT,
@HOTEL_LINK VARCHAR(200)

AS

DECLARE @CNT INT;
SELECT @CNT = COUNT(*) FROM HTL_ZZIM WHERE [USER_ID]=@USER_ID AND HOTEL_CODE=@HOTEL_CODE AND HOTEL_LINK=@HOTEL_LINK;

IF (@TYPE='I')
	BEGIN
		IF (@CNT=0)
			BEGIN
				INSERT INTO HTL_ZZIM
				(
					USER_ID,
					HOTEL_CODE,
					CITY_CODE,
					HOTEL_LINK,
					CREATE_DATE
				)
				VALUES
				(
					@USER_ID,
					@HOTEL_CODE,
					@CITY_CODE,
					@HOTEL_LINK,
					GETDATE()
				);
				SELECT @@identity AS ZZIM_NO, @HOTEL_CODE AS HOTEL_CODE;
			END
		ELSE 
			BEGIN 
				SELECT 0 AS ZZIM_NO, @HOTEL_CODE AS HOTEL_CODE;
			END 
	END
ELSE IF (@TYPE='D')
	BEGIN

	IF (@CNT=0)
			BEGIN
				SELECT 0 AS ZZIM_NO, @HOTEL_CODE AS HOTEL_CODE;
			END
		ELSE 
			BEGIN 
				DELETE HTL_ZZIM WHERE [USER_ID]=@USER_ID AND HOTEL_CODE=@HOTEL_CODE AND HOTEL_LINK=@HOTEL_LINK;
				SELECT 0 AS ZZIM_NO, @HOTEL_CODE AS HOTEL_CODE;
			END 

	END

GO
