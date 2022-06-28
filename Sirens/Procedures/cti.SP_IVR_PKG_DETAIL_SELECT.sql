USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_IVR_PKG_DETAIL_SELECT
■ DESCRIPTION				: SMS 전송 행사 정보 검색
■ INPUT PARAMETER			: 
	@PRO_CODE				: 행사코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec CTI.SP_IVR_PKG_DETAIL_SELECT 'IPF865-180306RS'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-16		김성호			최초생성
   2015-06-12		김성호			단축URL 표시를 위해 SHOW_YN 항목 추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_IVR_PKG_DETAIL_SELECT]
(
	@PRO_CODE	VARCHAR(20)
)

AS  
BEGIN

	SELECT B.KOR_NAME, B.EMAIL, (B.INNER_NUMBER1 + B.INNER_NUMBER2 + B.INNER_NUMBER3) AS [INNER_NUMBER], A.SHOW_YN
	, (
		CASE
			WHEN C.SEAT_CODE > 0 THEN (
		'한국출발 ' + CONVERT(VARCHAR(2), MONTH(C.DEP_DEP_DATE)) + '월 ' 
		+ CONVERT(VARCHAR(2), DAY(C.DEP_DEP_DATE)) + '일 ['
		+ C.DEP_TRANS_CODE + C.DEP_TRANS_NUMBER + '] ' 
		+ C.DEP_DEP_AIRPORT_CODE + ' ' + C.DEP_DEP_TIME + ' > ' 
		+ C.DEP_ARR_AIRPORT_CODE + ' ' + C.DEP_ARR_TIME + ' / '
		+ '현지출발 ' + CONVERT(VARCHAR(2), MONTH(C.ARR_DEP_DATE)) + '월 ' 
		+ CONVERT(VARCHAR(2), DAY(C.ARR_DEP_DATE)) + '일 ['
		+ C.ARR_TRANS_CODE + C.ARR_TRANS_NUMBER + '] ' 
		+ C.ARR_DEP_AIRPORT_CODE + ' ' + C.ARR_DEP_TIME + ' > '
		+ C.ARR_ARR_AIRPORT_CODE + ' ' + C.ARR_ARR_TIME)
			ELSE NULL
		END) AS [AIR_INFO]
	FROM Diablo.DBO.PKG_DETAIL A WITH(NOLOCK)
	INNER JOIN Diablo.DBO.EMP_MASTER B WITH(NOLOCK) ON A.NEW_CODE = B.EMP_CODE
	LEFT JOIN Diablo.DBO.PRO_TRANS_SEAT C WITH(NOLOCK) ON A.SEAT_CODE = C.SEAT_CODE
	WHERE A.PRO_CODE = @PRO_CODE;

END


GO
