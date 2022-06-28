USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_MOB_PKG_MASTER_SELECT
■ DESCRIPTION				: 모바일에서 사용되는 행사 마스터 최소항목 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
	@MASTER_CODE VARCHAR(10): 마스터코드
■ EXEC						: 

	exec XP_MOB_PKG_MASTER_SELECT 'EPF002'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-10-08		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_MOB_PKG_MASTER_SELECT]
(
	@MASTER_CODE	VARCHAR(10)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);
		
	SET @SQLSTRING = N'
	--마스터정보
	SELECT
		MASTER_CODE, MASTER_NAME, LOW_PRICE, SIGN_CODE, ATT_CODE, NEXT_DATE, LAST_DATE, 
		DBO.FN_GET_TOUR_NIGHY_DAY_TEXT(MASTER_CODE,1) AS [TOUR_NIGHT_DAY],
		(SELECT KOR_NAME FROM PUB_REGION AA WITH(NOLOCK) WHERE AA.SIGN = A.SIGN_CODE) AS [SIGN_NAME]
	FROM PKG_MASTER A WITH(NOLOCK)
	WHERE A.MASTER_CODE = @MASTER_CODE
	--사진정보
	SELECT TOP 1 B.*
	FROM PKG_FILE_MANAGER A WITH(NOLOCK)
	INNER JOIN INF_FILE_MASTER B WITH(NOLOCK) ON A.FILE_CODE = B.FILE_CODE
	WHERE A.MASTER_CODE = @MASTER_CODE AND B.FILE_TYPE = 1 AND B.SHOW_YN = ''Y''
	ORDER BY SHOW_ORDER;'

	SET @PARMDEFINITION = N'
		@MASTER_CODE VARCHAR(10)';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@MASTER_CODE;

END



GO
