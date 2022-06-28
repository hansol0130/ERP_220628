USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CHECKLIST_INSERT
■ DESCRIPTION				: 입력_체크리스트값
■ INPUT PARAMETER			: RES_CODE, SEQ_NO, CHECK_VALUE
■ EXEC						: 
    -- SP_MOV2_CHECKLIST_INSERT 'RP1703032908', 1, 20		-- 출발자(RP1703032908, 1) 입력_체크리스트값

■ MEMO						: 체크리스트값을 입력한다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26		오준욱(IBSOLUTION)		최초생성
   2017-10-11		김성호					EXISTS 사용으로 수정
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CHECKLIST_INSERT]
	@RES_CODE		VARCHAR(20),
	@SEQ_NO			VARCHAR(20),
	@CHECK_VALUE    VARCHAR(20)
AS
BEGIN
	--DECLARE @MEMO_CNT INT
	
	--SELECT @MEMO_CNT = COUNT(*) FROM TRAVEL_CHECKLIST A WITH (NOLOCK)
	--WHERE A.RES_CODE = @RES_CODE AND A.SEQ_NO = @SEQ_NO

	--IF (@MEMO_CNT < 1)
	IF NOT EXISTS(SELECT 1 FROM TRAVEL_CHECKLIST A WITH (NOLOCK) WHERE A.RES_CODE = @RES_CODE AND A.SEQ_NO = @SEQ_NO)
		BEGIN
			INSERT INTO TRAVEL_CHECKLIST (RES_CODE, SEQ_NO, CHECK_VALUE, NEW_DATE)
			VALUES ( @RES_CODE , @SEQ_NO, @CHECK_VALUE, GETDATE())
		END
	ELSE
		BEGIN
			UPDATE TRAVEL_CHECKLIST
			SET CHECK_VALUE = @CHECK_VALUE, 
				NEW_DATE = GETDATE()
			WHERE RES_CODE = @RES_CODE AND SEQ_NO = @SEQ_NO
		END
END           



GO
