USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_AGT_RES_SUMMARY
■ DESCRIPTION				: 대리점 메인 행사 예약 현황 요약
■ INPUT PARAMETER			: 
	@AGT_CODE		INT		: 거래처코드
	@START_DATE		DATE	: 기준 시작일
	@END_DATE		DATE	: 기준 종료일
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_AGT_RES_SUMMARY 91924, '2013-02-01', '2013-02-28'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-02-20		김성호			최초생성
   2021-11-03		오준혁			데이타타입 변경
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_AGT_RES_SUMMARY]
(
	@AGT_CODE		VARCHAR(50),
	@START_DATE		DATE,
	@END_DATE		DATE
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH LIST AS
	(
		SELECT RES_CODE
			, DBO.FN_RES_GET_SALE_PRICE(RES_CODE) AS [SALE_PRICE]
			, DBO.FN_RES_GET_TOTAL_PRICE(RES_CODE) AS [TOTAL_PRICE]
		FROM RES_MASTER_DAMO 
		WHERE DEP_DATE >= @START_DATE AND DEP_DATE < DATEADD(DAY, 1, @END_DATE) AND SALE_COM_CODE = @AGT_CODE AND RES_STATE < 7	-- 
	)
	SELECT @START_DATE AS [START_DATE], @END_DATE AS [END_DATE], COUNT(*) AS [TOTAL_COUNT], SUM(A.SALE_PRICE) AS [SALE_PRICE], SUM(A.TOTAL_PRICE) AS [TOTAL_PRICE]
		, SUM((A.SALE_PRICE * B.COMM_AMT / 100) + B.COMM_AMT) AS [COMM_PRICE]
	FROM LIST A
	INNER JOIN RES_MASTER_DAMO B ON A.RES_CODE = B.RES_CODE

END



GO
