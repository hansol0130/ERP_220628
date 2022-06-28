USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_HBS_DETAIL_INSERT
■ DESCRIPTION				: 게시물 등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-29		김성호			최초생성
   2013-06-17		김성호			마스터코드 유효성 검사
   2013-06-27		김성호			답변글 본문과 마스터코드 동기화
   2017-08-03		박형만			티몬항공일때 예약코드가 마스터코드로 올바르게 들어가도록 예외처리 
   2019-06-03						예약번호추가됨 
   2019-12-13		박형만			제목없을때 제목없음 으로 처리 
   2020-05-25		김영민(EHD)		NOTICE_YN  = N 기본값 
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_HBS_DETAIL_INSERT]
(
	@MASTER_SEQ		INT,
	@BOARD_SEQ		INT,
	@CATEGORY_SEQ	INT,
	@PARENT_SEQ		INT,
	@LEVEL			INT,
	@STEP			INT,
	@SUBJECT		NVARCHAR(400),
	@CONTENTS		NVARCHAR(MAX),
	@NOTICE_YN		VARCHAR(1),
	@DEL_YN			VARCHAR(1),
	@IP_ADDRESS		VARCHAR(15),
	@FILE_PATH		NVARCHAR(500),
	@EDIT_PASS		VARCHAR(60),
	@LOCK_YN		VARCHAR(1),
	@MASTER_CODE	VARCHAR(20),
	@REGION_NAME	VARCHAR(30),
	@NICKNAME		VARCHAR(20),
	@PHONE_NUM		VARCHAR(30),
	@EMAIL			VARCHAR(50),
	@NEW_CODE		INT,
	@EMP_CODE		VARCHAR(7),
	@RES_CODE       VARCHAR(20) = NULL
)

AS  
BEGIN

	BEGIN TRY

		BEGIN TRAN

		SELECT @BOARD_SEQ = ISNULL(MAX(BOARD_SEQ), 0) + 1 FROM HBS_DETAIL WITH(NOLOCK) WHERE MASTER_SEQ = @MASTER_SEQ;

		IF LEN(@MASTER_CODE) > 1 AND @MASTER_SEQ <> 4 AND @CATEGORY_SEQ <> 90 
		BEGIN
			IF EXISTS(SELECT 1 FROM RES_MASTER_damo WITH(NOLOCK) WHERE RES_CODE = @MASTER_CODE)
				SELECT @MASTER_CODE = MASTER_CODE FROM RES_MASTER_damo WITH(NOLOCK) WHERE RES_CODE = @MASTER_CODE
			ELSE IF EXISTS(SELECT 1 FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @MASTER_CODE)
				SELECT @MASTER_CODE = MASTER_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @MASTER_CODE
			ELSE IF NOT EXISTS(SELECT 1 FROM PKG_MASTER WITH(NOLOCK) WHERE MASTER_CODE = @MASTER_CODE)
				SELECT @MASTER_CODE = ''

			-- 마스터코드가 있고 지역명이 없을때 지역명을 넣어준다
			IF ISNULL(@REGION_NAME, '') = '' AND LEN(@MASTER_CODE) > 1
			BEGIN
				SELECT @REGION_NAME = KOR_NAME FROM PUB_REGION WITH(NOLOCK) WHERE [SIGN] = SUBSTRING(@MASTER_CODE, 1, 1)
			END

			-- 답변글일때 본문과 마스터코드를 동기화 한다
			IF @LEVEL > 0
			BEGIN
				UPDATE HBS_DETAIL SET MASTER_CODE = @MASTER_CODE WHERE MASTER_SEQ = @MASTER_SEQ AND BOARD_SEQ = @PARENT_SEQ
			END
		END

		--제목없는 경우 제목없음 넣어줌 
		IF ISNULL(@SUBJECT,'') = '' 
		BEGIN
			SET @SUBJECT = '제목없음'
		END 

		INSERT INTO HBS_DETAIL (
			MASTER_SEQ, BOARD_SEQ, CATEGORY_SEQ, PARENT_SEQ, 
			LEVEL, STEP, SUBJECT, CONTENTS, SHOW_COUNT, NOTICE_YN, 
			DEL_YN, IP_ADDRESS, COMPLETE_YN, FILE_PATH, EDIT_PASS, LOCK_YN, MASTER_CODE, REGION_NAME, 
			NICKNAME, PHONE_NUM, EMAIL, NEW_DATE, NEW_CODE, EMP_CODE, RES_CODE
		) VALUES (
			@MASTER_SEQ, @BOARD_SEQ, @CATEGORY_SEQ, (CASE WHEN @PARENT_SEQ = 0 THEN @BOARD_SEQ ELSE @PARENT_SEQ END), 
			@LEVEL, @STEP, @SUBJECT, @CONTENTS, 0, 'N', 
			'N', @IP_ADDRESS, 'N', @FILE_PATH, @EDIT_PASS, @LOCK_YN, @MASTER_CODE, @REGION_NAME, 
			@NICKNAME, @PHONE_NUM, @EMAIL, GETDATE(), @NEW_CODE, @EMP_CODE, @RES_CODE
		);

		-- 답변 완료 처리
		IF @PARENT_SEQ > 0
			UPDATE HBS_DETAIL SET COMPLETE_YN = 'Y' WHERE MASTER_SEQ = @MASTER_SEQ AND BOARD_SEQ = @PARENT_SEQ;

		COMMIT TRAN

	END TRY
	BEGIN CATCH

		ROLLBACK TRAN

	END	CATCH

	-- 디테일 순번 리턴
	SELECT @BOARD_SEQ;

END


GO
