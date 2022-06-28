USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_LOGDATE_MASTER_SELECT
■ DESCRIPTION				: BTMS 거래처 아이디로 거래처 코드 검색
■ INPUT PARAMETER			: 
	@AGT_ID					: 거래처ID
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-11		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_LOGDATE_MASTER_SELECT]
	@AGT_ID		VARCHAR(20)
AS 
BEGIN

	SELECT A.AGT_CODE
	FROM COM_MASTER A WITH(NOLOCK)
	WHERE A.AGT_ID = @AGT_ID

END 


GO
