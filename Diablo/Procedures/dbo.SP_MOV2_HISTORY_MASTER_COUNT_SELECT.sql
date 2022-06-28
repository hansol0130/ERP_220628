USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_HISTORY_MASTER_COUNT_SELECT
■ DESCRIPTION				: 검색_히스토리_마스터갯수
■ INPUT PARAMETER			: CUS_NO, PAGE_INDEX, PAGE_SIZE
■ EXEC						: 
    -- exec SP_MOV2_HISTORY_MASTER_COUNT_SELECT 8505125

■ MEMO						: 히스토리 마스터갯수
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-09-11		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_HISTORY_MASTER_COUNT_SELECT]
	@CUS_NO			INT
AS
BEGIN

	-- 히스토리내의 마스터 상품 갯수 에서 전체 갯수로 변경
	-- SELECT COUNT(*) AS CNT
	-- FROM CUS_MASTER_HISTORY A WITH(NOLOCK)
	-- WHERE CUS_NO = @CUS_NO
	--	AND HIS_TYPE = 1
	--	AND MASTER_CODE <> ''
	--	AND MASTER_CODE IS NOT NULL

	SELECT COUNT(*) AS CNT
	FROM CUS_MASTER_HISTORY A WITH(NOLOCK) 
	WHERE CUS_NO = @CUS_NO
		AND ( HIS_TYPE <> 1 OR 
			( HIS_TYPE = 1 AND MASTER_CODE <> '' AND MASTER_CODE IS NOT NULL ) )


END           



GO
