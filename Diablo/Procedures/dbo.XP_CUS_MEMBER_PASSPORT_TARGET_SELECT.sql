USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_CUS_MEMBER_PASSPORT_TARGET_SELECT
■ DESCRIPTION				: 여권 삭제 여부 고객 확인
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-04-15		김남훈			최초생성
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_CUS_MEMBER_PASSPORT_TARGET_SELECT]
AS  
BEGIN
	SELECT RC.RES_CODE, RC.PPT_NO, PD.FILENAME FROM 
		RES_MASTER_damo RM 
		INNER JOIN
		RES_CUSTOMER_damo RC 
		ON RM.RES_CODE = RC.RES_CODE
		INNER JOIN 
		PPT_DETAIL PD
		ON PD.RES_CODE = RC.RES_CODE 
		AND PD.PPT_NO = RC.PPT_NO
	WHERE RC.PPT_NO IS NOT NULL
		AND RM.DEP_DATE = CONVERT(VARCHAR(10),DATEADD(DD,-60,GETDATE()),121)
END
GO
