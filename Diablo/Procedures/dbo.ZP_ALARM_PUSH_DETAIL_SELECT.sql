USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: ZP_ALARM_PUSH_DETAIL_SELECT
■ DESCRIPTION				: 푸시 알림 상세보기
■ INPUT PARAMETER			: 
	@REF_NO			int		: 문서번호
	@PUSH_TYPE		int		: PUSH TYPE
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	EXEC ZP_ALARM_PUSH_DETAIL_SELECT '', ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2020-06-26		홍종우			최초생성
   2020-09-03		홍종우			APP_PUSH_MSG_ALARM TABLE UPDATE 시 CUS_NO 추가
   2022-04-20		오준혁			CUS_NO 가 0 이 들어올 경우(로그인 없는 경우) 처리
   2022-06-25		김성호			APP_PUSH_MSG_ALARM 검색 키 오류 수정 (A.MSG_NO -> A.MSG_SEQ)
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_ALARM_PUSH_DETAIL_SELECT]
	@REF_NO			INT,
	@PUSH_TYPE		INT,
	@CUS_NO			INT
AS 
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	IF (@PUSH_TYPE = 2)
	BEGIN
	    SELECT A.MSG_SEQ_NO AS REF_NO
	          ,A.TITLE AS TITLE
	          ,'[참좋은여행]비행편 변동으로 인한 운항정보 변경사항을 안내드립니다.' AS [MESSAGE]
	          ,A.NEW_DATE AS SEND_DATE
	          ,A.REMARK AS MSG_DETAIL
	          ,'' AS IMAGE_URL
	          ,'' AS LINK_URL
	    FROM   APP_MESSAGE_damo A
	           JOIN APP_RECEIVE B
	                ON  A.MSG_SEQ_NO = B.MSG_SEQ_NO
	    WHERE  A.MSG_SEQ_NO = @REF_NO
	    
	    --메세지 읽음 처리
	    IF EXISTS(
	           SELECT COUNT(1)
	           FROM   APP_RECEIVE
	           WHERE  MSG_SEQ_NO = @REF_NO
	                  AND READ_DATE IS NULL
	       )
	    BEGIN
	        UPDATE APP_RECEIVE
	        SET    READ_DATE = GETDATE()
	        WHERE  MSG_SEQ_NO = @REF_NO
	    END
	END
	ELSE
	BEGIN
	    SELECT A.MSG_NO AS REF_NO
	          ,B.TITLE
	          ,B.MSG
	          ,B.RECV_DATE AS SEND_DATE
	          ,B.MSG_DETAIL
	          ,B.IMAGE_URL
	          ,B.LINK_URL
	    FROM   APP_PUSH_MSG_ALARM A
	           JOIN APP_PUSH_MSG_INFO B
	                ON  A.MSG_NO = B.MSG_NO
	    WHERE  A.MSG_SEQ = @REF_NO
	    
	    -- 로그인 없이 실행될 경우 처리 안함
	    IF @CUS_NO <> 0
	    BEGIN
			--메세지 읽음 처리
			IF EXISTS(
				   SELECT COUNT(1)
				   FROM   APP_PUSH_MSG_ALARM
				   WHERE  MSG_SEQ = @REF_NO
						  AND CUS_NO = @CUS_NO
						  AND READ_DATE IS NULL
			   )
			BEGIN
				UPDATE APP_PUSH_MSG_ALARM
				SET    READ_DATE = GETDATE()
				WHERE  MSG_SEQ = @REF_NO
					   AND CUS_NO = @CUS_NO
			END
	    END
	    
	END
END
GO
