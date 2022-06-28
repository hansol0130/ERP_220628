USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_SET_GET_RES_COUNT
■ Description				: 
■ Input Parameter			: 
	@PRO_CODE				: 행사코드                 
■ Select					: 
■ Author					: 
■ Date						:   
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
									최초생성
2019-01-07			김성호			출발자 상태값 예약, 환불 적용 (0: 예약, 4: 환불)
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_SET_GET_RES_COUNT]  
(  
	@RES_CODE VARCHAR(20)
)  
RETURNS INT  
AS  
BEGIN  
  
	DECLARE @COUNT INT

	SET @COUNT = ISNULL((
		SELECT COUNT(*) RES_COUNT
		FROM RES_MASTER_damo A WITH(NOLOCK)
		INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		WHERE A.RES_CODE = @RES_CODE AND A.RES_STATE <= 7 AND B.RES_STATE IN (0, 3, 4)
	), 0)

	--SELECT @COUNT = COUNT(*) FROM RES_CUSTOMER_damo A WITH(NOLOCK) 
	--INNER JOIN RES_MASTER_damo B WITH(NOLOCK) ON B.RES_CODE = A.RES_CODE
	----WHERE RES_CODE = @RES_CODE AND RES_STATE IN (0, 3, 4)  
	---- 페널티(4)는 카운트에 포함시키지 않는다.  
	--WHERE B.RES_CODE = @RES_CODE AND B.RES_STATE <= 7 AND A.RES_STATE IN (0, 3, 4)  
  
	RETURN (@COUNT)  
END  






--select top 10 c.* 
--from RES_CUSTOMER_damo a with(nolock) 
--inner join RES_MASTER_damo b with(nolock) on a.res_code = b.res_code
--inner join SET_MASTER c with(nolock) on b.pro_code = c.PRO_CODE
--where a.RES_STATE = 4 and c.SET_STATE = 2
--order by c.new_date desc

GO
