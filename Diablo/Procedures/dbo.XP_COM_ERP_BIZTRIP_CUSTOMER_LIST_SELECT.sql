USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_ERP_BIZTRIP_CUSTOMER_LIST_SELECT
■ DESCRIPTION				: BTMS ERP 출장 현황 예약 출발자 리스트 검색
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처 코드
	@BT_CODE				: 출장코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC XP_COM_ERP_BIZTRIP_CUSTOMER_LIST_SELECT '92756', 'BT1604010105';
	exec XP_COM_ERP_BIZTRIP_CUSTOMER_LIST_SELECT @AGT_CODE=N'93881',@BT_CODE=N'BT1606020423'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-21		김성호			최초생성
   2016-05-17		박형만			출장예약 추가시 기존 출장자 추가정보 불러옴 
   2016-06-21		박형만			사원정보 추가 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_ERP_BIZTRIP_CUSTOMER_LIST_SELECT]
	@AGT_CODE		VARCHAR(10),
	@BT_CODE		VARCHAR(20)
AS 
BEGIN

	SELECT A.AGT_CODE, A.BT_CODE, A.PRO_CODE, B.PRO_DETAIL_TYPE, C.RES_CODE, C.PRICE_SEQ, D.SEQ_NO, C.RES_STATE, D.RES_STATE AS [CUS_RES_STATE], C.DEP_DATE
		, D.CUS_NO , E.EMP_SEQ , D.NOR_TEL1 , D.NOR_TEL2 , D.NOR_TEL3 , D.EMAIL , G.POS_NAME , H.TEAM_NAME 
		, D.CUS_NAME, D.LAST_NAME, D.FIRST_NAME, D.AGE_TYPE, D.GENDER, D.BIRTH_DATE, D.PASS_YN
		, DBO.FN_CUS_GET_AGE(D.BIRTH_DATE, C.DEP_DATE) AS [AGE]
		, damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', D.SEC_PASS_NUM) AS PASS_NUM, D.PASS_EXPIRE
		, D.NEW_DATE, D.ETC_REMARK 
	FROM COM_BIZTRIP_MASTER A WITH(NOLOCK)
	INNER JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.BT_CODE = B.BT_CODE
	INNER JOIN RES_MASTER_damo C WITH(NOLOCK) ON B.RES_CODE = C.RES_CODE
	INNER JOIN RES_CUSTOMER_damo D WITH(NOLOCK) ON C.RES_CODE = D.RES_CODE
	LEFT JOIN COM_EMPLOYEE_MATCHING E  WITH(NOLOCK) ON D.CUS_NO = E.CUS_NO 
	LEFT JOIN COM_EMPLOYEE F  WITH(NOLOCK) ON E.AGT_CODE = F.AGT_CODE AND E.EMP_SEQ = F.EMP_SEQ 
	LEFT JOIN COM_POSITION G  WITH(NOLOCK) ON F.AGT_CODE = G.AGT_CODE AND F.POS_SEQ = G.POS_SEQ 
	LEFT JOIN COM_TEAM H WITH(NOLOCK) ON F.AGT_CODE = H.AGT_CODE AND  F.TEAM_SEQ  = H.TEAM_SEQ 

	WHERE A.AGT_CODE = @AGT_CODE AND A.BT_CODE = @BT_CODE
	ORDER BY B.PRO_DETAIL_TYPE;

END 



GO
