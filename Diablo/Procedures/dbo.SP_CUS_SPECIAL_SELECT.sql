USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CUS_SPECIAL_SELECT
■ DESCRIPTION				: 특수고객 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
EXEC SP_CUS_SPECIAL_SELECT '3'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-06-09		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_CUS_SPECIAL_SELECT]
	@SPC_NO INT
AS 
BEGIN
	SELECT
	 A.SPC_NO, A.NO1 AS TEL_NUMBER1, A.NO2 AS TEL_NUMBER2, A.NO3 AS TEL_NUMBER3, A.CUS_NO, C.CUS_NAME, A.CONNECT_CODE AS EMP_CODE, B.KOR_NAME AS EMP_NAME,
	 A.REMARK, A.USE_YN, A.NEW_CODE, A.NEW_DATE
	FROM CUS_SPECIAL A WITH(NOLOCK)
	INNER JOIN EMP_MASTER B WITH(NOLOCK) ON A.CONNECT_CODE = B.EMP_CODE
	INNER JOIN CUS_CUSTOMER C WITH(NOLOCK) ON A.CUS_NO = C.CUS_NO
	WHERE A.SPC_NO = @SPC_NO
END
GO
