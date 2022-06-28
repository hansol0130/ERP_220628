USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_COM_GET_COM_TYPE_NAME
■ Description				: 회사 타입 명을 리턴한다 (99: 본사, 50: 대리점, 30: 인솔자, 12: 랜드사)
■ Input Parameter			:                  
		@COM_TYPE			: 회사타입
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.XN_COM_GET_COM_TYPE_NAME(99)
	SELECT DBO.XN_COM_GET_COM_TYPE_NAME(50)
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-26		김성호			최초생성
	2014-03-14		이동호			랜드사 지점구분(@COM_TYPE_NAME) 추가
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_COM_GET_COM_TYPE_NAME]
(
	@COM_TYPE INT
)
RETURNS VARCHAR(20)
AS
BEGIN

	DECLARE @COM_TYPE_NAME VARCHAR(20)

	IF @COM_TYPE = 99
		SET @COM_TYPE_NAME = '본사'
	ELSE IF @COM_TYPE = 50
		SET @COM_TYPE_NAME = '대리점'
	ELSE IF @COM_TYPE = 30
		SET @COM_TYPE_NAME = '인솔자'
	ELSE IF @COM_TYPE = 12
		SET @COM_TYPE_NAME = '랜드사'
	
	ELSE IF @COM_TYPE = 121
		SET @COM_TYPE_NAME = '랜드사전체'
	ELSE IF @COM_TYPE = 122
		SET @COM_TYPE_NAME = '랜드사본사'
	ELSE IF @COM_TYPE = 123
		SET @COM_TYPE_NAME = '랜드사부산'

	RETURN @COM_TYPE_NAME
END

GO
