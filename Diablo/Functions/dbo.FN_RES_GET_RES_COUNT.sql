USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_RES_GET_RES_COUNT
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
2019-01-07			김성호			출발자 상태값 예약만 살리고 삭제 (3: 거의 사용안함, 4: 조건에 없음)
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_RES_GET_RES_COUNT]  
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
		WHERE A.RES_CODE = @RES_CODE AND A.RES_STATE <= 7 AND B.RES_STATE = 0
	), 0)

	--SELECT @COUNT = COUNT(*) FROM RES_CUSTOMER_DAMO A WITH(NOLOCK) 
	--INNER JOIN RES_MASTER_DAMO B  WITH(NOLOCK) ON B.RES_CODE = A.RES_CODE
	----WHERE RES_CODE = @RES_CODE AND RES_STATE IN (0, 3, 4)  
	---- 페널티(4)는 카운트에 포함시키지 않는다.  
	--WHERE B.RES_CODE = @RES_CODE AND B.RES_STATE <= 7 AND A.RES_STATE IN (0, 3)  
  
	RETURN (@COUNT)  
END  

GO
