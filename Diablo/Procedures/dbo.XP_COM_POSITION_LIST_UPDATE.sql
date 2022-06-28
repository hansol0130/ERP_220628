USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_POSITION_LIST_UPDATE
■ DESCRIPTION				: BTMS 직급 순번 수정
■ INPUT PARAMETER			: 
	@AGENT_CODE				: 거래처코드
	@POS_SEQ_LIST		    : 컴마(,)로 구분된 POS_SEQ
	@ORDER_NUM_LIST			: 컴마(,)로 구분된 ORDER_NUM
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC DBO.XP_COM_POSITION_LIST_UPDATE 92756, '1,2,3,4,5,6,7', '3,1,2,4,5,6,7'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-07-28		이유라			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_POSITION_LIST_UPDATE]
	@AGT_CODE		VARCHAR(10),
	@POS_SEQ_LIST	VARCHAR(2000),
	@ORDER_NUM_LIST	VARCHAR(2000)
AS 
BEGIN

	WITH LIST AS
	(
		SELECT A.ID, CONVERT(INT, A.Data) AS [POS_SEQ], CONVERT(INT, B.Data) AS [ORDER_NUM]
		FROM DBO.FN_SPLIT (@POS_SEQ_LIST, ',') A
		INNER JOIN DBO.FN_SPLIT (@ORDER_NUM_LIST, ',') B ON A.ID = B.ID
	)
	UPDATE A SET A.ORDER_NUM = B.ORDER_NUM
	FROM COM_POSITION A
	INNER JOIN LIST B ON A.POS_SEQ = B.POS_SEQ
	WHERE A.AGT_CODE = @AGT_CODE

END 
GO
