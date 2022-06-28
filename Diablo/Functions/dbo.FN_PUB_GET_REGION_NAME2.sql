USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_PUB_GET_REGION_NAME2
■ Description				: 상품코드로 대표 지역명을 가져온다.
■ Input Parameter			:                  
		@PRO_CODE			: 상품코드
■ Select					: 
■ Author					: 임형민  
■ Date						: 2010-04-27  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2010-04-27       임형민			최초생성  
-------------------------------------------------------------------------------------------------*/ 

CREATE FUNCTION [dbo].[FN_PUB_GET_REGION_NAME2]
(
	@PRO_CODE  VARCHAR(20)
)

RETURNS VARCHAR(80)

AS

	BEGIN
		DECLARE @REGION_NAME VARCHAR(80)

		SELECT @REGION_NAME = C.KOR_NAME
		FROM PKG_MASTER A WITH(NOLOCK) 
		LEFT JOIN PKG_DETAIL B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE 
		LEFT JOIN PUB_REGION C WITH(NOLOCK) ON A.SIGN_CODE = C.[SIGN]
		WHERE B.PRO_CODE = @PRO_CODE

		RETURN @REGION_NAME
	END
GO
