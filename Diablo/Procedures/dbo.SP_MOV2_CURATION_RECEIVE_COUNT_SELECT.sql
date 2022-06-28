USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_RECEIVE_COUNT_SELECT
■ DESCRIPTION				: 검색_큐레이션수신정보_갯수
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_CURATION_RECEIVE_COUNT_SELECT 10
■ MEMO						: 큐레이션수신정보_갯수
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION				최초생성
   2017-10-11		김성호					쿼리 수정
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_RECEIVE_COUNT_SELECT]
	@HIS_NO	INT
AS
BEGIN

	SELECT COUNT(*) AS [ROW_CNT]
	FROM CUVE A WITH(NOLOCK) 
	INNER JOIN CUS_CUSTOMER_DAMO B WITH(NOLOCK) ON A.CUS_NO = B.CUS_NO
	WHERE A.HIS_NO = @HIS_NO

	--SELECT COUNT(*) ROW_CNT
	--	FROM (
	--		SELECT B.CUS_NAME, A.* FROM CUVE A  WITH(NOLOCK) INNER JOIN CUS_CUSTOMER_DAMO B ON A.CUS_NO = B.CUS_NO
	--		WHERE A.HIS_NO = @HIS_NO
	--	) A

END
GO
