USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_AGT_TOP_SUMMARY
■ DESCRIPTION				: 대리점 메인 상단 요약
■ INPUT PARAMETER			: 
	@EMP_CODE	CHAR(7)		: 사원코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_AGT_TOP_SUMMARY 'A130001'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-11		김성호			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_AGT_TOP_SUMMARY]
(
	@EMP_CODE	CHAR(7)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @AGT_CODE     VARCHAR(10)
	       ,@TODAY        DATETIME
	       
	SELECT @TODAY = CONVERT(VARCHAR(10), GETDATE(), 120)
		, @AGT_CODE = AGT_CODE
	FROM AGT_MEMBER WITH(NOLOCK) WHERE MEM_CODE = @EMP_CODE;


	WITH LIST AS
	(
		SELECT
			COUNT(CASE WHEN A.NEW_DATE >= @TODAY THEN 1 END) AS [TODAY_COUNT]
			, COUNT(CASE WHEN A.DEP_DATE >= @TODAY THEN 1 END) AS [NO_START_COUNT]
			, COUNT(CASE WHEN A.DEP_DATE >= @TODAY AND A.DEP_DATE < DATEADD(DAY, 7, @TODAY) THEN 1 END) AS [SEVEN_DAY_START]
			, COUNT(CASE WHEN B.ARR_DATE >= @TODAY AND B.ARR_DATE < DATEADD(DAY, 7, @TODAY) THEN 1 END) AS [SEVEN_DAY_END]
		FROM RES_MASTER_DAMO A WITH(NOLOCK)
		INNER JOIN PKG_DETAIL B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE
		WHERE A.SALE_COM_CODE = @AGT_CODE AND A.RES_STATE < 7 
		AND A.PRO_TYPE = 1
		AND A.NEW_DATE > DATEADD(MONTH,-1,@TODAY)
	)
	SELECT
		(SELECT COUNT(*) FROM PRI_NOTE_RECEIPT WITH(NOLOCK) WHERE EMP_CODE = @EMP_CODE AND RCV_DEL_YN = 'N' AND CONFIRM_YN = 'N') AS [MAIL_COUNT], A.*
	FROM LIST A

END



GO
