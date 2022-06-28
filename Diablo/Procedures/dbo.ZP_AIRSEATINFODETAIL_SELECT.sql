USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_AIRSEATINFODETAIL_SELECT
■ DESCRIPTION				: 
■ INPUT PARAMETER			: 
	@PRO_CODE				: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EX1:	EXEC ZP_AIRSEATINFODETAIL_SELECT ''
	EX2:	EXEC ZP_AIRSEATINFODETAIL_SELECT 'KPP303-191003' 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-10-01		김주환			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[ZP_AIRSEATINFODETAIL_SELECT]
(
	@PRO_CODE	VARCHAR(20)
)

AS  
BEGIN
	IF (@PRO_CODE IS NULL)
		RETURN;
		

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT A.*,
		(CASE WHEN ISNULL(B.SEAT_CODE,0) > 0 THEN 'Y' ELSE 'N' END) AS DEP_SEG_YN,
		(CASE WHEN ISNULL(C.SEAT_CODE,0) > 0 THEN 'Y' ELSE 'N' END) AS ARR_SEG_YN,		
		B.REAL_AIRLINE_CODE AS DEP_TRANS_REAL_CODE,
		C.REAL_AIRLINE_CODE AS ARR_TRANS_REAL_CODE,
		(SELECT KOR_NAME FROM EMP_MASTER_DAMO WITH(NOLOCK) WHERE EMP_CODE = A.NEW_CODE ) AS NEW_NAME ,
		(SELECT KOR_NAME FROM EMP_MASTER_DAMO WITH(NOLOCK) WHERE EMP_CODE = A.EDT_CODE ) AS EDT_NAME ,
		B.FLYING_TIME AS FLYING_TIME
	FROM PRO_TRANS_SEAT A WITH(NOLOCK)
	LEFT JOIN PRO_TRANS_SEAT_SEGMENT B WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE AND B.TRANS_SEQ = 1 AND B.SEG_NO =  1
	LEFT JOIN PRO_TRANS_SEAT_SEGMENT C WITH(NOLOCK) ON A.SEAT_CODE = C.SEAT_CODE AND C.TRANS_SEQ = 2 AND C.SEG_NO =  1
	LEFT JOIN PKG_DETAIL D WITH(NOLOCK) ON A.SEAT_CODE = D.SEAT_CODE
	WHERE D.PRO_CODE = @PRO_CODE

END

GO
