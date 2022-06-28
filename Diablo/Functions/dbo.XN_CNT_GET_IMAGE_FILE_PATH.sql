USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_CNT_GET_IMAGE_FILE_PATH
■ Description				: 컨텐츠 이미지의 경로 리턴
■ Input Parameter			:                  
	@FILE_CODE	INT			: 파일코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

	SELECT DBO.XN_CNT_GET_IMAGE_FILE_PATH(31791)

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-04-05		김성호			최초생성
	2017-01-19		박형만			M 이미지 사용에서 S 이미지 사용으로 변경 
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_CNT_GET_IMAGE_FILE_PATH]
(
	@FILE_CODE INT
)
RETURNS VARCHAR(100)
AS
BEGIN

	DECLARE @FILE_PATH VARCHAR(100)

	SELECT 
		--@FILE_PATH = (REPLACE(A.KOR_NAME, ':', '') + ':/CONTENT/' + A.REGION_CODE + '/' + A.NATION_CODE + '/' + A.STATE_CODE + '/' + A.CITY_CODE + '/IMAGE/' + (CASE WHEN (A.FILE_NAME_M IS NULL OR A.FILE_NAME_M = '') THEN A.FILE_NAME_S ELSE A.FILE_NAME_M END))
		@FILE_PATH = (REPLACE(A.KOR_NAME, ':', '') + ':/CONTENT/' + A.REGION_CODE + '/' + A.NATION_CODE + '/' + A.STATE_CODE + '/' + A.CITY_CODE + '/IMAGE/' + (CASE WHEN (A.FILE_NAME_S IS NULL OR A.FILE_NAME_S = '') THEN A.FILE_NAME_M ELSE A.FILE_NAME_S END))
	FROM INF_FILE_MASTER A
	WHERE A.FILE_CODE = @FILE_CODE AND A.FILE_TYPE = 1

	RETURN @FILE_PATH

END


GO
