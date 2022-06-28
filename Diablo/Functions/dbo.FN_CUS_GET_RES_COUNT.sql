USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_CUS_GET_RES_COUNT
■ Description				: 고객의 주민번호로 몇번 여행을 갔다왔는지를 카운팅하는 함수, 아직 출발하지 않은 예약은 카운트를 하지 않는다.
■ Input Parameter			: 
	@SOC_NUM1				: 주민번호 앞자리 
	@SOC_NUM2				: 주민번호 뒷자리 
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	select dbo.FN_CUS_GET_RES_COUNT('', '')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2010-10-01		이규식			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_CUS_GET_RES_COUNT]
(
	@SOC_NUM1 CHAR(6),
	@SOC_NUM2 CHAR(7)
)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @RES_COUNT INT

	SELECT @RES_COUNT = COUNT(*) FROM RES_CUSTOMER_DAMO A WITH(NOLOCK) 
	INNER JOIN RES_MASTER B WITH(NOLOCK) ON B.RES_CODE = A.RES_CODE
	WHERE 
	A.SOC_NUM1 = @SOC_NUM1
	AND
	A.SEC1_SOC_NUM2 = DAMO.DBO.PRED_META_PLAIN_V(@SOC_NUM2, 'DIABLO', 'DBO.RES_CUSTOMER_DAMO', 'SOC_NUM2')
	AND
	A.RES_STATE = 0
	AND 
	B.RES_STATE <= 7
	AND
	B.DEP_DATE < GETDATE()
	
	-- Return the result of the function
	RETURN @RES_COUNT

END
GO
