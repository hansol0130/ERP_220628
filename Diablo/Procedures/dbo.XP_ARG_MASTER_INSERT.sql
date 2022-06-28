USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ARG_MASTER_INSERT
■ DESCRIPTION				: 수배마스터 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	DECLARE @COUNT INT
	exec XP_ARG_MASTER_INSERT 0, '92687' ,'' ,'APP5042-130803' ,0 ,'2013-08-03 00:00:00.000' ,'2013-08-08 00:00:00.000' ,6 ,4 ,'9999999'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-22		이규식			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_MASTER_INSERT]
	@ARG_SEQ_NO INT OUTPUT,
 	@AGT_CODE VARCHAR(10),
	@RES_CODE VARCHAR(12),
	@PRO_CODE VARCHAR(20),
	@ARG_STATUS INT,
	@DEP_DATE DATETIME,
	@ARR_DATE DATETIME,
	@DAY INT,
	@NIGHTS INT,
	@NEW_CODE VARCHAR(7)
AS 
BEGIN
	SET @ARG_SEQ_NO = 0


	IF @PRO_CODE <> '' OR @RES_CODE <> ''
		BEGIN
			IF @RES_CODE <> ''
				BEGIN
					SELECT @ARG_SEQ_NO = ARG_SEQ_NO FROM ARG_MASTER 
					--WHERE (PRO_CODE = @PRO_CODE OR RES_CODE = @RES_CODE) 
					WHERE (PRO_CODE = @PRO_CODE OR RES_CODE = @RES_CODE) AND AGT_CODE = @AGT_CODE
				END
			ELSE
				BEGIN
					SELECT @ARG_SEQ_NO = ARG_SEQ_NO FROM ARG_MASTER 
					--WHERE PRO_CODE = @PRO_CODE
					WHERE PRO_CODE = @PRO_CODE  AND AGT_CODE = @AGT_CODE
				END

			-- 이미 수배마스터가 존재할경우에는 기존 수배마스터 정보를 리턴한다
			-- 변경 -> 기존 데이터 있을경우 에러(-1) 리턴
			-- 재변경 -> 수배마스터가 존재할경우에는 기존 수배마스터 정보를 리턴한다
			/*
			IF ISNULL(@ARG_SEQ_NO, 0) > 0 
				BEGIN
					SET @ARG_SEQ_NO = -1
				END
			*/

		END

	IF @ARG_SEQ_NO = 0
		BEGIN
			-- 행사코드가 없고 예약코드만 있을 경우 행사코드를 설정한다
			IF ISNULL(@PRO_CODE, '') = '' AND ISNULL(@RES_CODE, '') <> '' 
			BEGIN
				SELECT @PRO_CODE = PRO_CODE FROM RES_MASTER WHERE RES_CODE = @RES_CODE
			END

			INSERT INTO ARG_MASTER
				   (AGT_CODE
				   ,RES_CODE
				   ,PRO_CODE
				   ,ARG_STATUS
				   ,DEP_DATE
				   ,ARR_DATE
				   ,DAY
				   ,NIGHTS
				   ,NEW_CODE)
			VALUES
				   (@AGT_CODE
				   ,@RES_CODE
				   ,@PRO_CODE
				   ,@ARG_STATUS
				   ,@DEP_DATE
				   ,@ARR_DATE
				   ,@DAY
				   ,@NIGHTS
				   ,@NEW_CODE)

			SET @ARG_SEQ_NO = SCOPE_IDENTITY()

		END

	SELECT @ARG_SEQ_NO
END 

GO
