USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: XP_AGT_PKG_DETAIL_SELECT_LIST
■ Description				: 
■ Input Parameter			:                  
	@MASTER_CODE	VARCHAR(10),  
	@START_DATE		DATETIME,
	@END_DATE		DATETIME,
	@ORDER_TYPE		INT -- 0 출발일:기본 ,1 예약가능여부 ,2 출발확정,3 예약수 ,4 상품금액,
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						:  XP_PKG_AGT_DETAIL_SELECT_LIST 'EPP405' ,'2012-01-01','2013-01-03', 0 
■ Author					:  
■ Date						: 
■ Memo						: 제휴사 예약조회

SP_PKG_DETAIL_SELECT_LIST_5 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
									최초생성  
	2014-06-26		박형만			상품총액표시 추가 
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[XP_AGT_PKG_DETAIL_SELECT_LIST]
(
	@MASTER_CODE	VARCHAR(10),  
	@START_DATE		DATETIME,
	@END_DATE		DATETIME,
	@ORDER_TYPE		INT -- 0 출발일:기본 ,1 예약가능여부 ,2 출발확정,3 예약수 ,4 상품금액,
)
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	-- 변수 선언
	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @START VARCHAR(10), @END VARCHAR(10) , @ORDER_BY VARCHAR(200)
	  
	-- WHERE 조건 만들기  
	SET @SQLSTRING = '';  
	SET @START = ISNULL(CONVERT(VARCHAR(10), @START_DATE, 120), '')  
	SET @END = ISNULL(CONVERT(VARCHAR(10), DATEADD(DAY, 1, @END_DATE), 120), '')  
	SET @ORDER_BY = '' 
	  
	-- 마스터코드  
	IF ISNULL(@MASTER_CODE, '') <> '' 
	BEGIN  
		SET @SQLSTRING = @SQLSTRING + ' AND  A.MASTER_CODE = @MASTER_CODE  '  
	END 

	---- 행사코드  
	--IF ISNULL(@PRO_CODE, '') <> ''  
	--BEGIN  
	--	SET @SQLSTRING = @SQLSTRING + ' A.PRO_CODE LIKE @PRO_CODE + ''%'' AND'  
	--END 

	-- 출발일  
	IF ISNULL(@START, '') <> '' AND ISNULL(@END, '') <> ''  
	BEGIN  
		SET @SQLSTRING = @SQLSTRING + ' AND (  A.DEP_DATE >= CONVERT(DATETIME,@START) AND A.DEP_DATE < CONVERT(DATETIME,@END)  ) '  
	END  
	ELSE IF ISNULL(@START_DATE, '') <> '' AND ISNULL(@END_DATE, '') = ''  
	BEGIN  
		SET @SQLSTRING = @SQLSTRING + ' AND (  A.DEP_DATE >= CONVERT(DATETIME,@START)  )'
	END  
	ELSE IF ISNULL(@START_DATE, '') = '' AND ISNULL(@END_DATE, '') <> ''  
	BEGIN  
		SET @SQLSTRING = @SQLSTRING + ' AND (  A.DEP_DATE <  CONVERT(DATETIME,@END)  + 1  )'
	END 
--ORDER BY A.DEP_DATE  --0 출발일:기본 
--ORDER BY A.RES_ADD_YN DESC , A.DEP_DATE --1 예약가능여부 
--ORDER BY A.DEP_CFM_YN DESC , A.DEP_DATE --2 출발확정
--ORDER BY RES_COUNT DESC , A.DEP_DATE --3 예약수 
--ORDER BY PRO_PRICE DESC , A.DEP_DATE --4 상품금액

	-- 정렬조건 추가 
	SET @ORDER_BY = ( 
		SELECT 	CASE WHEN @ORDER_TYPE  = 0 THEN  ' A.DEP_DATE ' 
						WHEN @ORDER_TYPE  = 1 THEN  ' A.RES_ADD_YN DESC , A.DEP_DATE '
						WHEN @ORDER_TYPE  = 2 THEN  ' A.DEP_CFM_YN DESC , A.DEP_DATE '
						WHEN @ORDER_TYPE  = 3 THEN  ' RES_COUNT DESC , A.DEP_DATE ' 
						WHEN @ORDER_TYPE  = 4 THEN  ' PRO_PRICE DESC , A.DEP_DATE '
				ELSE ' A.DEP_DATE ' END  ) 
		

	SET @SQLSTRING = N'SELECT A.DEP_CFM_YN, A.CONFIRM_YN, A.RES_ADD_YN, DBO.FN_PRO_GET_ACCOUNT_STATE(A.PRO_CODE) AS [ACCOUNT_TYPE],  
								A.PRO_CODE, A.DEP_DATE, B.DEP_DEP_TIME AS [DEP_TIME],
								--(SELECT TOP 1 ADT_PRICE FROM PKG_DETAIL_PRICE WHERE PRO_CODE = A.PRO_CODE) AS [PRO_PRICE],  
								dbo.XN_PRO_DETAIL_SALE_PRICE_CUTTING(A.PRO_CODE,0) AS PRO_PRICE ,
								B.DEP_TRANS_CODE, B.DEP_TRANS_NUMBER, A.PRO_NAME,
								DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS [RES_COUNT],  
								FAKE_COUNT, MAX_COUNT, MIN_COUNT, B.SEAT_COUNT, C.SIGN_CODE, A.SALE_TYPE, A.PRICE_TYPE, A.PKG_INSIDE_REMARK  
						FROM PKG_DETAIL A WITH(NOLOCK)   
						INNER JOIN PKG_MASTER C WITH(NOLOCK) ON C.MASTER_CODE = A.MASTER_CODE   
						LEFT OUTER JOIN PRO_TRANS_SEAT B  WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE  
						WHERE 1=1 
						' + @SQLSTRING + '  
						ORDER BY ' + @ORDER_BY   
	  
	SET @PARMDEFINITION = N'@MASTER_CODE VARCHAR(10), @START VARCHAR(10), @END VARCHAR(10) ';  

	--PRINT @SQLSTRING  
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @MASTER_CODE, @START, @END
END  


GO
