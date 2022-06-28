USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_TC_LAND_LIST_SELECT
■ DESCRIPTION				: 랜드사 리스트 검색
■ INPUT PARAMETER			: 
	@KOR_NAME   VARCHAR(50)	: 랜드사명
■ OUTPUT PARAMETER			: 
   
■ EXEC						: 

	exec XP_TC_LAND_LIST_SELECT '참'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------

================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_TC_LAND_LIST_SELECT]
(
	@KOR_NAME		VARCHAR(50)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SELECT A.AGT_CODE,
            A.KOR_NAME,
			MAX(A.SHOW_YN) AS SHOW_YN
    FROM AGT_MASTER A WITH(NOLOCK)
    LEFT OUTER JOIN AGT_MEMBER B WITH(NOLOCK) ON (A.AGT_CODE = B.AGT_CODE AND B.MEM_TYPE ='1' AND B.WORK_TYPE != '5')
    LEFT OUTER JOIN OTR_POL_MASTER C WITH(NOLOCK) ON (B.AGT_CODE = C.AGT_CODE AND B.MEM_CODE = C.MEM_CODE)
    LEFT OUTER JOIN OTR_MASTER D WITH(NOLOCK) ON (C.OTR_SEQ = D.OTR_SEQ AND D.OTR_STATE = '3')
    WHERE A.AGT_TYPE_CODE = '12' AND A.SHOW_YN = 'Y' AND A.KOR_NAME LIKE '%' + @KOR_NAME + '%'
    GROUP BY A.AGT_CODE, A.KOR_NAME 
    ORDER BY A.AGT_CODE DESC
END



GO
