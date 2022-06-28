USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CUS_EMAIL_SELECT_LIST
■ DESCRIPTION				: ERP 회원 EMAIL 내역 조회
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
CREATE PROCEDURE [dbo].[SP_CUS_EMAIL_SELECT_LIST]
	@PAGE_INDEX INT,
	@PAGE_SIZE INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE @CUS_NO INT;

		SELECT
			@CUS_NO = Diablo.dbo.FN_PARAM(@KEY, 'CusNo');

		SELECT 
			@TOTAL_COUNT = COUNT(1)
		FROM Diablo.dbo.RES_CUSTOMER RES WITH(NOLOCK)
		INNER JOIN Diablo.dbo.RES_SND_EMAIL EML WITH(NOLOCK) ON RES.RES_CODE = EML.RES_CODE
		WHERE RES.CUS_NO = @CUS_NO;

		SELECT
			EML.SND_NO, EML.RES_CODE, EML.SND_TYPE, EML.SND_NAME, EML.SND_EMAIL,
			EML.RCV_EMAIL, EML.RCV_NAME, EML.REF_EMAIL, EML.TITLE, EML.BODY, EML.DOC_NO,
			EML.CFM_YN, EML.CFM_DATE, EML.NEW_CODE, EML.NEW_DATE
		FROM Diablo.dbo.RES_CUSTOMER RES WITH(NOLOCK)
		INNER JOIN Diablo.dbo.RES_SND_EMAIL EML WITH(NOLOCK) ON RES.RES_CODE = EML.RES_CODE
		LEFT OUTER JOIN Diablo.dbo.EMP_MASTER EM WITH(NOLOCK) ON EML.NEW_CODE = EM.EMP_CODE
		WHERE RES.CUS_NO = @CUS_NO
		ORDER BY EML.NEW_DATE DESC
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
		ROW ONLY;

	SET NOCOUNT OFF;
END
GO
