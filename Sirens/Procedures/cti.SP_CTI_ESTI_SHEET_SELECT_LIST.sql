USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ESTI_SHEET_SELECT_LIST
■ DESCRIPTION				: 상담평가 SHEET 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: EXEC SP_CTI_ESTI_SHEET_SELECT_LIST
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-10		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ESTI_SHEET_SELECT_LIST]

AS
SET NOCOUNT ON

	SELECT
		ESTI.SHEET_CODE,
		ESTI.TITLE,
		ESTI.MODIFY_FLAG,
		ESTI.NEW_DATE,
		EMP.KOR_NAME AS EMP_NAME
	FROM Sirens.cti.CTI_ESTI_SHEET ESTI, Diablo.dbo.EMP_MASTER EMP
	WHERE ESTI.NEW_CODE = EMP.EMP_CODE
	ORDER BY SHEET_CODE DESC

SET NOCOUNT OFF


GO
