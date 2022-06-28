USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name			: [XN_APP_RES_USE_CUS_LIST]
■ Description				: 회원별 스마트케어 대상예약 추출
■ Input Parameter			:           
		@CUS_NO INT 
■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 

--특정회원의 스마트케어 대상예약 
SELECT * FROM DBO.XN_APP_RES_USE_CUS_LIST(4228549)
WHERE RES_STATE NOT IN (7,8,9)
--AND DEP_DATE < GETDATE()
ORDER BY DEP_DATE 

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2016-09-05		박형만			최초생성 
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_APP_RES_USE_CUS_LIST]
(	
	@CUS_NO INT 
)
RETURNS TABLE
AS
RETURN
(
	--DECLARE @START_DEP_DATE	DATETIME,
	--@END_DEP_DATE	DATETIME
	--SET @START_DEP_DATE =  '2016-08-07'
	--SET @END_DEP_DATE =  '2016-08-30'

	SELECT B.DEP_DATE , B.PRO_CODE  ,B.RES_CODE , B.PRO_TYPE, B.RES_STATE , C.TRANSFER_TYPE , D.SIGN_CODE 
	FROM RES_CUSTOMER_DAMO A WITH(NOLOCK)
		INNER JOIN RES_MASTER_DAMO B WITH(NOLOCK)
			ON A.RES_CODE = B.RES_CODE 
		INNER JOIN PKG_DETAIL C  WITH(NOLOCK)
			ON B.PRO_CODE = C.PRO_CODE
		INNER JOIN PKG_MASTER D WITH(NOLOCK)
			ON C.MASTER_CODE = D.MASTER_CODE

	WHERE B.PRO_TYPE IN (1)  -- [패키지]
	AND  C.TRANSFER_TYPE = 1 -- [교통편] 패키지=항공편
	AND D.ATT_CODE IN ('P','R','W','G')  --[마스터 대표속성] 패키지,실시간항공,허니문,골프
	AND D.SIGN_CODE <> 'K' --[국내해외여부] 해외 

	--고객번호 
	AND A.CUS_NO = @CUS_NO 

	UNION ALL 
	
	SELECT B.DEP_DATE , B.PRO_CODE  ,B.RES_CODE , B.PRO_TYPE, B.RES_STATE , 1 TRANSFER_TYPE , SUBSTRING(PRO_CODE,1,1) AS SIGN_CODE 
	FROM RES_CUSTOMER_DAMO A WITH(NOLOCK)
		INNER JOIN RES_MASTER_DAMO B WITH(NOLOCK)
			ON A.RES_CODE = B.RES_CODE 
			
	WHERE B.PRO_TYPE IN (2)  -- [항공예약] 실시간,오프라인항공
	--고객번호 
	AND A.CUS_NO = @CUS_NO 
	--ORDER BY A.DEP_DATE , A.PRO_CODE  ,A.RES_CODE 
)

GO
