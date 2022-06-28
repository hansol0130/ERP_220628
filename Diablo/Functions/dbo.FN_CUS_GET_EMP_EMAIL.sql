USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_CUS_GET_EMP_EMAIL
■ Description				: 직원 email 검색
■ Input Parameter			: 
		@EMP_CODE			: 사번
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.FN_CUS_GET_EMP_EMAIL('2008011')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2009-04-04		김성호			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_CUS_GET_EMP_EMAIL]
(
	@EMP_CODE CHAR(7)
)
RETURNS VARCHAR(30)
AS
BEGIN

	DECLARE @EMP_EMAIL VARCHAR(30)

	SELECT @EMP_EMAIL = EMAIL FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = @EMP_CODE

	RETURN (@EMP_EMAIL)
END
GO
