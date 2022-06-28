USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_PKG_DETAIL_SELECT_LIST_BY_PROCODE
■ DESCRIPTION				: 행사코드로 행사검색
■ INPUT PARAMETER			: 
	@PRO_CODE	VARCHAR(20)	: 행사코드
■ OUTPUT PARAMETER			: 
   
■ EXEC						: 

	exec XP_PKG_DETAIL_SELECT_LIST_BY_PROCODE 'CPP1020-131217'	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-06-20		김완기			최초생성    
   2014-04-09		정지용			쿼리 수정
================================================================================================================*/ 

 CREATE  PROCEDURE [dbo].[XP_PKG_DETAIL_SELECT_LIST_BY_PROCODE]
(
	@PRO_CODE	NVARCHAR(20)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF @PRO_CODE<> ''
	BEGIN
		WITH LIST AS(
			SELECT 
				   A.DEP_CFM_YN
				 , A.CONFIRM_YN
				 , A.RES_ADD_YN
				 , A.PRO_CODE
				 , A.SEAT_CODE
				 , A.DEP_DATE
				 , A.ARR_DATE
				 , A.PRO_NAME
				 , A.TOUR_NIGHT
				 , A.TOUR_DAY
				 , A.NEW_CODE				 
			FROM PKG_DETAIL A WITH(NOLOCK)   				
			WHERE A.PRO_CODE LIKE @PRO_CODE + '%'		
			)
		SELECT 
			A.*
			, DBO.FN_PRO_GET_ACCOUNT_STATE(A.PRO_CODE) AS [ACCOUNT_TYPE]
			, DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS [RES_COUNT]
			, (CASE WHEN A.SEAT_CODE = 0 THEN A.DEP_DATE ELSE B.DEP_DEP_DATE END) AS DEP_DATE
			, B.DEP_DEP_TIME AS [DEP_TIME]
			, (CASE WHEN A.SEAT_CODE = 0 THEN A.ARR_DATE ELSE B.ARR_ARR_DATE END) AS ARR_DATE
			, (SELECT COUNT(ARG_CODE) FROM ARG_MASTER WITH(NOLOCK) WHERE PRO_CODE = A.PRO_CODE) AS AGR_COUNT	
			, B.ARR_ARR_TIME AS [ARR_TIME]
			, C.KOR_NAME 
			, C.INNER_NUMBER3
			, C.EMAIL  
		FROM 
		LIST A 
		LEFT OUTER JOIN PRO_TRANS_SEAT B  WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE  
		LEFT OUTER JOIN EMP_MASTER C ON  A.NEW_CODE = C.EMP_CODE
	END
	/*
	WITH LIST AS(
		SELECT A.DEP_CFM_YN, A.CONFIRM_YN, A.RES_ADD_YN, DBO.FN_PRO_GET_ACCOUNT_STATE(A.PRO_CODE) AS [ACCOUNT_TYPE],  
				A.PRO_CODE
				, (CASE WHEN A.SEAT_CODE = 0 THEN A.DEP_DATE ELSE B.DEP_DEP_DATE END) AS DEP_DATE
				, B.DEP_DEP_TIME AS [DEP_TIME]
				, (CASE WHEN A.SEAT_CODE = 0 THEN A.ARR_DATE ELSE B.ARR_ARR_DATE END) AS ARR_DATE
				, B.ARR_ARR_TIME AS [ARR_TIME]
				, A.PRO_NAME, A.TOUR_NIGHT, A.TOUR_DAY, A.NEW_CODE,
				DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS [RES_COUNT],
			    (SELECT COUNT(ARG_CODE) FROM ARG_MASTER WHERE PRO_CODE = A.PRO_CODE) AS AGR_COUNT				
		FROM PKG_DETAIL A WITH(NOLOCK)   	
		LEFT OUTER JOIN PRO_TRANS_SEAT B  WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE  
		WHERE A.PRO_CODE LIKE @PRO_CODE + '%'		
		)
	SELECT A.*, B.KOR_NAME, B.INNER_NUMBER3, B.EMAIL  FROM LIST A LEFT OUTER JOIN EMP_MASTER B 
		ON  A.NEW_CODE = B.EMP_CODE
	*/
END

GO
