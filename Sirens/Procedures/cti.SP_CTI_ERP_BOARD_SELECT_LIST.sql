USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_BOARD_SELECT_LIST
■ DESCRIPTION				: ERP 게시글내역 조회
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@CATEGORY				: 카테고리구분코드
	@KEY VARCHAR(100)		: 검색 키
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 상담 내역
■ EXEC						: 

	DECLARE @TOTAL_COUNT INT, @KEY VARCHAR(100)
	SELECT @KEY = N'CusNo=4228549&MasterSeq=4'
	exec cti.SP_CTI_ERP_BOARD_SELECT_LIST 1, 5, @TOTAL_COUNT OUTPUT, @KEY
	SELECT @TOTAL_COUNT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-18		곽병삼			최초생성
   2014-10-24		김성호			페이징쿼리 추가
   2014-11-02		정지용			게시판 그룹코드 추가 / 게시판 마스터 번호 조건 추가
================================================================================================================*/ 

CREATE PROCEDURE [cti].[SP_CTI_ERP_BOARD_SELECT_LIST]
--DECLARE
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@TOTAL_COUNT	INT OUTPUT,
	@KEY			VARCHAR(100)
AS

SET NOCOUNT ON

	DECLARE @CUS_NO INT;
	DECLARE @MASTER_SEQ INT;
	DECLARE @ARR_MASTER_SEQ VARCHAR(10)

	SELECT
		@CUS_NO = Diablo.DBO.FN_PARAM(@KEY, 'CusNo'),
		@MASTER_SEQ = Diablo.DBO.FN_PARAM(@KEY, 'MasterSeq');

	IF @MASTER_SEQ = 4
	BEGIN
		SET @ARR_MASTER_SEQ = '4,12,24'; /* 1:1문의, 자유여행 1:1문의, 1:1담당자별 문의게시판 */
	END	
	ELSE
	BEGIN
		SET @ARR_MASTER_SEQ = @MASTER_SEQ;
	END
		
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM Diablo.dbo.HBS_DETAIL HBS WITH(NOLOCK)
	INNER JOIN Diablo.dbo.HBS_MASTER MAS WITH(NOLOCK) ON HBS.MASTER_SEQ = MAS.MASTER_SEQ
	WHERE HBS.NEW_CODE = @CUS_NO AND HBS.DEL_YN = 'N' AND ((@MASTER_SEQ = 0) OR (HBS.MASTER_SEQ IN (SELECT Data FROM Diablo.dbo.FN_SPLIT(@ARR_MASTER_SEQ, ','))));

	SELECT
		HBS.MASTER_SEQ,
		MAS.SUBJECT AS NOTICE_TYPE,
		HBS.BOARD_SEQ,
		HBS.CATEGORY_SEQ,
		HBS.REGION_NAME,
		HBS.MASTER_CODE,
		CASE WHEN ISNULL(LEN(HBS.SUBJECT),0) > 10 THEN (LEFT(HBS.SUBJECT,10) + '...') ELSE HBS.SUBJECT END SUBJECT,
		HBS.CONTENTS,
		HBS.NEW_CODE,
		CONVERT(VARCHAR(10),HBS.NEW_DATE,120) AS NEW_DATE,
		HBS.COMPLETE_YN,
		MAS.GROUP_CODE
	FROM Diablo.dbo.HBS_DETAIL HBS WITH(NOLOCK)
	INNER JOIN Diablo.dbo.HBS_MASTER MAS WITH(NOLOCK) ON HBS.MASTER_SEQ = MAS.MASTER_SEQ
	WHERE HBS.NEW_CODE = @CUS_NO AND HBS.DEL_YN = 'N' AND ((@MASTER_SEQ = 0) OR (HBS.MASTER_SEQ IN (SELECT Data FROM Diablo.dbo.FN_SPLIT(@ARR_MASTER_SEQ, ','))))
	ORDER BY HBS.NEW_DATE DESC
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY;

SET NOCOUNT OFF
GO
