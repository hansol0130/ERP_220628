USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Server					: 
■ Database					: DIABLO
■ USP_Name					: XP_AGT_RES_SALE_SELECT
■ Description				: 대리점 예약판매현황
■ Input Parameter			:                  
							@PROVIDER VARCHAR(10) , --유입처
							@AGT_CODE VARCHAR(50), --대리점
							@RES_NAME VARCHAR(20), --예약자
							@START_DATE DATETIME , --출발일 시작
							@END_DATE DATETIME , --출발일 종료
							@RES_CODE RES_CODE, --예약코드
							@PRO_CODE PRO_CODE, --행사코드
							@RES_STATE INT, --예약상태 10:전체
							@ORDER_TYPE --  예약상태순=1/출발일순=2/상품금액3/변동금액4/판매금액5/수수료
							@NEW_CODE CHAR(7) -- 담당자 코드

							
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC XP_AGT_RES_SALE_SELECT @PROVIDER = NULL ,@START_DATE = '2013-03-01',@END_DATE = '2013-03-28',
		@RES_CODE = NULL , @PRO_CODE = NULL , @RES_STATE  = 10 , @RES_NAME = NULL , @AGT_CODE = NULL  , @NEW_CODE = null 
■ Author					: 박형만  
■ Date						: 2013-02-20
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-20		박형만			최초생성  
	2018-01-22		이명훈			0 나누기 오류 수정
	2021-11-18		오준혁			예약일순으로 정렬 추가
	2021-11-25		오준혁			제휴사인 경우 수수료 계산은 (상품금액*수수료율)
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[XP_AGT_RES_SALE_SELECT] 
(
	@PROVIDER VARCHAR(10) ,
	@AGT_CODE VARCHAR(50),
	@RES_NAME VARCHAR(20),
	@START_DATE DATETIME , 
	@END_DATE DATETIME ,
	@RES_CODE RES_CODE,
	@PRO_CODE PRO_CODE,
	@RES_STATE INT,
	@ORDER_TYPE INT ,
	@NEW_CODE CHAR(7)
)
AS 

--DECLARE @PROVIDER VARCHAR(10) ,
--	@AGT_CODE VARCHAR(50),
--	@RES_NAME VARCHAR(20),
--	@START_DATE DATETIME , 
--	@END_DATE DATETIME ,
--	@RES_CODE RES_CODE,
--	@PRO_CODE PRO_CODE,
--	@RES_STATE INT,
--	@ORDER_TYPE INT,
--	@NEW_CODE CHAR(7)
--SELECT @PROVIDER = NULL ,@START_DATE = '2013-01-01',@END_DATE = '2013-03-28',
--@RES_CODE = NULL , @PRO_CODE = NULL , @RES_STATE  = 10 , @RES_NAME = NULL , 
--@AGT_CODE = NULL  ,@ORDER_TYPE = 1, @NEW_CODE = 'A130001'

DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000) ,@WHERE NVARCHAR(1000)  ,@INNER_TABLE NVARCHAR(1000), @ORDER_BY VARCHAR(200)
SET @WHERE = ''

--예약코드 우선 
IF ISNULL(@RES_CODE,'') <> ''
BEGIN
	SET @WHERE = @WHERE + ' 
	AND  A.RES_CODE = @RES_CODE '
END 
ELSE IF ISNULL(@PRO_CODE,'') <> ''   --행사코드 우선 
BEGIN
	SET @WHERE = @WHERE + ' 
	AND  A.PRO_CODE = @PRO_CODE '
END 
ELSE 
BEGIN

	IF ISNULL(@PROVIDER,'') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' 
		AND  A.PROVIDER = @PROVIDER '
	END 

	IF ISNULL(@AGT_CODE,'') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' 
		AND  A.SALE_COM_CODE = @AGT_CODE '
	END 

	IF ISNULL(@NEW_CODE,'') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' 
		AND  A.SALE_EMP_CODE = @NEW_CODE '
	END 

	IF ISNULL(@RES_NAME,'') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' 
		AND  A.RES_NAME = @RES_NAME '
	END 

	IF @RES_STATE <> 10 
	BEGIN
		SET @WHERE = @WHERE + ' 
		AND  A.RES_STATE = @RES_STATE '
	END 

END 

-- 정렬조건 추가 
 --예약상태순=1/출발일순=2/상품금액3/변동금액4/판매금액5/수수료6/예약일순7
SET @ORDER_BY = ( 
	SELECT 	CASE WHEN @ORDER_TYPE  = 0 THEN  ' DEP_DATE ' 
					WHEN @ORDER_TYPE  = 1 THEN  ' IS_END DESC , RES_STATE ASC , DEP_DATE '
					WHEN @ORDER_TYPE  = 2 THEN  ' DEP_DATE ASC'
					WHEN @ORDER_TYPE  = 3 THEN  ' SALE_PRICE DESC ' 
					WHEN @ORDER_TYPE  = 4 THEN  ' CHANGE_PRICE DESC '
					WHEN @ORDER_TYPE  = 5 THEN  ' TOTAL_PRICE  DESC'
					WHEN @ORDER_TYPE  = 6 THEN  ' COMM_AMT DESC '
					WHEN @ORDER_TYPE  = 7 THEN  ' NEW_DATE ASC '
			ELSE ' A.DEP_DATE ' END  ) 

SET @SQLSTRING = '
SELECT 
	CASE WHEN A.ARR_DATE > GETDATE() THEN 0 ELSE  1 END IS_END  ,
	A.RES_STATE,
	A.RES_CODE,
	A.DEP_DATE,
	A.PRO_CODE,
	A.PRO_NAME,
	A.RES_NAME,
	A.NEW_DATE,
	A.SALE_EMP_CODE ,
	DBO.XN_COM_GET_EMP_NAME(A.SALE_EMP_CODE) AS SALE_EMP_NAME ,
	DBO.XN_COM_GET_TEAM_NAME(A.SALE_EMP_CODE) AS SALE_EMP_NAME,
	(SELECT KOR_NAME FROM AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = A.SALE_COM_CODE) AS AGT_NAME,
	DBO.FN_RES_GET_RES_COUNT(A.RES_CODE) AS RES_COUNT,
	DBO.FN_RES_GET_SALE_PRICE(A.RES_CODE) AS SALE_PRICE,
	(DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) - DBO.FN_RES_GET_SALE_PRICE(A.RES_CODE)) AS CHANGE_PRICE,
	DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) AS TOTAL_PRICE,
	
	CASE WHEN  DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) = 0 THEN A.COMM_AMT
		WHEN A.COMM_AMT > 0 THEN (A.COMM_AMT / DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE))  *  100.0		
		ELSE A.COMM_RATE  END  AS COMM_RATE ,

	CASE WHEN A.COMM_RATE > 0 THEN (DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) * 0.01) * A.COMM_RATE 
		ELSE A.COMM_AMT END  AS COMM_AMT, 

	CASE WHEN A.COMM_RATE > 0 THEN (DBO.FN_RES_GET_SALE_PRICE(A.RES_CODE) * 0.01) * A.COMM_RATE 
		ELSE A.COMM_AMT END  AS COMM_AMT2 -- 제휴사 수수료 계산 
	
FROM RES_MASTER_DAMO A WITH(NOLOCK)
WHERE A.DEP_DATE BETWEEN @START_DATE AND @END_DATE
' + @WHERE +
'
ORDER BY '+ @ORDER_BY +' , A.SALE_EMP_CODE '

SET @PARMDEFINITION = N'
@PROVIDER VARCHAR(10) ,
@AGT_CODE VARCHAR(50),
@RES_NAME VARCHAR(20),
@START_DATE DATETIME , 
@END_DATE DATETIME ,
@RES_CODE RES_CODE,
@PRO_CODE PRO_CODE,
@RES_STATE INT,
@NEW_CODE CHAR(7)';      
      
--PRINT @SQLSTRING
EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
@PROVIDER,
@AGT_CODE,
@RES_NAME,
@START_DATE,
@END_DATE,
@RES_CODE,
@PRO_CODE,
@RES_STATE,
@NEW_CODE


GO
