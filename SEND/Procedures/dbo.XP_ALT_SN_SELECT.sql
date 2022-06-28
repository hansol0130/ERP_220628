USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ALT_SN_SELECT
■ DESCRIPTION				: 알림톡 순번 지정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_ALT_SN_SELECT CONVERT(VARCHAR(10), GETDATE(), 120)


	SELECT TOP 10 * FROM SEND.DBO.ALT_SEND_MASTER A WITH(NOLOCK) ORDER BY A.SN DESC

	SELECT * FROM SEND.DBO.ALT_SEQUENCE_NUMBER A WITH(NOLOCK) WHERE SN_DATE = '2018-06-13' ORDER BY A.SN DESC

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-05-18		김성호			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_ALT_SN_SELECT]
	@SN_DATE	DATE,
	@SN			VARCHAR(100) OUTPUT
AS
BEGIN

	DECLARE @RESULT TABLE (SN VARCHAR(100) NOT NULL)

	UPDATE SEND.DBO.ALT_SEQUENCE_NUMBER SET SN = SN + 1

		OUTPUT CONVERT(CHAR(8), INSERTED.SN_DATE, 112) + '-' + RIGHT('000000' + CONVERT(VARCHAR(10), INSERTED.SN), 6)
		INTO @RESULT

	WHERE SN_DATE = @SN_DATE;

	SELECT TOP 1 @SN = SN FROM @RESULT
 
END

GO
