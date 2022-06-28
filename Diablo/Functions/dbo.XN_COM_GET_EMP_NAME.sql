USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_COM_GET_EMP_NAME
■ Description				: 사원코드로 사원명 OR 대리점사원명 가져오기
■ Input Parameter			:                  
		@EMP_CODE			: 로그인아이디
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: SELECT DBO.XN_COM_GET_EMP_NAME('9999999')
							  SELECT DBO.XN_COM_GET_EMP_NAME('A130001')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-18		박형만			최초생성
	2013-02-22		김성호			XN_COM_GET_COM_TYPE 사용으로 수정
	2015-10-26		김성호			EMP_MASTER 테이블명 변경 (EMP_MASTER_damo)
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_COM_GET_EMP_NAME]
(
	@EMP_CODE CHAR(7)
)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @EMP_NAME VARCHAR(20), @COM_TYPE INT

	SELECT @COM_TYPE = DBO.XN_COM_GET_COM_TYPE(@EMP_CODE)

	IF DBO.XN_COM_GET_VGL_YN(@EMP_CODE) = 'Y'
		SELECT @EMP_NAME = KOR_NAME FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = @EMP_CODE
	ELSE
		SELECT @EMP_NAME = KOR_NAME FROM AGT_MEMBER WITH(NOLOCK) WHERE MEM_CODE = @EMP_CODE

	RETURN (@EMP_NAME)
END

GO
