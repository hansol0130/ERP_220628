USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_PASSPORT_INFO_MASTER_INSERT
■ DESCRIPTION				: 입력_여권정보등록마스터
■ INPUT PARAMETER			: @key
■ EXEC						: 
    -- SP_MOV2_PASSPORT_INFO_MASTER_INSERT 

■ MEMO						: 여권정보등록마스터-한글이름등록포함
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-19		아이비솔루션				최초생성
   2019-01-23		김남훈					Date 조건 Try Catch
   2019-02-13		김남훈					비 로그인자 여권정보 등록 추가
   2019-12-20		김성호					잘못된 D'Amo Function 사용 수정
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_PASSPORT_INFO_MASTER_INSERT]
	@KEY				VARCHAR(1000)
AS

BEGIN
	DECLARE @RES_CODE CHAR(12), @CUS_IDENTIFY VARCHAR(MAX), @RES_NO INT, @PASS_STATUS INT, @CUS_NO INT;
	DECLARE @CUS_YN CHAR(1), @NEW_CODE CHAR(7);
	DECLARE @LAST_NAME VARCHAR(20), @FIRST_NAME VARCHAR(20), @GENDER CHAR(1), @BIRTH_DATE VARCHAR(20), @NOR_TEL1 VARCHAR(6);
	DECLARE @NOR_TEL2 VARCHAR(5), @NOR_TEL3 VARCHAR(4), @PASS_NUM VARCHAR(20), @PASS_ISSUE VARCHAR(20), @PASS_EXPIRE VARCHAR(20);
	DECLARE @SEQ_NO INT;
	DECLARE @PPT_NO INT, @CUS_NAME VARCHAR(40);
	DECLARE @CATCH CHAR(1);

	BEGIN TRY
		SET @BIRTH_DATE = CONVERT(DATETIME, DBO.FN_PARAM(@KEY, 'BirthDateS'));
	END TRY
	BEGIN CATCH
		SET @BIRTH_DATE = NULL
	END CATCH

	BEGIN TRY
		SET @PASS_ISSUE = CONVERT(DATETIME, DBO.FN_PARAM(@KEY, 'PassportIssueS'));
	END TRY
	BEGIN CATCH
		SET @PASS_ISSUE = NULL
	END CATCH

	BEGIN TRY
		SET @PASS_EXPIRE = CONVERT(DATETIME, DBO.FN_PARAM(@KEY, 'PassportExpireS'));
	END TRY
	BEGIN CATCH
		SET @PASS_EXPIRE = NULL
	END CATCH

	BEGIN TRAN
		BEGIN TRY

			SELECT
				@RES_CODE = DBO.FN_PARAM(@KEY, 'ReserveCode'),
				@CUS_IDENTIFY = DBO.FN_PARAM(@KEY, 'CustomerIdentify'),
				@RES_NO = CONVERT(INT, DBO.FN_PARAM(@KEY, 'ResNo')),
				@PASS_STATUS = CONVERT(INT, DBO.FN_PARAM(@KEY, 'PassportStatus')),
				@CUS_YN = DBO.FN_PARAM(@KEY, 'CustomerAgreeYN'),
				@NEW_CODE = DBO.FN_PARAM(@KEY, 'NewCode'),
				@LAST_NAME = DBO.FN_PARAM(@KEY, 'LastName'),
				@FIRST_NAME = DBO.FN_PARAM(@KEY, 'FirstName'),
				@GENDER = DBO.FN_PARAM(@KEY, 'Gender'),
				@PASS_NUM = DBO.FN_PARAM(@KEY, 'PassportNum'),
				@SEQ_NO = CONVERT(INT, DBO.FN_PARAM(@KEY, 'SeqNo')),
				@CUS_NAME = DBO.FN_PARAM(@KEY, 'CustomerName')

			SELECT @CUS_NO = CUS_NO FROM RES_CUSTOMER_damo WHERE RES_CODE = @RES_CODE AND SEQ_NO = @RES_NO
		
			
			SELECT @PPT_NO = ISNULL(MAX(PPT_NO) + 1, 1) FROM PPT_MASTER WHERE RES_CODE = @RES_CODE

			IF(charindex('RT', @RES_CODE) <> 1)
			BEGIN
				INSERT INTO PPT_MASTER (RES_CODE, PPT_NO, CUS_IDENTIFY, RES_NO, PASS_STATUS, CUS_NO, CUS_YN, NEW_CODE, NEW_DATE) 
				VALUES ( @RES_CODE, @PPT_NO, @CUS_IDENTIFY, @RES_NO, @PASS_STATUS, @CUS_NO, @CUS_YN, @NEW_CODE, GETDATE() ) 
			END

			UPDATE RES_CUSTOMER_damo 
			SET LAST_NAME = @LAST_NAME,
				FIRST_NAME = @FIRST_NAME,
				GENDER = @GENDER,
				BIRTH_DATE = @BIRTH_DATE,		
				sec_PASS_NUM = damo.dbo.enc_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM',@PASS_NUM),
				PASS_ISSUE = @PASS_ISSUE,
				PASS_EXPIRE = @PASS_EXPIRE,
				PPT_NO = @PPT_NO
			WHERE RES_CODE = @RES_CODE 
				AND SEQ_NO = @SEQ_NO
			
			IF(charindex('RT', @RES_CODE) <> 1)
			BEGIN
				INSERT INTO PPT_MASTER_LOG_damo	( RES_CODE, PPT_NO, LAST_NAME, FIRST_NAME, GENDER, BIRTH_DATE, sec_PASS_NUM, PASS_ISSUE, PASS_EXPIRE, row_id, KOR_NAME)
				VALUES ( @RES_CODE, @PPT_NO, @LAST_NAME, @FIRST_NAME, @GENDER, @BIRTH_DATE, 
				--2019/12/20 수정
				--damo.dbo.enc_varchar('DIABLO','dbo.PPT_MASTER_LOG_damo','PASS_NUM',@PASS_NUM), @PASS_ISSUE, @PASS_EXPIRE, NEWID(), @CUS_NAME)
				damo.dbo.enc_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM',@PASS_NUM), @PASS_ISSUE, @PASS_EXPIRE, NEWID(), @CUS_NAME)
			END

			IF @@TRANCOUNT > 0
			BEGIN
				COMMIT TRAN;
				SELECT @PPT_NO;
			END		

		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRAN;
				SELECT -1;
			END
		END CATCH
END
GO
