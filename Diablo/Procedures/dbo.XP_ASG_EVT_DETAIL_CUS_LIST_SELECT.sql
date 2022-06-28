USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_DETAIL_CUS_LIST_SELECT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 배정행사 상세정보 출발고객 검색
■ INPUT PARAMETER			: 
	@PRO_CODE  VARCHAR(20)  : 행사코드
■ OUTPUT PARAMETER			: 
							: 
■ EXEC						: 
	DECLARE @PRO_CODE VARCHAR(20) 

	SELECT @PRO_CODE='CPP3590-130801'

	exec XP_ASG_EVT_DETAIL_CUS_LIST_SELECT 'MPP980-140129'
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-25		오인규			최초생성   전화번호 하고 메일주소는 테스트용으로 넣어놨음 실서버반영시 변경해야함
   2014-01-14		박형만			생년월일 불러오기 추가
   2015-03-03		김성호			주민번호 삭제, 생년월일 사용
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_ASG_EVT_DETAIL_CUS_LIST_SELECT]
(
	@PRO_CODE  VARCHAR(20) 
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
			B.RES_CODE
			,B.SEQ_NO
			,B.CUS_NAME
			,B.LAST_NAME
			,B.FIRST_NAME
--			,CONVERT(VARCHAR(10),DBO.FN_CUS_GET_BIRTH_DATE(B.SOC_NUM1,damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','SOC_NUM2', B.SEC_SOC_NUM2)),121) AS BIRTH_DATE
			,B.BIRTH_DATE
--			,B.SOC_NUM1
--			,damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','SOC_NUM2', B.SEC_SOC_NUM2) AS SOC_NUM2 --주민번호 뒷자리
			,B.GENDER
			,damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', B.SEC_PASS_NUM) AS PASS_NUM
			--,B.PASS_NUM
			,B.PASS_EXPIRE
			,B.NOR_TEL1 
			,B.NOR_TEL2
			,B.NOR_TEL3
			,B.CALL_DATE -- 통화시간
			,B.ROOMING  
			,B.SENDING_REMARK 
			,B.EMAIL
--			,dbo.FN_CUS_GET_AGE(B.SOC_NUM1,damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','SOC_NUM2', B.SEC_SOC_NUM2),A.DEP_DATE) AS AGE
			,dbo.FN_CUS_GET_AGE(B.BIRTH_DATE,A.DEP_DATE) AS AGE
			,B.RES_STATE
			,C.PUB_VALUE AS CXL_REMARK
			,B.ETC_REMARK AS ETC --A.ETC
	FROM	dbo.Res_master_damo A WITH(NOLOCK)
	LEFT OUTER JOIN dbo.RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	LEFT JOIN COD_PUBLIC C WITH(NOLOCK) ON C.PUB_TYPE = 'RES.CANCEL.TYPE' AND C.PUB_CODE = A.CXL_TYPE
	WHERE	A.PRO_CODE =@PRO_CODE AND B.RES_STATE = 0
	ORDER BY RES_CODE,SEQ_NO;
 END



GO
