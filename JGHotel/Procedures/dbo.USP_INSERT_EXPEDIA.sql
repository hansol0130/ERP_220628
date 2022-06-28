USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_INSERT_EXPEDIA]

/*
USP_INSERT_EXPEDIA '<XML />'
*/

@XML VARCHAR(MAX)

AS

DECLARE @XML_DOCUMENT_HANDLE INT;
DECLARE @XML_DOCUMENT VARCHAR(MAX);
SET @XML_DOCUMENT = '<?xml version="1.0" encoding="euc-kr"?>' + @XML

EXEC SP_XML_PREPAREDOCUMENT @XML_DOCUMENT_HANDLE OUTPUT, @XML_DOCUMENT

CREATE TABLE #TMP_TABLE (
	HOTEL_CODE INT,
	CAPTION VARCHAR(200),
	IMG_THUMB VARCHAR(200),
	IMG_URL VARCHAR(200),
	MAIN_YN VARCHAR(1),
	USE_YN VARCHAR(1),
	CREATE_DATE DATETIME,
	CREATE_USER VARCHAR(30),
	UPDATE_DATE DATETIME,
	UPDATE_USER VARCHAR(30),
	IMG_Y VARCHAR(200),
	IMG_Z VARCHAR(200)
)

INSERT INTO #TMP_TABLE
SELECT 
	HOTEL_CODE, CAPTION, IMG_THUMB, IMG_URL, MAIN_YN, USE_YN,
	CREATE_DATE, CREATE_USER, UPDATE_DATE, UPDATE_USER, IMG_Y, IMG_Z
FROM OPENXML (@XML_DOCUMENT_HANDLE, '/ArrayOfExpediaRQ/ExpediaRQ',2)                 
WITH (  
	HOTEL_CODE INT './HotelCode', 
	CAPTION VARCHAR(200) './Caption',
	IMG_THUMB VARCHAR(200) './ImgThumb',
	IMG_URL VARCHAR(200) './ImgUrl',
	MAIN_YN VARCHAR(1) './MainYn',
	USE_YN VARCHAR(1) './UseYn',
	CREATE_DATE DATETIME './CreateDate',
	CREATE_USER VARCHAR(30) './CreateUser',
	UPDATE_DATE DATETIME './UpdateDate',
	UPDATE_USER VARCHAR(30) './UpdateUser',
	IMG_Y VARCHAR(200) './ImgY',
	IMG_Z VARCHAR(200) './ImgZ'
) A


DECLARE @CNT INT;
DECLARE @HOTEL_CODE INT;
DECLARE @IMG_URL VARCHAR(1000);

SET @CNT = 0;
SET @HOTEL_CODE = 0;
SET @IMG_URL = '';

--호텔코드 수집
SELECT TOP 1 @HOTEL_CODE = HOTEL_CODE FROM #TMP_TABLE
SELECT @CNT = COUNT(*) FROM HTL_INFO_MAST_HOTEL WHERE HOTEL_CODE= @HOTEL_CODE

--이미지 적용
IF(@CNT > 0)
	BEGIN

		--있으면 삭제
		DELETE FROM HTL_INFO_MAST_IMAGE
		WHERE HOTEL_CODE = @HOTEL_CODE

		--인서트
		INSERT INTO HTL_INFO_MAST_IMAGE
		(
			HOTEL_CODE,
			CAPTION,
			IMG_THUMB,
			IMG_URL,
			MAIN_YN,
			USE_YN,
			CREATE_DATE,
			CREATE_USER,
			UPDATE_DATE,
			UPDATE_USER,
			IMG_Y,
			IMG_Z
		)
		SELECT * FROM #TMP_TABLE

		--메인이미지 수집
		SELECT @IMG_URL = IMG_URL
		FROM (
			SELECT RANK() OVER (ORDER BY MAIN_YN DESC, CHARINDEX('Exterior', CAPTION) DESC, CREATE_USER ASC, IMG_THUMB ASC) AS SORT, *
			FROM HTL_INFO_MAST_IMAGE 
			WHERE HOTEL_CODE = @HOTEL_CODE
		) A
		WHERE SORT=1

		--메인이미지 변경
		UPDATE HTL_INFO_MAST_HOTEL SET MAIN_IMG = @IMG_URL
		WHERE HOTEL_CODE = @HOTEL_CODE

	END

EXEC SP_XML_REMOVEDOCUMENT @XML_DOCUMENT_HANDLE 


GO