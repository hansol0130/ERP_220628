USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================    
■ USP_Name			: [dbo].[ZP_EVENT_LOTTE_PROMO_CODE_SELECT]
■ Description		: 롯데면세점 프로모션 상품 전용 코드 가져오기
■ Input Parameter   :                      
■ Output Parameter	:                      
■ Output Value		:                     
■ Exec				: 

	EXEC [onetime].[ZP_RES_HOPE_SYSTEM_MOVE] 'XXX986-211231A'

------------------------------------------------------------------------------------------------------------------    
■ Change History
------------------------------------------------------------------------------------------------------------------    
	Date			Author		Description
------------------------------------------------------------------------------------------------------------------    
	2021-04-02		오준혁		최초생성
================================================================================================================*/   
CREATE PROCEDURE [dbo].[ZP_EVENT_LOTTE_PROMO_CODE_SELECT]

	 @CUS_NO       INT
	,@RES_CODE     CHAR(12)
	,@PROMO_CODE   VARCHAR(10) OUTPUT
	
AS
BEGIN
	
	SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	
	DECLARE @Code CHAR(10) = ''
	
	-- 이미 등록되어있는 경우, 등록된 것을 사용 (예약자의 경우)
	SELECT @Code = CODE
	FROM   onetime.LOTTE_CODE
	WHERE  CUS_NO = @CUS_NO
	       AND RES_CODE = @RES_CODE
	       
	IF (@Code = '')
	BEGIN
		
		-- 코드표 중 하나를 가져온다.
		SELECT TOP 1 @Code = CODE
		FROM   onetime.LOTTE_CODE
		WHERE  CUS_NO IS NULL
		
		-- 코드 사용으로 등록		
		UPDATE onetime.LOTTE_CODE
		SET    CUS_NO = @CUS_NO
		      ,RES_CODE = @RES_CODE
		      ,NEW_DATE = GETDATE()
		WHERE  CODE = @Code
		
	END


	SET @PROMO_CODE = @Code

END	
GO
