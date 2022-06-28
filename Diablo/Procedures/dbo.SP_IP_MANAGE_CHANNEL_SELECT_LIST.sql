USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_IP_MANAGE_CHANNEL_SELECT_LIST
■ DESCRIPTION				: 아이피 관리 채널번호검색(남아있는 채널번호)
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						:  EXEC SP_IP_MANAGE_CHANNEL_SELECT_LIST
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-05		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_IP_MANAGE_CHANNEL_SELECT_LIST]
AS 
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	SELECT B.number
	FROM COD_PUBLIC A WITH(NOLOCK)
	LEFT JOIN MASTER.DBO.SPT_VALUES B ON B.number >= A.PUB_VALUE AND B.number <= A.PUB_VALUE2
	WHERE A.PUB_TYPE = 'CTI.CONFIG' AND A.PUB_CODE = 'CHANNEL' AND B.TYPE = 'P'
	AND B.number NOT IN (
		SELECT CH_NUM
		FROM EMP_MASTER
		WHERE WORK_TYPE = '1' AND CH_NUM IS NOT NULL
	)

END
GO
