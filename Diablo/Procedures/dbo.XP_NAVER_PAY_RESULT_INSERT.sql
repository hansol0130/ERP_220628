USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_NAVER_PAY_RESULT_INSERT
■ DESCRIPTION				: 네이버 페이 승인 요청 응답결과 등록 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  XP_NAVER_PAY_RESULT_INSERT 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-05-23		박형만			최초생성
   
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_NAVER_PAY_RESULT_INSERT]
(
	@NPAY_ID	VARCHAR(50)		,
	@NPAY_HIS_ID	VARCHAR(50)		,
	@LAST_STATUS	VARCHAR(10)		,
	@RESULT_CODE	VARCHAR(20)		,
	@RESULT_MSG	VARCHAR(500)		,
	@RES_CODE	RES_CODE		,
	@CUS_NO	INT,
	
	@PAY_MEANS	VARCHAR(10)		,
	@TOTAL_PRICE	INT		,
	@PAY_PRICE	INT		,
	@PAY_POINT	INT		,

	@CARD_CODE	VARCHAR(10)		,
	@CARD_NO	VARCHAR(50)		,
	@CARD_AUTH_NO	VARCHAR(30)		,
	@INST_NO	INT		,
	@BANK_CODE	VARCHAR(10)		,
	@BANK_NUM	VARCHAR(50)		,

	@PAY_DATE DATETIME , 
	@MALL_ID	VARCHAR(50)		,
	@NEW_DATE	DATETIME		,
	@REMARK		VARCHAR(1000)		,
	@USER_AGENT	VARCHAR(1000)		,
	@RESULT_TEXT	VARCHAR(1000)
)
AS 
BEGIN
	INSERT INTO NAVER_PAY_RESULT 
		(NPAY_ID,NPAY_HIS_ID,LAST_STATUS,
		RESULT_CODE,RESULT_MSG,RES_CODE,CUS_NO,
		PAY_MEANS,TOTAL_PRICE,PAY_PRICE,PAY_POINT,
		CARD_CODE,CARD_NO,CARD_AUTH_NO,INST_NO,
		BANK_CODE,BANK_NUM,PAY_DATE,
		MALL_ID,NEW_DATE,REMARK,USER_AGENT,RESULT_TEXT) 
	VALUES (@NPAY_ID,@NPAY_HIS_ID,@LAST_STATUS,
		@RESULT_CODE,@RESULT_MSG,@RES_CODE,@CUS_NO,
		@PAY_MEANS,@TOTAL_PRICE,@PAY_PRICE,@PAY_POINT,
		@CARD_CODE,@CARD_NO,@CARD_AUTH_NO,@INST_NO,
		@BANK_CODE,@BANK_NUM,@PAY_DATE,
		@MALL_ID,@NEW_DATE,@REMARK,@USER_AGENT,@RESULT_TEXT) 

	SELECT @@IDENTITY 
END 
GO
