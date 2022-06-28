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
   2016-01-28		정지용			대표번호 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_TEAM_UPDATE]
	@AGT_CODE			VARCHAR(10),
	@TEAM_SEQ			INT,
	@TEAM_NAME			VARCHAR(20),
	@PARENT_TEAM_SEQ	INT,
	@COM_NUMBER			VARCHAR(20),
	@ORDER_NUM			INT,
	@USE_YN				CHAR(1),
	@EDT_SEQ			INT
AS 
BEGIN

	UPDATE COM_TEAM SET
		TEAM_NAME = @TEAM_NAME
		, PARENT_TEAM_SEQ = @PARENT_TEAM_SEQ
		, COM_NUMBER = @COM_NUMBER
		, ORDER_NUM = @ORDER_NUM
		, USE_YN = @USE_YN
		, EDT_SEQ = @EDT_SEQ
		, EDT_DATE = GETDATE()
	WHERE AGT_CODE = @AGT_CODE AND TEAM_SEQ = @TEAM_SEQ

END 



GO
