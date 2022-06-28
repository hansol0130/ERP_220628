USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_CUS_GET_CUS_GRADE_CODE
■ Description				: 고객 등급 조회
■ Input Parameter			: 
	@CUS_NO			     	: 고객번호
	@VIP_YEAR				: 기준일자       
■ Exec						: 

	SELECT dbo.FN_CUS_GET_CUS_GRADE_CODE(1313806, '2018')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2022-03-17		오준혁			고객 등급 코드 조회
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_CUS_GET_CUS_GRADE_CODE]
(
	 @CUS_NO       INT
	,@VIP_YEAR     VARCHAR(4)
)
RETURNS INT
AS
BEGIN
	
	DECLARE @CUS_GRADE_CODE INT = 0
	

    SELECT @CUS_GRADE_CODE = CUS_GRADE
    FROM   CUS_VIP_HISTORY
    WHERE  CUS_NO = @CUS_NO
           AND VIP_YEAR = @VIP_YEAR
	
	
	RETURN ISNULL(@CUS_GRADE_CODE,0)
	
END

GO
