USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_RES_HOTEL_CANCEL_CHARGE_SELECT
■ DESCRIPTION				: 출장자 호텔 예약후 취소규정 검색
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC XP_COM_RES_HOTEL_CANCEL_CHARGE_SELECT '92756 ','BT1602298891 ','RH1112041269',100

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-01		이유라			최초생성
   2016-05-26		김성호			BT_STATE 삭제
================================================================================================================*/ 

CREATE PROC [dbo].[XP_COM_RES_HOTEL_CANCEL_CHARGE_SELECT]
	@AGT_CODE VARCHAR(10),
	@BT_CODE  VARCHAR(20),
	@RES_CODE VARCHAR(20),
	@NEW_SEQ INT
AS 
BEGIN
	WITH AGT_BIZTRIP_LIST AS 
	(
		SELECT A.AGT_CODE,A.BT_CODE, A.BT_START_DATE, A.BT_END_DATE, A.BT_REASON,  B.RES_CODE, 
		A.BT_TIME_LIMIT, A.NEW_DATE, A.NEW_SEQ, C.KOR_NAME AS EMP_NAME,
		D.HOTEL_LIKE_YN, D.HOTEL_DISLIKE_YN,  D.HOTEL_PRICE_LIMIT, D.REASON_SEQ, D.REASON_REMARK
		FROM 
		COM_BIZTRIP_MASTER A
		JOIN COM_BIZTRIP_DETAIL B
		ON A.BT_CODE = B.BT_CODE
		AND A.AGT_CODE = @AGT_CODE
		AND A.BT_CODE = @BT_CODE
		AND A.NEW_SEQ = @NEW_SEQ
		JOIN COM_EMPLOYEE C
		ON A.NEW_SEQ = C.EMP_SEQ
		AND A.AGT_CODE = @AGT_CODE
		LEFT JOIN COM_BIZTRIP_RULE_REMARK D
		ON B.RES_CODE = D.RES_CODE
	)
	--호텔예약 정보
	SELECT 
		ABL.AGT_CODE, ABL.BT_CODE, ABL.RES_CODE, B.LAST_CXL_DATE, B.CXL_REMARK, B.LAST_CXL_DATE, B.RES_STATE,
		(SELECT TOP 1 CUS_NO FROM COM_EMPLOYEE_MATCHING WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ = @NEW_SEQ) AS CUS_NO
	FROM RES_MASTER_damo A WITH(NOLOCK)
	INNER JOIN AGT_BIZTRIP_LIST ABL WITH(NOLOCK) ON ABL.RES_CODE = A.RES_CODE
	INNER JOIN RES_HTL_ROOM_MASTER B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	WHERE A.RES_CODE = @RES_CODE
	ORDER BY A.RES_CODE DESC
END
GO
