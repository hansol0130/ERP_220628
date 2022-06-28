USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [ZP_CTI_CONSULT_RES_HOPE_CUS_TEL_LIST]
■ DESCRIPTION				: 희망예약 체크 요망 고객
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec ZP_CTI_CONSULT_RES_HOPE_CUS_TEL_LIST 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2022-03-23		오준혁			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[ZP_CTI_CONSULT_RES_HOPE_CUS_TEL_LIST]
	@NOR_TEL VARCHAR(12) 
AS
BEGIN

	DECLARE @COUNT INT
	
	SELECT @COUNT = COUNT(1)
	FROM   Diablo.onetime.RES_HOPE_CUS_TEL_LIST
	WHERE  NOR_TEL = @NOR_TEL
	
	 
	SELECT ISNULL(@COUNT,0)
	 
END
GO
