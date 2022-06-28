USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ARG_LAND_GRADE_UPDATE
■ DESCRIPTION				: 랜드사 등급 변경
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	EXEC DBO.XP_ARG_LAND_GRADE_UPDATE '92685'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-07-22		김완기
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_LAND_GRADE_UPDATE]
	@AGT_CODE VARCHAR(20),
	@AGT_GRADE VARCHAR(1)
AS 
BEGIN

		UPDATE AGT_MASTER
		SET AGT_GRADE = @AGT_GRADE
		WHERE AGT_CODE =  @AGT_CODE


END 

GO
