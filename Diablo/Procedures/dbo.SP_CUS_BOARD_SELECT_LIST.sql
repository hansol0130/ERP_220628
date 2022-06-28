USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CUS_BOARD_SELECT_LIST
■ DESCRIPTION				: ERP 회원 게시판 내역 조회
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@CATEGORY				: 카테고리구분코드
	@KEY VARCHAR(100)		: 검색 키
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 상담 내역
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-01-16		정지용			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_CUS_BOARD_SELECT_LIST]
	@PAGE_INDEX INT,
	@PAGE_SIZE INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CUS_NO INT;
	DECLARE @MASTER_SEQ INT;
	DECLARE @ARR_MASTER_SEQ VARCHAR(10);

	SELECT
		@CUS_NO = Diablo.dbo.FN_PARAM(@KEY, 'CusNo'),
		@MASTER_SEQ = Diablo.dbo.FN_PARAM(@KEY, 'MasterSeq');

	IF @MASTER_SEQ = 4
	BEGIN
		SET @ARR_MASTER_SEQ = '4,12,24'; /* 1:1문의, 자유여행 1:1문의, 1:1담당자별 문의게시판 */
	END
	ELSE
	BEGIN
		SET @ARR_MASTER_SEQ = @MASTER_SEQ;
	END

	SELECT 
		@TOTAL_COUNT = COUNT(1)
	FROM Diablo.dbo.HBS_DETAIL HBS WITH(NOLOCK)
	INNER JOIN Diablo.dbo.HBS_MASTER MAS WITH(NOLOCK) ON HBS.MASTER_SEQ = MAS.MASTER_SEQ
	WHERE 
		HBS.NEW_CODE = @CUS_NO
		AND HBS.DEL_YN = 'N'
		AND ((@MASTER_SEQ = 0) OR (HBS.MASTER_SEQ IN ( SELECT Data FROM Diablo.dbo.FN_SPLIT(@ARR_MASTER_SEQ, ','))));

	SELECT
		HBS.MASTER_SEQ,
		MAS.SUBJECT AS CATEGORY_NAME,
		HBS.BOARD_SEQ,
		HBS.CATEGORY_SEQ,
		HBS.REGION_NAME,
		HBS.MASTER_CODE,
		HBS.SUBJECT,
		HBS.CONTENTS,
		HBS.NEW_CODE,
		HBS.COMPLETE_YN,
		MAS.GROUP_CODE,
		HBS.NEW_DATE
	FROM Diablo.dbo.HBS_DETAIL HBS WITH(NOLOCK)
	INNER JOIN Diablo.dbo.HBS_MASTER MAS WITH(NOLOCK) ON HBS.MASTER_SEQ = MAS.MASTER_SEQ
	WHERE HBS.NEW_CODE = @CUS_NO
		AND HBS.DEL_YN = 'N'
		AND ((@MASTER_SEQ = 0) OR (HBS.MASTER_SEQ IN ( SELECT Data FROM Diablo.dbo.FN_SPLIT(@ARR_MASTER_SEQ, ','))))
	ORDER BY HBS.NEW_DATE DESC
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY;

	SET NOCOUNT OFF;
END
GO
