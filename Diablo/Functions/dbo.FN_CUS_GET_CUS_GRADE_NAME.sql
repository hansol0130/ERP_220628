USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_CUS_GET_CUS_GRADE_NAME
■ Description				: 고객 등급 조회
■ Input Parameter			: 
	@CUS_NO			     	: 고객번호
	@VIP_YEAR				: 기준일자       
■ Exec						: 

	SELECT dbo.FN_CUS_GET_CUS_GRADE_NAME(1313806, '2018')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2020-10-30		오준혁			고객 등급 조회
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_CUS_GET_CUS_GRADE_NAME]
(
	 @CUS_NO       INT
	,@VIP_YEAR     VARCHAR(4)
)
RETURNS VARCHAR(20)
AS
BEGIN
	
	DECLARE @CUS_GRADE_NAME VARCHAR(20) = ''
	

    SELECT @CUS_GRADE_NAME = CUS_GRADE_NAME
    FROM   CUS_VIP_HISTORY
    WHERE  CUS_NO = @CUS_NO
           AND VIP_YEAR = @VIP_YEAR
	
	
	RETURN ISNULL(@CUS_GRADE_NAME,'')
	
END

GO
