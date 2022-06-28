USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_PKG_DETAIL_HOTEL_LIST_SELECT
■ DESCRIPTION				: 행사 상세 숙박정보 리스트 검색
■ INPUT PARAMETER			: 
	@PRO_CODE VARCHAR(20)	: 행사코드
	@PRICE_SEQ INT			: 가격순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_PKG_DETAIL_HOTEL_LIST_SELECT 'EPP104-130430EY', 1

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-09		김성호			최초생성
   2013-06-10		김성호			WITH(NOLOCK) 추가
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_WEB_PKG_DETAIL_HOTEL_LIST_SELECT]
(
	@PRO_CODE	VARCHAR(20),
	@PRICE_SEQ	INT
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);

	SET @SQLSTRING = N'
	-- 호텔정보
	SELECT A.HTL_MASTER_CODE
	FROM PKG_DETAIL_PRICE_HOTEL A WITH(NOLOCK)
	INNER JOIN HTL_MASTER B WITH(NOLOCK) ON A.HTL_MASTER_CODE = B.MASTER_CODE
	WHERE A.PRO_CODE = @PRO_CODE AND A.PRICE_SEQ = @PRICE_SEQ
	GROUP BY A.HTL_MASTER_CODE
	;
	'

	SET @PARMDEFINITION = N'
		@PRO_CODE VARCHAR(20),
		@PRICE_SEQ INT';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PRO_CODE,
		@PRICE_SEQ;

END


/*

SELECT TOP 10 A.PRO_CODE, COUNT(*)
FROM PKG_DETAIL_PRICE_HOTEL A
INNER JOIN PKG_DETAIL B ON A.PRO_CODE = B.PRO_CODE
WHERE B.DEP_DATE > GETDATE() AND A.HTL_MASTER_CODE IS NOT NULL AND A.PRO_CODE LIKE 'EPP%'
GROUP BY A.PRO_CODE
HAVING COUNT(*) > 1

*/
GO
