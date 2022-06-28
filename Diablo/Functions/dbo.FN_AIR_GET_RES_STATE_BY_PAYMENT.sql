USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_AIR_GET_RES_STATE_BY_PAYMENT
■ Description				: 항공 결제금액에 따른 Z_STATE상태 변경
■ Input Parameter			:                  
		@RES_CODE			: 예약코드
■ Select					: 
■ Author					: 
■ Date						:   
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
									최초생성  
-------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[FN_AIR_GET_RES_STATE_BY_PAYMENT]
(
	@RES_CODE VARCHAR(20)
)

RETURNS CHAR(1)

AS

	BEGIN
		DECLARE @RES_STATE INT;

			--항공의 경우 DSR정산이 지난후에 결제가 잡히기 때문에, 우선 고객 예약진행시 CXL_YN을 N으로 잡는다.
			--따라서 PAY_MATCHING테이블의 데이터도 CXL_YN = N인것만 보여줄수 없음.
			SELECT @RES_STATE = (CASE WHEN PAY_PRICE = 0 THEN 2    --미납
									  WHEN A.TOTAL_PRICE > PAY_PRICE THEN 3   --부분납
									  WHEN A.TOTAL_PRICE = PAY_PRICE THEN 3   --완납
									  ELSE 3 END)
			FROM 
			(
				SELECT DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) AS TOTAL_PRICE,
					   ISNULL((SELECT SUM(PART_PRICE) FROM PAY_MATCHING WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE),0) AS PAY_PRICE  --항공은 CXL_YN조건 부여 안함
				FROM RES_MASTER_DAMO A WITH(NOLOCK) 
				WHERE RES_CODE = @RES_CODE
			) A;

			RETURN @RES_STATE;
	END
GO
