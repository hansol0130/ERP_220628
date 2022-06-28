USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_AIR_PROMOTION_SELECT
■ DESCRIPTION				: 항공 프로모션 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SP_AIR_PROMOTION_SELECT 1
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2017-02-16			정지용			최초생성
2017-08-25			정지용			프로모션 제한날짜 필드 추가
2019-07-23			박형만			최소적용 인원 추가 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_AIR_PROMOTION_SELECT]	
	@SEQ_NO INT
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

	SELECT
		SEQ_NO, TITLE, AIRLINE_CODE, AIRPORT_CODE, CLASS, SDATE, EDATE, LIMITED_DATE,
		SALE_PRICE, SALE_COMM_RATE, USE_YN, NEW_DATE, NEW_CODE, EDT_CODE, EDT_DATE, SITE_CODE, DEP_SDATE, DEP_EDATE , MIN_PAX_COUNT
	FROM AIR_PROMOTION WITH(NOLOCK)
	WHERE SEQ_NO = @SEQ_NO;

END
GO
