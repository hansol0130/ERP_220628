USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Server					: 
■ Database					: DIABLO
■ Function_Name				: XN_COM_GET_TEAM_NAME
■ Description				: 사원코드로 팀코드 OR 대리점코드 가져오기
■ Input Parameter			:                  
		@AGT_ID				: 로그인아이디
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: SELECT DBO.XN_COM_GET_TEAM_CODE('9999999')
							  SELECT DBO.XN_COM_GET_TEAM_CODE('A130001')
■ Author					: 박형만  
■ Date						: 2013-02-18
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-18		박형만			최초생성
	2013-02-22		김성호			XN_COM_GET_COM_TYPE 사용으로 수정
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_COM_GET_TEAM_CODE]
(
	@EMP_CODE CHAR(7)
)
RETURNS CHAR(3)
AS
BEGIN
	DECLARE @TEAM_CODE CHAR(3), @COM_TYPE INT

	SELECT @COM_TYPE = DBO.XN_COM_GET_COM_TYPE(@EMP_CODE)

	IF DBO.XN_COM_GET_VGL_YN(@EMP_CODE) = 'Y'
		SELECT @TEAM_CODE = TEAM_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE EMP_CODE = @EMP_CODE
	ELSE
		SELECT  @TEAM_CODE = '999' -- 가상의 팀 대리점팀

	RETURN (@TEAM_CODE)
END
GO
