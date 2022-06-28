USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_CTI_CONSULT_SELECT_COUNT
- 기 능 : 함수_고객상담_통화내역검색_카운트
====================================================================================
	참고내용
====================================================================================
- 예제 EXEC 
SP_CTI_CONSULT_SELECT_COUNT @CTI_TYPE = -1  ,  
@START_DATE = '2012-05-01 00:00:00',
@END_DATE = '2012-05-20 00:00:00' , 
@TEAM_CODE = '529',
@EMP_CODE = '9999999',
@TEAM_CODE = '529',
@CUS_NAME = '박',
@NOR_TEL1 = '010',
@NOR_TEL2 = '',
@NOR_TEL3 = ''
====================================================================================
	변경내역
====================================================================================
- 2012-05-14 신규 작성 
===================================================================================*/
CREATE PROCEDURE [dbo].[SP_CTI_CONSULT_SELECT_COUNT]
	@CTI_TYPE INT ,
	@TEAM_CODE TEAM_CODE ,
	@EMP_CODE EMP_CODE ,
	@CUS_NAME CUS_NAME ,
	@NOR_TEL1 VARCHAR(5),
	@NOR_TEL2 VARCHAR(4),
	@NOR_TEL3 VARCHAR(4),
	@START_DATE DATETIME,
	@END_DATE DATETIME
AS
BEGIN 

--DECLARE @CTI_TYPE INT ,
--@TEAM_CODE TEAM_CODE ,
--@EMP_CODE EMP_CODE ,
--@CUS_NAME CUS_NAME ,
--@NOR_TEL1 VARCHAR(5),
--@NOR_TEL2 VARCHAR(4),
--@NOR_TEL3 VARCHAR(4),
--@START_DATE DATETIME,
--@END_DATE DATETIME

--SELECT @CTI_TYPE = -1  ,  
--@START_DATE = '2012-05-01 00:00:00',
--@END_DATE = '2012-05-20 00:00:00' , 
--@TEAM_CODE = '529',
--@EMP_CODE = '9999999',
--@TEAM_CODE = '529',
--@CUS_NAME = '박',

--@NOR_TEL1 = '010',
--@NOR_TEL2 = '',
--@NOR_TEL3 = ''

	DECLARE @STR_QUERY NVARCHAR(4000)
	DECLARE @STR_WHERE NVARCHAR(1000)
	DECLARE @STR_PARAMS NVARCHAR(1000)
	SET @STR_WHERE = ''

	IF( @CTI_TYPE > -1 ) 
	BEGIN
		SET @STR_WHERE = @STR_WHERE + '	AND	 CTI_TYPE = @CTI_TYPE ' 
	END 
	IF( ISNULL(@TEAM_CODE,'') <>'' ) 
	BEGIN
		SET @STR_WHERE = @STR_WHERE + ' AND  A.TEAM_CODE = @TEAM_CODE ' 
	END 
	IF( ISNULL(@EMP_CODE,'') <>'' ) 
	BEGIN
		SET @STR_WHERE = @STR_WHERE + ' AND  A.NEW_CODE = @EMP_CODE  ' 
	END 
	IF( ISNULL(@CUS_NAME,'') <>'' ) 
	BEGIN
		SET @STR_WHERE = @STR_WHERE + ' AND B.CUS_NAME LIKE  + @CUS_NAME +''%''  ' 
	END 

	IF( ISNULL(@NOR_TEL1,'') <>'' ) 
	BEGIN
		SET @STR_WHERE = @STR_WHERE + ' AND A.NOR_TEL1 = @NOR_TEL1 ' 
	END 
	IF( ISNULL(@NOR_TEL2,'') <>'' ) 
	BEGIN
		SET @STR_WHERE = @STR_WHERE + ' AND A.NOR_TEL2 = @NOR_TEL2 ' 
	END 
	IF( ISNULL(@NOR_TEL3,'') <>'' ) 
	BEGIN
		SET @STR_WHERE = @STR_WHERE + ' AND A.NOR_TEL3 = @NOR_TEL3 ' 
	END 

	SET @STR_QUERY = N'
		SELECT 
			COUNT(*)
		FROM CTI_CONSULT A WITH(NOLOCK) 
			LEFT JOIN CUS_CUSTOMER_DAMO B WITH(NOLOCK)
				ON A.CUS_NO = B.CUS_NO
		WHERE 1=1
		AND  RCV_DATE >= @START_DATE
		AND  RCV_DATE <= DATEADD(D,1,@END_DATE )  
		' + @STR_WHERE 
	
	SET @STR_PARAMS =N'@CTI_TYPE INT 
	,@TEAM_CODE TEAM_CODE 
	,@EMP_CODE EMP_CODE 
	,@CUS_NAME CUS_NAME 
	,@NOR_TEL1 VARCHAR(5),@NOR_TEL2 VARCHAR(4),@NOR_TEL3 VARCHAR(4)
	,@START_DATE DATETIME,@END_DATE DATETIME'

--PRINT (@STR_QUERY )
	EXEC SP_EXECUTESQL @STR_QUERY ,@STR_PARAMS,@CTI_TYPE ,  
	@TEAM_CODE ,
	@EMP_CODE ,
	@CUS_NAME ,
	@NOR_TEL1,@NOR_TEL2,@NOR_TEL3,
	@START_DATE ,@END_DATE 
	
END 
GO
