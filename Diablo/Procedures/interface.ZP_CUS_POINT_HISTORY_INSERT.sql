USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
/*================================================================================================================    
■ USP_NAME     : [ZP_CUS_POINT_HISTORY_INSERT]    
■ DESCRIPTION    : 포인트 사용    
■ INPUT PARAMETER   :     
■ OUTPUT PARAMETER   :     
■ EXEC      :     
■ MEMO      :     
------------------------------------------------------------------------------------------------------------------    
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------    
   DATE			AUTHOR		DESCRIPTION               
------------------------------------------------------------------------------------------------------------------    
   2020-12-09	오준혁		최초생성
   2021-08-31	오준혁		@PRO_CODE 파라미터 추가 : 미리 res_code를 생성한 경우(마켓등)에서 사용하기 위해
   2022-03-21	김성호		포인트등록 오류 시 로그 등록
================================================================================================================*/     
CREATE PROCEDURE [interface].[ZP_CUS_POINT_HISTORY_INSERT]
	@CUS_NO						INT,
	@USE_TYPE					INT,
	@USE_POINT_PRICE			MONEY,
	@RES_CODE					CHAR(12)				= '',
	@TITLE						VARCHAR(100)			= '',
	@REMARK						VARCHAR(200)			= '',
	@NEW_CODE					CHAR(7)					= '9999999', 
	@IS_PAYMENT					INT, -- 포인트 결재여부 0=일반 , 1=결재입력
	@TARGET_POINT_NO			INT  = 0, -- 우선차감되어야 하는 포인트 (기본값0)
	@PRO_CODE                   VARCHAR(20) = ''
AS     
BEGIN
    
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		DECLARE @CODE         INT = 1
		       ,@POINT_NO     INT = 0
		       ,@MESSAGE      VARCHAR(4000) = '포인트 사용 성공'
			
			
		IF ISNULL(@RES_CODE,'') = ''
		BEGIN
			RAISERROR('예약코드가 없습니다.', 16, 1)
		END			
		
		EXEC dbo.SP_CUS_POINT_HISTORY_INSERT 
			 @CUS_NO
			,@USE_TYPE
			,@USE_POINT_PRICE
			,@RES_CODE
			,@TITLE
			,@REMARK
			,@NEW_CODE
			,@IS_PAYMENT
			,@TARGET_POINT_NO
			,@PRO_CODE
			
		-- POINT_NO 
		SELECT TOP 1 @POINT_NO = POINT_NO
		FROM   dbo.CUS_POINT
		WHERE  CUS_NO = @CUS_NO
		ORDER BY
		       POINT_NO DESC					
		
		
		-- 결과 리터
		SELECT @CODE AS 'CODE'
		      ,@POINT_NO AS 'POINT_NO'
		      ,@MESSAGE AS 'MESSAGE'
				
	END TRY
	BEGIN CATCH
	
		-- 에러로그
		INSERT INTO VGLog.dbo.SYS_ERP_LOG(
			LOG_TYPE,
			CATEGORY,
			EMP_CODE,
			TITLE, 
			BODY, 
			REQUEST, 
			TRACE)
		VALUES(
			1,				-- LogTypeEnum { None = 0, Error, Warning, Information };
			'AIR',
			@NEW_CODE,
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			('CUS_NO:' + CONVERT(VARCHAR(10), @CUS_NO) + ', RES_CODE:' + @RES_CODE),
			ERROR_LINE());
	
		-- 에러 결과 리터
		SELECT -1 AS 'CODE'
		      ,0 AS 'POINT_NO'
		      ,ERROR_MESSAGE() AS 'MESSAGE'

	END CATCH
         
END
GO
