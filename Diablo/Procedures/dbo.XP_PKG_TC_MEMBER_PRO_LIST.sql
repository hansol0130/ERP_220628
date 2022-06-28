USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_PKG_TC_MEMBER_PRO_LIST
■ DESCRIPTION				: 인솔자의 해당 월의 배정된 상품출력 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	--SUMMARY
	exec XP_PKG_TC_MEMBER_PRO_LIST 'T130187', '2014-02-01'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-01-29		이동호			최초생성       
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_PKG_TC_MEMBER_PRO_LIST]
(	
	@TC_CODE	VARCHAR(10),	
	@NOW_MONTH	VARCHAR(10)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @SORTING VARCHAR(200), @SQLSTRING NVARCHAR(4000)

		SET @SQLSTRING = N'
			SELECT * FROM (
				SELECT A.PRO_CODE, COUNT(A.PRO_CODE) AS ''CUSTOMER_COUNT'', A.ARR_DATE FROM PKG_DETAIL A WITH(NOLOCK)
						LEFT JOIN RES_MASTER_damo B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE  
						LEFT JOIN RES_CUSTOMER_damo C WITH(NOLOCK) ON B.RES_CODE = C.RES_CODE  
					WHERE A.TC_CODE ='''+@TC_CODE+'''
						AND A.DEP_DATE >= '''+@NOW_MONTH+'''
						AND A.DEP_DATE <= DATEADD(ms,-3,DATEADD(mm, DATEDIFF(m,0, CONVERT(DATETIME, '''+@NOW_MONTH+''') )+1, 0)) 
						AND A.TC_YN = ''Y''
						AND C.RES_STATE < 5
					GROUP BY A.PRO_CODE,A.ARR_DATE
				) A ORDER BY A.ARR_DATE'
 print @SQLSTRING
 EXEC SP_EXECUTESQL @SQLSTRING
END 
GO
