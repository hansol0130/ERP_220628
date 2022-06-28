USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ USP_Name					: SP_ACC_PAY_CHANGE_INS  
■ Description				: 이동전표 생성 프로시저
■ Input Parameter			:                     
		@FROM_PRO_CODE		: 이동전 행사코드
		@FROM_RES_CODE		: 이동전 예약코드
		@TO_PRO_CODE		: 이동할 행사코드
		@TO_RES_CODE		: 이동할 예약코드
		@EMP_CODE			: 작업자 코드
		@ERRORCODE			: 에러 코드
		@ERRORMSG			: 에러 메세지
■ Output Parameter			:                
         @VISION_CONTENT	:
■ Output Value				:                 
■ Exec						: EXEC SP_ACC_PAY_CHANGE_INS  
■ Author					: 
■ Date						:  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
2015-12-23			김성호			최초생성
2016-01-22			김성호			전표생성자 이소연대리로 통일
2017-10-24			김성호			전표생성자 전가영계장으로 통일
-------------------------------------------------------------------------------------------------*/ 

CREATE PROCEDURE [dbo].[SP_ACC_PAY_CHANGE_INS]
(
	@FROM_PRO_CODE		VARCHAR(20),
	@FROM_RES_CODE		CHAR(12),
	@TO_PRO_CODE		VARCHAR(20),
	@TO_RES_CODE		CHAR(12),
	@EMP_CODE			CHAR(7),
	@ERRORCODE			INTEGER OUTPUT,
	@ERRORMSG			VARCHAR(1000) OUTPUT
)
AS
BEGIN

	BEGIN TRY

	-- 등록자 재무회계팀 전가영계장 통일
	SET @EMP_CODE = '2012040';

	IF EXISTS(
		SELECT 1
		FROM PAY_MATCHING A WITH(NOLOCK)
		INNER JOIN PAY_MASTER_damo B WITH(NOLOCK) ON A.PAY_SEQ = B.PAY_SEQ
		WHERE A.RES_CODE = @FROM_RES_CODE AND B.PAY_TYPE NOT IN (10) AND B.CLOSED_YN = 'Y' AND A.CXL_YN = 'N'
	)
	BEGIN

		DECLARE @SLIP_MK_SEQ SMALLINT, @DAY VARCHAR(8), @RET INT, @PART_PRICE INT, @TEMP VARCHAR(100), @REMARK VARCHAR(200)

		--SELECT @DAY = CONVERT(VARCHAR(8), GETDATE(), 112), @REMARK = (@FROM_PRO_CODE + ' > ' + @TO_PRO_CODE);
		SELECT @DAY = CONVERT(VARCHAR(8), GETDATE(), 112), @TEMP = ('[예약이동] ' + @FROM_RES_CODE + ' > ' + @TO_RES_CODE + ' ');

		-- SLIP_FG : 3 대체전표
		-- JUNL_FG : RM 예약이동전표
        EXEC @SLIP_MK_SEQ = SP_ACC_SLIPM_SEQ @DAY, @EMP_CODE, '3', 'RM'

		DECLARE MY_CURSOR SCROLL CURSOR FOR

			SELECT A.PART_PRICE, (@TEMP + ISNULL(B.PAY_NAME, ''))
			FROM PAY_MATCHING A WITH(NOLOCK)
			INNER JOIN PAY_MASTER_damo B WITH(NOLOCK) ON A.PAY_SEQ = B.PAY_SEQ
			WHERE A.RES_CODE = @FROM_RES_CODE AND B.PAY_TYPE NOT IN (10) AND B.CLOSED_YN = 'Y' AND A.CXL_YN = 'N'

		OPEN MY_CURSOR

		FETCH NEXT FROM MY_CURSOR INTO @PART_PRICE, @REMARK

		WHILE (@@FETCH_STATUS = 0)
		BEGIN

			-- 차변
			EXEC @RET = SP_ACC_SLIPD_INS_NEW @DAY, @SLIP_MK_SEQ, '27300', '1', NULL, NULL, @EMP_CODE
				, @FROM_PRO_CODE, NULL, @PART_PRICE, 0, @REMARK, @EMP_CODE, NULL, NULL, NULL

			IF @RET <> 0 GOTO ERR_HANDLER

			-- 대변
			EXEC @RET = SP_ACC_SLIPD_INS_NEW @DAY, @SLIP_MK_SEQ, '27300', '2', NULL, NULL, @EMP_CODE
				, @TO_PRO_CODE, NULL, 0, @PART_PRICE, @REMARK, @EMP_CODE, NULL, NULL, NULL

			IF @RET <> 0 GOTO ERR_HANDLER

			FETCH NEXT FROM MY_CURSOR INTO @PART_PRICE, @REMARK
		END

		CLOSE MY_CURSOR
		DEALLOCATE MY_CURSOR

		SET @ERRORMSG = '[예약이동전표생성완료]'

	END

	--COMMIT TRAN
	RETURN 0

	END TRY
	BEGIN CATCH 
		SET @ERRORCODE = 999
		SET @ERRORMSG = @ERRORMSG + ERROR_MESSAGE()

		RETURN -1
	END CATCH

	ERR_HANDLER:
		SELECT @ERRORCODE = 600, @ERRORMSG = '[전표생성 실패]'

		RETURN -1  
END

GO
