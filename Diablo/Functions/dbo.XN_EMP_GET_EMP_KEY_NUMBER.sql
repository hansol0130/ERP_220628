USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name			: XN_EMP_GET_EMP_KEY_NUMBER
■ Description				: 사원코드로 대표번호 조회 
■ Input Parameter			:                  
		@EMP_CODE			: 로그인아이디
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: SELECT DBO.XN_EMP_GET_EMP_KEY_NUMBER('2013007')
							  SELECT DBO.XN_EMP_GET_EMP_KEY_NUMBER('A130001')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2019-11-18		박형만			최초생성
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_EMP_GET_EMP_KEY_NUMBER]
(
	@EMP_CODE CHAR(7)
)
RETURNS VARCHAR(15)
AS
BEGIN
	
	DECLARE @KEY_NUMBER VARCHAR(15)
	SELECT  
		-- 대표번호가 있는경우 
		@KEY_NUMBER = 
		CASE WHEN A.IN_USE_YN = 'N' AND ISNULL(A.MAIN_NUMBER2,'') <> '' AND  ISNULL(A.MAIN_NUMBER3,'') <> '' THEN 
				ISNULL(A.MAIN_NUMBER1,'') +'-'+ ISNULL(A.MAIN_NUMBER2,'') + '-' +  ISNULL(A.MAIN_NUMBER3,'') -- (N:대표번호사용) 이고 사용이고 대표번호가 있는경우   
			WHEN A.IN_USE_YN = 'Y' AND  ISNULL(A.INNER_NUMBER2,'') <> '' AND  ISNULL(A.INNER_NUMBER3,'') <> '' THEN 
				ISNULL(A.INNER_NUMBER1,'') +'-'+ ISNULL(A.INNER_NUMBER2,'') + '-' +  ISNULL(A.INNER_NUMBER3,'') -- (Y:직통번호사용) 이고 사용이고 내선번호가 있는경우    
			WHEN ISNULL(B.KEY_NUMBER,'') <> '' THEN B.KEY_NUMBER  -- 팀번호가 있으면 팀번호 사용 
				ELSE ISNULL(A.INNER_NUMBER1,'') +'-'+ ISNULL(A.INNER_NUMBER2,'') + '-' +  ISNULL(A.INNER_NUMBER3,'')  END  -- 팀번호도 없으면 개인 내선 번호 사용 
	FROM EMP_MASTER_damo A WITH(NOLOCK) 
		INNER JOIN EMP_TEAM B WITH(NOLOCK) 
			ON A.TEAM_CODE = B.TEAM_CODE 
	WHERE A.EMP_CODE = @EMP_CODE

	IF ISNULL(@KEY_NUMBER,'') =  ''   -- 내선번호도 없으면 대표번호 사용 
	BEGIN
		SET @KEY_NUMBER = '02-2188-4000'
	END 
	ELSE IF SUBSTRING(@KEY_NUMBER,1,1) = '-'  -- - 로 시작하는것 빼기 
	BEGIN
		SET @KEY_NUMBER = SUBSTRING(@KEY_NUMBER,2,LEN(@KEY_NUMBER) -1 ) 
	END 
	 

	RETURN (@KEY_NUMBER)
END
GO
