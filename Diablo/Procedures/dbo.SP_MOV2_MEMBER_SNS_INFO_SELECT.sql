USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_MOV2_MEMBER_SNS_INFO_SELECT
■ DESCRIPTION				: 
■ INPUT PARAMETER			: 
	@SNS_COMPANY_NUM        : SNS공급처 번호
	@SNS_ID INT			    : SNS제공 ID
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------

================================================================================================================*/ 
CREATE PROC [dbo].[SP_MOV2_MEMBER_SNS_INFO_SELECT]
	@SNS_COMPANY_NUM INT,
	@SNS_ID VARCHAR(200)
AS 
BEGIN

	SELECT CUS_ID, CUS_PASS FROM CUS_MEMBER AS CUS_M WITH(NOLOCK)
	INNER JOIN
	CUS_SNS_INFO AS CUS_S WITH(NOLOCK)
	ON CUS_M.CUS_NO = CUS_S.CUS_NO
	WHERE CUS_STATE = 'Y' 
		AND CUS_ID IS NOT NULL 
		AND CUS_ID <> '' 
		AND SNS_COMPANY = @SNS_COMPANY_NUM
		AND SNS_ID = @SNS_ID
	UNION ALL
	SELECT CUS_ID, CUS_PASS FROM CUS_MEMBER_SLEEP AS CUS_M WITH(NOLOCK)
	INNER JOIN
	CUS_SNS_INFO AS CUS_S WITH(NOLOCK)
	ON CUS_M.CUS_NO = CUS_S.CUS_NO
	WHERE CUS_STATE = 'Y' 
	AND CUS_ID IS NOT NULL 
	AND CUS_ID <> '' 
	AND SNS_COMPANY = @SNS_COMPANY_NUM

END 


GO
