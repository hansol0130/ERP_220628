USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_HISTORY_LIST_SELECT
■ DESCRIPTION				: 검색_히스토리페이지별목록
■ INPUT PARAMETER			: CUS_NO, PAGE_INDEX, PAGE_SIZE
■ EXEC						: 
    -- 
	DECLARE @TOTAL_COUNT INT
	exec SP_MOV2_HISTORY_LIST_SELECT 8505125, 1, 20, @TOTAL_COUNT OUTPUT
	SELECT @TOTAL_COUNT

■ MEMO						: 히스토리페이지별목록
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-07-27		IBSOLUTION				최초생성
   2017-10-21		IBSOLUTION				@TOTAL_COUNT 추가
   2017-12-04		IBSOLUTION				MASTER_NAME IS NOT NULL 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_HISTORY_LIST_SELECT]
	@CUS_NO			INT,
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@TOTAL_COUNT	INT OUTPUT
AS
BEGIN

	SELECT @TOTAL_COUNT = COUNT(*) 
		FROM CUS_MASTER_HISTORY A WITH(NOLOCK)
		WHERE A.CUS_NO = @CUS_NO
			AND (A.HIS_TYPE <> 1 OR (A.HIS_TYPE = 1 AND A.MASTER_CODE <> ''))

	SELECT P1.* FROM (	
		SELECT ROW_NUMBER() OVER (ORDER BY A1.HIS_DATE DESC ) AS ROWNUM, * 
		FROM ( 	
			SELECT A.* , B.SUBJECT, C.EVT_NAME, D.MASTER_NAME, D.LOW_PRICE, E.*,
				(SELECT K.INT_SEQ FROM CUS_INTEREST K WITH(NOLOCK) WHERE K.CUS_NO = @CUS_NO AND K.PRO_CODE = A.MASTER_CODE) INTEREST
			FROM CUS_MASTER_HISTORY A WITH(NOLOCK)
			LEFT JOIN HBS_DETAIL B WITH(NOLOCK)
				ON A.MASTER_SEQ = B.MASTER_SEQ
				AND A.BOARD_SEQ = B.BOARD_SEQ
			LEFT JOIN PUB_EVENT C WITH(NOLOCK)
				ON A.EVT_SEQ = C.EVT_SEQ
			LEFT JOIN PKG_MASTER D WITH(NOLOCK)
				ON A.MASTER_CODE = D.MASTER_CODE
			LEFT JOIN INF_FILE_MASTER E WITH(NOLOCK) 
				ON D.MAIN_FILE_CODE = E.FILE_CODE 
				AND E.FILE_TYPE = 1
				AND E.SHOW_YN = 'Y'				
			WHERE A.CUS_NO = @CUS_NO
				AND (A.HIS_TYPE <> 1 OR (A.HIS_TYPE = 1 AND A.MASTER_CODE <> '' AND D.MASTER_NAME IS NOT NULL))
		) A1
	) P1
	WHERE P1.ROWNUM BETWEEN (@PAGE_INDEX - 1) * @PAGE_SIZE + 1 AND @PAGE_INDEX  * @PAGE_SIZE

END           

GO
