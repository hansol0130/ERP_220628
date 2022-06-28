USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: ZP_AUTOTEST_LOG_INSERT
■ DESCRIPTION				: 자동화테스트 로그 저장
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2020-06-03		오준혁			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_AUTOTEST_LOG_INSERT]
(
	 @SITE_TYPE     CHAR(2)
	,@TEST_TYPE     VARCHAR(20)
	,@LINK          VARCHAR(100)
	,@LOG           VARCHAR(1000)
	,@ERROR_YN      CHAR(1)
)	
AS
BEGIN

    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
    INSERT INTO VGLog.dbo.AUTO_TEST_LOG
      (
        SITE_TYPE
       ,TEST_TYPE
       ,LINK
       ,[LOG]
       ,ERROR_YN
       ,NEW_DATE
      )
    VALUES
      (
        @SITE_TYPE
       ,@TEST_TYPE
       ,@LINK
       ,@LOG
       ,@ERROR_YN
       ,GETDATE()
      )
      


END






GO
