USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_SELECT
■ DESCRIPTION				: 검색_큐레이션정보
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_CURATION_SELECT 10
■ MEMO						: 큐레이션정보
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_SELECT]
	@CUR_NO				INT

AS
BEGIN

		SELECT A.*, B.KOR_NAME
			FROM CUR_INFO A  WITH(NOLOCK) LEFT JOIN  EMP_MASTER B WITH(NOLOCK) ON A.NEW_CODE = B.EMP_CODE
			WHERE A.CUR_NO = @CUR_NO

END           



GO
