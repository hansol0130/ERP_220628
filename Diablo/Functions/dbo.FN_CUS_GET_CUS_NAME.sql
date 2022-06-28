USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_CUS_GET_CUS_NAME
■ Description				: CUS_NO를 입력 받아 고객명을 가져온다.   
■ Input Parameter			:                  
		@CUS_NO				: 고객 고유번호
■ Select					: 
■ Author					: 김현진  
■ Date						: 2009-03-13  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2009-03-13       김현진			최초생성  
-------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[FN_CUS_GET_CUS_NAME]
(
	@CUS_NO				INT
)

RETURNS VARCHAR(20)

AS

	BEGIN
		DECLARE @CUS_NAME VARCHAR(20)

		SELECT @CUS_NAME = CUS_NAME FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) WHERE CUS_NO = @CUS_NO

		RETURN (@CUS_NAME)
	END
GO
