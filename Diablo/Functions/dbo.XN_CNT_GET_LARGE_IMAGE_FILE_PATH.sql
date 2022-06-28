USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name			: XN_CNT_GET_LARGE_IMAGE_FILE_PATH
■ Description				: 컨텐츠 이미지중 가장큰 이미지의 경로 리턴
■ Input Parameter			:                  
	@CNT_CODE	INT			: 컨텐츠코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

	SELECT DBO.XN_CNT_GET_LARGE_IMAGE_FILE_PATH(31791)

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2017-02-09		오준욱			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_CNT_GET_LARGE_IMAGE_FILE_PATH]
(
	@CNT_CODE INT
)
RETURNS VARCHAR(100)
AS
BEGIN

	DECLARE @FILE_PATH VARCHAR(100)

	SELECT 
		@FILE_PATH = (REPLACE(B.KOR_NAME, ':', '') + ':/CONTENT/' + B.REGION_CODE + '/' + B.NATION_CODE + '/' + B.STATE_CODE + '/' + B.CITY_CODE + '/IMAGE/' + ( CASE WHEN (B.FILE_NAME_L IS NULL OR B.FILE_NAME_L = '') THEN 
				( CASE WHEN (B.FILE_NAME_M IS NULL OR B.FILE_NAME_M = '') THEN 
					(CASE WHEN (B.FILE_NAME_S IS NULL OR B.FILE_NAME_S = '') THEN 
						NULL
					ELSE B.FILE_NAME_S END)
				ELSE B.FILE_NAME_M END)
			ELSE B.FILE_NAME_L END))
	FROM INF_FILE_MANAGER A WITH(NOLOCK)
	INNER JOIN INF_FILE_MASTER B WITH(NOLOCK) ON A.FILE_CODE = B.FILE_CODE
	WHERE A.CNT_CODE = @CNT_CODE AND B.FILE_TYPE = 1

	RETURN @FILE_PATH

END
GO
