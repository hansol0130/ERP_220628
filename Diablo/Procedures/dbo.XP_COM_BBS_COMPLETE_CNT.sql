USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BBS_COMPLETE_CNT
■ DESCRIPTION				: BTMS 온라인 상담 게시판 오늘 완료된 게시물 카운트
■ INPUT PARAMETER			: 
■ EXEC						: 
	XP_COM_BBS_COMPLETE_CNT '93877', 103
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-05-25		저스트고-이유라   최초생성
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_COM_BBS_COMPLETE_CNT]
	@AGT_CODE	VARCHAR(10),
	@EMP_SEQ	INT
AS  
BEGIN
	SELECT COUNT(*)
	FROM COM_BBS_DETAIL A WITH(NOLOCK)
	WHERE A.MASTER_SEQ = 4 AND A.AGT_CODE = @AGT_CODE AND A.NEW_SEQ = @EMP_SEQ AND 
		(SELECT [STATUS] FROM COM_BBS_DETAIL WHERE MASTER_SEQ = A.MASTER_SEQ AND PARENT_SEQ = A.BOARD_SEQ AND BOARD_SEQ <> PARENT_SEQ) = 3 AND
		(SELECT NEW_DATE FROM COM_BBS_DETAIL WHERE MASTER_SEQ = A.MASTER_SEQ AND PARENT_SEQ = A.BOARD_SEQ AND BOARD_SEQ <> PARENT_SEQ) >=  CONVERT(VARCHAR(10), GETDATE(), 120)
END



GO
