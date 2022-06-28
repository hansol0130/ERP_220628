USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_CUS_CLEAR_TARGET_INSERT
■ DESCRIPTION				: 고객정보 매핑 통합 대상 회원 테이블 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 


------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2018-05-17		박형만			최초생성 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_CUS_CLEAR_TARGET_INSERT]
	--@ERROR_MSG		VARCHAR(1000) OUTPUT,
	@RES_CODE	RES_CODE,
	@SEQ_NO	INT,
	@DEP_DATE	DATETIME,
	@CUS_NAME VARCHAR(50),
	@OLD_CUS_NO	INT = 0,
	@TARGET_CUS_NO	VARCHAR(1000) = NULL,
	@TARGET_CNT	INT = 0,
	@TARGET_TYPE INT = 0,
	@CHK_TYPE INT = 0,
	@CHK_TEXT VARCHAR(500) = NULL ,
	@STATUS INT = 0 , 
	@REMARK	VARCHAR(1000) = NULL

AS
BEGIN
	-- 등록이 안되었을경우 
	IF NOT  EXISTS (
		SELECT * FROM CUS_CLEAR_TARGET WITH(NOLOCK)
		WHERE RES_CODE = @RES_CODE
		AND SEQ_NO = @SEQ_NO )
	BEGIN
		INSERT INTO CUS_CLEAR_TARGET (RES_CODE,SEQ_NO,DEP_DATE,CUS_NAME,OLD_CUS_NO,TARGET_CUS_NO,TARGET_CNT,TARGET_TYPE,CHK_TYPE,CHK_TEXT,STATUS,REMARK)
		VALUES ( @RES_CODE,@SEQ_NO,@DEP_DATE,@CUS_NAME,@OLD_CUS_NO,@TARGET_CUS_NO,@TARGET_CNT,@TARGET_TYPE,@CHK_TYPE,@CHK_TEXT,@STATUS,@REMARK)
	END 
	ELSE 
	BEGIN
		-- 처리 완료 아닐경우에만 초기화 
		IF (SELECT STATUS FROM CUS_CLEAR_TARGET WITH(NOLOCK)
		WHERE RES_CODE = @RES_CODE
		AND SEQ_NO = @SEQ_NO) <> 1 
		BEGIN 
			-- 이미 등록된 경우 NEW_dATE 갱신 
			-- 데이터 초기화 
			UPDATE CUS_CLEAR_TARGET 
			SET DEP_dATE = @DEP_DATE
				,CUS_NAME = @CUS_NAME
				,OLD_CUS_NO = @OLD_CUS_NO 
				,TARGET_CUS_NO = @TARGET_CUS_NO 
				--,NEW_CUS_NO = @NEW_CUS_NO
				,TARGET_CNT = @TARGET_CNT 
				,TARGET_TYPE = @TARGET_TYPE
				,CHK_TYPE = @CHK_TYPE
				,CHK_TEXT = @CHK_TEXT
				,STATUS = @STATUS
				,NEW_DATE = GETDATE() 
				,EXEC_CODE = NULL 
				,EXEC_DATE = NULL 
				,MERGE_INFO = NULL 
				,COMP_YN  ='N' 
				,REMARK =@REMARK
			WHERE RES_CODE = @RES_CODE
			AND SEQ_NO = @SEQ_NO 	
		END 

		
	END 

END  

GO
