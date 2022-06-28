USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_COM_GET_COM_NAME
■ Description				: 회사 타입명을 리턴한다 (99: 본사, 50: 대리점, 30: 인솔자, 12: 랜드사)
■ Input Parameter			:                  
		@EMP_CODE			: 사원코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.XN_COM_GET_COM_NAME('2008011')
	SELECT DBO.XN_COM_GET_COM_NAME('A130001')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-26		김성호			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_COM_GET_COM_NAME]
(
	@EMP_CODE CHAR(7)
)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @COM_NAME VARCHAR(10)
	
	IF ISNUMERIC(@EMP_CODE) = 1
		SET @COM_NAME = '본사'
	ELSE IF LEFT(@EMP_CODE,1) = 'A'
		SET @COM_NAME = '대리점'
	ELSE IF LEFT(@EMP_CODE,1) = 'T'
		SET @COM_NAME = '인솔자'
	ELSE IF LEFT(@EMP_CODE,1) = 'L'
		SET @COM_NAME = '랜드사'

	RETURN @COM_NAME
END

GO
