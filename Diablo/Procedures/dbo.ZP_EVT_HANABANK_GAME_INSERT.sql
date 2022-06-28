USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================    
■ USP_Name			: [dbo].[ZP_EVT_HANABANK_GAME_INSERT]      
■ Description		: 하나은행 제휴 룰렛게임 이벤트
■ Input Parameter   :                      
■ Output Parameter	:                      
■ Output Value		:                     
■ Exec				: 
------------------------------------------------------------------------------------------------------------------    
■ Change History
------------------------------------------------------------------------------------------------------------------    
	Date			Author		Description
------------------------------------------------------------------------------------------------------------------    
	2021-12-06		오준혁		최초생성
	2022-01-06		오준혁		이벤트 시작일/종료일 설정
================================================================================================================*/   
CREATE PROCEDURE [dbo].[ZP_EVT_HANABANK_GAME_INSERT]
	 @CUS_NO     INT
	,@CODE       VARCHAR(10) 
AS
BEGIN
	
	SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @Status      VARCHAR(10) = ''
	       ,@Message     VARCHAR(100) = ''
	
	-- 이벤트 종료
	DECLARE @Today           VARCHAR(10) = FORMAT(GETDATE() ,'yyyy-MM-dd')
	       ,@EventStartDay     VARCHAR(10) = '2022-01-24'
	       ,@EventEndDay     VARCHAR(10) = '2022-04-30'

	-- 이벤트 시작 체크
	IF (@EventStartDay > @Today)
	BEGIN
		
		SET @Status = 'EXPIRED'
		SET @Message = '이벤트는 ' + @EventStartDay + ' 부터 시작합니다.'
		
		SELECT @Status AS 'Status'
			  ,@Message AS 'Message'
		
		RETURN
	END

	-- 이벤트 종료 체크
	IF (@Today > @EventEndDay)
	BEGIN
		
		SET @Status = 'EXPIRED'
		SET @Message = '이벤트 기간이 종료되었습니다.'
		
		SELECT @Status AS 'Status'
			  ,@Message AS 'Message'
		
		RETURN
	END

		
	
	
	
	IF EXISTS (SELECT 1
	           FROM   onetime.EVT_HNBANK_GAME
	           WHERE  CUS_NO = @CUS_NO)
	BEGIN
		
		SET @Status = 'ALREADY'
		SET @Message = '이미 신청하셨습니다.<br/>마이페이지에서 포인트를 확인해주세요.'
		
	END
	ELSE
	BEGIN
		
		-- 쿠폰번호 유무 확인
		IF EXISTS (SELECT 1 FROM onetime.EVT_HNBANK_GAME WHERE CODE = @CODE)
		BEGIN
			
			
			-- 사용된 쿠폰인지 확인
			IF EXISTS (SELECT 1
					   FROM   onetime.EVT_HNBANK_GAME
					   WHERE  CODE = @CODE
							  AND CUS_NO IS NOT NULL)
			BEGIN
			
				SET @Status = 'USED'
				SET @Message = '사용된 쿠폰번호입니다.<br/>쿠폰번호를 재확인해주세요.'
			
			END
			ELSE
			BEGIN
				
				UPDATE onetime.EVT_HNBANK_GAME
				SET    CUS_NO = @CUS_NO
				      ,NEW_DATE = GETDATE()
				WHERE  CODE = @CODE
				
				
				-- 포인트 적립				
				DECLARE @TOTAL_POINT INT

				SELECT TOP 1 @TOTAL_POINT = TOTAL_PRICE
				FROM   CUS_POINT
				WHERE  CUS_NO = @CUS_NO
				ORDER BY
				       POINT_NO DESC
				       				
				
				INSERT INTO CUS_POINT
					(
					CUS_NO
					,POINT_TYPE
					,ACC_USE_TYPE
					,START_DATE
					,END_DATE
					,POINT_PRICE
					,RES_CODE
					,TITLE
					,TOTAL_PRICE
					,REMARK
					,NEW_CODE
					,NEW_DATE
					,MASTER_SEQ
					,BOARD_SEQ
					)
				VALUES
					(
					@CUS_NO
					,1 -- 적립
					,5 -- 이벤트적립
					,GETDATE()
					,DATEADD(MM ,36 ,GETDATE())
					,3000
					,NULL
					,'하나은행 환전지갑 룰렛 이벤트(럭키박스)'
					,ISNULL(@TOTAL_POINT, 0) + 3000
					,NULL
					,'9999999'
					,GETDATE()
					,NULL
					,NULL
					) 	
				
				SET @Status = 'OK'
				SET @Message = '포인트가 적립되었습니다.<br/>마이페이지에서 포인트를 확인해주세요.'
				
			END
			
		END
		ELSE
		BEGIN
			
			SET @Status = 'NOT_EXISTS'
			SET @Message = '일치하지 않는 쿠폰번호입니다.<br/>쿠폰번호를 재확인해주세요.'
			
		END

	END

	SELECT @Status AS 'Status'
	      ,@Message AS 'Message'
		
END	
GO
