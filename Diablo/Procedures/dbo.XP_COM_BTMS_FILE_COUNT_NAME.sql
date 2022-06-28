USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BTMS_FILE_COUNT_NAME
■ DESCRIPTION				: BTMS 거래처 파일 카운트 및 이름
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@FILE_SEQ				: 파일순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE					AUTHOR				DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-28		저스트고강태영			최초 생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BTMS_FILE_COUNT_NAME]
	@AGT_CODE		VARCHAR(10),
	@FILE_SEQ		INT
AS 
BEGIN

SELECT
	COUNT(*) AS CNT,
	[FILE_NAME]
FROM COM_FILE
WHERE AGT_CODE = @AGT_CODE AND FILE_SEQ = @FILE_SEQ
GROUP BY [FILE_NAME]

END
GO
