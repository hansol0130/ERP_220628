USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_FIRST_CITY_CODE_SELECT
■ DESCRIPTION				: 상품 첫 도시코드 검색
■ INPUT PARAMETER			: 
	@PRO_CODE				: 행사코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_PKG_FIRST_CITY_CODE_SELECT 'AHH16950-1401183094'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-12-02		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_PUB_FIRST_CITY_CODE_SELECT]
(
	@PRO_CODE	VARCHAR(20)
)

AS  
BEGIN

	WITH LIST AS
	(
		SELECT C.CITY_CODE AS [AIR_CITY_CODE], (
			SELECT TOP 1 AA.CITY_CODE FROM PKG_DETAIL_SCH_CITY AA WITH(NOLOCK)
			INNER JOIN PUB_CITY BB WITH(NOLOCK) ON AA.CITY_CODE = BB.CITY_CODE
			WHERE AA.PRO_CODE = A.PRO_CODE AND BB.NATION_CODE <> 'KR'
			ORDER BY AA.SCH_SEQ, AA.DAY_SEQ, AA.CITY_SHOW_ORDER
		) AS [PKG_CITY_CODE], D.CITY_CODE AS [HTL_CITY_CODE]
		FROM PKG_DETAIL A WITH(NOLOCK)
		LEFT JOIN PRO_TRANS_SEAT B WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE
		LEFT JOIN PUB_AIRPORT C WITH(NOLOCK) ON B.DEP_ARR_AIRPORT_CODE = C.AIRPORT_CODE
		LEFT JOIN HTL_MASTER D WITH(NOLOCK) ON A.MASTER_CODE = D.MASTER_CODE
		WHERE A.PRO_CODE = @PRO_CODE
	)
	SELECT (
		CASE
			WHEN A.AIR_CITY_CODE IS NOT NULL THEN A.AIR_CITY_CODE
			WHEN A.PKG_CITY_CODE IS NOT NULL THEN A.PKG_CITY_CODE
			WHEN A.HTL_CITY_CODE IS NOT NULL THEN A.HTL_CITY_CODE
		END
	) AS [CITY_CODE]
	FROM LIST A

END


GO
