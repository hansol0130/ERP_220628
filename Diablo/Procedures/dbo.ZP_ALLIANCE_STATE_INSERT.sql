USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: ZP_ALLIANCE_STATE_INSERT
■ DESCRIPTION				: 졔휴 ETBS 예약내용저장 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  ZP_ALLIANCE_STATE_INSERT 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2021-08-27		김영민			최초생성
   
================================================================================================================*/ 
CREATE   PROC [dbo].[ZP_ALLIANCE_STATE_INSERT]
(
	@TYPE			CHAR			,--type = N 포인트 사용시 , U 결재완료후
	@RES_CODE		VARCHAR(12)		,
	@ETBS_CODE		VARCHAR(20)		 ='',
	@RES_STATE	    INT			 	,
	@VENDOR			VARCHAR(8)		 ='', --제휴사코드
	@SVID			VARCHAR(5)		 ='', --제휴사svid
	@ETB_USERID		VARCHAR(12)		 ='', --제휴연계용 고객키
	@ETB_CUSURL		VARCHAR(100)	 =''   
)
AS 
BEGIN
	
		IF(@TYPE = 'N')
			BEGIN
				INSERT INTO RES_ALLIANCE_ETBS 
				(RES_CODE, ETBS_CODE, RES_STATE, NEW_DATE, VENDOR, SVID, ETB_USERID, ETB_CUSURL) 
				VALUES (@RES_CODE, RTRIM(@ETBS_CODE), @RES_STATE, GETDATE(),@VENDOR, @SVID, @ETB_USERID, @ETB_CUSURL)
			END
			ELSE
			BEGIN
				UPDATE RES_ALLIANCE_ETBS SET
				ETBS_CODE = @ETBS_CODE,
				RES_STATE = @RES_STATE,
				NEW_DATE =  GETDATE()
				WHERE RES_CODE  = @RES_CODE
			END
	
	SELECT @@IDENTITY 
END 
GO
