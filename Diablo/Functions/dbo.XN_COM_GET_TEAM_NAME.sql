USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_COM_GET_TEAM_NAME
■ Description				: 사원코드로 팀명 OR 대리점팀명 가져오기
■ Input Parameter			:                  
		@AGT_ID				: 로그인아이디
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: SELECT DBO.XN_COM_GET_TEAM_NAME('9999999')
							  SELECT DBO.XN_COM_GET_TEAM_NAME('A130001')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-18		박형만			최초생성
	2013-02-22		김성호			외주직원일 경우 외주사 명을 리턴
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_COM_GET_TEAM_NAME]
(
	@EMP_CODE CHAR(7)
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @TEAM_NAME VARCHAR(50), @COM_TYPE INT

	SELECT @COM_TYPE = DBO.XN_COM_GET_COM_TYPE(@EMP_CODE)

	IF DBO.XN_COM_GET_VGL_YN(@EMP_CODE) = 'Y' --@COM_TYPE = 99
		SELECT @TEAM_NAME = TEAM_NAME FROM EMP_TEAM WITH(NOLOCK)
		WHERE TEAM_CODE IN (SELECT TEAM_CODE FROM EMP_MASTER WHERE EMP_CODE = @EMP_CODE)
	ELSE
		SELECT @TEAM_NAME = KOR_NAME FROM AGT_MASTER WITH(NOLOCK)
		WHERE AGT_CODE IN (SELECT AGT_CODE FROM AGT_MEMBER WHERE MEM_CODE = @EMP_CODE)

	RETURN (@TEAM_NAME)
END
GO
