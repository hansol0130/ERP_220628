USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : [ZP_CUS_SALE_CODE_UPDATE]
- 기 능 : 난수생성
====================================================================================
	변경내역
	
	[dbo].[ZP_CUS_SALE_CODE_UPDATE] '1123-1234', 'RP1905070934', 11982544, 'U'
====================================================================================
- 2021-07-08 김영민 신규 작성 
===================================================================================*/
CREATE PROCEDURE [dbo].[ZP_CUS_SALE_CODE_UPDATE]
	 @CODE         VARCHAR(10)
    ,@RES_CODE     VARCHAR(12)
    ,@CUS_NO       INT
    ,@TYPE         CHAR(1)
AS
BEGIN
	
	SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
	DECLARE @MSG VARCHAR(50)
	
	IF @TYPE = 'U'
	BEGIN
	    IF EXISTS(
	           SELECT CUS_NO
	           FROM   CUS_SALE_CODE
	           WHERE  SALE_CODE = @CODE
	                  AND USE_YN = 'Y'
	       )
	    BEGIN
	        SET @MSG = (
	                SELECT 'U' + '|' + B.CUS_NAME + '|' + A.RES_CODE + '|' + A.USE_NAME AS MSG
	                FROM   CUS_SALE_CODE A
	                       JOIN CUS_CUSTOMER_DAMO B
	                            ON  A.CUS_NO = B.CUS_NO
	                WHERE  A.SALE_CODE = @CODE
	            )
	    END
	    ELSE
	    BEGIN
	        IF EXISTS(
	               SELECT SALE_CODE
	               FROM   CUS_SALE_CODE
	               WHERE  SALE_CODE = @CODE
	                      --AND END_DATE > GETDATE()
	                      AND GETDATE() BETWEEN START_DATE AND END_DATE 
	           )
	        BEGIN
	        	
	        	IF EXISTS(SELECT 1
	        	          FROM   CUS_SALE_CODE
	        	          WHERE  SALE_CODE = @CODE
	        	                 AND ISNULL(USE_NAME ,'') = '')
	        	BEGIN
	        		-- 최초 등록자가 없는 경우
	        		SET @MSG = 'E'
	        		
	        	END
	        	ELSE
	        	BEGIN

					UPDATE CUS_SALE_CODE
					SET    CUS_NO = @CUS_NO
						  ,RES_CODE = @RES_CODE
						  ,USE_YN = 'Y'
						  ,--USE_NAME = (SELECT CUS_NAME
						   --              FROM CUS_CUSTOMER_damo WHERE CUS_NO = @CUS_NO),
						   EDIT_DATE = GETDATE()
					WHERE  SALE_CODE = @CODE
	            
					IF @@ROWCOUNT = 0
						SET @MSG = 'N'
					ELSE
						SET @MSG = 'Y'
	        		
	        	END

	        END
	        ELSE
	        BEGIN
	            IF (
	                   (
	                       SELECT COUNT(SALE_CODE)
	                       FROM   CUS_SALE_CODE
	                       WHERE  SALE_CODE = @CODE
	                   ) <= 0
	               )
	                SET @MSG = 'N'
	            ELSE
	                SET @MSG = (
	                        SELECT 'X' + '|' + CONVERT(CHAR(10) ,START_DATE ,120) + '|' + CONVERT(CHAR(10) ,END_DATE ,120) AS MSG
	                        FROM   CUS_SALE_CODE
	                        WHERE  SALE_CODE = @CODE
	                    )
	        END
	    END
	END
	ELSE 
	IF @TYPE = 'D'
	BEGIN
	    UPDATE CUS_SALE_CODE
	    SET    CUS_NO = NULL
	          ,RES_CODE = NULL
	          ,USE_YN = 'N'
	          --,USE_NAME = NULL
	          ,EDIT_DATE = GETDATE()
	    WHERE  SALE_CODE = @CODE
	    
	    SET @MSG = 'D'
	END
	
	
	SELECT @MSG
	
END
GO
