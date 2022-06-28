USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_PREFER_UPDATE
■ DESCRIPTION				: BTMS 선호/비선호 상품 추가 및 삭제
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@PRE_SEQ				: 출장그룹 순번
	@PRO_TYPE				: 상품코드 (항공 A, 호텔 H)
	@PREFER_YN				: 선호상태 (선호 Y, 비선호 N)
	@PRE_CODE				: 코드
	@NEW_SEQ				: 등록자
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-31		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_PREFER_UPDATE]
	@AGT_CODE		VARCHAR(10),
	@PRE_SEQ		INT,
	@PRO_TYPE		CHAR(1),
	@PREFER_YN		CHAR(1),
	@PRE_CODE		VARCHAR(20),
	@NEW_SEQ		INT
AS 
BEGIN

	IF EXISTS(SELECT 1 FROM COM_PREFER WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE AND PRE_SEQ = @PRE_SEQ)
	BEGIN
		DELETE FROM COM_PREFER WHERE AGT_CODE = @AGT_CODE AND PRE_SEQ = @PRE_SEQ
	END
	ELSE
	BEGIN
		SELECT @PRE_SEQ = (ISNULL((SELECT MAX(PRE_SEQ) FROM COM_PREFER WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE), 0) + 1)

		INSERT INTO COM_PREFER (AGT_CODE, PRE_SEQ, PRO_TYPE, PREFER_YN, PRE_CODE, NEW_DATE, NEW_SEQ)
		SELECT @AGT_CODE, @PRE_SEQ, @PRO_TYPE, @PREFER_YN, @PRE_CODE, GETDATE(), @NEW_SEQ
	END

END

GO
