USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_COM_GET_COM_TYPE
■ Description				: 회사 타입을 리턴한다 (99: 본사, 50: 대리점, 30: 인솔자, 12: 랜드사)
■ Input Parameter			:                  
		@EMP_CODE			: 사원코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.XN_COM_GET_COM_TYPE('2008011')
	SELECT DBO.XN_COM_GET_COM_TYPE('A130001')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-22		김성호			최초생성
	2013-02-25		김성호			COM_TYPE 코드 수정
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_COM_GET_COM_TYPE]
(
	@EMP_CODE CHAR(7)
)
RETURNS INT
AS
BEGIN
	DECLARE @COM_TYPE INT
	
	IF ISNUMERIC(@EMP_CODE) = 1
		SET @COM_TYPE = 99
	ELSE IF LEFT(@EMP_CODE,1) = 'A'
		SET @COM_TYPE = 50
	ELSE IF LEFT(@EMP_CODE,1) = 'T'
		SET @COM_TYPE = 30
	ELSE IF LEFT(@EMP_CODE,1) = 'L'
		SET @COM_TYPE = 12

	RETURN @COM_TYPE
END

GO
