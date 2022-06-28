USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_RES_PKG_ACCOUNT_NUMBER
■ DESCRIPTION				: 예약계좌정보
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_RES_PKG_ACCOUNT_NUMBER 'RP1603317895'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-07-04		정지용			최초생성
   2016-07-13		박형만			입금마감일추가
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[SP_RES_PKG_ACCOUNT_NUMBER]
(
	@RES_CODE CHAR(12)
)
AS  
BEGIN
	SELECT 
		B.TEAM_NAME, C.KOR_NAME AS BANK_NAME, D.ACC_NAME, D.REG_NUMBER , A.LAST_PAY_DATE 
	FROM RES_MASTER A WITH(NOLOCK)
	INNER JOIN EMP_TEAM B WITH(NOLOCK) ON A.NEW_TEAM_CODE = B.TEAM_CODE
	LEFT JOIN AGT_MASTER C WITH(NOLOCK) ON B.AGT_CODE = C.AGT_CODE
	LEFT JOIN AGT_ACCOUNT D WITH(NOLOCK) ON B.AGT_CODE = D.AGT_CODE AND B.ACC_SEQ = D.ACC_SEQ
	WHERE A.RES_CODE = @RES_CODE
END

GO
