USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_TOURGUIDE_CUSTOMER_LIST_SELECT
■ DESCRIPTION				: 여행가이드 출발자 리스트 검색
■ INPUT PARAMETER			: 
	@RES_CODE VARCHAR(20)	: 예약코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_RES_TOURGUIDE_CUSTOMER_LIST_SELECT 'RP1307085133', 5355809
	exec XP_WEB_RES_TOURGUIDE_CUSTOMER_LIST_SELECT 'RP1307085133', 15

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-07-04		김성호			최초생성
   2013-07-11		김성호			CUS_NO 추가
   2013-07-16		김성호			예약자만 전체인원 검색
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_WEB_RES_TOURGUIDE_CUSTOMER_LIST_SELECT]
(
	@RES_CODE	VARCHAR(20),
	@CUS_NO		INT
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF EXISTS(SELECT 1 FROM RES_MASTER_damo WHERE RES_CODE = @RES_CODE AND (CUS_NO = @CUS_NO OR @CUS_NO = 0))
	BEGIN
		SELECT B.RES_CODE, B.SEQ_NO, B.CUS_NAME, B.CUS_NO
		FROM RES_MASTER_DAMO A WITH(NOLOCK)
		INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		WHERE A.RES_CODE = @RES_CODE AND A.RES_STATE <= 7 AND B.RES_STATE IN (0, 3)  
	END
	ELSE
	BEGIN
		SELECT B.RES_CODE, B.SEQ_NO, B.CUS_NAME, B.CUS_NO
		FROM RES_MASTER_DAMO A WITH(NOLOCK)
		INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		WHERE A.RES_CODE = @RES_CODE AND A.RES_STATE <= 7 AND B.RES_STATE IN (0, 3) AND B.CUS_NO = @CUS_NO
	END

END
GO
