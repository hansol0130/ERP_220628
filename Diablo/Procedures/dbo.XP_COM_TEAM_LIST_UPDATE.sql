USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_TEAM_LIST_UPDATE
■ DESCRIPTION				: BTMS 메뉴 리스트 검색
■ INPUT PARAMETER			: 
	@AGENT_CODE				: 거래처코드
	@TEAM_SEQ_LIST			: 컴마(,)로 구분된 TEAM_SEQ
	@ORDER_NUM_LIST			: 컴마(,)로 구분된 ORDER_NUM
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_COM_TEAM_LIST_UPDATE 1, '1,2,3', '3,1,2'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-23		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_TEAM_LIST_UPDATE]
	@AGT_CODE		VARCHAR(10),
	@TEAM_SEQ_LIST	VARCHAR(2000),
	@ORDER_NUM_LIST	VARCHAR(2000)
AS 
BEGIN

	WITH LIST AS
	(
		SELECT A.ID, CONVERT(INT, A.Data) AS [TEAM_SEQ], CONVERT(INT, B.Data) AS [ORDER_NUM]
		FROM DBO.FN_SPLIT (@TEAM_SEQ_LIST, ',') A
		INNER JOIN DBO.FN_SPLIT (@ORDER_NUM_LIST, ',') B ON A.ID = B.ID
	)
	UPDATE A SET A.ORDER_NUM = B.ORDER_NUM
	FROM COM_TEAM A
	INNER JOIN LIST B ON A.TEAM_SEQ = B.TEAM_SEQ
	WHERE A.AGT_CODE = @AGT_CODE

END 




GO
