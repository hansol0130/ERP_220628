USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_EVT_LOTTE_COUPON_SELECT_COUNT
- 기 능 : 함수_롯데면세점_교환권발급_내역조회_카운트
====================================================================================
	참고내용
====================================================================================
- 예제
EXEC SP_EVT_LOTTE_COUPON_SELECT_COUNT @SEARCH_TYPE = 1 ,@START_DATE = '2012-05-23' ,@END_DATE = '2012-05-29' ,@PRO_CODE = '',@RES_CODE = '' ,@CUS_NAME = '' 
,@TEAM_CODE = '529' ,@NEW_CODE = '', @PROVIDER = -1  ;
====================================================================================
	변경내역
====================================================================================
- 2011-08-26 신규 작성 
- 2012-05-24 유입처 조회 
===================================================================================*/
CREATE PROC [dbo].[SP_EVT_LOTTE_COUPON_SELECT_COUNT]
	@SEARCH_TYPE INT , -- 0:출발일 , 1=쿠폰발급일
	@START_DATE VARCHAR(10),
	@END_DATE VARCHAR(10),
	@PRO_CODE PRO_CODE,
	@RES_CODE RES_CODE,
	@CUS_NAME VARCHAR(20),  --출발자명 
	@TEAM_CODE TEAM_CODE,
	@NEW_CODE EMP_CODE ,
	
	@PROVIDER INT 
AS 

BEGIN
--SELECT TOP 10 * FROM EVT_LOTTE_COUPON_damo

--DECLARE @STR_REQ_NO VARCHAR(4000)
--SET @STR_REQ_NO = '1,2,3,5,6'

--DECLARE 
--@SEARCH_TYPE INT , -- 0:출발일 , 1=쿠폰발급일
--@START_DATE VARCHAR(10),
--@END_DATE VARCHAR(10),
--@PRO_CODE PRO_CODE,
--@RES_CODE RES_CODE,
--@CUS_NAME VARCHAR(20),  --출발자명 
--@TEAM_CODE TEAM_CODE,
--@NEW_CODE EMP_CODE,
--@PAGE_SIZE INT ,
--@PAGE_INDEX INT ,
--@PROVIDER INT 

--SELECT @SEARCH_TYPE = 1 , @START_DATE = '2012-04-29' ,@END_DATE = '2012-08-29' ,@PRO_CODE = '' ,@RES_CODE = '' , @CUS_NAME = '' 
--,@TEAM_CODE = '' ,@NEW_CODE = '',@PAGE_SIZE=2,@PAGE_INDEX=0 , @PROVIDER = 0 ;

DECLARE @STR_QUERY NVARCHAR(4000)
DECLARE @STR_WHERE NVARCHAR(1000)
DECLARE @STR_PARAMS NVARCHAR(1000)
SET @STR_WHERE = ''

IF( ISNULL(@PRO_CODE,'') <>'' ) 
BEGIN
	SET @STR_WHERE = @STR_WHERE + ' AND  B.PRO_CODE = @PRO_CODE ' 
END 
IF( ISNULL(@RES_CODE,'') <>'' ) 
BEGIN
	SET @STR_WHERE = @STR_WHERE + ' AND  B.RES_CODE = @RES_CODE ' 
END 
IF( ISNULL(@CUS_NAME,'') <>'' ) 
BEGIN
	SET @STR_WHERE = @STR_WHERE + ' AND  C.CUS_NAME = @CUS_NAME  ' 
END 
IF( ISNULL(@TEAM_CODE,'') <>'' ) 
BEGIN
	SET @STR_WHERE = @STR_WHERE + ' AND  D.TEAM_CODE = @TEAM_CODE  ' 
END 
IF( ISNULL(@NEW_CODE,'') <>'' ) 
BEGIN
	SET @STR_WHERE = @STR_WHERE + ' AND  D.EMP_CODE = @NEW_CODE  ' 
END 

-- PROVIDER = -1 :전체 
IF( @PROVIDER > -1 ) 
BEGIN
	--롯데일때는 16 제외 
	IF( @PROVIDER = 1 ) 
	BEGIN
		SET @STR_WHERE = @STR_WHERE + ' AND  B.PROVIDER <> 16  ' 
	END
	ELSE IF  ( @PROVIDER = 16 ) 
	BEGIN
		SET @STR_WHERE = @STR_WHERE + ' AND  B.PROVIDER = @PROVIDER  ' 
	END 
END 

SET @STR_QUERY = N'
	SELECT COUNT(*)
	FROM EVT_LOTTE_COUPON AS A WITH(NOLOCK)
		INNER JOIN  RES_MASTER_damo AS B WITH(NOLOCK)
			ON A.RES_CODE = B.RES_CODE  
		INNER JOIN  RES_CUSTOMER_damo AS C WITH(NOLOCK)
			ON A.RES_CODE = C.RES_CODE 
			AND A.SEQ_NO = C.SEQ_NO 
		INNER JOIN  EMP_MASTER_damo AS D WITH(NOLOCK)
			ON A.ISSUER_CODE = D.EMP_CODE 
		INNER JOIN  EMP_TEAM AS E WITH(NOLOCK)
			ON D.TEAM_CODE = E.TEAM_CODE 
		
	WHERE (( @SEARCH_TYPE = 0 AND B.DEP_DATE >= CONVERT(DATETIME,@START_DATE) AND B.DEP_DATE < DATEADD(D,1,CONVERT(DATETIME,@END_DATE)) ) 
	OR ( @SEARCH_TYPE = 1 AND A.ISSUE_DATE >= CONVERT(DATETIME,@START_DATE) AND A.ISSUE_DATE < DATEADD(D,1,CONVERT(DATETIME,@END_DATE))) )
	AND A.ISSUE_YN =''Y''  
	
	'+ @STR_WHERE 
	

SET @STR_PARAMS =N'@SEARCH_TYPE INT , 
	@START_DATE VARCHAR(10),
	@END_DATE VARCHAR(10),
	@PRO_CODE PRO_CODE,
	@RES_CODE RES_CODE,
	@CUS_NAME VARCHAR(20), 
	@TEAM_CODE TEAM_CODE,
	@NEW_CODE EMP_CODE,
	@PROVIDER INT ' 
	
--PRINT (@STR_QUERY )
	EXEC SP_EXECUTESQL @STR_QUERY ,@STR_PARAMS,@SEARCH_TYPE ,  
	@START_DATE ,
	@END_DATE,
	@PRO_CODE,
	@RES_CODE,
	@CUS_NAME, 
	@TEAM_CODE,
	@NEW_CODE,
	@PROVIDER
	
END 
GO
