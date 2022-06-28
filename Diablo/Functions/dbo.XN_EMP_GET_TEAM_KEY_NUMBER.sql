USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Function_Name			: XN_EMP_GET_TEAM_KEY_NUMBER
■ Description				: 사원코드로 팀 대표번호 조회 
■ Input Parameter			:                  
		@EMP_CODE			: 로그인아이디
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: SELECT DBO.XN_EMP_GET_TEAM_KEY_NUMBER('2013007')
							  SELECT DBO.XN_EMP_GET_TEAM_KEY_NUMBER('A130001')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2019-12-12		박형만			최초생성
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_EMP_GET_TEAM_KEY_NUMBER]
(
	@EMP_CODE CHAR(7)
)
RETURNS VARCHAR(15)
AS
BEGIN
	
	DECLARE @KEY_NUMBER VARCHAR(15)
	DECLARE @INNER_NUMBER VARCHAR(15)
	SELECT  
		-- 대표번호가 있는경우 
		@KEY_NUMBER = B.KEY_NUMBER ,
		@INNER_NUMBER = A.INNER_NUMBER1 +'-'+A.INNER_NUMBER2 +'-'+A.INNER_NUMBER3 
	FROM EMP_MASTER_damo A WITH(NOLOCK) 
		INNER JOIN EMP_TEAM B  WITH(NOLOCK) 
			ON A.TEAM_CODE = B.TEAM_CODE 
	WHERE A.EMP_CODE = @EMP_CODE

	IF ISNULL(@KEY_NUMBER,'') =  ''   -- 팀대표 번호 없으면 개별 번호 사용 
	BEGIN
		IF ISNULL(@INNER_NUMBER,'') <> ''
		BEGIN
			SET @KEY_NUMBER = @INNER_NUMBER
		END 
		ELSE 
		BEGIN
			SET @KEY_NUMBER = '02-2188-4000'
		END  
		
	END 
	
	IF SUBSTRING(@KEY_NUMBER,1,1) = '-'  -- - 로 시작하는것 빼기 
	BEGIN
		SET @KEY_NUMBER = SUBSTRING(@KEY_NUMBER,2,LEN(@KEY_NUMBER) -1 ) 
	END 
	 

	RETURN (@KEY_NUMBER)
END
GO
