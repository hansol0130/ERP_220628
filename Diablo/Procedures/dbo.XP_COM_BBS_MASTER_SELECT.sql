USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BBS_MASTER_SELECT
■ DESCRIPTION				: BTMS 게시판 마스터 가져오기
■ INPUT PARAMETER			: 
	@MASTER_SEQ  INT		: 게시판 마스터코드
	@AGT_CODE VARCHAR(20) : 에이전트 코드
	
■ EXEC						: 
	EXEC XP_COM_CATEGORY_SELECT 4, 1
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-24		저스트고-백경훈		최초생성
   2016-04-14		저스트고-이유라		ERP용 (AGT_CODE 없을경우 처리)
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BBS_MASTER_SELECT]
	@MASTER_SEQ	INT,
	@AGT_CODE	VARCHAR(20)
AS 
BEGIN		
	IF(@AGT_CODE <> '')
	BEGIN 
		SELECT * FROM COM_BBS_MASTER where MASTER_SEQ = @MASTER_SEQ AND AGT_CODE = @AGT_CODE
	END
	ELSE
	BEGIN 
		SELECT * FROM COM_BBS_MASTER where MASTER_SEQ = @MASTER_SEQ
	END
END  




GO
