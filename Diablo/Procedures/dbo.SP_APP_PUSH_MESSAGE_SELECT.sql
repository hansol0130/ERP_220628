USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_APP_PUSH_MESSAGE_SELECT
- 기 능 : 푸시 메세지 단건 조회
====================================================================================
	참고내용
====================================================================================
- 예제
 EXEC SP_APP_PUSH_MESSAGE_SELECT 1,10630098
====================================================================================
	변경내역
====================================================================================
- 2018-11-16 김남훈 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_APP_PUSH_MESSAGE_SELECT]
	@MSG_NO INT = -1, --메세지 번호
	@CUS_NO INT  -- 고객 코드
AS 
SET NOCOUNT ON 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT 
	A.MSG_NO, 
	A.READ_DATE, 
	B.TEMPLATE_TYPE, 
	B.TITLE,
	B.MSG,
	B.MSG_DETAIL,
	B.IMAGE_URL,
	B.RECV_DATE,
	B.LINK_URL
	FROM APP_PUSH_MSG_ALARM A, APP_PUSH_MSG_INFO B WITH(NOLOCK)
	WHERE A.MSG_NO = B.MSG_NO
	AND (@MSG_NO = -1 OR A.MSG_NO = @MSG_NO)
	AND A.CUS_NO = @CUS_NO
	AND B.RECV_DATE > DATEADD(M,-1,GETDATE())
	ORDER BY B.RECV_DATE DESC

	--메세지 읽음 처리
	IF(@MSG_NO <> -1)
	BEGIN
		UPDATE APP_PUSH_MSG_ALARM
		SET READ_DATE = GETDATE()
		WHERE MSG_NO = @MSG_NO
		AND CUS_NO = @CUS_NO
		AND READ_DATE IS NULL
	END
END 
GO
