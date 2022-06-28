USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_HISTORY_MASTER_LIST_SELECT
■ DESCRIPTION				: 검색_히스토리_최근마스터3개
■ INPUT PARAMETER			: CUS_NO, PAGE_INDEX, PAGE_SIZE
■ EXEC						: 
    -- exec SP_MOV2_HISTORY_MASTER_LIST_SELECT 8505125

■ MEMO						: 히스토리 최근 마스터 3개
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-07		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_HISTORY_MASTER_LIST_SELECT]
	@CUS_NO			INT
AS
BEGIN
	SELECT TOP 3 A.MASTER_CODE
	FROM CUS_MASTER_HISTORY A WITH(NOLOCK)
	WHERE CUS_NO = @CUS_NO
		AND HIS_TYPE = 1
		AND MASTER_CODE IS NOT NULL
	ORDER BY HIS_DATE DESC
END           



GO
