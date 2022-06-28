USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CUS_FAX_PASSINFO_SELECT
■ DESCRIPTION				: 검색_여권팩스매칭고객정보
								함수_여권팩스매칭고객정보 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 

EXEC SP_CUS_FAX_PASSINFO_SELECT 
@CUS_NAME='',@BIRTH_DATE=NULL,@PASS_NUM=NULL,@MASTER_CODE=NULL,@DEP_DATE=NULL,@TEAM_CODE='511',@NEW_CODE=NULL

EXEC SP_CUS_FAX_PASSINFO_SELECT 
@CUS_NAME='',@BIRTH_DATE=NULL,@PASS_NUM=NULL,@MASTER_CODE='APP3900',@DEP_DATE=NULL,@TEAM_CODE='608',@NEW_CODE='2011038'



------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2018-05-17		박형만			최초생성 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_CUS_FAX_PASSINFO_SELECT]
	@CUS_NAME varchar(50),
	@BIRTH_DATE VARCHAR(10),
	@PASS_NUM varchar(12),
	@MASTER_CODE varchar(10),
	@DEP_DATE VARCHAR(10),
	@TEAM_CODE varchar(3),
	@NEW_CODE varchar(7) ,
	@PASS_YN varchar(1) = NULL 
AS 
BEGIN 


--DECLARE @CUS_NAME varchar(50),
--	@BIRTH_DATE VARCHAR(10),
--	@PASS_NUM varchar(12),
--	@MASTER_CODE varchar(10),
--	@DEP_DATE VARCHAR(10),
--	@TEAM_CODE varchar(3),
--	@NEW_CODE varchar(7)

--SELECT @CUS_NAME='',@BIRTH_DATE=NULL,@PASS_NUM=NULL,@MASTER_CODE=NULL,@DEP_DATE=NULL,@TEAM_CODE='511',@NEW_CODE=NULL

	DECLARE @SQLSTRING NVARCHAR(MAX),@PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(MAX)
	
	SELECT @WHERE = '' 

	IF ISNULL(@CUS_NAME,'') <> ''
	BEGIN
		SET @WHERE  = @WHERE + ' AND B.CUS_NAME = @CUS_NAME  ' 
	END 
	
	IF ISNULL(@BIRTH_DATE,'') <> ''
	BEGIN
		SET @WHERE  = @WHERE + ' AND B.BIRTH_DATE = @BIRTH_DATE  ' 
	END 
	-- 잘들어가 있나 확인용 ?
	IF ISNULL(@PASS_NUM,'') <> ''
	BEGIN
		SET @WHERE  = @WHERE + ' AND ( B.SEC_PASS_NUM  = damo.dbo.enc_varchar(''DIABLO'', ''dbo.RES_CUSTOMER'', ''PASS_NUM'', @PASS_NUM) ) ' 
	END 
	
	IF ISNULL(@DEP_DATE,'') <> ''
	BEGIN
		SET @WHERE  = @WHERE + ' AND A.DEP_DATE = @DEP_DATE  ' 
	END 
	ELSE  -- 출발일 없으면 
	BEGIN
		SET @WHERE  = @WHERE + ' AND A.DEP_DATE > DATEADD(D,-1,GETDATE()) '  -- 오늘이후출발일
	END 
	IF ISNULL(@MASTER_CODE,'') <> ''
	BEGIN
		SET @WHERE  = @WHERE + ' AND C.MASTER_CODE = @MASTER_CODE  ' 
	END 

	----마스터 코드 없고 , 출발일검색 없으면 오늘이후  출발일 
	--IF ISNULL(@DEP_DATE,'') = '' AND ISNULL(@MASTER_CODE,'') = '' 
	--BEGIN
	--	SET @WHERE  = @WHERE + ' AND A.DEP_DATE > DATEADD(D,-1,GETDATE()) '  -- 오늘이후출발일
	--END 


	IF ISNULL(@NEW_CODE,'') <> ''
	BEGIN
		SET @WHERE  = @WHERE + ' AND A.NEW_CODE = @NEW_CODE  ' 
	END 
	IF ISNULL(@TEAM_CODE,'') <> ''
	BEGIN
		SET @WHERE  = @WHERE + ' AND A.NEW_TEAM_CODE = @TEAM_CODE' 
	END 

	IF ISNULL(@PASS_YN,'') <> ''
	BEGIN
		IF @PASS_YN ='Y'
		BEGIN
			SET @WHERE  = @WHERE + ' AND B.SEC_PASS_NUM  IS NOT NULL ' 	
		END 
		ELSE 
		BEGIN
			SET @WHERE  = @WHERE + ' AND B.SEC_PASS_NUM  IS NULL ' 	
		END 
		
	END 

	 
----기존쿼리 
--SELECT A.CUS_NO,  A.CUS_ID, A.CUS_NAME ,A.SOC_NUM1, A.SOC_NUM2
--	, A.LAST_NAME, A.FIRST_NAME, A.EMAIL
--	, A.NOR_TEL1, A.NOR_TEL2, A.NOR_TEL3
--	, damo.dbo.dec_varchar('DIABLO', 'dbo.RES_CUSTOMER', 'PASS_NUM', B.SEC_PASS_NUM) AS PASS_NUM 
--	, A.PASS_ISSUE, A.PASS_EXPIRE, A.PASS_DATE
--	, A.PASS_EMP_CODE
--	, dbo.FN_CUS_GET_EMP_NAME(A.PASS_EMP_CODE) AS [PASS_EMP_NAME]
--	, C.DEP_DATE 
--	, C.PRO_CODE
--	, B.RES_CODE , B.SEQ_NO 
--	, C.PRO_NAME , A.IPIN_DUP_INFO ,B.SOC_NUM1 AS RES_SOC_NUM1 , damo.dbo.dec_varchar('DIABLO', 'dbo.RES_CUSTOMER', 'SOC_NUM2', B.SEC_SOC_NUM2) AS RES_SOC_NUM2 
--	, B.BIRTH_DATE, B.GENDER
--	, B.IPIN_DUP_INFO AS [RES_IPIN_DUP_INFO]
--FROM CUS_CUSTOMER A WITH(NOLOCK)
--INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.CUS_NO = B.CUS_NO
--INNER JOIN RES_MASTER_damo C WITH(NOLOCK) ON  B.RES_CODE = C.RES_CODE 
--INNER JOIN PKG_DETAIL D WITH(NOLOCK) ON C.PRO_CODE = D.PRO_CODE
--WHERE C.RES_STATE NOT IN (7,8,9) --유효예약
----AND B.RES_STATE = 0  --유효예약자 
----#조건
-- --AND A.CUS_NAME = @CUS_NAME 
-- AND C.DEP_DATE > DATEADD(D,-1,GETDATE())  
-- AND C.NEW_TEAM_CODE = 511

 -- 신규 
 -- 기본 고객매핑 안되거나 OR  출발자에 정보가 있는경우에는 출발자꺼 사용 
 -- 고객매핑되거나 출발자에 정보가 없는경우는 고객정보 사용 

 	 SET @SQLSTRING = N'
 SELECT B.CUS_NO
,D.CUS_ID
,CASE WHEN B.CUS_NO = 1 THEN B.CUS_NAME ELSE D.CUS_NAME END AS CUS_NAME 
,D.SOC_NUM1, damo.dbo.dec_varchar(''DIABLO'', ''dbo.CUS_CUSTOMER'', ''SOC_NUM2'', D.SEC_SOC_NUM2) AS SOC_NUM2
,B.LAST_NAME
,B.FIRST_NAME
,CASE WHEN B.CUS_NO = 1 OR ISNULL(B.EMAIL,''@'') <> ''@'' THEN B.EMAIL ELSE D.EMAIL END AS EMAIL  
,CASE WHEN B.CUS_NO = 1 OR ISNULL(B.NOR_TEL1,'''') <> '''' THEN B.NOR_TEL1 ELSE D.NOR_TEL1 END AS NOR_TEL1 
,CASE WHEN B.CUS_NO = 1 OR ISNULL(B.NOR_TEL2,'''') <> '''' THEN B.NOR_TEL2 ELSE D.NOR_TEL2 END AS NOR_TEL2
,CASE WHEN B.CUS_NO = 1 OR ISNULL(B.NOR_TEL3,'''') <> '''' THEN B.NOR_TEL3 ELSE D.NOR_TEL3 END AS NOR_TEL3 
,CASE WHEN B.CUS_NO = 1 OR B.SEC_PASS_NUM IS NOT NULL THEN damo.dbo.dec_varchar(''DIABLO'', ''dbo.RES_CUSTOMER'', ''PASS_NUM'', B.SEC_PASS_NUM) 
 ELSE damo.dbo.dec_varchar(''DIABLO'', ''dbo.CUS_CUSTOMER'', ''PASS_NUM'', D.SEC_PASS_NUM)  END AS PASS_NUM 
,CASE WHEN B.CUS_NO = 1 OR B.PASS_ISSUE IS NOT NULL THEN B.PASS_ISSUE ELSE D.PASS_ISSUE END AS PASS_ISSUE
,CASE WHEN B.CUS_NO = 1 OR B.PASS_EXPIRE IS NOT NULL THEN B.PASS_EXPIRE ELSE D.PASS_EXPIRE END AS PASS_EXPIRE 
,D.PASS_DATE  -- 고객정보 
,D.PASS_EMP_CODE -- 고객정보 
,dbo.FN_CUS_GET_EMP_NAME(D.PASS_EMP_CODE) AS [PASS_EMP_NAME] -- 고객정보 
,C.DEP_DATE 
,C.PRO_CODE
,A.RES_CODE , B.SEQ_NO 
,C.PRO_NAME , D.IPIN_DUP_INFO , B.SOC_NUM1 AS RES_SOC_NUM1 , damo.dbo.dec_varchar(''DIABLO'', ''dbo.RES_CUSTOMER'', ''SOC_NUM2'', B.SEC_SOC_NUM2) AS RES_SOC_NUM2 

,CASE WHEN B.CUS_NO = 1 OR B.BIRTH_DATE IS NOT NULL THEN B.BIRTH_DATE ELSE D.BIRTH_DATE END AS BIRTH_DATE
,CASE WHEN B.CUS_NO = 1 OR B.GENDER IS NOT NULL THEN B.GENDER ELSE D.GENDER END AS GENDER
	 
FROM RES_MASTER_damo A WITH(NOLOCK)
INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
INNER JOIN PKG_DETAIL C WITH(NOLOCK) ON A.PRO_CODE = C.PRO_CODE

LEFT JOIN CUS_CUSTOMER_DAMO D WITH(NOLOCK) ON  B.CUS_NO = D.CUS_NO  AND B.CUS_NO > 1 

WHERE A.RES_STATE NOT IN (7,8,9) --유효예약
AND B.RES_STATE = 0  --유효예약자 
' + @WHERE + N'
ORDER BY A.DEP_DATE , B.RES_CODE , B.SEQ_NO ' 


SET @PARMDEFINITION = N'
@CUS_NAME varchar(50),
@BIRTH_DATE DATETIME,
@PASS_NUM varchar(12),
@MASTER_CODE varchar(10),
@DEP_DATE DATETIME,
@TEAM_CODE varchar(3),
@NEW_CODE varchar(7) '


--PRINT @SQLSTRING 
EXEC SP_EXECUTESQL @SQLSTRING , @PARMDEFINITION , @CUS_NAME,
	@BIRTH_DATE ,
	@PASS_NUM ,
	@MASTER_CODE ,
	@DEP_DATE ,
	@TEAM_CODE,
	@NEW_CODE 

END 

GO
