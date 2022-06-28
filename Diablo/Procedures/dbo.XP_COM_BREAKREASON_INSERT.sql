USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BREAKREASON_INSERT
■ DESCRIPTION				: BTMS 거래처 취소 사유 리스트 사용유무 일괄 업데이트
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@REASON_SEQ				: 사유순번
	@PRO_TYPE				: 구분타입 (C: 공통, A: 항공, H: 호텔)
	@REASON_REMARK			: 비고사항
	@USE_YN					: 사용유무
	@NEW_SEQ				: 등록자코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-01		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BREAKREASON_INSERT]
	@AGT_CODE		VARCHAR(10),
	@REASON_SEQ		INT,
	@PRO_TYPE		CHAR(1),
	@REASON_REMARK	VARCHAR(50),
	@USE_YN			CHAR(1),
	@NEW_SEQ		INT
AS 
BEGIN

	SELECT @REASON_SEQ = ISNULL((SELECT MAX(REASON_SEQ) FROM COM_BREAK_REASON A WITH(NOLOCK) WHERE A.AGT_CODE = @AGT_CODE), 0) + 1

	INSERT INTO COM_BREAK_REASON (AGT_CODE, REASON_SEQ, PRO_TYPE, REASON_REMARK, USE_YN, NEW_DATE, NEW_SEQ)
	VALUES (@AGT_CODE, @REASON_SEQ, @PRO_TYPE, @REASON_REMARK, @USE_YN, GETDATE(), @NEW_SEQ);

END

GO
