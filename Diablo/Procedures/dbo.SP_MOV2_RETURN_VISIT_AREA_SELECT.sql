USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*================================================================================================================
■ USP_NAME					: SP_MOV2_RETURN_VISIT_AREA_SELECT
■ DESCRIPTION				: 검색_재방문_지역정보
■ INPUT PARAMETER			: @START_DATE, @END_DATE, @MASTER_CODES
■ EXEC						: 
    -- exec SP_MOV2_RETURN_VISIT_AREA_SELECT '2016-09-23', '2016-10-01', 'APA074,APP0025,APP5034'

■ MEMO						: 1개이상 본상품에서 지역정보를 가져온다
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-19		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_RETURN_VISIT_AREA_SELECT]
	@START_DATE		VARCHAR(10),
	@END_DATE		VARCHAR(10),
	@MASTER_CODES	VARCHAR(100)
AS
BEGIN

---------------------------------------------
--1 인기상품 선택
---------------------------------------------
	DECLARE @MASTER_CODE NVARCHAR(10);
	DECLARE @COMMA_COUNT INT;
	SELECT @COMMA_COUNT = CHARINDEX(',' , @MASTER_CODES)

	IF @COMMA_COUNT > 1
		BEGIN
			SELECT @MASTER_CODE = A1.MASTER_CODE FROM (
				SELECT TOP 1 B.MASTER_CODE, COUNT(*) NO FROM DBO.FN_SPLIT(@MASTER_CODES, ',') A
					INNER JOIN RES_MASTER_DAMO B WITH(NOLOCK)
						ON A.DATA = B.MASTER_CODE
					INNER JOIN PKG_MASTER C WITH(NOLOCK)
						ON A.DATA = C.MASTER_CODE
					WHERE B.NEW_DATE >= @START_DATE 
						AND B.NEW_DATE <= @END_DATE  + ' 23:59:59'
						AND C.SHOW_YN ='Y' 
					GROUP BY B.MASTER_CODE
					ORDER BY NO DESC
				) A1


			IF @MASTER_CODE IS NULL 
				BEGIN
					SELECT @MASTER_CODE = A.Data FROM (SELECT TOP 1 * from DBO.FN_SPLIT(@MASTER_CODES, ',') ORDER BY ID DESC) A
				END
		END
	ELSE
		SET @MASTER_CODE = @MASTER_CODES;

---------------------------------------------
--2 지역명 / 국가
---------------------------------------------
	SELECT TOP 1 E.NATION_CODE, E.KOR_NAME, C.SIGN_CODE, D.IMG_URL1 NATION_FLAG FROM PKG_MASTER_SCH_CITY A WITH(NOLOCK)
		INNER JOIN PUB_CITY B WITH(NOLOCK)
			ON A.CITY_CODE = B.CITY_CODE
		INNER JOIN PUB_NATION E WITH(NOLOCK)
			ON B.NATION_CODE = E.NATION_CODE
		INNER JOIN PKG_MASTER C WITH(NOLOCK)
			ON C.MASTER_CODE = A.MASTER_CODE
		LEFT JOIN SAFE_INFO_TRAVEL_WARNING D WITH(NOLOCK)
			ON D.COUNTRY_NAME = E.KOR_NAME
		WHERE A.MASTER_CODE = @MASTER_CODE
			AND A.MAINCITY_YN = 'Y'


END           


GO
