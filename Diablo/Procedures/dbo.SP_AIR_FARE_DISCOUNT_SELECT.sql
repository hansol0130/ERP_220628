USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_AIR_FARE_DISCOUNT_SELECT
- 기 능 : 오늘의 특가 항공권 조회
====================================================================================
	참고내용
====================================================================================
- 예제
 EXEC SP_AIR_FARE_DISCOUNT_SELECT 0,0
 EXEC SP_AIR_FARE_DISCOUNT_SELECT 1,0
 EXEC SP_AIR_FARE_DISCOUNT_SELECT 1,4
====================================================================================
	변경내역
====================================================================================
- 2011-04-05 박형만 신규 작성 
- 2012-10-09 박형만 오늘의 특가 항공권으로 변경 
===================================================================================*/
CREATE PROC [dbo].[SP_AIR_FARE_DISCOUNT_SELECT]
	@TYPE INT, -- 0 : 판매기간관계없이 전체(ERP) , 1: 현재 판매기간이 남아있는것(HOMEPAGE)
	@SEQ_NO INT  -- 0 : 전체 , 1 :해당 SEQ_NO
AS

SELECT 
FD.SEQ_NO,
FD.START_DATE , 
FD.END_DATE , 
FD.AIRLINE_CODE , PA.KOR_NAME AS AIRLINE_NAME,
FD.SUBJECT,
FD.TITLE1,FD.TEXT1,
FD.TITLE2,FD.TEXT2,
FD.TITLE3,FD.TEXT3,
FD.DIS_PRICE,
FD.LINK,
FD.USE_YN,
FD.NEW_CODE,
FD.NEW_DATE,
FD.EDT_CODE,
FD.EDT_DATE
FROM FARE_DISCOUNT AS FD  WITH(NOLOCK)
	INNER JOIN PUB_AIRLINE AS PA  WITH(NOLOCK)
		ON FD.AIRLINE_CODE = PA.AIRLINE_CODE
WHERE USE_YN = 'Y' 
AND ( @TYPE = 0 
	OR (@TYPE = 1 AND GETDATE() BETWEEN START_DATE  AND END_DATE )  
	)
AND (@SEQ_NO = 0 OR FD.SEQ_NO = @SEQ_NO ) 
ORDER BY FD.SEQ_NO DESC
GO
