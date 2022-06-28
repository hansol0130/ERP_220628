USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name			: FN_PRO_GET_POINT_PRICE
■ Description				: 
■ Input Parameter			: 
		@PRO_CODE			: 행사코드별 고객 적립 예상 포인트 
■ Select					: 
■ Author					: 
■ Date						:   
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
		???			???				최초생성		
	2015-09-16		박형만			예약의 포인트가 아닌 예약고객의 적립 예상 포인트 로 변경 
-------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[FN_PRO_GET_POINT_PRICE]
(
	@PRO_CODE VARCHAR(20)
)

RETURNS INT

AS

	BEGIN
		DECLARE @POINT_PRICE INT

		SELECT @POINT_PRICE = ISNULL(SUM (CASE ISNULL(A.POINT_YN, '0') WHEN '0' THEN 0 ELSE A.POINT_PRICE END), 0) -- AS TOTAL_POINT
		FROM DBO.RES_CUSTOMER_damo A WITH(NOLOCK)
			INNER JOIN DBO.CUS_CUSTOMER_damo C WITH(NOLOCK) ON A.CUS_NO = C.CUS_NO
		WHERE A.RES_STATE = 0
		AND A.AGE_TYPE <> 2
		AND ISNULL(A.POINT_YN, 'Y') = 'Y'
		AND ISNULL(C.POINT_CONSENT, 'N') = 'Y'
		AND A.RES_CODE IN (SELECT RES_CODE
							FROM DBO.RES_MASTER_damo WITH(NOLOCK)
							WHERE PRO_CODE =@PRO_CODE)

		--기존
		--SELECT @POINT_PRICE = SUM(CASE POINT_YN WHEN 'Y' THEN POINT_PRICE END)
		--FROM RES_CUSTOMER_DAMO WITH(NOLOCK) 
		--WHERE RES_CODE IN (SELECT RES_CODE FROM RES_MASTER_DAMO WITH(NOLOCK)  WHERE PRO_CODE = @PRO_CODE) AND RES_STATE = 0
		
		RETURN (@POINT_PRICE)
	END
GO
