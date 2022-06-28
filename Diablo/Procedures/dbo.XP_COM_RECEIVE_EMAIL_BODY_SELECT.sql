USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_RECEIVE_EMAIL_BODY_SELECT
■ DESCRIPTION				: BTMS 이메일 내역 내용 조회
■ INPUT PARAMETER			: 
	@EMAIL_SEQ				: 이메일SEQ
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_COM_RECEIVE_EMAIL_BODY_SELECT '','17';

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-07-15		이유라			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_RECEIVE_EMAIL_BODY_SELECT]
	@AGT_CODE		VARCHAR(10),
	@EMAIL_SEQ		INT
AS 
BEGIN

	SELECT BODY FROM COM_RECEIVE_EMAIL WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE AND EMAIL_SEQ = @EMAIL_SEQ;

END 


GO
