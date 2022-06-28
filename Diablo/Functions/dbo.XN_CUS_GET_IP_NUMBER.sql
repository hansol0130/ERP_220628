USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_CUS_GET_IP_NUMBER
■ Description				: 사원이나 기기에 할당된 아이피 번호를 검색
■ Input Parameter			:                  
	@IP_TYPE				: 1:PC, 2:전화
	@CONNECT_CODE			: 관리코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.XN_CUS_GET_IP_NUMBER(1, '2008011')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2014-04-11		김성호			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_CUS_GET_IP_NUMBER]
(
	@IP_TYPE		INT,	-- 1:PC, 2:전화
	@CONNECT_CODE	VARCHAR(10)
)
RETURNS VARCHAR(15)
AS
BEGIN

	DECLARE @IP_NUMBER VARCHAR(15)

	SELECT @IP_NUMBER = A.IP_NUMBER FROM IP_MASTER A WITH(NOLOCK) WHERE A.IP_TYPE = @IP_TYPE AND A.CONNECT_CODE = @CONNECT_CODE

	RETURN (@IP_NUMBER)
END
GO
