USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_PKG_MASTER_SELECT_PRODUCT_NAVER_UPDLIST
- 기 능 : 네이버 연동상품 수정내역 조회 ( 요약 EP전송 )
====================================================================================
	참고내용
====================================================================================
- 네이버 연동상품 조회 NaverShoppingProductMakeText.exe 스케쥴 프로그램에서 사용
	shopping.naver.com 여행 카테고리 상품 전송 ( 요약 EP전송)
- 예제
 EXEC SP_PKG_MASTER_SELECT_PRODUCT_NAVER_UPDLIST '2014-02-14 14:00:00','2014-02-20 16:00:00'
====================================================================================
	변경내역
====================================================================================
- 2014-02-20 박형만 최초생성
===================================================================================*/
CREATE PROC [dbo].[SP_PKG_MASTER_SELECT_PRODUCT_NAVER_UPDLIST]
	@START_DATE DATETIME , 
	@END_DATE DATETIME 
AS 
--DECLARE @START_DATE DATETIME,@END_DATE DATETIME 
--SELECT @START_DATE = '2014-02-14 14:00:00' , @END_DATE = '2014-02-14 16:00:00';

--네이버 PROVIDER 코드 
DECLARE @PROVIDER_NAVER INT 
SET @PROVIDER_NAVER = 21 ;
------------------------------------------------------------------
--금일수정 된것중에 , 삭제 변동 상품 조회 
------------------------------------------------------------------
WITH PKG_AFF_UPD_LIST AS 
( 
	SELECT 
		PM.EDT_DATE,
		UPPER(PM.MASTER_CODE)  AS MAPID,
		PM.MASTER_NAME  AS PNAME,
		PM.LOW_PRICE  AS PRICE ,
		CASE WHEN PM.SHOW_YN ='N' THEN 'D'	--삭제상품 보이지 않음  
		 WHEN PM.LAST_DATE < @START_DATE THEN 'D'  --삭제상품   앞으로 행사없음 
		ELSE 'U' END AS CLASS , 
		GETDATE() AS UTIME 
	FROM PKG_MASTER_AFFILIATE A 
		INNER JOIN PKG_MASTER PM 
			ON A.MASTER_CODE = PM.MASTER_CODE 
	WHERE A.PROVIDER = @PROVIDER_NAVER  
	AND PM.EDT_DATE > @START_DATE 
	AND PM.EDT_DATE < @END_DATE 
) 
SELECT * FROM PKG_AFF_UPD_LIST;
GO
