USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ARG_PKG_DETAIL_SELECT
■ DESCRIPTION				: 수배행사요약 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

exec XP_ARG_PKG_DETAIL_SELECT 'A140407-0045'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-04-01		박형만			최초생성
   2014-04-09		정지용			배정가이드 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_PKG_DETAIL_SELECT]
 	@ARG_CODE VARCHAR(12) 
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

--행사요약정보 (행사정보+담당자정보)
	SELECT TOP 1 
	C.PRO_CODE ,
	C.PRO_NAME , 
	CASE WHEN ISNULL(C.PRO_CODE,'') ='' THEN A.DEP_DATE ELSE 
		(CASE WHEN D.SEAT_CODE IS NOT NULL THEN  D.DEP_DEP_DATE ELSE C.DEP_DATE END) END AS DEP_DATE,
	CASE WHEN ISNULL(C.PRO_CODE,'') ='' THEN '' ELSE 
		(CASE WHEN D.SEAT_CODE IS NOT NULL THEN  D.DEP_DEP_TIME ELSE '' END) END AS DEP_TIME,

	CASE WHEN ISNULL(C.PRO_CODE,'') ='' THEN A.ARR_DATE ELSE 
		(CASE WHEN D.SEAT_CODE IS NOT NULL THEN  D.ARR_ARR_DATE ELSE C.ARR_DATE END) END AS ARR_DATE,
	CASE WHEN ISNULL(C.PRO_CODE,'') ='' THEN '' ELSE 
		(CASE WHEN D.SEAT_CODE IS NOT NULL THEN  D.ARR_ARR_TIME ELSE '' END) END AS ARR_TIME,

	CASE WHEN ISNULL(C.PRO_CODE,'') ='' THEN A.NIGHTS ELSE C.TOUR_NIGHT END AS TOUR_NIGHT,
	CASE WHEN ISNULL(C.PRO_CODE,'') ='' THEN A.DAY ELSE C.TOUR_DAY END AS TOUR_DAY,
	DBO.XN_COM_GET_TEAM_CODE(A.NEW_CODE) AS NEW_TEAM , 
	E.KOR_NAME AS NEW_NAME , 
	c.NEW_CODE,
	E.INNER_NUMBER1 , 
	E.INNER_NUMBER2 , 
	E.INNER_NUMBER3 , 
	E.FAX_NUMBER1 , 
	E.FAX_NUMBER2 , 
	E.FAX_NUMBER3 ,
	E.EMAIL AS NEW_EMAIL, 
	F.GUIDE_INFO,
	F.GUIDE_COUNT
	FROM ARG_DETAIL A 
		INNER JOIN ARG_MASTER B 
			ON A.ARG_CODE = B.ARG_CODE 
		LEFT JOIN PKG_DETAIL C
			ON B.PRO_CODE = C.PRO_CODE 
		LEFT JOIN PRO_TRANS_SEAT D
			ON C.SEAT_CODE = D.SEAT_CODE 
		LEFT JOIN EMP_MASTER E
			ON C.NEW_CODE = E.EMP_CODE 
		LEFT JOIN ( 
			SELECT ARG_CODE, CASE WHEN COUNT(1) > 1 THEN MAX(B.KOR_NAME) + '외 ' + CONVERT(varchar(5), COUNT(1) - 1) + '명' ELSE MAX(B.KOR_NAME) END AS GUIDE_INFO, COUNT(1) AS GUIDE_COUNT FROM ARG_GUIDE A WITH(NOLOCK) 
			INNER JOIN AGT_MEMBER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.MEM_CODE = B.MEM_CODE
			WHERE ARG_CODE = @ARG_CODE GROUP BY ARG_CODE
		) F ON A.ARG_CODE = F.ARG_CODE
	WHERE A.ARG_CODE = @ARG_CODE  
END 

GO
