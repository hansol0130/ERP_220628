USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_PKG_MASTER_LIST_SELECT
■ DESCRIPTION				: 마스터 리스트
■ INPUT PARAMETER			: 	
■ OUTPUT PARAMETER			: 
	@ATT_CODE  : 속성코드
	@SIGN_CODE : 지역코드
■ EXEC						: 
	EXEC CTI.SP_CTI_PKG_MASTER_LIST_SELECT 'P', 'C'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-22		정지용				최초생성
================================================================================================================*/ 

CREATE PROCEDURE [cti].[SP_CTI_PKG_MASTER_LIST_SELECT]
(
	@ATT_CODE VARCHAR(1),
	@SIGN_CODE VARCHAR(1)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT 
		A.MASTER_CODE, A.MASTER_NAME, A.SECTION_YN,
		A.NEXT_DATE,A.LAST_DATE,A.LOW_PRICE , A.HIGH_PRICE 
	FROM Diablo.dbo.PKG_MASTER A WITH(NOLOCK)
	WHERE 
		A.MASTER_CODE IN (SELECT MASTER_CODE FROM Diablo.dbo.PKG_ATTRIBUTE WITH(NOLOCK) WHERE ATT_CODE = @ATT_CODE)
		AND A.SIGN_CODE = @SIGN_CODE AND (SECTION_YN = 'Y' OR A.NEXT_DATE >= CONVERT(VARCHAR(10), GETDATE(), 120))
		AND (SHOW_YN = 'Y' OR SECTION_YN = 'Y')
		ORDER BY A.REGION_ORDER;
END

GO
