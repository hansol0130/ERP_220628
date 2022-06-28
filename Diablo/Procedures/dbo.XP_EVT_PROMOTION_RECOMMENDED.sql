USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_EVT_PROMOTION_RECOMMENDED
■ DESCRIPTION				: 프로모션 이벤트 추천
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2017-04-28		정지용			최초생성
   2017-05-19		정지용			입력 24시간 -> 자정이 지나면 가능하도록 수정
================================================================================================================*/ 
CREATE PROC [dbo].[XP_EVT_PROMOTION_RECOMMENDED]
	@SEC_SEQ INT,
 	@SEQ_NO INT,
	@IPADDRESS VARCHAR(50)
AS 
BEGIN
	DECLARE @LAST_RECOMMEND_DATE DATETIME;

	SELECT @LAST_RECOMMEND_DATE = MAX(NEW_DATE) FROM EVT_PROMOTION_DETAIL_RECOMMENDED WITH(NOLOCK) WHERE SEC_SEQ = @SEC_SEQ AND IPADDRESS = @IPADDRESS;	
	--IF GETDATE() < DATEADD(dd, 1, @LAST_RECOMMEND_DATE)
	IF CONVERT(INT, CONVERT(VARCHAR(10), GETDATE(), 112)) <= CONVERT(INT, CONVERT(VARCHAR(10), @LAST_RECOMMEND_DATE, 112))
	BEGIN
		SELECT 'EXISTS'
		RETURN;
	END

	INSERT INTO EVT_PROMOTION_DETAIL_RECOMMENDED ( SEC_SEQ, SEQ_NO, CUS_NO, IPADDRESS, NEW_dATE )
	VALUES ( @SEC_SEQ, @SEQ_NO, NULL, @IPADDRESS, GETDATE() )	

	IF @@ROWCOUNT > 0
		SELECT 'SUCC';
	ELSE
		SELECT 'FAIL';
END


GO
