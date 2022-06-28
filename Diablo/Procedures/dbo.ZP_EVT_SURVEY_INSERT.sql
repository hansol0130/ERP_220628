USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_EVT_SURVEY_INSERT
■ DESCRIPTION				: 설문조사 선택 데이터 저장(맞춤검색)
■ INPUT PARAMETER			: 
	@CUS_NO			int		: 고객고유번호
	@ORDER_BY		char(2)	: 누구와
	@REGION_CODE	char(2)	: 어디로
	@DAY			char(2)	: 일정
	@PRICE			char(2)	: 예산
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	EXEC ZP_EVT_SURVEY_INSERT '', '', '', ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2020-05-27		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_EVT_SURVEY_INSERT]
	@CUS_NO			INT,
	@ORDER_BY		CHAR(2),
	@REGION_CODE	CHAR(2),
	@DAY			CHAR(2),
	@PRICE			CHAR(2)
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	IF NOT EXISTS(
	       SELECT 1
	       FROM   EVT_SURVEY A
	       WHERE  A.CUS_NO = @CUS_NO
	   )
	BEGIN
	    INSERT INTO EVT_SURVEY
	      (
	        CUS_NO
	       ,ORDER_BY
	       ,REGION_CODE
	       ,DAY
	       ,PRICE
	       ,NEW_DATE
	      )
	    VALUES
	      (
	        @CUS_NO
	       ,@ORDER_BY
	       ,@REGION_CODE
	       ,@DAY
	       ,@PRICE
	       ,GETDATE()
	      )
	END
	ELSE
	BEGIN
	    UPDATE EVT_SURVEY
	    SET    ORDER_BY = @ORDER_BY
	          ,REGION_CODE = @REGION_CODE
	          ,DAY = @DAY
	          ,PRICE = @PRICE
	          ,EDT_DATE = GETDATE()
	    WHERE  CUS_NO = @CUS_NO
	END
END
GO
