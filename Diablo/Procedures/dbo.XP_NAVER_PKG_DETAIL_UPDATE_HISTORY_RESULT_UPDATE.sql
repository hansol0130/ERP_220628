USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : XP_NAVER_PKG_DETAIL_UPDATE_HISTORY_RESULT_UPDATE
- 기 능 : 네이버 상품 변경내역 , 처리결과 수정 

XP_NAVER_PKG_DETAIL_UPDATE_HISTORY_RESULT_UPDATE 
====================================================================================
	참고내용
====================================================================================
- 네이버 상품 연동 변경내역에 대한 처리 결과 수정 
====================================================================================
	변경내역
====================================================================================
- 2019-12-18 박형만 최초생성
===================================================================================*/
CREATE PROC [dbo].[XP_NAVER_PKG_DETAIL_UPDATE_HISTORY_RESULT_UPDATE]
	@SEQ_NO INT  ,  -- 
	@UPDATE_TYPE VARCHAR(20),
	@RESULT_CODE VARCHAR(20) ,
	@RESULT_MESSAGE VARCHAR(1000),
	@RESULT_TEXT VARCHAR(MAX) ,
	@SEND_YN VARCHAR(1)  -- 'Y' 일때만 세부 결과 등록 
AS 
BEGIN

	BEGIN TRAN 

	--IF @SEND_YN = 'Y' 
	--BEGIN
		DECLARE @RESULT_SEQ INT 
		SET @RESULT_SEQ = ISNULL(( SELECT MAX(RESULT_SEQ) FROM NAVER_PKG_DETAIL_UPDATE_RESULT WHERE SEQ_NO = @SEQ_NO) ,0)  + 1 

		INSERT INTO NAVER_PKG_DETAIL_UPDATE_RESULT (
			SEQ_NO,RESULT_SEQ,UPDATE_TYPE,RESULT_CODE,RESULT_MESSAGE,RESULT_TEXT,SEND_YN
		) 
		VALUES(@SEQ_NO,@RESULT_SEQ,@UPDATE_TYPE,@RESULT_CODE,@RESULT_MESSAGE,@RESULT_TEXT,@SEND_YN )	
	--END 
	
	UPDATE NAVER_PKG_DETAIL_UPDATE_HISTORY 
	SET CHK_DATE = GETDATE() 
	WHERE SEQ_NO = @SEQ_NO

	COMMIT TRAN 
END 


GO
