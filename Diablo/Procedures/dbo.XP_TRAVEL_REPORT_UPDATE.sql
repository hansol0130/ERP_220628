USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_TRAVEL_REPORT_UPDATE
■ DESCRIPTION				: 사외업무시스템 출장보고서 저장
■ INPUT PARAMETER			: 
		
   	
■ OUTPUT PARAMETER			: 
							: 
■ EXEC						: 

	exec XP_TRAVEL_REPORT_UPDATE @OTR_SEQ=14,@EDI_CODE=NULL,@PRO_CODE=N'XPP3019-190518',@NEW_CODE=N'T140262',@AGT_CODE=N'',@PAY_ASSIGN=0,@SEAT_COUNT=25,@SEAT_BELT_YN=N'Y',@SEAT_REMARK=N'',@REMARK=N'',@SUG_REMARK=N'',
		@KEY=N'H|B|1|||||largo_menu_02.jpg|@H|B|2|||||@H|W|1|||||@M|B|1|||||@M|W|1|||||btn_menu_05.png|largo_menu_02_ov.jpg|img_largo_main - 복사본 (2).jpg|@',@OTR_STATE=1
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-04-15		이명훈			생성   
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_TRAVEL_REPORT_UPDATE]
(
	@OTR_SEQ INT,
	@EDI_CODE VARCHAR(20),
	@OTR_STATE INT,
	@PRO_CODE VARCHAR(20),
	@NEW_CODE VARCHAR(10),
	@AGT_CODE VARCHAR(10),
	@PAY_ASSIGN INT,
	@SEAT_COUNT INT,
	@SEAT_BELT_YN CHAR,
	@SEAT_REMARK VARCHAR(MAX),
	@REMARK VARCHAR(MAX),
	@SUG_REMARK VARCHAR(MAX),
	@KEY VARCHAR(MAX)
)
AS  
BEGIN
	-- 마스터는 업데이트
    UPDATE TRAVEL_REPORT_MASTER
	SET AGT_CODE = @AGT_CODE, PAY_ASSIGN = @PAY_ASSIGN, OTR_STATE = @OTR_STATE, EDI_CODE = @EDI_CODE, SEAT_COUNT = @SEAT_COUNT, SEAT_BELT_YN = @SEAT_BELT_YN, SEAT_REMARK = @SEAT_REMARK, REMARK = @REMARK, SUG_REMARK = @SUG_REMARK
	WHERE OTR_SEQ = @OTR_SEQ


	-- 디테일은 삭제후 다시 인서트
	DELETE FROM TRAVEL_REPORT_DETAIL WHERE OTR_SEQ = @OTR_SEQ

	DECLARE @ROW INT,
			@ROW_COUNT INT,
			@ROW_STR VARCHAR(MAX),
			@STR VARCHAR(MAX),
			@SECTION CHAR,
			@BEST_WORST CHAR,
			@SEQ_NO INT,
			@NAME VARCHAR(100),
			@SECTION_CODE VARCHAR(10),
			@CLASSIFY VARCHAR(20),
			@REASON VARCHAR(MAX),
			@FILE1 VARCHAR(MAX),
			@FILE2 VARCHAR(MAX),
			@FILE3 VARCHAR(MAX)

	DECLARE @SN INT,	-- START_NUM
			@EN INT		-- END_NUM

	SET @ROW_COUNT = LEN(@KEY) - LEN(REPLACE(@KEY, '@', ''))
	SET @ROW = 1

	WHILE @ROW <= @ROW_COUNT
	BEGIN
		SET @ROW_STR = dbo.FN_SPLIT_LONG(@KEY, '@', @ROW)

		SET @SECTION = dbo.FN_SPLIT_LONG(@ROW_STR, '|', 1)
		SET @BEST_WORST = dbo.FN_SPLIT_LONG(@ROW_STR, '|', 2)
		SET @SEQ_NO = dbo.FN_SPLIT_LONG(@ROW_STR, '|', 3)
		SET @NAME = dbo.FN_SPLIT_LONG(@ROW_STR, '|', 4)
		SET @SECTION_CODE = dbo.FN_SPLIT_LONG(@ROW_STR, '|', 5)
		SET @CLASSIFY = dbo.FN_SPLIT_LONG(@ROW_STR, '|', 6)
		SET @REASON = dbo.FN_SPLIT_LONG(@ROW_STR, '|', 7)
		SET @FILE1 = dbo.FN_SPLIT_LONG(@ROW_STR, '|', 8)
		SET @FILE2 = dbo.FN_SPLIT_LONG(@ROW_STR, '|', 9)
		SET @FILE3 = dbo.FN_SPLIT_LONG(@ROW_STR, '|', 10)

		INSERT INTO TRAVEL_REPORT_DETAIL(OTR_SEQ, SECTION, BEST_WORST, SEQ_NO, NAME, SECTION_CODE, CLASSIFY, REASON, FILE1, FILE2, FILE3)
		VALUES(@OTR_SEQ, @SECTION, @BEST_WORST, @SEQ_NO, @NAME, @SECTION_CODE, @CLASSIFY, @REASON, @FILE1, @FILE2, @FILE3)

		SET @ROW += 1
	END

END
GO
