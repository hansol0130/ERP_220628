USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_STS_HBS_REPLY_LIST_SELECT
■ DESCRIPTION				: 게시판 응답율 현황
■ INPUT PARAMETER			: 
	@MASTER_SEQ_LIST		: 게시판 코드 (ex 4: 1:1문의게시판, 19: 고객의 소리)
	@START_DATE				: 게시글 등록 시작일
	@END_DATE				: 게시글 등록 종료일
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_STS_HBS_REPLY_LIST_SELECT '4,19', '2017-01-01', '2017-12-31'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-01-23		김성호			최초생성
   2018-01-24		박형민			CATEGORY_SEQ 추가 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_STS_HBS_REPLY_LIST_SELECT]
(
	@MASTER_SEQ_LIST	VARCHAR(20) = '4',
	@START_DATE			DATE,
	@END_DATE			DATE
)

AS  
BEGIN

	WITH BOARD_LIST AS (
		SELECT
			A.MASTER_SEQ, A.BOARD_SEQ, A.PARENT_SEQ, A.CATEGORY_SEQ, ISNULL(A.REGION_NAME, '') AS [REGION_NAME], A.NEW_DATE --, ISNULL(B.CATEGORY_NAME, '') AS [CATEGORY_NAME]
		FROM HBS_DETAIL A WITH(NOLOCK)
		--LEFT JOIN HBS_CATEGORY B ON A.MASTER_SEQ = B.MASTER_SEQ AND A.CATEGORY_SEQ = B.CATEGORY_SEQ
		WHERE A.MASTER_SEQ IN (SELECT DATA FROM DBO.FN_SPLIT(@MASTER_SEQ_LIST, ',')) AND A.NEW_DATE > @START_DATE AND A.NEW_DATE < DATEADD(DD, 1, @END_DATE) AND A.BOARD_SEQ = A.PARENT_SEQ AND A.DEL_YN = 'N'
	)
	SELECT A.MASTER_SEQ, A.BOARD_SEQ,A.CATEGORY_SEQ, A.REGION_NAME, A.NEW_DATE, D.TEAM_NAME, C.KOR_NAME, B.NEW_DATE AS [REPLY_DATE]--, DATEDIFF(HH, A.NEW_DATE, B.NEW_DATE) AS [DATE_DIFF]
		, (CASE
				WHEN DATEDIFF(HH, A.NEW_DATE, B.NEW_DATE) <= 4 THEN '4'
				WHEN DATEDIFF(HH, A.NEW_DATE, B.NEW_DATE) <= 12 THEN '12'
				WHEN DATEDIFF(HH, A.NEW_DATE, B.NEW_DATE) <= 24 THEN '24'
				WHEN DATEDIFF(HH, A.NEW_DATE, B.NEW_DATE) <= 48 THEN '48'
				WHEN DATEDIFF(HH, A.NEW_DATE, B.NEW_DATE) > 48 THEN 'Time Over'
				ELSE '-'
			END) AS [DIFF_TYPE]
	FROM BOARD_LIST A
	LEFT JOIN HBS_DETAIL B WITH(NOLOCK) ON A.MASTER_SEQ = B.MASTER_SEQ AND A.BOARD_SEQ = B.PARENT_SEQ AND B.BOARD_SEQ <> B.PARENT_SEQ
	LEFT JOIN EMP_MASTER_DAMO C WITH(NOLOCK) ON B.NEW_CODE = C.EMP_CODE
	LEFT JOIN EMP_TEAM D WITH(NOLOCK) ON C.TEAM_CODE = D.TEAM_CODE
	ORDER BY A.MASTER_SEQ, A.NEW_DATE

END


GO
