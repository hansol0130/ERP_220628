USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: dbo.XP_WEB_CUS_PARENT_AGREE_INSERT
■ DESCRIPTION				: 법정 대리인 동의 저장
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-12-20		오준혁			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_WEB_CUS_PARENT_AGREE_INSERT]
     @SEQ_NO       INT
    ,@AUTH_KEY     VARCHAR(100)
AS 
BEGIN

    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	INSERT INTO dbo.CUS_PARENT_AGREE
	  (
	    CUS_NO
	   ,CUS_PARENT_NAME
	   ,NOR_TEL1
	   ,NOR_TEL2
	   ,NOR_TEL3
	   ,SEQ_NO
	   ,NEW_DATE
	  )
	SELECT CUS_NO
	      ,CUS_NAME
	      ,NOR_TEL1
	      ,NOR_TEL2
	      ,NOR_TEL3
	      ,SEQ_NO
	      ,GETDATE()
	FROM   dbo.CUS_PHONE_AUTH
	WHERE  SEQ_NO = @SEQ_NO
	       AND AUTH_KEY = @AUTH_KEY 

	
END
GO
