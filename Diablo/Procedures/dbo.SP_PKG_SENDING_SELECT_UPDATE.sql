USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_SENDING_SELECT_UPDATE
■ DESCRIPTION				: 샌딩 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
    2017-04-17		정지용			최초생성
	2018-02-20		김성호			고유키생성 ex: 2K001 (1년 범위 UNIQUE) 첫자리:월,둘째자리:일,나머지:일련번호
	2018-03-06		김성호			고유키생성 ex: M06001 (월 범위 UNIQUE) 첫자리:공항터미널,둘셋째자리:일자,나머지:일련번호
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_SENDING_SELECT_UPDATE]
	@SEQ_NO INT,
	@PRO_CODE VARCHAR(20),
	@PRO_NAME VARCHAR(200),
	@DEP_DATE DATETIME,
	@DEP_TIME CHAR(5),
	@TRANS_NAME VARCHAR(15),
	@MEET_CNT INT,
	@CONTRACT_CNT INT,
	@RECEIPT_CNT INT,
	@MEET_COUNTER INT,
	@MEET_DATE DATETIME,
	@MEET_TIME CHAR(5),
	@REMARK VARCHAR(2000),
	@MANAGER_CODE VARCHAR(7),
	@INNER_NUMBER VARCHAR(4),
	@EMR_TEL_NUMBER VARCHAR(11),
	@TC_YN CHAR(1),
	@EDT_CODE CHAR(7)
AS 
BEGIN
	SET NOCOUNT OFF;

	BEGIN TRY

	BEGIN TRAN

	-- 고유키 발급 **************************************************************************************************************
	DECLARE @SEND_KEY VARCHAR(6)--, @MEET_COUNTER_VAL CHAR(1), @MEET_DAY CHAR(2);	

	IF EXISTS(SELECT 1 FROM PKG_SENDING A WITH(NOLOCK) WHERE A.SEQ_NO = @SEQ_NO AND A.MEET_DATE = @MEET_DATE AND A.MEET_COUNTER = @MEET_COUNTER)
	BEGIN
		-- 미팅장소 & 미팅날짜 변화가 없을 때
		SELECT @SEND_KEY = A.SEND_KEY FROM PKG_SENDING A WITH(NOLOCK) WHERE A.SEQ_NO = @SEQ_NO
	END
	ELSE IF EXISTS(SELECT 1 FROM PKG_SENDING A WITH(NOLOCK) WHERE A.SEQ_NO = @SEQ_NO AND A.MEET_DATE = @MEET_DATE)
	BEGIN
		-- 미팅장소가 변경될 때
		SELECT @SEND_KEY = (CASE @MEET_COUNTER WHEN 2 THEN 'M' WHEN 4 THEN 'H' WHEN 3 THEN 'G' END) + SUBSTRING(SEND_KEY, 2, 5) FROM PKG_SENDING A WITH(NOLOCK) WHERE A.SEQ_NO = @SEQ_NO
	END
	ELSE
	BEGIN
		-- 미팅날짜가 변경될 때
		--SELECT @MEET_COUNTER_VAL = CASE @MEET_COUNTER WHEN 2 THEN 'M' WHEN 4 THEN 'H' WHEN 3 THEN 'G' END, @MEET_DAY = FORMAT(@MEET_DATE, 'dd');
		--SET @SEND_KEY = @MEET_COUNTER_VAL + @MEET_DAY;
		SELECT @SEND_KEY = (CASE @MEET_COUNTER WHEN 2 THEN 'M' WHEN 4 THEN 'H' WHEN 3 THEN 'G' END) + FORMAT(@MEET_DATE, 'dd')
		SELECT @SEND_KEY = (@SEND_KEY + RIGHT(('000' + CONVERT(VARCHAR(3), ISNULL(MAX(SUBSTRING(A.SEND_KEY, 4, 3)), 0) + 1)), 3))
		FROM PKG_SENDING A WITH(NOLOCK)
		WHERE A.MEET_DATE = @MEET_DATE;
	END
	-- **************************************************************************************************************************

	UPDATE PKG_SENDING SET 
		PRO_CODE = @PRO_CODE,
		PRO_NAME = @PRO_NAME,
		DEP_DATE = @DEP_DATE,
		DEP_TIME = @DEP_TIME,
		TRANS_NAME = @TRANS_NAME,
		MEET_CNT = @MEET_CNT,
		CONTRACT_CNT = @CONTRACT_CNT,
		RECEIPT_CNT = @RECEIPT_CNT,
		MEET_COUNTER = @MEET_COUNTER,
		MEET_DATE = @MEET_DATE,
		MEET_TIME = @MEET_TIME,
		MANAGER_CODE = @MANAGER_CODE, 
		INNER_NUMBER = @INNER_NUMBER, 
		EMR_TEL_NUMBER = @EMR_TEL_NUMBER,
		REMARK = @REMARK,
		TC_YN = @TC_YN,
		EDT_CODE = @EDT_CODE,
		EDT_DATE = GETDATE(),
		SEND_KEY = @SEND_KEY
	WHERE SEQ_NO = @SEQ_NO;

	COMMIT TRAN

	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN;
	END CATCH
END
GO
