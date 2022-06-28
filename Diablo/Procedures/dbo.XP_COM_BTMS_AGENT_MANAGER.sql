USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BTMS_AGENT_MANAGER
■ DESCRIPTION				: BTMS 거래처 담당자
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE					AUTHOR				DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-05-01		저스트고강태영			최초 생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BTMS_AGENT_MANAGER]
	
AS 
BEGIN

SELECT A.EMP_CODE, A.KOR_NAME, B.ORDER_NUM
FROM EMP_MASTER A
LEFT JOIN COM_POSITION B ON A.POS_TYPE = B.POS_SEQ
WHERE TEAM_CODE = 524 AND WORK_TYPE = '1'
ORDER BY B.ORDER_NUM ASC, A.KOR_NAME

END
GO
