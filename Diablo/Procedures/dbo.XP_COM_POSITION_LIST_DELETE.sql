USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_POSITION_LIST_DELETE
■ DESCRIPTION				: BTMS 직급 삭제
■ INPUT PARAMETER			: 
	@AGENT_CODE				: 거래처코드
	@POS_SEQ_LIST		    : 컴마(,)로 구분된 POS_SEQ
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC DBO.XP_COM_POSITION_LIST_DELETE 93881, '';
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-07-29		이유라			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_POSITION_LIST_DELETE]
	@AGT_CODE		VARCHAR(10),
	@POS_SEQ_LIST	VARCHAR(2000)
AS 
BEGIN

	DELETE FROM COM_POSITION WHERE AGT_CODE = @AGT_CODE AND POS_SEQ IN (SELECT DATA FROM DBO.FN_SPLIT(@POS_SEQ_LIST, ','))

	UPDATE  POS_TABLE 
	SET ORDER_NUM =  ROW_NUM
	FROM (
		SELECT ORDER_NUM, ROW_NUMBER() OVER(ORDER BY ORDER_NUM) AS ROW_NUM FROM COM_POSITION WHERE AGT_CODE = @AGT_CODE
	) POS_TABLE

END 
GO
