USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_DOC_APPROVAL_TEAM_UPDATE
■ DESCRIPTION				: 전자결재 팀 변경
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	DECLARE @EDI_CODE		CHAR(10)

	SET @EDI_CODE = '1305149723'

	EXEC DBO.XP_DOC_APPROVAL_TEAM_UPDATE @EDI_CODE
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-28		김완기			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_DOC_APPROVAL_TEAM_UPDATE]
	@EDI_CODE		CHAR(10)
AS 
BEGIN

	DECLARE @RCV_TEAM_CODE VARCHAR(3);

	SELECT  @RCV_TEAM_CODE = B.TEAM_CODE
	  FROM  EDI_APPROVAL A 
	 INNER  JOIN EMP_MASTER B ON A.APP_CODE = B.EMP_CODE
	 WHERE  A.EDI_CODE = @EDI_CODE
	   AND  A.APP_STATUS = 'Y'
	   AND  A.SEQ_NO = '1'

	UPDATE EDI_MASTER_damo
	SET RCV_TEAM_CODE = @RCV_TEAM_CODE
	WHERE EDI_CODE =  @EDI_CODE


END 

GO
