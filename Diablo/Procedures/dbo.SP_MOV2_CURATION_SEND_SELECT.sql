USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_SEND_SELECT
■ DESCRIPTION				: 검색_큐레이션발송
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_CURATION_SEND_SELECT 10
■ MEMO						: 큐레이션발송
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_SEND_SELECT]
	@HIS_NO						INT
AS
BEGIN

	SELECT A.*, D.KOR_NAME
		FROM cuve_history A  WITH(NOLOCK) LEFT JOIN  
			(select B.CUR_NO,C.KOR_NAME from CUR_INFO B  WITH(NOLOCK) LEFT JOIN  EMP_MASTER C WITH(NOLOCK) ON B.NEW_CODE = C.EMP_CODE)
			D ON A.CUR_NO = D.CUR_NO WHERE HIS_NO = @HIS_NO

END           



GO
