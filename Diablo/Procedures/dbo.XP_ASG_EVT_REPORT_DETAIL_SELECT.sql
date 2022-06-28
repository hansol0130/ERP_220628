USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_DETAIL_SELECT
■ DESCRIPTION				: 출장보고서 상세내용 표출
■ INPUT PARAMETER			: 
	@PRO_CODE	VARCHAR(30)	: 프로모션 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_ASG_EVT_REPORT_DETAIL_SELECT 'XXX101-140302';

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-17		이상일			최초생성
   2014-01-13		이동호			출국출발일자 수정 
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_ASG_EVT_REPORT_DETAIL_SELECT]
(
	@PRO_CODE		VARCHAR(30)
)

AS  
BEGIN

SELECT 
			A.PRO_CODE --행사코드
			,A.PRO_NAME--행사명
			,A.TOUR_NIGHT --박
			,A.TOUR_DAY --일
			,A.NEW_CODE --상품당담자코드
			,DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME--,NEW_NAME --상품담당자명
			,E.EMAIL AS NEW_CODE_MAIL--,NEW_CODE_MAIL -상품당담자메일
			,E.HP_NUMBER1
			,E.HP_NUMBER2 
			,E.HP_NUMBER3 --상품담당자전화번호
			,B.DEP_TRANS_CODE --출국운항사코드
			,B.DEP_TRANS_NUMBER -- 출국편명					
			,(CASE WHEN A.SEAT_CODE = 0 THEN A.DEP_DATE ELSE B.DEP_DEP_DATE END) AS 'DEP_DEP_DATE' --출국출발일자	
			,B.DEP_DEP_TIME --출국출발시간
			,B.DEP_ARR_DATE --출국도착일자
			,B.DEP_ARR_TIME --출국도착시간
			,B.ARR_TRANS_CODE --귀국운항사코드
			,B.ARR_TRANS_NUMBER -- 귀국편명
			,B.ARR_DEP_DATE --귀국출발일자
			,B.ARR_DEP_TIME --귀국출발시간
			--,B.ARR_ARR_DATE --귀국도착일자
			,(CASE WHEN A.SEAT_CODE = 0 THEN A.ARR_DATE ELSE B.ARR_ARR_DATE END) AS 'ARR_ARR_DATE' --귀국도착일자
			,B.ARR_ARR_TIME --귀국도착시간
			,(	SELECT COUNT(C.RES_CODE) 
				FROM dbo.RES_MASTER_damo C LEFT OUTER JOIN dbo.RES_CUSTOMER_damo D ON C.RES_CODE = D.RES_CODE
				WHERE C.PRO_CODE =A.PRO_CODE AND D.RES_STATE = 0) AS TOTALCUSTOMERCOUNT --총 출발인원
			,ISNULL(V.OTR_STATE , '0') AS REPORT_STATE --출장보고서 상태
			--,CASE WHEN DATEDIFF(DAY,GETDATE(),A.DEP_DATE) <=0 THEN 1 ELSE 0 END AS RES_STATE --상태 
			,CASE WHEN DATEDIFF(DAY,GETDATE(),A.DEP_DATE) <0 THEN 1 
				  WHEN GETDATE() BETWEEN A.DEP_DATE AND A.ARR_DATE THEN 3
			 ELSE 2 END AS RES_STATE --상태 
			,Y.SIGN_CODE --지역코드
			,X.KOR_NAME AS SIGN_KOR_NAME --지역명
			,V.EDI_CODE 
			,V.OTR_SEQ
			,V.TOTAL_VALUATION
			,A.NEW_CODE AS ApprovalTargetCode 
			,DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) +'['+ DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) +']' AS ApprovalTarget 
			,A.TC_CODE 
			,ISNULL(A.TC_ASSIGN_YN, 'N') AS TC_ASSIGN_YN
			,A.TC_ASSIGN_DATE
			,A.TC_NAME
			--,(SELECT AGT_GRADE FROM AGT_MEMBER WHERE MEM_CODE = A.TC_CODE) AS AGT_GRADE
			,V.AGT_GRADE
			,V.NEW_CODE AS WRITE_CODE -- 작성자코드
			,DBO.XN_COM_GET_EMP_NAME(V.NEW_CODE) AS WRITE_NAME -- 작성자명
			,V.NEW_DATE AS WRITE_DATE -- 작성일
	FROM	dbo.PKG_DETAIL A WITH(NOLOCK)
			LEFT OUTER JOIN dbo.PRO_TRANS_SEAT B WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE
			LEFT OUTER JOIN dbo.EMP_MASTER E WITH(NOLOCK) ON A.NEW_CODE = E.EMP_CODE
			INNER JOIN dbo.PKG_MASTER Y WITH(NOLOCK) ON A.MASTER_CODE = Y.MASTER_CODE
			LEFT OUTER JOIN dbo.PUB_REGION X WITH(NOLOCK) ON Y.SIGN_CODE = X.SIGN
			LEFT OUTER JOIN dbo.OTR_MASTER V WITH(NOLOCK) ON A.PRO_CODE = V.PRO_CODE
	WHERE	A.PRO_CODE =@PRO_CODE

END

GO
