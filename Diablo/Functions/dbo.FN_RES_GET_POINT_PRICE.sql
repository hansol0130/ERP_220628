USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_RES_GET_POINT_PRICE
■ Description				: 예약별 포인트 합계 함수
■ Input Parameter			:                  
		@PRO_CODE			: 예약코드   
■ Select					: SELECT * FROM dbo.FN_RES_GET_POINT_PRICE()
■ Author					:   
■ Date						: 
■ Memo						: RES_STATE - 0:예약, 3:환불, 4:페널티
							  AGE_TYPE - 1:성인, 2:아동, 3:유아
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
									최초생성  
-------------------------------------------------------------------------------------------------*/ 

CREATE FUNCTION [dbo].[FN_RES_GET_POINT_PRICE]
(
	@RES_CODE			VARCHAR(20)
)

RETURNS INT

AS

	BEGIN

		DECLARE @POINT_PRICE INT

		-- 예약번호에 해당하는 출발자의 포인트 합계
		SELECT @POINT_PRICE = ISNULL(SUM (CASE ISNULL(A.POINT_YN, '0') WHEN '0' THEN DBO.FN_RES_GET_TOTAL_PRICE_ONE(A.RES_CODE, A.SEQ_NO) * 0.01 ELSE A.POINT_PRICE END), 0)
		FROM DBO.RES_CUSTOMER_DAMO A WITH(NOLOCK) 
		INNER JOIN DBO.CUS_CUSTOMER_DAMO C  WITH(NOLOCK) ON A.CUS_NO = C.CUS_NO
		WHERE A.RES_CODE = @RES_CODE
			AND A.RES_STATE = 0
			AND A.AGE_TYPE <> 2
			AND A.POINT_YN = 'Y'
			AND C.POINT_CONSENT = 'Y'
--		  AND ISNULL(A.POINT_YN, 'N') = 'Y'
--		  AND ISNULL(C.POINT_CONSENT, 'N') = 'Y'
		  
		RETURN @POINT_PRICE
	END
GO
