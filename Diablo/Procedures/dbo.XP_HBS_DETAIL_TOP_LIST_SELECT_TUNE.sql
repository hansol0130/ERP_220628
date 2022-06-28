USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_HBS_DETAIL_TOP_LIST_SELECT
■ DESCRIPTION				: 게시물 검색
■ INPUT PARAMETER			: 
	@MASTER_SEQ_ARRAY		: 마스터코드 배열값
	@TOP_COUNT_ARRAY		: 탑카운터 배열값
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	DECLARE @MASTER_SEQ_ARRAY VARCHAR(30), @TOP_COUNT_ARRAY	VARCHAR(30), @CATEGORY_ARRAY VARCHAR(30)
	SELECT @MASTER_SEQ_ARRAY = '18, 1, 23, 24', @TOP_COUNT_ARRAY = '1, 2, 1, 5', @CATEGORY_ARRAY = '2, 2, 2, 0'
	exec XP_HBS_DETAIL_TOP_LIST_SELECT @MASTER_SEQ_ARRAY, @TOP_COUNT_ARRAY, @CATEGORY_ARRAY

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-24		김성호			최초생성
   2013-06-06		김성호			정렬조건 추가
   2013-06-07		김성호			CATEGORY_SEQ 조건 추가
   2013-06-19		박형만			CUS_NAME 추가 
================================================================================================================*/ 

CREATE    PROCEDURE [dbo].[XP_HBS_DETAIL_TOP_LIST_SELECT_TUNE]
(
	@MASTER_SEQ_ARRAY	VARCHAR(30),
	@TOP_COUNT_ARRAY	VARCHAR(30),
	@CATEGORY_ARRAY		VARCHAR(30)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT A.ID, CONVERT(INT, A.DATA) AS [MASTER_SEQ], CONVERT(INT, B.DATA) AS [TOP_COUNT], CONVERT(INT, C.DATA) AS [CATEGORY_SEQ]
		, (
			SELECT TOP(CONVERT(INT, B.DATA)) ('|' + CONVERT(VARCHAR(20), BOARD_SEQ)) AS [text()] 
			FROM HBS_DETAIL AA 
			WHERE AA.MASTER_SEQ = CONVERT(INT, A.DATA) AND AA.LEVEL = 0 AND AA.DEL_YN = 'N'
				AND AA.CATEGORY_SEQ = (CASE WHEN CONVERT(INT, C.DATA) > 0 THEN CONVERT(INT, C.DATA) ELSE AA.CATEGORY_SEQ END)
				AND AA.BOARD_SEQ NOT IN ( 18581 , 18580 ,18521 ,19845 ,20285 , 20617 , 21064  , 21031  ,20617 ,24918 , 38762  ,38760 , 39239 , 39192    )   -- 2015.11.06 임시 
			ORDER BY CASE AA.MASTER_SEQ WHEN '6' THEN AA.SHOW_COUNT  ELSE AA.NEW_DATE END DESC 
			FOR XML PATH('')
		) AS [BOARD_CODE]
	INTO #TEMP
	FROM DBO.FN_SPLIT(@MASTER_SEQ_ARRAY, ',') A
	INNER JOIN DBO.FN_SPLIT(@TOP_COUNT_ARRAY, ',') B ON A.ID = B.ID
	LEFT JOIN DBO.FN_SPLIT(@CATEGORY_ARRAY, ',') C ON A.ID = C.ID

	SELECT A.TOP_COUNT, B.* , ( SELECT CUS_NAME FROM CUS_CUSTOMER WHERE CUS_NO = B.NEW_CODE ) AS CUS_NAME   
	FROM #TEMP A
	INNER JOIN HBS_DETAIL B ON A.MASTER_SEQ = B.MASTER_SEQ 
	    AND B.BOARD_SEQ IN (SELECT DATA FROM DBO.FN_SPLIT(A.BOARD_CODE,'|'))
		AND B.LEVEL = 0 AND B.DEL_YN = 'N'
		AND B.CATEGORY_SEQ = (CASE WHEN A.CATEGORY_SEQ > 0 THEN A.CATEGORY_SEQ ELSE B.CATEGORY_SEQ END)
AND B.BOARD_SEQ NOT IN ( 18581 , 18580 ,18521 ,19845 ,20285 , 20617 , 21064  , 21031  ,20617 ,24918 , 38762  ,38760 , 39239 , 39192 )   -- 2015.01.26 임시 
	ORDER BY CASE B.MASTER_SEQ WHEN '6' THEN B.SHOW_COUNT  ELSE B.NEW_DATE END DESC

END



GO
