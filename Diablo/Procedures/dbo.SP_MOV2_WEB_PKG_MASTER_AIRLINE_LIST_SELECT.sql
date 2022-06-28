USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_WEB_PKG_MASTER_AIRLINE_LIST_SELECT
■ DESCRIPTION				: 검색_마스터별항공사목록
■ INPUT PARAMETER			: MASTER_CODE
■ EXEC						: 
    -- exec SP_MOV2_WEB_PKG_MASTER_AIRLINE_LIST_SELECT 'APP4299'

■ MEMO						: 마스터항공사목록
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-27		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_WEB_PKG_MASTER_AIRLINE_LIST_SELECT]
	@MASTER_CODE	VARCHAR(10)
AS
BEGIN
	-- 항공사정보
	SELECT B1.DEP_TRANS_CODE, C1.KOR_NAME
	FROM PKG_DETAIL A1 WITH(NOLOCK)
	LEFT JOIN PRO_TRANS_SEAT B1 WITH(NOLOCK) 
		ON B1.SEAT_CODE = A1.SEAT_CODE
	LEFT JOIN PUB_AIRLINE C1 WITH(NOLOCK) 
		ON B1.DEP_TRANS_CODE = C1.AIRLINE_CODE
	WHERE A1.MASTER_CODE = @MASTER_CODE AND A1.DEP_DATE >= GETDATE() AND A1.SHOW_YN = 'Y'
	Group By B1.DEP_TRANS_CODE, C1.KOR_NAME
	ORDER BY C1.KOR_NAME
	
END           



GO
