USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DHS__HSHOTEL_CFM_CODE_UPDATE
■ DESCRIPTION					: 저장_호텔예약코드_업데이트
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-18		오준혁			최초생성
   2022-02-10		오준혁			확정코드 저장시 예약상태 변경 및 로그 기록
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_HSHOTEL_CFM_CODE_UPDATE]
	 @RES_CODE      CHAR(12)
    ,@CFM_CODE      VARCHAR(20)
    ,@CLIENT_IP     VARCHAR(20)
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @Status      VARCHAR(10) = 'OK'
	       ,@Message     VARCHAR(100) = ''

	-- 이미 등록되어 있는 경우 체크
	IF (@CFM_CODE <> '')
	BEGIN
		
		IF EXISTS (SELECT 1 FROM dbo.RES_DHS_DETAIL WHERE CFM_CODE = @CFM_CODE)
		BEGIN
			SET @Status = 'Error'
			SET @Message = '이미 등록되어 있습니다. (' + @CFM_CODE + ')'
		END
		ELSE
		BEGIN
			
			UPDATE dbo.RES_DHS_DETAIL
			SET    CFM_CODE = @CFM_CODE
			WHERE  RES_CODE = @RES_CODE
			
			-- 상태값 변경 (결제완료:4)
			UPDATE dbo.RES_MASTER_damo
			SET    RES_STATE = 4
			WHERE  RES_CODE = @RES_CODE
			
			SET @Status  = 'OK4'
			SET @Message = '저장되었습니다. (' + @CFM_CODE + ')'
			
			
		END
		
	END
	ELSE
	BEGIN
		
		UPDATE dbo.RES_DHS_DETAIL
		SET    CFM_CODE = @CFM_CODE
		WHERE  RES_CODE = @RES_CODE
			
			
		-- 상태값 변경 (예약확정:2)
		UPDATE dbo.RES_MASTER_damo
		SET    RES_STATE = 2
		WHERE  RES_CODE = @RES_CODE

		SET @Status  = 'OK2'
		SET @Message = '저장되었습니다. (' + @CFM_CODE + ')'
		
	END


	IF @Status = 'OK' 
	BEGIN
		
		-- 로그 기록	
		INSERT INTO dbo.RES_DHS_DETAIL_LOG
		(
			RES_CODE,
			CFM_CODE,
			CLIENT_IP,
			NEW_DATE
		)
		VALUES
		(
			@RES_CODE,
			@CFM_CODE,
			@CLIENT_IP,
			GETDATE()
		)
		
		
	END


	-- 결과 리턴
	SELECT @Status AS 'Status'
	      ,@Message AS 'Message'	 
	
	
END
GO
