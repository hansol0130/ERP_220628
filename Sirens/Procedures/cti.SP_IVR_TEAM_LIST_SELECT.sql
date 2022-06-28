USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_IVR_TEAM_LIST_SELECT
■ DESCRIPTION				: IVR 서버용 팀 리스트 검색
							: 대표번호를 기준으로 하나의 팀만 가져온다.
■ INPUT PARAMETER			: 
	@KEY_NUMBERS			: 이전 대표번호 문자열 EX) '2599,4000,4010,4020,4030,4040,4050,4060,4070,4080,4090,4100,4130,4140,4160,4170,4180,4188,4670,4680,5300,'
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC CTI.SP_IVR_TEAM_LIST_SELECT '2599,4000,4010,4020,4030,4040,4050,4060,4070,4080,4090,4100,4130,4140,4160,4170,4180,4188,4670,4680,5300,'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-01-20		김성호			최초생성
   2015-06-10		김성호			팀코드 추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_IVR_TEAM_LIST_SELECT]
(
	@KEY_NUMBERS VARCHAR(4000) = ''
)
AS  
BEGIN

	WITH LIST AS
	(
		SELECT
			ROW_NUMBER() OVER(PARTITION BY A.KEY_NUMBER ORDER BY A.VIEW_YN DESC, A.USE_YN DESC, B.PUB_TYPE DESC, A.ORDER_SEQ) AS [ROW_NUMBER],
			ISNULL(A.KEY_NUMBER, '') AS [KEY_NUMBER], A.TEAM_CODE, A.TEAM_NAME, A.VIEW_YN, A.USE_YN, A.ORDER_SEQ
		FROM (
			SELECT RIGHT(A.KEY_NUMBER, 4) AS [KEY_NUMBER], A.TEAM_CODE, A.TEAM_NAME, A.VIEW_YN, A.USE_YN, A.ORDER_SEQ
			FROM Diablo.DBO.EMP_TEAM A WITH(NOLOCK)
			WHERE A.TEAM_TYPE > 0 AND A.KEY_NUMBER IS NOT NULL
			UNION ALL
			SELECT DATA, '', '', 'N', 'N', 999
			FROM DIABLO.DBO.FN_SPLIT(@KEY_NUMBERS, ',') A
			WHERE A.DATA <> ''
		) A
		LEFT JOIN Diablo.DBO.COD_PUBLIC B WITH(NOLOCK) ON B.PUB_TYPE = 'KEY.NUMBER' AND A.TEAM_CODE = B.PUB_CODE
	)
	SELECT A.KEY_NUMBER, A.TEAM_CODE, A.TEAM_NAME, (CASE WHEN A.VIEW_YN = 'Y' AND A.USE_YN = 'Y' THEN 'Y' ELSE 'N' END) AS [USE_YN]
	--SELECT A.KEY_NUMBER, A.TEAM_NAME, (CASE WHEN A.VIEW_YN = 'Y' AND A.USE_YN = 'Y' THEN 'Y' ELSE 'N' END) AS [USE_YN]
	FROM LIST A
	WHERE A.ROW_NUMBER = 1 AND A.KEY_NUMBER <> ''

END
GO
