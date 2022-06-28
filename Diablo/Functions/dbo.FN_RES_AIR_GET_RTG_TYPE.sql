USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name			: FN_RES_AIR_GET_RTG_TYPE
■ Description				: 항공여정의 ROUTING_TYPE 을 구함
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
2016-08-16	박형만	최초생성
-------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[FN_RES_AIR_GET_RTG_TYPE]
(
	@RES_CODE VARCHAR(20)
)
RETURNS INT
AS
BEGIN
--DECLARE @RES_CODE VARCHAR(20)
--SET @RES_CODE = 'RT1607189095' 

	DECLARE @DIR_CNT INT --  ITINERARY 여정갯수 
	DECLARE @ROUTING_TYPE INT --  여정타입  0=왕복, 1=편도 ,2=다구간
		
	SELECT @DIR_CNT = MAX(DIRECTION) FROM RES_SEGMENT  WITH(NOLOCK) WHERE RES_CODE = @RES_CODE  

	DECLARE @DEP_ARR_AIRPORT_CODE VARCHAR(10)
	DECLARE @ARR_DEP_AIRPORT_CODE VARCHAR(10)
	--편도 
	IF ( @DIR_CNT = 0 )
	BEGIN
		SET @ROUTING_TYPE =  1 --편도
	END 
	ELSE IF( @DIR_CNT = 1 )
		BEGIN
			SELECT TOP 1 @DEP_ARR_AIRPORT_CODE = ARR_AIRPORT_CODE FROM RES_SEGMENT WITH(NOLOCK) WHERE RES_CODE = @RES_CODE AND DIRECTION = 0 ORDER BY SEQ_NO DESC
			SELECT TOP 1 @ARR_DEP_AIRPORT_CODE = DEP_AIRPORT_CODE FROM RES_SEGMENT WITH(NOLOCK) WHERE RES_CODE = @RES_CODE AND DIRECTION = 1 ORDER BY SEQ_NO ASC

			--select @DEP_ARR_AIRPORT_CODE , @ARR_DEP_AIRPORT_CODE 
			IF( @DEP_ARR_AIRPORT_CODE = @ARR_DEP_AIRPORT_CODE )
			BEGIN 
				SET @ROUTING_TYPE =  0 -- 왕복
			END 
			ELSE 
			BEGIN
				SET @ROUTING_TYPE =  2  --다구간
			END 
		END 
	ELSE 
	BEGIN
		SET @ROUTING_TYPE =  2 --다구간
	END 
	RETURN @ROUTING_TYPE;
END
GO
