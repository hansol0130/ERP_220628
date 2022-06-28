USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_LOGDATA_SEARCH_SELECT
■ DESCRIPTION				: BTMS 거래처 직원 검색
■ INPUT PARAMETER			: 
	@EMP_ID					: 아이디
	@KOR_NAME				: 이름
	@BIRTH_DATE				: 생년월일
	@HP_NUMBER				: 핸드폰번호
	@EMAIL					: 이메일
■ OUTPUT PARAMETER			: 
■ EXEC						: 
- 예제
 EXEC XP_COM_LOGDATA_SEARCH_SELECT @AGENT_CODE = '92756'
	,@EMP_ID = '1000003'
	,@KOR_NAME = '이유라' 
	,@BIRTH_DATE ='' 
	,@EMAIL = 'test@test.com'
	,@HP_NUMBER = ''
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-30		이유라			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_LOGDATA_SEARCH_SELECT]
	@AGENT_CODE			VARCHAR(10),
	@EMP_ID				VARCHAR(20),
	@KOR_NAME			VARCHAR(20),
	@BIRTH_DATE			VARCHAR(20),
	@HP_NUMBER  		VARCHAR(20),
	@EMAIL  		VARCHAR(100)
AS 
BEGIN

	DECLARE @STR_WHERE VARCHAR(1000)
	SET @STR_WHERE = '' 

	DECLARE @SQLSTRING NVARCHAR(4000)
	DECLARE @PARMDEFINITION NVARCHAR(1000)

	IF(ISNULL(@AGENT_CODE,'') <>'')
	BEGIN
		SET @STR_WHERE = @STR_WHERE +' 
		AND AGT_CODE = @AGENT_CODE '
	END 
	IF(ISNULL(@EMP_ID,'') <>'')
	BEGIN
		SET @STR_WHERE = @STR_WHERE +' 
		AND EMP_ID = @EMP_ID '
	END 
	IF(ISNULL(@KOR_NAME,'') <>'')
	BEGIN
		SET @STR_WHERE = @STR_WHERE +' 
		AND KOR_NAME = @KOR_NAME '
	END 
	IF(ISNULL(@BIRTH_DATE,'') <>'') 
	BEGIN
		SET @STR_WHERE = @STR_WHERE +' 
		AND BIRTH_DATE = @BIRTH_DATE '
	END
	IF(ISNULL(@HP_NUMBER,'') <>'') 
	BEGIN
		SET @STR_WHERE = @STR_WHERE +' 
		AND HP_NUMBER = @HP_NUMBER '
	END 
	IF(ISNULL(@EMAIL,'') <>'') 
	BEGIN
		--예외. daum.net hanmail.net 같은 메일로 인식하도록
		IF( CHARINDEX('@daum.net',@EMAIL) > 0 OR  CHARINDEX('@hanmail.net',@EMAIL) > 0 )
		BEGIN
			DECLARE @EMAIL_ID VARCHAR(50)
			SET @EMAIL_ID = SUBSTRING(@EMAIL , 0 , CHARINDEX('@',@EMAIL) )
			
			SET @STR_WHERE = @STR_WHERE +' 
			AND EMAIL IN ('''+@EMAIL_ID  +'@daum.net'','''+@EMAIL_ID  +'@hanmail.net'') '
		END 
		ELSE 
		BEGIN
			SET @STR_WHERE = @STR_WHERE +' 
			AND EMAIL = @EMAIL '
		END  
	END 

	SET @SQLSTRING = N'
	SELECT * FROM COM_EMPLOYEE WITH(NOLOCK) 
	WHERE WORK_TYPE = ''1'' AND EMP_ID IS NOT NULL AND EMP_ID <> '''' ' 
	+ @STR_WHERE 

	SET @PARMDEFINITION = N'@AGENT_CODE VARCHAR(10)
	,@EMP_ID VARCHAR(20)
	,@KOR_NAME VARCHAR(20)
	,@BIRTH_DATE VARCHAR(20) 
	,@HP_NUMBER VARCHAR(20)
	,@EMAIL  VARCHAR(100)'

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @AGENT_CODE
	,@EMP_ID 
	,@KOR_NAME 
	,@BIRTH_DATE  
	,@HP_NUMBER 
	,@EMAIL   

	PRINT @SQLSTRING
END 

GO
