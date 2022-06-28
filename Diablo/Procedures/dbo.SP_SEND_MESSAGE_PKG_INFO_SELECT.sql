USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_SEND_MESSAGE_PKG_INFO_SELECT
■ DESCRIPTION				: 알림톡 발송 기본 정보 (상품기준)
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_SEND_MESSAGE_PKG_INFO_SELECT 'XXF777-180627'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
    2018-06-19		정지용			최초생성
	2019-12-12		박형만			개인별,팀별 대표번호 가져오기 함수 필드 추가 ( 대표번호 발송 관련 ) 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_SEND_MESSAGE_PKG_INFO_SELECT]
	@PRO_CODE VARCHAR(20)	
AS 
BEGIN
	SELECT 
		  A.PRO_TYPE
		, A.PRO_CODE
		, A.PRO_NAME
		, ISNULL(B.PRICE_SEQ,1) AS PRICIE_SEQ
		, ISNULL(C.FAX_NUMBER1,'') +'-' + ISNULL(C.FAX_NUMBER2,'') +'-' +  ISNULL(C.FAX_NUMBER3,'') AS FAX_NUMBER
		, E.TEAM_NAME
		, E.TEAM_CODE 
		, C.EMAIL AS EMAIL
		, A.NEW_CODE
		, C.KOR_NAME AS NEW_NAME
		, C.INNER_NUMBER1, C.INNER_NUMBER2, C.INNER_NUMBER3
		, A.FIRST_MEET
		, F.DEP_TRANS_CODE
		, F.DEP_TRANS_NUMBER
		, F.DEP_DEP_DATE
		, F.DEP_DEP_TIME
		, (SELECT DBO.FN_PUB_GET_CITY_NAME(AA.CITY_CODE) FROM PUB_AIRPORT AA WITH(NOLOCK) WHERE AA.AIRPORT_CODE = F.DEP_DEP_AIRPORT_CODE) AS [DEP_DEP_CITY_NAME]
		, F.DEP_ARR_DATE
		, F.DEP_ARR_TIME
		, (SELECT DBO.FN_PUB_GET_CITY_NAME(AA.CITY_CODE) FROM PUB_AIRPORT AA WITH(NOLOCK) WHERE AA.AIRPORT_CODE = F.DEP_ARR_AIRPORT_CODE) AS [DEP_ARR_CITY_NAME]
		, F.ARR_TRANS_CODE
		, F.ARR_TRANS_NUMBER
		, F.ARR_DEP_DATE
		, F.ARR_DEP_TIME
		, (SELECT DBO.FN_PUB_GET_CITY_NAME(AA.CITY_CODE) FROM PUB_AIRPORT AA WITH(NOLOCK) WHERE AA.AIRPORT_CODE = F.ARR_DEP_AIRPORT_CODE) AS [ARR_DEP_CITY_NAME]
		, F.ARR_ARR_DATE
		, F.ARR_ARR_TIME			
		, (SELECT DBO.FN_PUB_GET_CITY_NAME(AA.CITY_CODE) FROM PUB_AIRPORT AA WITH(NOLOCK) WHERE AA.AIRPORT_CODE = F.ARR_ARR_AIRPORT_CODE) AS [ARR_ARR_CITY_NAME]
		, DBO.XN_EMP_GET_EMP_KEY_NUMBER( C.EMP_CODE ) AS EMP_KEY_NUMBER   -- 개인별 대표번호 2019-11-18 
		, DBO.XN_EMP_GET_TEAM_KEY_NUMBER( C.EMP_CODE ) AS TEAM_KEY_NUMBER   -- 개인별 대표번호 2019-11-18 
	FROM Diablo.DBO.PKG_DETAIL A WITH(NOLOCK)
	INNER JOIN Diablo.dbo.PKG_MASTER D WITH(NOLOCK)
	ON A.MASTER_CODE = D.MASTER_CODE
	LEFT OUTER JOIN Diablo.DBO.PKG_DETAIL_PRICE B WITH(NOLOCK)
	ON A.PRO_CODE = B.PRO_CODE
	INNER JOIN Diablo.dbo.EMP_MASTER C WITH(NOLOCK)
	ON A.NEW_CODE = C.EMP_CODE
	INNER JOIN DIABLO.dbo.EMP_TEAM E WITH(NOLOCK)
	ON C.TEAM_CODE = E.TEAM_CODE
	LEFT JOIN PRO_TRANS_SEAT F WITH(NOLOCK) ON A.SEAT_CODE = F.SEAT_CODE
	WHERE A.PRO_CODE = @PRO_CODE;
END



GO
