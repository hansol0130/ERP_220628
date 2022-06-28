USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_SET_GET_PRO_COUNT
■ Description				: 정산 예약자수는 페널티까지 포함한다.
■ Input Parameter			: 
	@PRO_CODE				: 행사코드                 
■ Select					: 
■ Author					: 
■ Date						: 

	SELECT DBO.FN_SET_GET_PRO_COUNT('APP583-181223Z2')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
									최초생성
2019-01-07			김성호			출발자 상태값 예약, 환불 적용 (0: 예약, 4: 환불)
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_SET_GET_PRO_COUNT]
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
		WHERE A.PRO_CODE = @PRO_CODE AND A.RES_STATE <= 7 AND B.RES_STATE IN (0, 3, 4)
	), 0)

	-- 예약 = 0, 취소 = 1, 이동 = 2, 환불 = 3, 페널티 = 4
	--SELECT @COUNT = COUNT(*) FROM RES_CUSTOMER_damo WITH(NOLOCK)
	--WHERE RES_CODE IN (SELECT RES_CODE FROM RES_MASTER_damo  WITH(NOLOCK) 
	--WHERE PRO_CODE = @PRO_CODE AND RES_STATE <= 7) AND RES_STATE IN (0, 3, 4)

	RETURN (@COUNT)
END





GO
