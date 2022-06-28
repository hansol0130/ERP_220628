USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_MASTER_UPDATE
■ DESCRIPTION				: BTMS 거래처 기본정보 수정
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-23		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_MASTER_UPDATE]
	@AGT_CODE		VARCHAR(10),
	@NOR_TEL1		VARCHAR(6),
	@NOR_TEL2		VARCHAR(5),
	@NOR_TEL3		VARCHAR(4),
	@FAX_TEL1		VARCHAR(6),
	@FAX_TEL2		VARCHAR(5),
	@FAX_TEL3		VARCHAR(4),
	@AGT_MGR_NAME	VARCHAR(20),
	@AGT_MGR_EMAIL	VARCHAR(50),
	@AGT_MGR_TEL1	VARCHAR(6),
	@AGT_MGR_TEL2	VARCHAR(5),
	@AGT_MGR_TEL3	VARCHAR(4),
	@AGT_MGR_HAND1	VARCHAR(4),
	@AGT_MGR_HAND2	VARCHAR(4),
	@AGT_MGR_HAND3	VARCHAR(4),
	@URL			VARCHAR(50),
	@CON_START_DATE	DATETIME,
	@CON_END_DATE	DATETIME,
	@EDT_SEQ		INT

AS 
BEGIN

	UPDATE A SET A.NOR_TEL1 = @NOR_TEL1, A.NOR_TEL2 = @NOR_TEL2, A.NOR_TEL3 = @NOR_TEL3, A.FAX_TEL1 = @FAX_TEL1, A.FAX_TEL2 = @FAX_TEL2, A.FAX_TEL3 = @FAX_TEL3
		, A.AGT_MGR_NAME = @AGT_MGR_NAME, A.AGT_MGR_EMAIL = @AGT_MGR_EMAIL, A.AGT_MGR_TEL1 = @AGT_MGR_TEL1, A.AGT_MGR_TEL2 = @AGT_MGR_TEL2, A.AGT_MGR_TEL3 = @AGT_MGR_TEL3
		, A.AGT_MGR_HAND1 = @AGT_MGR_HAND1, A.AGT_MGR_HAND2 = @AGT_MGR_HAND2, A.AGT_MGR_HAND3 = @AGT_MGR_HAND3, A.URL = @URL
	FROM AGT_MASTER A
	WHERE A.AGT_CODE = @AGT_CODE

	IF EXISTS(SELECT 1 FROM COM_MASTER A WITH(NOLOCK) WHERE A.AGT_CODE = @AGT_CODE)
	BEGIN
		UPDATE COM_MASTER SET CON_START_DATE = @CON_START_DATE, CON_END_DATE = @CON_END_DATE, EDT_DATE = GETDATE(), EDT_SEQ = @EDT_SEQ WHERE AGT_CODE = @AGT_CODE
	END

END 





GO
