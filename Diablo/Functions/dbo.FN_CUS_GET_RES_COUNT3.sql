USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_CUS_GET_RES_COUNT3
■ Description				: 고객번호 기준 여행 횟수 조회, 아직 출발하지 않은 예약은 카운트를 하지 않는다.
■ Input Parameter			: 
	@CUS_NO					: 고객번호 
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	select dbo.FN_CUS_GET_RES_COUNT3 (1)
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2020-12-11		김성호			최초생성
	2022-04-18		오준혁			쿼리 성능 튜닝(조건 중 A.RES_STATE 먼저 진행되는 것을 방지) 
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_CUS_GET_RES_COUNT3]
(
	@CUS_NO INT
)
RETURNS INT
AS
BEGIN
	
	DECLARE @RES_COUNT INT

	SELECT @RES_COUNT = COUNT(*)
	FROM   RES_CUSTOMER_DAMO A WITH(NOLOCK ,INDEX(IDX_RES_CUSTOMER))
	       INNER JOIN RES_MASTER_damo B WITH(NOLOCK)
	            ON  B.RES_CODE = A.RES_CODE
	WHERE  A.CUS_NO = @CUS_NO
	       AND @CUS_NO > 1
	       AND A.RES_STATE = 0
	       AND B.RES_STATE <= 7
	       AND B.DEP_DATE < GETDATE()
	
	RETURN @RES_COUNT

END
GO
