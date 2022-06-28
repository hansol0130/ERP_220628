USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_PKG_DETAIL_PRICE_LIST_SELECT
■ DESCRIPTION				: 행사 상세 가격 검색
■ INPUT PARAMETER			: 
	@PRO_CODE VARCHAR(20)	: 행사코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_PKG_DETAIL_PRICE_LIST_SELECT 'EPF002-130406AF', 1

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-04		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_WEB_PKG_DETAIL_PRICE_LIST_SELECT]
(
	@PRO_CODE	VARCHAR(20)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);

	SET @SQLSTRING = N'
	-- 가격정보
	SELECT *, (CASE ISNULL(POINT_YN, ''0'') WHEN ''0'' THEN ''N'' ELSE ''Y'' END) AS POINT_CREATE_YN FROM PKG_DETAIL_PRICE  WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE;
	'


	SET @PARMDEFINITION = N'
		@PRO_CODE VARCHAR(20)';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PRO_CODE;

END




GO
