USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_CTI_CONSULT_SELECT_LIST
- 기 능 : 함수_고객상담_통화내역검색
====================================================================================
	참고내용
====================================================================================
- 예제 EXEC 
SP_CTI_CONSULT_SELECT_LIST @CTI_TYPE = -1  ,  
@START_DATE = '2012-05-01 00:00:00',
@END_DATE = '2012-05-20 00:00:00' , 
@TEAM_CODE = '',
@EMP_CODE = '',
@CUS_NAME = '',
@NOR_TEL1 = '010',
@NOR_TEL2 = '',
@NOR_TEL3 = '',

@PAGE_INDEX = 0 , 
@PAGE_SIZE =15 
====================================================================================
	변경내역
====================================================================================
- 2012-05-14 신규 작성 
===================================================================================*/
CREATE PROCEDURE [dbo].[SP_CTI_CONSULT_SELECT_LIST]
	@CTI_TYPE INT ,
	@TEAM_CODE TEAM_CODE ,
	@EMP_CODE EMP_CODE ,
	@CUS_NAME CUS_NAME ,
	@NOR_TEL1 VARCHAR(5),
	@NOR_TEL2 VARCHAR(4),
	@NOR_TEL3 VARCHAR(4),
	@START_DATE DATETIME,
	@END_DATE DATETIME,

	@PAGE_INDEX INT,
	@PAGE_SIZE INT
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
--@END_DATE DATETIME,

--@PAGE_INDEX INT,
--@PAGE_SIZE INT

--SELECT @CTI_TYPE = -1  ,  
--@START_DATE = '2012-05-01 00:00:00',
--@END_DATE = '2012-05-20 00:00:00' , 
--@TEAM_CODE = '529',
--@EMP_CODE = '9999999',
--@TEAM_CODE = '529',
--@CUS_NAME = '박',

--@NOR_TEL1 = '010',
--@NOR_TEL2 = '',
--@NOR_TEL3 = '',
--@PAGE_INDEX = 0 , 
--@PAGE_SIZE =30 

	DECLARE @FROM INT 
	DECLARE @TO INT
	SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;
	SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;

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
	WITH DOCUMENTLIST AS ( 
		SELECT 
			ROW_NUMBER() OVER (ORDER BY  A.CTI_NO  DESC)  AS ROW_NUM ,
			A.CTI_NO, 
			A.CTI_STATE, 
			A.CTI_TYPE , 
			B.CUS_NAME , 
			A.NOR_TEL1 ,A.NOR_TEL2 ,A.NOR_TEL3 ,
			A.RCV_DATE , A.NEW_DATE , 
			A.TEAM_CODE , ( SELECT TEAM_NAME FROM EMP_TEAM WITH(NOLOCK) WHERE TEAM_CODE = A.TEAM_CODE ) AS TEAM_NAME ,
			A.NEW_CODE , ( SELECT KOR_NAME FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = A.NEW_CODE ) AS NEW_NAME ,
			A.CONTENTS ,
			A.SEQ_NO
		FROM CTI_CONSULT A WITH(NOLOCK) 
			LEFT JOIN CUS_CUSTOMER_DAMO B WITH(NOLOCK)
				ON A.CUS_NO = B.CUS_NO
		WHERE 1=1
		AND  RCV_DATE >= @START_DATE
		AND  RCV_DATE <= DATEADD(D,1,@END_DATE )  
		' + @STR_WHERE + '
	)
	SELECT * FROM  DOCUMENTLIST
	WHERE ROW_NUM BETWEEN @FROM AND @TO
	ORDER BY ROW_NUM ;
	'
	
	SET @STR_PARAMS =N'@CTI_TYPE INT 
	,@TEAM_CODE TEAM_CODE 
	,@EMP_CODE EMP_CODE 
	,@CUS_NAME CUS_NAME 
	,@NOR_TEL1 VARCHAR(5),@NOR_TEL2 VARCHAR(4),@NOR_TEL3 VARCHAR(4)
	,@START_DATE DATETIME,@END_DATE DATETIME

	,@PAGE_INDEX INT
	,@PAGE_SIZE INT
	,@FROM INT 
	,@TO INT '
--PRINT (@STR_QUERY )
	EXEC SP_EXECUTESQL @STR_QUERY ,@STR_PARAMS,@CTI_TYPE ,  
	@TEAM_CODE ,
	@EMP_CODE ,
	@CUS_NAME ,
	@NOR_TEL1,@NOR_TEL2,@NOR_TEL3,
	@START_DATE ,@END_DATE ,
	@PAGE_INDEX , 
	@PAGE_SIZE ,
	@FROM ,@TO

END 
GO
