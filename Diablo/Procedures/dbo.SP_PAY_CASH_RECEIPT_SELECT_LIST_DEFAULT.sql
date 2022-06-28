USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_PAY_CASH_RECEIPT_SELECT_LIST_DEFAULT
- 기 능 : 요청할 현금영수증 내역 기본 조회
====================================================================================
	참고내용
====================================================================================
- 예제
-- EXEC SP_PAY_CASH_RECEIPT_SELECT_LIST_DEFAULT  @PAY_SEQ_MCH_SEQ =  '14201_1,18088_1,28021_1,28482_1,46547_1,'
====================================================================================
	변경내역
====================================================================================
- 2010-05-17 박형만 신규 작성 
- 2010-06-03 박형만 암호화 적용
- 2010-06-08 박형만 PAY_NUM 암호화 적용
===================================================================================*/
CREATE PROC [dbo].[SP_PAY_CASH_RECEIPT_SELECT_LIST_DEFAULT]
	@PAY_SEQ_MCH_SEQ VARCHAR(1000)
AS
SET NOCOUNT ON 
--DECLARE @PAY_SEQ_MCH_SEQ VARCHAR(1000)
--SET @PAY_SEQ_MCH_SEQ = '46775,46776,46777,46778,'
--SET @PAY_SEQ_MCH_SEQ = '14201_1,18088_1,28021_1,28482_1,46547_1,'

DECLARE @TMP_STR VARCHAR(1000)
SET  @TMP_STR = @PAY_SEQ_MCH_SEQ 
--SELECT CHARINDEX(',',@TMP_STR) > 0 

DECLARE @PAY_SEQ_NO TABLE 
( PAY_SEQ INT,
  MCH_SEQ INT 
 ) 

WHILE CHARINDEX(',',@TMP_STR) > 0 
BEGIN
	--SET @TMP_STR = SUBSTRING(@TMP_STR,0, CHARINDEX(',',@TMP_STR) -1 ) 
	DECLARE @PAY_SEQ VARCHAR(100)
	--SET @PAY_SEQ = CONVERT(INT,SUBSTRING(@TMP_STR,0, CHARINDEX(',',@TMP_STR))) 
	
	DECLARE @TMP_SEQ VARCHAR(50)
	SET @TMP_SEQ = SUBSTRING(@TMP_STR,0, CHARINDEX(',',@TMP_STR)) 
	
	
	INSERT INTO @PAY_SEQ_NO 
	VALUES( SUBSTRING(@TMP_SEQ,0,CHARINDEX('_',@TMP_STR)) ,
		SUBSTRING(@TMP_SEQ,CHARINDEX('_',@TMP_STR)+1,LEN(@TMP_SEQ)+1)  ) 
	SET @TMP_STR = SUBSTRING(@TMP_STR,CHARINDEX(',',@TMP_STR)+1,LEN(@TMP_STR)+1)  
	--SELECT @PAY_SEQ , @TMP_STR 
END 
SELECT 
A.PAY_SEQ, 
A.MCH_SEQ,
ISNULL(C.REQ_VER ,-1) AS REQ_VER, 
A.RES_CODE , --예약번호 
B.PAY_TYPE , --결제종류
C.SOC_NUM1 ,
--C.SOC_NUM2 ,
damo.dbo.dec_varchar('DIABLO','dbo.PAY_CASH_RECEIPT','SOC_NUM2', C.SEC_SOC_NUM2) AS SOC_NUM2 ,
--주민번호
C.NOR_TEL1 ,C.NOR_TEL2 , C.NOR_TEL3 , --전화번호
B.PAY_NAME , --입금자
A.PART_PRICE - ISNULL(CTOTAL.TARGET_PRICE,0) AS TARGET_PRICE   --남은 대상금액 
FROM PAY_MATCHING AS A WITH(NOLOCK)
	INNER JOIN PAY_MASTER_damo AS B WITH(NOLOCK)
		ON A.PAY_SEQ = B.PAY_SEQ
		AND B.CXL_YN = 'N'
		AND A.CXL_YN = 'N'
	INNER JOIN @PAY_SEQ_NO AS P 
		ON P.PAY_SEQ = A.PAY_SEQ 
		AND P.MCH_SEQ = A.MCH_SEQ 
	LEFT JOIN PAY_CASH_RECEIPT_damo AS C WITH(NOLOCK) --이전최근신청내역 차수 
		ON  A.PAY_SEQ = C.PAY_SEQ
		AND A.MCH_SEQ = C.MCH_SEQ 
		-- 상태값은 전체 
		AND C.REQ_VER = ( SELECT TOP 1 MAX(REQ_VER) FROM PAY_CASH_RECEIPT_damo AS C2
			WHERE C.PAY_SEQ = C2.PAY_SEQ 
			AND	  C.MCH_SEQ = C2.MCH_SEQ )  --최근 차수만
	LEFT JOIN ( 
		SELECT PAY_SEQ , MCH_SEQ , SUM(TARGET_PRICE) AS TARGET_PRICE  
		FROM PAY_CASH_RECEIPT_damo AS C1 WITH(NOLOCK)
		WHERE C1.STATUS_TYPE IN(0,1) -- 처리중,처리완료 만 . 처리 완료인것만만 해야 하나? 고민
		GROUP BY PAY_SEQ , MCH_SEQ
	) AS CTOTAL  --처리중인것 이전차수 금액  전체 더함
		ON A.PAY_SEQ = CTOTAL.PAY_SEQ 
		AND A.MCH_SEQ = CTOTAL.MCH_SEQ 
WHERE A.PART_PRICE > ISNULL(CTOTAL.TARGET_PRICE,0) --금액 남은것들만


GO
