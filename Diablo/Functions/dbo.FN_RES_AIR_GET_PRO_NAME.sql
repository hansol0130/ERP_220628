USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_RES_AIR_GET_PRO_NAME
■ Description				: 
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
					이거누가만든거죠? 커서로 ㅠ		최초생성
						
수정내역			
2014-03-04	박형만	사용안하는 소스 제거 FARE_GROUP  
2016-04-29	박형만	오프라인 항공도 나올수 있게 실시간 항공 조건 제외 
2016-08-17	박형만	이전 도착공항과, 다음출발 공항이 다를경우 , 공항명 추가로 노출하기 
2017-08-01	박형만	SEQ_NO 재 설정 (삭제된 세그도 제대로 나와야함) 
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_RES_AIR_GET_PRO_NAME]
(
	@RES_CODE VARCHAR(20)
)

RETURNS VARCHAR(100)
AS
	BEGIN
	--DECLARE @RES_CODE VARCHAR(20)
	--SET @RES_CODE = 'RT1605319056' 
		DECLARE @PRO_NAME VARCHAR(300);

		--DECLARE @AIR_PRO_TYPE INT;  --항공 상품 타입
		--SELECT @AIR_PRO_TYPE = AIR_PRO_TYPE FROM RES_AIR_DETAIL  WITH(NOLOCK) WHERE RES_CODE = @RES_CODE;

		DECLARE @PREV_ARR_AIRPORT_NAME VARCHAR(100)
		SET @PREV_ARR_AIRPORT_NAME = ''

		--DECLARE @ROUTING_TYPE INT --  여정타입  0=왕복, 1=편도 ,2=다구간
		--SET @ROUTING_TYPE = DBO.FN_RES_AIR_GET_RTG_TYPE(@RES_CODE) 
		
		DECLARE @RTG_COUNT INT;
			
		SELECT @RTG_COUNT = COUNT(*) FROM RES_SEGMENT  WITH(NOLOCK) WHERE RES_CODE = @RES_CODE;

		--루팅 항공사명을 위한 커서(인천-나리타-인천)
		SET @PRO_NAME = '';

		DECLARE @SEQ_NO INT;
		DECLARE @DEP_AIRPORT_NAME VARCHAR(100), @ARR_AIRPORT_NAME VARCHAR(100);


		DECLARE CURSOR_AIR_SEGMENT CURSOR FOR
		SELECT ROW_NUMBER() OVER (ORDER BY SEQ_NO) AS SEQ_NO ,	  -- 다시 SEQ_NO 넘버링
			(SELECT KOR_NAME FROM PUB_AIRPORT  WITH(NOLOCK) WHERE AIRPORT_CODE = DEP_AIRPORT_CODE) AS DEP_AIRPORT_NAME,
			(SELECT KOR_NAME FROM PUB_AIRPORT  WITH(NOLOCK) WHERE AIRPORT_CODE = ARR_AIRPORT_CODE) AS ARR_AIRPORT_NAME
		FROM RES_SEGMENT
		WHERE RES_CODE = @RES_CODE
		ORDER BY SEQ_NO 

		OPEN CURSOR_AIR_SEGMENT

		FETCH CURSOR_AIR_SEGMENT INTO @SEQ_NO, @DEP_AIRPORT_NAME, @ARR_AIRPORT_NAME

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			--이전 도착지와 다른경우 
			IF( @SEQ_NO > 1 
				AND @PREV_ARR_AIRPORT_NAME <> '' AND @DEP_AIRPORT_NAME <> @PREV_ARR_AIRPORT_NAME  )
			BEGIN 
				SET @PRO_NAME = @PRO_NAME + @PREV_ARR_AIRPORT_NAME +'-'  
			END 

			SET @PRO_NAME = @PRO_NAME + @DEP_AIRPORT_NAME + '-';

			--도착지 저장 
			--SELECT @PREV_ARR_AIRPORT_NAME  , @DEP_AIRPORT_NAME  , @SEQ_NO , @RTG_COUNT 
				

			IF (@SEQ_NO = @RTG_COUNT)  --마지막 루팅일 경우 도착 공항 포함
			BEGIN
				SET @PRO_NAME = @PRO_NAME + @ARR_AIRPORT_NAME;
			END

			SET @PREV_ARR_AIRPORT_NAME = @ARR_AIRPORT_NAME 

			FETCH CURSOR_AIR_SEGMENT INTO @SEQ_NO, @DEP_AIRPORT_NAME, @ARR_AIRPORT_NAME
		END

		CLOSE CURSOR_AIR_SEGMENT;

		DEALLOCATE CURSOR_AIR_SEGMENT;

		--SELECT @PRO_NAME 

		RETURN @PRO_NAME;
	END

GO
