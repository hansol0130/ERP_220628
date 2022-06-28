USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_CUSTOMER_RESERVE_INFO_SELECT
■ DESCRIPTION				: ERP 고객정보 예약상세정보 검색
■ INPUT PARAMETER			: 
	@RES_CODE				: 예약번호 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_ERP_CUSTOMER_RESERVE_INFO_SELECT 'RP1407141942'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2014-10-18		곽병삼			최초생성
	2014-10-22		박형만			예약1건에 대해서 정보가져오도록 수정 
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ERP_CUSTOMER_RESERVE_INFO_SELECT]
--DECLARE
	@RES_CODE VARCHAR(12)
AS
SET NOCOUNT ON 

--DECLARE @RES_CODE VARCHAR(12)
--SELECT @RES_CODE = 'RP1407141942' 

--예약상품 정보 
SELECT 
	B.MASTER_CODE , 
	A.PRO_CODE ,
	C.PRO_NAME ,
	C.UNITE_YN ,
	C.DEP_CFM_YN ,
	C.CONFIRM_YN ,
	C.RES_ADD_YN ,
	C.TOUR_NIGHT,
	C.TOUR_DAY,
	Diablo.DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS RES_COUNT ,
	C.FAKE_COUNT, C.MIN_COUNT, C.MAX_COUNT , 
	Diablo.DBO.FN_PRO_GET_POINT_PRICE(A.PRO_CODE) AS POINT_PRICE,
	D.POINT_RATE ,
	E.DEP_TRANS_CODE,
	E.DEP_TRANS_NUMBER,
	E.DEP_DEP_DATE,
	E.DEP_ARR_DATE,
	E.DEP_DEP_TIME,
	E.DEP_ARR_TIME,
	E.DEP_SPEND_TIME,
	E.DEP_DEP_AIRPORT_CODE,
	E.DEP_ARR_AIRPORT_CODE,
	E.ARR_TRANS_CODE,
	E.ARR_TRANS_NUMBER,
	E.ARR_DEP_DATE,
	E.ARR_ARR_DATE,
	E.ARR_DEP_TIME,
	E.ARR_ARR_TIME,
	E.ARR_DEP_AIRPORT_CODE,
	E.ARR_ARR_AIRPORT_CODE,
	C.FIRST_MEET,
	C.TC_NAME,
	C.TC_YN,
	C.GUIDE_YN 
FROM Diablo.DBO.RES_MASTER_DAMO A WITH(NOLOCK)
	INNER JOIN Diablo.DBO.PKG_MASTER B WITH(NOLOCK) 
		ON A.MASTER_CODE = B.MASTER_CODE 
	INNER JOIN Diablo.DBO.PKG_DETAIL C WITH(NOLOCK)
		ON A.PRO_CODE = C.PRO_CODE 
	LEFT JOIN Diablo.DBO.PKG_DETAIL_PRICE D WITH(NOLOCK)
		ON A.PRO_CODE = D.PRO_CODE 
		AND A.PRICE_SEQ = D.PRICE_SEQ 
	LEFT JOIN Diablo.DBO.PRO_TRANS_SEAT E WITH(NOLOCK)
		ON C.SEAT_CODE = E.SEAT_CODE 
	LEFT JOIN Diablo.DBO.EMP_MASTER F WITH(NOLOCK)
		ON A.NEW_CODE = F.EMP_CODE
	--INNER JOIN Diablo.DBO.PUB_REGION C WITH(NOLOCK)
WHERE RES_CODE = @RES_CODE 
ORDER BY A.NEW_DATE DESC 

--예약정보 
SELECT TOP 1
	A.PRO_CODE,
	A.PRO_NAME,
	A.RES_NAME,
	A.RES_CODE,
	A.RES_STATE,
	A.PRO_TYPE,
	A.NEW_DATE , 
	Diablo.DBO.FN_RES_GET_RES_COUNT(A.RES_CODE) AS RES_COUNT ,
	Diablo.DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) AS TOTAL_PRICE ,--판매금액 
	Diablo.DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) AS PAY_PRICE, --입금금액 

	Diablo.DBO.FN_RES_IS_TOURLIST(A.RES_CODE) AS [TOUR_STATE],
	Diablo.DBO.FN_RES_GET_PAY_STATE(A.RES_CODE) AS [PAY_STATE],
	Diablo.DBO.FN_RES_IS_APIS(A.RES_CODE) AS [APIS_YN],
	Diablo.DBO.FN_RES_GET_OK_COUNT(A.RES_CODE) AS OK_COUNT,
	Diablo.DBO.FN_RES_GET_APIS_COUNT(A.RES_CODE) AS APIS_COUNT,
	A.LAST_PAY_DATE ,
	A.ETC
FROM Diablo.DBO.RES_MASTER_DAMO A WITH(NOLOCK)
	INNER JOIN Diablo.DBO.EMP_MASTER F WITH(NOLOCK)
		ON A.NEW_CODE = F.EMP_CODE
	--INNER JOIN Diablo.DBO.PUB_REGION C WITH(NOLOCK)
WHERE RES_CODE = @RES_CODE 
ORDER BY A.NEW_DATE DESC 

--결제정보 
SELECT A.PAY_SEQ, A.MCH_SEQ, B.PAY_DATE, A.PART_PRICE, B.PAY_TYPE, 
	damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM) AS PAY_NUM
	, PAY_METHOD, PAY_NAME, A.NEW_CODE AS CHARGE_CODE
	, Diablo.DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS CHARGE_NAME
	, (SELECT KOR_NAME FROM Diablo.DBO.AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = B.AGT_CODE) AS AGT_NAME
	, A.REMARK , B.AGT_CODE , B.ADMIN_REMARK , B.PG_APP_NO
FROM Diablo.DBO.PAY_MATCHING A WITH(NOLOCK)
INNER JOIN Diablo.DBO.PAY_MASTER_DAMO B WITH(NOLOCK) ON A.PAY_SEQ = B.PAY_SEQ
WHERE A.RES_CODE = @RES_CODE AND B.CXL_YN = 'N' AND A.CXL_YN = 'N'

SET NOCOUNT OFF

GO