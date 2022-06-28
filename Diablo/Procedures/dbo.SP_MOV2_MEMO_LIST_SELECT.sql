USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_MEMO_LIST_SELECT
■ DESCRIPTION				: 검색_메모목록
■ INPUT PARAMETER			: RES_CODE, SEQ_NO, ORDER_TYPE, LIST_TYPE, DAY_NO, CNT_CODE
■ EXEC						: 
    -- SP_MOV2_MEMO_LIST_SELECT 'RP1703032908', 1, 0, 1, 0, 0		-- 출발자(RP1703032908, 1) 검색_메모목록(일차순)
	-- SP_MOV2_MEMO_LIST_SELECT 'RP1703032908', 1, 0, 2, 2, 0		-- 출발자(RP1703032908, 1) 검색_메모일자별목록 (2일차 )
	-- SP_MOV2_MEMO_LIST_SELECT 'RP1703032908', 1, 0, 3, 0, 19755	-- 출발자(RP1703032908, 1) 검색_메모컨텐츠별목록 cnt_code : 19755 에 해당하는 메모목록

■ MEMO						: 출발자의 메모목록을 가져온다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_MEMO_LIST_SELECT]
	@RES_CODE		VARCHAR(20),
	@SEQ_NO			VARCHAR(20),
	@ORDER_TYPE		int,
	@LIST_TYPE		int,
	@DAY_NO			VARCHAR(20),
	@CNT_CODE		VARCHAR(20)
AS
BEGIN
	DECLARE @SQLSTRING NVARCHAR(4000), @SQLORDER NVARCHAR(100)

	IF @LIST_TYPE = 1           
		BEGIN
			IF @ORDER_TYPE = 1 
				BEGIN
					SET @SQLORDER = ' ORDER BY T.DAY_NO, T.NEW_DATE DESC ';
				END
			ELSE
				BEGIN				
					SET @SQLORDER = ' ORDER BY T.NEW_DATE DESC ';
				END

			SET @SQLSTRING = N'
				SELECT T.MEMO_NO, T.RES_CODE, T.SEQ_NO, T.DAY_NO, T.CNT_CODE, T.MEMO_TITLE, T.MEMO_CONTENT, T.NEW_DATE, A.KOR_TITLE
				FROM TRAVEL_MEMO T WITH (NOLOCK) 
				LEFT JOIN INF_MASTER A WITH (NOLOCK) 
				ON T.CNT_CODE = A.CNT_CODE
				WHERE T.RES_CODE = ''' + @RES_CODE + ''' AND T.SEQ_NO = ' + @SEQ_NO + ' ' + @SQLORDER
		END
	ELSE IF @LIST_TYPE = 2
		BEGIN
			SET @SQLSTRING = N'
				SELECT T.MEMO_NO, T.RES_CODE, T.SEQ_NO, T.DAY_NO, T.CNT_CODE, T.MEMO_TITLE, T.MEMO_CONTENT, T.NEW_DATE, A.KOR_TITLE
				FROM TRAVEL_MEMO T WITH (NOLOCK) 
				LEFT JOIN INF_MASTER A WITH (NOLOCK) 
				ON T.CNT_CODE = A.CNT_CODE
				WHERE T.RES_CODE = ''' + @RES_CODE + ''' AND T.SEQ_NO = ' + @SEQ_NO + ' AND T.DAY_NO = ' + @DAY_NO + '
				ORDER BY T.NEW_DATE DESC '
		END
	ELSE
		BEGIN
			SET @SQLSTRING = N'
				SELECT T.MEMO_NO, T.RES_CODE, T.SEQ_NO, T.DAY_NO, T.CNT_CODE, T.MEMO_TITLE, T.MEMO_CONTENT, T.NEW_DATE, A.KOR_TITLE
				FROM TRAVEL_MEMO T WITH (NOLOCK) 
				LEFT JOIN INF_MASTER A WITH (NOLOCK) 
				ON T.CNT_CODE = A.CNT_CODE
				WHERE T.RES_CODE = ''' + @RES_CODE + ''' AND T.SEQ_NO = ' + @SEQ_NO + ' AND ( T.CNT_CODE = 0 OR T.CNT_CODE = ' + @CNT_CODE + ')
				ORDER BY T.NEW_DATE DESC '
		END

	-- PRINT @SQLSTRING
	EXEC SP_EXECUTESQL @SQLSTRING
END           



GO
