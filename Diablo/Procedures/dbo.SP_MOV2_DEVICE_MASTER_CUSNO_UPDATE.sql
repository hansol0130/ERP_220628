USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*================================================================================================================
■ USP_NAME					: SP_MOV2_DEVICE_MASTER_CUSNO_UPDATE
■ DESCRIPTION				: 입력_디바이스_고객번호연결
■ INPUT PARAMETER			: DEVICE_NO, CUS_NO
■ EXEC						: 
    -- EXEC SP_MOV2_DEVICE_MASTER_CUSNO_UPDATE '250dbdf2-80f4-376a-97c7-002b3dcc222e', 8505125

■ MEMO						: 디바이스정보에 고객번호연결
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-28		오준욱(IBSOLUTION)		최초생성
   2020-07-29		홍종우					DELETE에서 UPDATE로 변경
   2022-06-07       이장훈					테이블에 저장된 device 정보와 사용자 device 정보를 비교하기 위해  parameter 추가 [CUS_DEVICE_ID,REMARK,APP_CODE,NEW_CODE] 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_DEVICE_MASTER_CUSNO_UPDATE]
@DEVICE_NO 		VARCHAR(512)
,@CUS_NO 		INT
--추가
,@CUS_DEVICE_ID	VARCHAR(4000)=''
,@REMARK		VARCHAR(2000)=''
,@APP_CODE 		INT=1
,@NEW_CODE 		VARCHAR(7)='999999'

AS
BEGIN
	
	DECLARE @OLD_CUS_DEVICE_ID VARCHAR(4000)

	/* 1.고객 디바이스 정보 조회 */
	IF EXISTS(SELECT TOP 1 DEVICE_NO FROM DEVICE_MASTER WITH (NOLOCK) WHERE CUS_NO=@CUS_NO AND DEVICE_NO=@DEVICE_NO)
	BEGIN
		  -- 사용하고있는 DEVICE_ID 정보를 조회
		  SELECT 
		       @OLD_CUS_DEVICE_ID = CUS_DEVICE_ID
		  FROM DEVICE_MASTER WITH (NOLOCK) 
		  WHERE CUS_NO		=@CUS_NO
		  AND	DEVICE_NO	=@DEVICE_NO  
	END

	/* 2.디바이스 로그인  로그 저장 */
	INSERT INTO DEVICE_MASTER_LOG(CUS_NO ,DEVICE_NO ,CUS_DEVICE_ID ,NEW_CUS_DEVICE_ID,NEW_DATE)
	SELECT @CUS_NO,@DEVICE_NO,@OLD_CUS_DEVICE_ID,@CUS_DEVICE_ID,GETDATE()

	/* 3. 로그인시 고객 DEVICE_ID 정보 체크 */
	IF(LEN(ISNULL(@CUS_DEVICE_ID,'')) > 0) 
	BEGIN
		
		/* 3.1 DEVICE_NO 존재여부 체크 */
		IF EXISTS(SELECT TOP 1 DEVICE_NO FROM DEVICE_MASTER WITH (NOLOCK) WHERE CUS_NO=@CUS_NO AND DEVICE_NO=@DEVICE_NO)
		BEGIN
			
			UPDATE DEVICE_MASTER
			SET    CUS_NO			=@CUS_NO
				 , CUS_DEVICE_ID	=CASE WHEN CUS_DEVICE_ID=@CUS_DEVICE_ID THEN CUS_DEVICE_ID  ELSE  @CUS_DEVICE_ID END
				 , NEW_DATE			=GETDATE()
				 
			WHERE  CUS_NO			=@CUS_NO
			AND	   DEVICE_NO		=@DEVICE_NO 

		END
		ELSE
		BEGIN
			/* 3.1 현재 등록된 디바이스 고객 정보 NULL 변경	*/
			UPDATE DEVICE_MASTER
			SET    CUS_NO = NULL
			
			WHERE  CUS_NO = @CUS_NO
			AND DEVICE_NO <> @DEVICE_NO;
			
			/* 3.2 신규 디바이스 정보를 저장 */
			INSERT INTO DEVICE_MASTER
			(
				APP_CODE,
				CUS_NO,
				DEVICE_NO,
				CUS_DEVICE_ID,
				REMARK,
				NEW_CODE,
				NEW_DATE
			)
			VALUES
			(
				@APP_CODE,
				@CUS_NO,
				@DEVICE_NO,
				@CUS_DEVICE_ID,
				@REMARK,
				@NEW_CODE,
				GETDATE()
			)
		END
	END
	ELSE
	BEGIN

		--DELETE
		--FROM   DEVICE_MASTER
		--WHERE  CUS_NO = @CUS_NO
		--       AND DEVICE_NO <> @DEVICE_NO;
		
		UPDATE DEVICE_MASTER
		SET    CUS_NO = NULL
		WHERE  CUS_NO = @CUS_NO
			   AND DEVICE_NO <> @DEVICE_NO;
		
		UPDATE DEVICE_MASTER
		SET    CUS_NO = @CUS_NO
			  ,NEW_DATE = GETDATE()
		WHERE  DEVICE_NO = @DEVICE_NO
	END   

	/*
	--DELETE
	--FROM   DEVICE_MASTER
	--WHERE  CUS_NO = @CUS_NO
	--       AND DEVICE_NO <> @DEVICE_NO;
	
	UPDATE DEVICE_MASTER
	SET    CUS_NO = NULL
	WHERE  CUS_NO = @CUS_NO
	       AND DEVICE_NO <> @DEVICE_NO;
	
	UPDATE DEVICE_MASTER
	SET    CUS_NO = @CUS_NO
	      ,NEW_DATE = GETDATE()
	WHERE  DEVICE_NO = @DEVICE_NO*/
END           



GO
