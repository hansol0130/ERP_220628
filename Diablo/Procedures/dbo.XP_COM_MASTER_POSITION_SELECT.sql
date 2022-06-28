USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_MASTER_POSITION_SELECT
■ DESCRIPTION				: BTMS 거래처 직급 검색
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_COM_MASTER_POSITION_SELECT 93084

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-04		저스트고(강태영)			최초생성
   2016-02-23		저스트고(강태영)			정렬 - ORDER_NUM
   2016-07-28		저스트고(이유라)			각 직급별 인원카운트 추가
================================================================================================================*/ 

CREATE PROC [dbo].[XP_COM_MASTER_POSITION_SELECT]
	@AGT_CODE		VARCHAR(10)
AS 
BEGIN

	SELECT 
		A.AGT_CODE, A.POS_SEQ, A.POS_NAME, A.ORDER_NUM, A.NEW_DATE, A.NEW_SEQ, 
		(SELECT COUNT(*) FROM COM_EMPLOYEE B WHERE A.AGT_CODE = B.AGT_CODE AND A.POS_SEQ = B.POS_SEQ ) AS INWON
	FROM COM_POSITION A
	WHERE A.AGT_CODE = @AGT_CODE
	ORDER BY A.ORDER_NUM

END 
GO
