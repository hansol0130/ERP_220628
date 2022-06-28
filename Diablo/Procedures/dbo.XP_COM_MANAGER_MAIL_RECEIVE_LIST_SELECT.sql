USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_MANAGER_MAIL_RECEIVE_LIST_SELECT
■ DESCRIPTION				: 거래처별 메일수신 받는 담당자 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_COM_MANAGER_MAIL_RECEIVE_LIST_SELECT '92756'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-05-06	    이유라			최초생성    
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_MANAGER_MAIL_RECEIVE_LIST_SELECT]
(
	@AGT_CODE	varchar(20)  
)
AS 
BEGIN

	SELECT *
	FROM COM_EMPLOYEE
	WHERE AGT_CODE = @AGT_CODE AND MANAGER_YN = 'Y' AND MAIL_RECEIVE_YN = 'Y' AND WORK_TYPE = '1'

END 

GO
