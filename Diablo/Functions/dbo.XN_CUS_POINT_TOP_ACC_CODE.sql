USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_CUS_POINT_TOP_ACC_CODE
■ Description				: 양도된 POINT_NO의 최상위 ACC_TYPE를 검색한다.
■ Input Parameter			:                  
	@POINT_NO				: 포인트 넘버
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.XN_COM_GET_TOP_MENU_CODE('VGT', '10101', 'Y')
	SELECT DBO.XN_COM_GET_TOP_MENU_CODE('VGT', '101010101', 'N')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-07-23		김성호			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_CUS_POINT_TOP_ACC_CODE]
(
	@POINT_NO	INT
)
RETURNS INT
AS
BEGIN

	DECLARE @ACC_TYPE INT

	IF EXISTS(SELECT 1 FROM CUS_POINT A WITH(NOLOCK) WHERE POINT_NO = @POINT_NO AND A.ACC_USE_TYPE = 6)
	BEGIN
		SELECT @ACC_TYPE = DBO.XN_CUS_POINT_TOP_ACC_CODE(ORG_POINT_NO) FROM CUS_POINT A WITH(NOLOCK) WHERE POINT_NO = @POINT_NO
	END
	ELSE
	BEGIN
		SELECT @ACC_TYPE = ACC_USE_TYPE FROM CUS_POINT A WITH(NOLOCK) WHERE POINT_NO = @POINT_NO
	END

	RETURN @ACC_TYPE

END
GO
