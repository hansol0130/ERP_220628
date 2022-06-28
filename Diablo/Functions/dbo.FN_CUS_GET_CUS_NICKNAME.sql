USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_CUS_GET_CUS_NICKNAME
■ Description				: CUS_NO를 입력 받아 고객 별명을 가져온다.   
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
   2010-12-08		김성호			회원테이블 분리로 인한 수정
-------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[FN_CUS_GET_CUS_NICKNAME]
(
	@CUS_NO VARCHAR(20)
)

RETURNS VARCHAR(20)

AS

	BEGIN
		DECLARE @CUS_NICKNAME VARCHAR(20)

		SELECT @CUS_NICKNAME = NICKNAME FROM CUS_MEMBER WITH(NOLOCK)  WHERE CUS_NO = @CUS_NO

		RETURN (@CUS_NICKNAME)
	END
GO
