USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_IP_MANAGE_EXISTS_CHANNEL
■ DESCRIPTION				: 사내 IP관리
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
exec SP_IP_MANAGE_EXISTS_CHANNEL @CH_NUM=11
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2014-05-15		정지용			최초생성
   2015-02-13		김성호			CH_NUM = '' 인 경우 무조건 TRUE
================================================================================================================*/ 
CREATE PROC [dbo].[SP_IP_MANAGE_EXISTS_CHANNEL]
 	@CH_NUM  INT
AS 
BEGIN
	IF EXISTS(SELECT 1 FROM EMP_MASTER WITH(NOLOCK) WHERE WORK_TYPE = 1 AND CH_NUM = @CH_NUM) AND @CH_NUM <> ''
	BEGIN
		SELECT 0;
		RETURN;
	END
	SELECT 1;
END
GO
