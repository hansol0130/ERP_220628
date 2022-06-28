USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_ALL_CONFIRM
■ DESCRIPTION				: 검색_MOV2_큐비모두확인
■ INPUT PARAMETER			: CUS_NO
■ EXEC						: 
    -- exec SP_MOV2_CURATION_ALL_CONFIRM 998899301

■ MEMO						: 큐비모두확인
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-04		IBSOLUTION				최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_ALL_CONFIRM]
	@CUS_NO		INT
AS
BEGIN
		Update CUVE	
			SET CONFIRM_DATE = GETDATE()
			WHERE CUS_NO = @CUS_NO
				AND CONFIRM_DATE IS NULL

END           



GO
