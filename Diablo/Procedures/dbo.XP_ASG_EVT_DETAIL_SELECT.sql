USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_DETAIL_SELECT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 배정행사 상세정보 검색
■ INPUT PARAMETER			: 
	@PRO_CODE  VARCHAR(20)  : 행사코드
■ OUTPUT PARAMETER			: 
							: 
■ EXEC						: 
	DECLARE @PRO_CODE VARCHAR(20) 

	SELECT @PRO_CODE='CPP3590-130801'

	exec XP_ASG_EVT_DETAIL_SELECT @PRO_CODE
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-25		오인규			최초생성    출장보고서 상태값 추가해야함
   2014-01-06		이동호						연령대 나이 출발일 기준으로 수정 AGE
   2014-01-13		이동호						출장보고서 참조자 코드 추가 ApprovalReferenceCode
   2014-01-15		이동호						출장보고서 항목별평가 카운트 수정(가이드,호텔,식사)
   2014-01-15		이동호						출장보고서 참조자 컬럼 추가 APP_LIST
   2015-03-03		김성호			주민번호 삭제, 생년월일 사용
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_ASG_EVT_DETAIL_SELECT]
(
	@PRO_CODE  VARCHAR(20) 
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @OTR_SEQ INT
	SELECT @OTR_SEQ =ISNULL(OTR_SEQ,0)FROM TRAVEL_REPORT_MASTER WHERE PRO_CODE = @PRO_CODE


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
			,(CASE WHEN A.SEAT_CODE = 0 THEN A.DEP_DATE ELSE B.DEP_DEP_DATE END ) AS 'DEP_DEP_DATE'  --출국출발일자
			,B.DEP_DEP_TIME --출국출발시간
			,B.DEP_ARR_DATE --출국도착일자
			,B.DEP_ARR_TIME --출국도착시간
			,B.ARR_TRANS_CODE --귀국운항사코드
			,B.ARR_TRANS_NUMBER -- 귀국편명
			,B.ARR_DEP_DATE --귀국출발일자
			,B.ARR_DEP_TIME --귀국출발시간			
			,(CASE WHEN A.SEAT_CODE = 0 THEN A.ARR_DATE ELSE B.ARR_ARR_DATE END ) AS 'ARR_ARR_DATE'  --귀국도착일자
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
			,A.NEW_CODE AS ApprovalTargetCode 
			,DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) +'['+ DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) +']' AS ApprovalTarget 
			--,CASE WHEN ISNULL(V.EDI_CODE, '') != '' THEN (SELECT REF_NAME FROM EDI_REFERENCE WHERE EDI_CODE = V.EDI_CODE AND SEQ_NO = '1') ELSE '' END AS  ApprovalReference
			,CASE WHEN ISNULL(V.EDI_CODE, '') != '' THEN (STUFF((SELECT ', ' + REF_NAME AS [text()] FROM EDI_REFERENCE WITH(NOLOCK) WHERE EDI_CODE = V.EDI_CODE FOR XML PATH('') ), 1, 2, '')) ELSE '' END AS  ApprovalReference			
			,CASE WHEN ISNULL(V.EDI_CODE, '') != '' THEN (STUFF((SELECT '| ' + REF_CODE AS [text()] FROM EDI_REFERENCE WITH(NOLOCK) WHERE EDI_CODE = V.EDI_CODE FOR XML PATH('') ), 1, 2, '')) ELSE '' END AS  ApprovalReferenceCode		
			,A.TC_CODE 
			,A.TC_NAME
			,V.NEW_CODE AS WRITE_CODE -- 작성자코드
			,DBO.XN_COM_GET_EMP_NAME(V.NEW_CODE) AS WRITE_NAME -- 작성자명
			,V.NEW_DATE AS WRITE_DATE -- 작성일
			,A.MEET_COUNTER
			,(SELECT TOP 1 OP.APP_LIST FROM OTR_POL_MASTER OP WHERE OP.OTR_SEQ = @OTR_SEQ AND OP.POL_TYPE = '1') AS APP_LIST
	FROM	dbo.PKG_DETAIL A LEFT OUTER JOIN dbo.PRO_TRANS_SEAT B ON A.SEAT_CODE = B.SEAT_CODE
			LEFT OUTER JOIN dbo.EMP_MASTER E ON A.NEW_CODE = E.EMP_CODE
			INNER JOIN dbo.PKG_MASTER Y ON A.MASTER_CODE = Y.MASTER_CODE
			LEFT OUTER JOIN dbo.PUB_REGION X ON Y.SIGN_CODE = X.SIGN
			LEFT OUTER JOIN dbo.TRAVEL_REPORT_MASTER V ON A.PRO_CODE = V.PRO_CODE
	WHERE	A.PRO_CODE =@PRO_CODE;

--연령별함수
	SELECT  SUBSTRING(CONVERT(char(4), dbo.FN_CUS_GET_AGE(D.BIRTH_DATE, C.DEP_DATE)),1,1) AS AGE --연령대
	FROM	dbo.RES_MASTER_damo C
	LEFT OUTER JOIN dbo.RES_CUSTOMER_damo D ON C.RES_CODE = D.RES_CODE  --AND  D.SOC_NUM1 IS NOT NULL
	WHERE	C.PRO_CODE =@PRO_CODE AND D.RES_STATE = 0;

	SELECT 
		B.CLIENT_NAME, 
		B.CLIENT_TEL, 
		CASE WHEN B.CLIENT_CALL_YN = 'Y' THEN '통화성공'
		WHEN B.CLIENT_CALL_YN = 'N' THEN '통화거부'
		WHEN B.CLIENT_CALL_YN = 'F' THEN '통화실패'
		END AS CLIENT_CALL_YN,
		D.ANSWER_TEXT 
	FROM TRAVEL_REPORT_MASTER A
	INNER JOIN dbo.OTR_POL_MASTER B ON A.OTR_SEQ = B.OTR_SEQ AND B.POL_TYPE ='5'
	INNER JOIN dbo.OTR_POL_QUESTION C ON B.OTR_POL_MASTER_SEQ = C.OTR_POL_MASTER_SEQ AND C.QUS_TYPE='2'
	INNER JOIN dbo.OTR_POL_ANSWER D ON C.OTR_POL_MASTER_SEQ = D.OTR_POL_MASTER_SEQ AND C.OTR_POL_QUESTION_SEQ = D.OTR_POL_QUESTION_SEQ
	INNER JOIN TRAVEL_REPORT_MASTER E ON E.OTR_SEQ = B.OTR_SEQ
	WHERE E.PRO_CODE = @PRO_CODE

END


GO
