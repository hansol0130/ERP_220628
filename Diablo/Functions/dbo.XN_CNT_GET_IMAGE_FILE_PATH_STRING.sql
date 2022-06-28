USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_CNT_GET_IMAGE_FILE_PATH_STRING
■ Description				: 컨텐츠의 이미지 경로를 문자열로 리턴
■ Input Parameter			:                  
	@FILE_CODE	INT			: 파일코드
	@TOP_COUNT	INT			: 가져올 파일 수
	@EXPRESS	VARCHAR(1)	: 구분자
■ Output Parameter			:                  
■ Output Value				: 유니버셜스튜디오:/CONTENT/310/JP/J33/OSA/IMAGE/31791_2.jpg|유니버셜스튜디오:/CONTENT/310/JP/J33/OSA/IMAGE/31792_2.jpg
■ Exec						: 

	SELECT DBO.XN_CNT_GET_IMAGE_FILE_PATH_STRING(31791, 3, '|')
	SELECT DBO.XN_CNT_GET_IMAGE_FILE_PATH_STRING(18949, 2, '|')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-04-05		김성호			최초생성
	2016-08-08		김성호			파일타입 이미지 만 검색되도록 수정
	2019-03-12		김성호			CNT_CODE, TOP_COUNT 조건문 추가
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_CNT_GET_IMAGE_FILE_PATH_STRING]
(
	@CNT_CODE INT,
	@TOP_COUNT INT,
	@EXPRESS VARCHAR(1)
)
RETURNS VARCHAR(1000)
AS
BEGIN

	DECLARE @FILE_PATH_STRING VARCHAR(1000);

	IF @CNT_CODE > 0 AND @TOP_COUNT > 0
	BEGIN

		SELECT @FILE_PATH_STRING = (
			SELECT STUFF((
				SELECT TOP (@TOP_COUNT) (@EXPRESS + DBO.XN_CNT_GET_IMAGE_FILE_PATH(A.FILE_CODE)) AS [text()]
				FROM INF_FILE_MANAGER A WITH(NOLOCK)
				INNER JOIN INF_FILE_MASTER B WITH(NOLOCK) ON A.FILE_CODE = B.FILE_CODE
				WHERE A.CNT_CODE = @CNT_CODE AND B.FILE_TYPE = 1
				ORDER BY A.SHOW_ORDER
				FOR XML PATH('')
			), 1, 1, '')
		)

	END

	--WITH LIST AS
	--(
	--	SELECT STUFF((
	--		SELECT TOP (@TOP_COUNT) (@EXPRESS + DBO.XN_CNT_GET_IMAGE_FILE_PATH(A.FILE_CODE)) AS [text()]
	--		FROM INF_FILE_MANAGER A WITH(NOLOCK)
	--		INNER JOIN INF_FILE_MASTER B WITH(NOLOCK) ON A.FILE_CODE = B.FILE_CODE
	--		WHERE A.CNT_CODE = @CNT_CODE AND B.FILE_TYPE = 1
	--		ORDER BY A.SHOW_ORDER
	--		FOR XML PATH('')
	--	), 1, 1, '') AS [FILE_PATH_STRING]
	--)
	--SELECT @FILE_PATH_STRING = A.FILE_PATH_STRING FROM LIST A

	RETURN @FILE_PATH_STRING

END




GO
