USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_ERP_BIZTRIP_MASTER_LIST_SELECT
■ DESCRIPTION				: BTMS ERP 출장 현황 마스터 예약 리스트 검색
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처 코드
	@BT_CODE				: 출장코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_COM_ERP_BIZTRIP_MASTER_LIST_SELECT '92756', 'BT1604140125';

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-20		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_ERP_BIZTRIP_MASTER_LIST_SELECT]
	@AGT_CODE		VARCHAR(10),
	@BT_CODE		VARCHAR(20)
AS 
BEGIN

	SELECT B.PRO_DETAIL_TYPE, C.RES_STATE, C.RES_CODE, C.SYSTEM_TYPE, C.DEP_DATE, C.ARR_DATE, C.LAST_PAY_DATE, C.ETC, C.PRO_NAME
		, C.NEW_DATE, C.NEW_CODE, E.KOR_NAME AS [NEW_NAME]
		, (CASE WHEN D.RES_CODE IS NULL THEN 'N' ELSE 'Y' END) AS [RULE_BREAK_YN]
		, DBO.FN_RES_GET_RES_COUNT(C.RES_CODE) AS [RES_COUNT]
		, (
			CASE B.PRO_DETAIL_TYPE
				WHEN 2 THEN F.AIRLINE_CODE
				WHEN 3 THEN (I.KOR_NAME + '/' + H.KOR_NAME)
			END
		) AS [GUBUN]
		, DBO.FN_RES_AIR_GET_PRO_NAME(C.RES_CODE) AS [SEG_NAME]
		, F.AIR_GDS, F.PNR_CODE1, F.AIR_GDS2, F.PNR_CODE2
		, (CASE WHEN B.PAY_LATER_EMP_SEQ > 0 THEN 'Y' ELSE 'N' END) AS [PAY_LASTER_YN]
	FROM COM_BIZTRIP_MASTER A WITH(NOLOCK)
	INNER JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.BT_CODE = B.BT_CODE
	INNER JOIN RES_MASTER_damo C WITH(NOLOCK) ON B.RES_CODE = C.RES_CODE
	LEFT JOIN COM_BIZTRIP_RULE_REMARK D WITH(NOLOCK) ON C.RES_CODE = D.RES_CODE
	LEFT JOIN EMP_MASTER E WITH(NOLOCK) ON C.NEW_CODE = E.EMP_CODE
	LEFT JOIN RES_AIR_DETAIL F WITH(NOLOCK) ON C.RES_CODE = F.RES_CODE
	LEFT JOIN RES_HTL_ROOM_MASTER G WITH(NOLOCK) ON C.RES_CODE = G.RES_CODE
	LEFT JOIN PUB_CITY H WITH(NOLOCK) ON G.CITY_CODE = H.CITY_CODE
	LEFT JOIN PUB_NATION I WITH(NOLOCK) ON H.NATION_CODE = I.NATION_CODE
	WHERE A.AGT_CODE = @AGT_CODE AND A.BT_CODE = @BT_CODE
	ORDER BY B.PRO_DETAIL_TYPE;

END 



GO
