USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BTMS_FILE_DELETE
■ DESCRIPTION				: BTMS 거래처 파일 삭제
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
CREATE PROC [dbo].[XP_COM_BTMS_FILE_DELETE]
	@AGT_CODE		VARCHAR(10),
	@FILE_SEQ		INT
AS 
BEGIN

DELETE COM_FILE
WHERE AGT_CODE = @AGT_CODE
AND FILE_SEQ = @FILE_SEQ

END
GO
