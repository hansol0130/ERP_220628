USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_RECOMMEND_INSERT
■ DESCRIPTION				: 패키지 예약 추천인 등록 /수정 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-10-16		박형만			최초생성
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_WEB_RES_RECOMMEND_INSERT]
	@RES_CODE	RES_CODE ,  --호텔은 예약코드 미리 생성
	@REC_CUS_NO INT ,
	@NEW_CODE EMP_CODE 
AS 
BEGIN
	

	IF EXISTS ( SELECT * FROM RES_RECOMMEND 
			WHERE REs_CODE = @RES_CODE ) 
	BEGIN
		UPDATE RES_RECOMMEND 
		SET REC_CUS_NO = @REC_CUS_NO 
		, EDT_CODE = @NEW_CODE
		, EDT_DATE = GETDATe()
		WHERE REs_CODE = @RES_CODE
	END 
	ELSE 
	BEGIN
		INSERT INTO RES_RECOMMEND    
				(RES_CODE,
				REC_CUS_NO,
				NEW_CODE,
				NEW_DATE) 
		VALUES
				(@RES_CODE,
				@REC_CUS_NO,
				@NEW_CODE,
				GETDATE());	
	END 
	

END 
GO
