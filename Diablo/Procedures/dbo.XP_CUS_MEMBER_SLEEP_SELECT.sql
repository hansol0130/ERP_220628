USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_CUS_MEMBER_SLEEP_SELECT
■ DESCRIPTION				: 휴면 예정 고객 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-09-21		정지용			최초생성
   2021-01-27		김영민			휴면 예정 조건 추가(포인트/상담/구매이력)
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_CUS_MEMBER_SLEEP_SELECT]
AS  
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
		CUS_NO, CASE WHEN SNS_MEM_YN ='N' THEN  CUS_ID ELSE Email END AS CUS_ID, CUS_NAME, EMAIL, GENDER, DATEADD(d, 365, LAST_LOGIN_DATE) AS SLEEP_DATE 
	FROM CUS_MEMBER WITH(NOLOCK)
	WHERE 
		LAST_LOGIN_DATE IS NOT NULL AND DATEDIFF(DD, GETDATE(), DATEADD(d, 334, LAST_LOGIN_DATE)) = 31
		AND CUS_NO  NOT IN  --포인트 이력
					(SELECT  CUS_NO FROM CUS_POINT  WHERE NEW_DATE  >   DATEADD(DAY, -365, GETDATE())
					AND NEW_DATE  < DATEADD(DD, 1, GETDATE())  AND POINT_NO  NOT IN  (
					SELECT  CUS_POINT.POINT_NO
					FROM CUS_POINT  WHERE POINT_TYPE  = '2' AND ACC_USE_TYPE = '2')
					GROUP BY CUS_NO)
		AND CUS_NO NOT IN --상담이력
					(SELECT  CUS_NO FROM SIRENS.CTI.CTI_CONSULT  WHERE CONSULT_DATE > DATEADD(DAY, -365, GETDATE()) AND
					CONSULT_DATE < DATEADD(DAY, 1, GETDATE())  
					GROUP BY SIRENS.CTI.CTI_CONSULT.CUS_NO)
		AND CUS_NO NOT IN--출발이력(결재완료건)
					(SELECT A.CUS_NO FROM RES_CUSTOMER_DAMO A  JOIN 
					RES_MASTER B ON A.RES_CODE = B.RES_CODE 
					WHERE B.DEP_DATE >  DATEADD(DAY, -365, GETDATE())
					AND B.DEP_DATE + 1 < DATEADD(DAY, 1, GETDATE()) AND B.RES_STATE  IN('4') GROUP BY A.CUS_NO )
		AND  ISNULL(FORMEMBER_YN,'N') <> 'Y'  --평생회원제외
	
END
GO
