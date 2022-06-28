USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_LAND_ARG_MEMBER_CODE_SELECT
■ DESCRIPTION				: 수배된 랜드사 직원코드조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
XP_LAND_ARG_MEMBER_CODE_SELECT 'RP1412112022'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-24		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[XP_LAND_ARG_MEMBER_CODE_SELECT]
 	@RES_CODE CHAR(12)
AS 
BEGIN
	DECLARE @PRO_CODE VARCHAR(20)

	SELECT TOP 1 @PRO_CODE = PRO_CODE FROM RES_MASTER WITH(NOLOCK) WHERE RES_CODE = @RES_CODE;

	SELECT @PRO_CODE  + '[+]'+ C.MEM_CODE FROM ARG_MASTER A WITH(NOLOCK)
		INNER JOIN AGT_MASTER B ON A.AGT_CODE = B.AGT_CODE
		INNER JOIN AGT_MEMBER C ON B.AGT_CODE = C.AGT_CODE AND C.MEM_TYPE IN(0, 9) AND C.WORK_TYPE = 1 -- 현재 재직중인 관리자와 직원
		WHERE A.PRO_CODE = @PRO_CODE 
			GROUP BY C.MEM_CODE
END


GO
