USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : [SP_RES_STATE_INFO_AFFILIATE]
- 기 능 : 제휴사 상품 예약상태  정보 조회 (SQL.검색_제휴사예약상태정보)
====================================================================================
	참고내용
	
	출발일 7일 지난 예약~출발하지 않은 예약
	해당 제휴사의 마스터코드 
	제휴사코드에 해당하는 XML 파일 생성
====================================================================================
- 예제
 EXEC SP_RES_STATE_INFO_AFFILIATE  'KPD801'
====================================================================================
	
	
====================================================================================
- 2011-02-01 박형만 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_RES_STATE_INFO_AFFILIATE]
	@MASTER_CODE VARCHAR(20)
AS 
SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @BASIS_DATE DATETIME 
SET @BASIS_DATE = GETDATE()

	--DECLARE @MASTER_CODE VARCHAR(20)
	--SET @MASTER_CODE = 'KPD801' -- 테마캠프  --  'KPC801'  -- 홍익관광 

SELECT --TOP 100 
	RM.RES_CODE , 
	RAM.ALT_CODE , 
	RAM.ALT_NAME , 
	RAM.ALT_RES_CODE ,
	CONVERT(VARCHAR(19),RM.NEW_DATE,121) AS NEW_DATE  ,
	ISNULL(CASE WHEN RES_STATE NOT IN (7,8,9) THEN CONVERT(VARCHAR(19),RM.EDT_DATE,121) ELSE CONVERT(VARCHAR(19),RM.CXL_DATE,121)  
		END,'') AS EDT_DATE ,  --수정일 
	CONVERT(VARCHAR(19),RM.DEP_DATE,121) AS DEP_DATE  , 
	RM.RES_STATE , 
	PD.MASTER_CODE ,
	ISNULL((SELECT SUM(PAY_PRICE)
		FROM PAY_MASTER A
		INNER JOIN PAY_MATCHING B ON A.PAY_SEQ = B.PAY_SEQ
		WHERE RES_CODE = RM.RES_CODE ),0) AS PAY_PRICE , 
	ISNULL(STUFF((
		SELECT (' / ' + ISNULL(C.PUB_VALUE, '') + ' [' + CONVERT(VARCHAR(20), PAY_PRICE) + ']') AS [text()]
		FROM PAY_MASTER A
		INNER JOIN PAY_MATCHING B ON A.PAY_SEQ = B.PAY_SEQ
		LEFT JOIN COD_PUBLIC C ON C.PUB_TYPE = 'PAY.PAYMENTTYPE' AND A.PAY_TYPE = C.PUB_CODE
		WHERE RES_CODE = RM.RES_CODE
		FOR XML PATH('')
	), 1, 3, ''),'') AS PAY_INFO_TEXT
	
FROM RES_MASTER_DAMO AS RM 
	INNER JOIN PKG_DETAIL AS PD 
		ON RM.PRO_CODE = PD.PRO_CODE 
	INNER JOIN RES_ALT_MATCHING AS RAM 
		ON RM.RES_CODE = RAM.RES_CODE 
	--INNER JOIN ( 
	
	--	SELECT 
	--	PAY_MATCHING 
	
	--LEFT JOIN PAY_MATCHING AS PM  
	--	ON RM.RES_CODE = RAM.RES_CODE
WHERE PD.MASTER_CODE IN (@MASTER_CODE)  -- 테마캠프  --  'KPC801'  -- 홍익관광 
AND RM.DEP_DATE > DATEADD(DD,-7,@BASIS_DATE)  -- 출발일 7일 지난 예약~출발하지 않은예약
GO
