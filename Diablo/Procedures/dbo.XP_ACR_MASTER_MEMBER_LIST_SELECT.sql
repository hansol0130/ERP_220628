USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ACR_MASTER_MEMBER_LIST_SELECT
■ DESCRIPTION				: 랜드사 직원별 가이드 경위서 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC DBO.XP_ACR_MASTER_MEMBER_LIST_SELECT 'L130192'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-01-09		이동호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ACR_MASTER_MEMBER_LIST_SELECT]
	@GUIDE_CODE	VARCHAR(7)
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @SORT_STRING VARCHAR(100);	
	
	SET @WHERE = ''
	
	IF ISNULL(@GUIDE_CODE, '') <> ''
		BEGIN
		
		SET @WHERE = ' AND A.GUIDE_CODE = ''' + @GUIDE_CODE + ''''
		
		SET @SQLSTRING = N'				
				SELECT
					A.*,
					(SELECT KOR_NAME FROM PUB_REGION WHERE REGION_CODE = A.REGION_CODE) AS REGION_NAME,
					DBO.XN_COM_GET_EMP_NAME(A.GUIDE_CODE) AS GUIDE_NAME,
					DBO.XN_COM_GET_EMP_NAME(A.CFM_CODE) AS CFM_NAME,
					DBO.XN_COM_GET_TEAM_NAME(A.CFM_CODE) AS CFM_TEAM_NAME,
					DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME,
					DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS NEW_TEAM_NAME
				FROM ACR_MASTER A 
				WHERE 1=1 ' + @WHERE + ' ORDER BY A.NEW_DATE DESC';
		END
		PRINT @SQLSTRING
		
		EXEC SP_EXECUTESQL @SQLSTRING

END
GO
