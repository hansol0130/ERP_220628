USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_MAXNO_SELECT
■ DESCRIPTION				: 검색_큐레이션정렬순번최대값
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_CURATION_MAXNO_SELECT 

■ MEMO						: 큐레이션정렬순번최대값
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-12-21		IBSOLUTION			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_MAXNO_SELECT]
AS
BEGIN

	SELECT MAX(CUR_ORDER) MAX_ORDER FROM CUR_INFO WITH(NOLOCK) 

END           

GO
