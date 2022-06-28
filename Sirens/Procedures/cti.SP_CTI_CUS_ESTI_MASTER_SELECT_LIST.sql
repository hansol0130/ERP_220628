USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_CUS_ESTI_MASTER_SELECT_LIST
■ DESCRIPTION				: 고객평가 리스트 조회
■ INPUT PARAMETER			: 
	@ESTI_WOL	CHAR(6), : 평가월
	@SHEET_CODE	INT,	: 평가쉬트지코드
	@TEAM_CODE	VARCHAR(3) : 팀코드
■ OUTPUT PARAMETER			: 
■ EXEC						: EXEC SP_CTI_CUS_ESTI_MASTER_SELECT_LIST '201501',1,'538'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-01-10		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CUS_ESTI_MASTER_SELECT_LIST]
--DECLARE
	@ESTI_WOL	CHAR(6),
	@SHEET_CODE	INT,
	@TEAM_CODE	VARCHAR(3)

--SET @ESTI_WOL = '201501'
--SET @SHEET_CODE = 1
--SET @TEAM_CODE = '538'

AS

SET NOCOUNT ON

SELECT
	ESTI.ESTI_WOL,
	ESTI.SHEET_CODE,
	SHEET.TITLE AS SHEET_NAME,
	ESTI.TEAM_CODE,
	TEAM.TEAM_NAME,
	ESTI.EMP_CODE,
	EMP.KOR_NAME AS EMP_NAME,
	ESTI.CUS_NO,
	ESTI.ESTI_VALUE,
	CONVERT(VARCHAR(10), ESTI.NEW_DATE, 120) AS ESTI_DATE,
	ESTI.NEW_CODE AS ESTI_CODE,
	EMP2.KOR_NAME AS ESTI_NAME
FROM Sirens.cti.CTI_CUS_ESTI_MASTER ESTI, Diablo.dbo.EMP_MASTER EMP, Diablo.dbo.EMP_TEAM TEAM, Diablo.dbo.EMP_MASTER EMP2, Sirens.cti.CTI_ESTI_SHEET SHEET
WHERE ESTI.ESTI_WOL = @ESTI_WOL
AND ESTI.SHEET_CODE = @SHEET_CODE
AND ESTI.TEAM_CODE = @TEAM_CODE
AND ESTI.TEAM_CODE = TEAM.TEAM_CODE
AND ESTI.EMP_CODE = EMP.EMP_CODE
AND ESTI.NEW_CODE = EMP2.EMP_CODE
AND ESTI.SHEET_CODE = SHEET.SHEET_CODE
ORDER BY ESTI.ESTI_WOL, ESTI.SHEET_CODE, ESTI.TEAM_CODE, ESTI.EMP_CODE

SET NOCOUNT OFF
GO
