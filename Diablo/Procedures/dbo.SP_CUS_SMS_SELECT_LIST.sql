USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CUS_SMS_SELECT_LIST
■ DESCRIPTION				: ERP 회원 SMS 내역 조회
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
CREATE PROCEDURE [dbo].[SP_CUS_SMS_SELECT_LIST]
	@PAGE_INDEX INT,
	@PAGE_SIZE INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @CUS_NO INT;

	SELECT 
		@CUS_NO = Diablo.dbo.FN_PARAM(@KEY, 'CusNo');

	SELECT 
		@TOTAL_COUNT = COUNT(1)
	FROM (
		SELECT SMS.SND_NO FROM Diablo.dbo.RES_CUSTOMER RES WITH(NOLOCK)
		INNER JOIN Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK) ON RES.RES_CODE = SMS.RES_CODE
		WHERE RES.CUS_NO = @CUS_NO AND SMS.SND_NO NOT IN (
			SELECT SMS.SND_NO FROM Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK) WHERE SMS.CUS_NO = @CUS_NO
		)
		UNION ALL
		SELECT SMS.SND_NO FROM Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK) WHERE SMS.CUS_NO = @CUS_NO) A;

	SELECT
		SMS.SND_NO,
		SMS.SND_TYPE,
		SMS.RCV_NUMBER1,
		SMS.RCV_NUMBER2,
		SMS.RCV_NUMBER3,
		SMS.RCV_NAME,
		SMS.SND_NUMBER,
		SMS.NEW_CODE,
		SMS.EMP_NAME AS NEW_NAME,
		SMS.BODY,
		SMS.NEW_DATE,
		SMS.SND_RESULT
	FROM (
		SELECT
			SMS.SND_NO,
			SMS.SND_TYPE,
			SMS.RCV_NUMBER1,
			SMS.RCV_NUMBER2,
			SMS.RCV_NUMBER3,
			SMS.RCV_NAME,
			SMS.SND_NUMBER,
			SMS.NEW_CODE,
			EM.KOR_NAME AS [EMP_NAME],
			SMS.BODY,
			SMS.NEW_DATE,
			SMS.SND_RESULT
		FROM Diablo.dbo.RES_CUSTOMER RES WITH(NOLOCK)
		INNER JOIN Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK) ON RES.RES_CODE = SMS.RES_CODE
		LEFT OUTER JOIN DIABLO.DBO.EMP_MASTER EM ON SMS.NEW_CODE = EM.EMP_CODE
		WHERE RES.CUS_NO = @CUS_NO
		AND SMS.SND_NO NOT IN (
		SELECT
			SMS.SND_NO
		FROM Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK)
		WHERE SMS.CUS_NO = @CUS_NO)
		UNION ALL
		SELECT
			SMS.SND_NO,
			SMS.SND_TYPE,
			SMS.RCV_NUMBER1,
			SMS.RCV_NUMBER2,
			SMS.RCV_NUMBER3,
			SMS.RCV_NAME,
			SMS.SND_NUMBER,
			SMS.NEW_CODE,
			EM.KOR_NAME AS [EMP_NAME],
			SMS.BODY,
			SMS.NEW_DATE,
			SMS.SND_RESULT
		FROM Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK)
		LEFT OUTER JOIN DIABLO.DBO.EMP_MASTER EM ON SMS.NEW_CODE = EM.EMP_CODE
		WHERE SMS.CUS_NO = @CUS_NO
	) SMS
	ORDER BY SMS.NEW_DATE DESC
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY;

	SET NOCOUNT OFF;
END

GO
