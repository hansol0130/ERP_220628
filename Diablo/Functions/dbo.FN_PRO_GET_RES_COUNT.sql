USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_PRO_GET_RES_COUNT
■ Description				: 
■ Input Parameter			: 
		@PRO_CODE			: 행사코드                 
■ Select					: 
■ Author					: 
■ Date						:   
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
									최초생성
2019-01-07			김성호			출발자 상태값 예약만 살리고 삭제 (3: 거의 사용안함, 4: 조건에 없음)
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_PRO_GET_RES_COUNT]
(
	@PRO_CODE VARCHAR(20)
)

RETURNS INT

AS

BEGIN

	DECLARE @COUNT INT

	SET @COUNT = ISNULL((
		SELECT COUNT(*) RES_COUNT
		FROM RES_MASTER_damo A WITH(NOLOCK)
		INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		WHERE A.PRO_CODE = @PRO_CODE AND A.RES_STATE <= 7 AND B.RES_STATE = 0
	), 0)

	--SELECT @COUNT = COUNT(*) FROM RES_CUSTOMER_DAMO WITH(NOLOCK)
	--WHERE RES_CODE IN (SELECT RES_CODE FROM RES_MASTER_DAMO  WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE AND RES_STATE <= 7) AND RES_STATE IN (0, 3)

	RETURN (@COUNT)

END
GO
