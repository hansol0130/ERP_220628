USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name			: [XN_APP_RES_USE_LIST]
■ Description				: 스마트케어 대상예약 추출
■ Input Parameter			:           
      
		@START_DEP_DATE			: 출발시작일 '2016-08-07'
		@END_DEP_DATE			: 출발종료일 '2016-08-30'  ( 2016-08-30 출발하는거 까지의 예약 조회 ) 
■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 


--2016년8월1일부터 2016년 8월31일 까지의 출발예약
SELECT A.* FROM DBO.XN_APP_RES_USE_LIST('2016-08-01' ,'2016-08-31') A 
	INNER JOIN RES_MASTER_DAMO B 
		ON A.RES_CODE = B.RES_CODE 
ORDER BY A.DEP_DATE , A.PRO_CODE , A.RES_CODE 

SELECT PRO_CODE FROM DBO.XN_APP_RES_USE_LIST('2016-08-01' ,'2016-08-30')
GROUP BY PRO_CODE 

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2016-09-05		박형만			최초생성 
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_APP_RES_USE_LIST]
(	
	@START_DEP_DATE	DATETIME,
	@END_DEP_DATE	DATETIME
)
RETURNS TABLE
AS
RETURN
(
	--DECLARE @START_DEP_DATE	DATETIME,
	--@END_DEP_DATE	DATETIME
	--SET @START_DEP_DATE =  '2016-08-07'
	--SET @END_DEP_DATE =  '2016-08-30'

	SELECT A.DEP_DATE , A.PRO_CODE  ,A.RES_CODE , A.PRO_TYPE, A.RES_STATE , B.TRANSFER_TYPE , C.SIGN_CODE 
	FROM RES_MASTER_DAMO A WITH(NOLOCK)
		INNER JOIN PKG_DETAIL B  WITH(NOLOCK)
			ON A.PRO_CODE = B.PRO_CODE
		INNER JOIN PKG_MASTER C WITH(NOLOCK)
			ON B.MASTER_CODE = C.MASTER_CODE

	WHERE A.PRO_TYPE IN (1)  -- [패키지]
	AND  B.TRANSFER_TYPE = 1 -- [교통편] 패키지=항공편
	AND C.ATT_CODE IN ('P','R','W','G')  --[마스터 대표속성] 패키지,실시간항공,허니문,골프
	AND C.SIGN_CODE <> 'K' --[국내해외여부] 해외 

	--출발일조건(선택)
	AND B.DEP_DATE >= @START_DEP_DATE  AND B.DEP_DATE < CONVERT(DATETIME,DATEADD(DD,1,@END_DEP_DATE))
	AND A.DEP_DATE >= @START_DEP_DATE  AND A.DEP_DATE < CONVERT(DATETIME,DATEADD(DD,1,@END_DEP_DATE))

	--예약상태별조건(선택)
	AND A.RES_STATE >= 2 -- [예약상태] 예약확정~
	AND A.RES_STATE < 7  -- [예약상태] 취소이전 까지 

	UNION ALL 
	
	SELECT A.DEP_DATE , A.PRO_CODE  ,A.RES_CODE , A.PRO_TYPE, A.RES_STATE , 1  , SUBSTRING(PRO_CODE,1,1) AS SIGN_CODE 
	FROM RES_MASTER_DAMO A WITH(NOLOCK)
	WHERE A.PRO_TYPE IN (2)  -- [항공예약] 실시간,오프라인항공
	--출발일조건(선택)
	AND A.DEP_DATE >= @START_DEP_DATE  AND A.DEP_DATE < CONVERT(DATETIME,DATEADD(DD,1,@END_DEP_DATE))
	--예약상태별조건(선택)
	AND A.RES_STATE >= 2 -- [예약상태] 예약확정~
	AND A.RES_STATE < 7  -- [예약상태] 취소이전 까지 

	--ORDER BY A.DEP_DATE , A.PRO_CODE  ,A.RES_CODE 
)

GO
