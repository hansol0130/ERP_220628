USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_LOGDATE_SHOWYN_SELECT
■ DESCRIPTION				: BTMS 거래처 코드로 운영여부 
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-18		저스트고강태영			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_LOGDATE_SHOWYN_SELECT]
	@AGT_CODE		VARCHAR(20)
AS 
BEGIN

SELECT A.SHOW_YN, B.CON_START_DATE, B.CON_END_DATE
FROM AGT_MASTER A
LEFT JOIN COM_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
WHERE A.AGT_CODE = @AGT_CODE

END 
GO
