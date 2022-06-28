USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_EMAIL_SELECT_LIST
■ DESCRIPTION				: ERP 이메일내역 조회
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@CATEGORY				: 카테고리구분코드
	@KEY VARCHAR(100)		: 검색 키
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 상담 내역
■ EXEC						: 

	DECLARE @TOTAL_COUNT INT, @KEY VARCHAR(100)
	SELECT @KEY = N'CusNo=4228549'
	exec CTI.SP_CTI_ERP_EMAIL_SELECT_LIST 1, 5, @TOTAL_COUNT OUTPUT, @KEY
	SELECT @TOTAL_COUNT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-18		곽병삼			최초생성
   2014-10-24		김성호			페이징쿼리 추가
   2014-10-26		정지용			담당자추가
================================================================================================================*/ 

CREATE PROCEDURE [cti].[SP_CTI_ERP_EMAIL_SELECT_LIST]
--DECLARE
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@TOTAL_COUNT	INT OUTPUT,
	@KEY			VARCHAR(100)
AS

SET NOCOUNT ON

	DECLARE @CUS_NO INT;

	SELECT
		@CUS_NO = Diablo.DBO.FN_PARAM(@KEY, 'CusNo');

	SELECT @TOTAL_COUNT = COUNT(*)
	FROM Diablo.dbo.RES_CUSTOMER RES WITH(NOLOCK)
	INNER JOIN Diablo.dbo.RES_SND_EMAIL EML WITH(NOLOCK) ON RES.RES_CODE = EML.RES_CODE
	WHERE RES.CUS_NO = @CUS_NO;

	SELECT
		EML.SND_NO,
		EML.SND_TYPE,
		CONVERT(VARCHAR(19),EML.NEW_DATE,120) AS NEW_DATE,
		EML.NEW_CODE,
		EM.KOR_NAME AS [EMP_NAME],
		EML.SND_NAME,
		EML.RCV_EMAIL,
		EML.RCV_NAME,
		EML.CFM_YN,
		CONVERT(VARCHAR(19),EML.CFM_DATE,120) AS CFM_DATE,
		EML.TITLE,
		EML.BODY
	FROM Diablo.dbo.RES_CUSTOMER RES WITH(NOLOCK)
	INNER JOIN Diablo.dbo.RES_SND_EMAIL EML WITH(NOLOCK) ON RES.RES_CODE = EML.RES_CODE
	LEFT OUTER JOIN Diablo.dbo.EMP_MASTER EM WITH(NOLOCK) ON EML.NEW_CODE = EM.EMP_CODE
	WHERE RES.CUS_NO = @CUS_NO
	ORDER BY EML.NEW_DATE DESC
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY;

SET NOCOUNT OFF
GO
