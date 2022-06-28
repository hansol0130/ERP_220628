USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_NOT_READ_COUNT
■ DESCRIPTION				: 검색_MOV2_읽지않은큐비수
■ INPUT PARAMETER			: CUS_NO
■ EXEC						: 
    -- exec SP_MOV2_CURATION_NOT_READ_COUNT 998899301

■ MEMO						: 읽지않은큐비수
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-04		IBSOLUTION				최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_NOT_READ_COUNT]
	@CUS_NO		INT
AS
BEGIN

		SELECT COUNT(*) AS CNT FROM CUVE A WITH(NOLOCK)
			WHERE A.CUS_NO = @CUS_NO
				AND A.CONFIRM_DATE IS NULL

END           



GO
