USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_RESV_DETAIL_PAY_SELECT
■ DESCRIPTION				: BTMS 예약된 상품의 결제 내역 - 출장예약현황
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_COM_BIZTRIP_RESV_DETAIL_PAY_SELECT 'BT1712015817'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-04		이유라			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_RESV_DETAIL_PAY_SELECT]
	@RES_CODE RES_CODE
AS 
BEGIN
	--예약번호별 결제리스트
	SELECT	
			B.AGT_CODE ,
			B.PAY_SEQ , A.RES_CODE , A.PART_PRICE, A.NEW_CODE AS CHARGE_CODE,
			B.PAY_DATE, 
			B.PAY_TYPE, 
			B.PAY_SUB_TYPE ,
			B.PAY_SUB_NAME ,
			damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM) AS PAY_NUM , 
			B.PAY_METHOD, 
			B.PAY_NAME,
			B.ADMIN_REMARK , 
			B.PG_APP_NO ,
			(SELECT KOR_NAME FROM EMP_MASTER WITH(NOLOCK) WHERE EMP_CODE = A.NEW_CODE) AS CHARGE_NAME,
			(SELECT KOR_NAME FROM AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = B.AGT_CODE) AS AGT_NAME ,
			CASE 
				-- 2 : OFF신용카드 , 3 : PG신용카드  ,  13 : ARS  14 : ARS호전환 
				WHEN PAY_TYPE IN ( 2 , 3 , 13 ,14) THEN 
					CASE WHEN LEN(damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM)) > 14 
						THEN  STUFF(damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM) , 5,8,'-****-****-') 
						ELSE ISNULL(PAY_SUB_NAME,'') 
					END 
				--  15 가상계좌 
				WHEN PAY_TYPE IN ( 15 ) THEN 
					ADMIN_REMARK 
				ELSE 
					damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM) 
			END AS PAY_INFO 
	FROM PAY_MATCHING A WITH(NOLOCK)
		INNER JOIN PAY_MASTER_DAMO B WITH(NOLOCK) 
			ON A.PAY_SEQ = B.PAY_SEQ
	WHERE A.RES_CODE IN (SELECT Data FROM dbo.FN_XML_SPLIT(@RES_CODE, ',')) AND A.CXL_YN = 'N' AND B.CXL_YN = 'N'
	--AND (ISNULL(@CUS_NO,0) = 0 OR  CUS_NO = @CUS_NO)
	ORDER BY A.PAY_SEQ DESC , A.MCH_SEQ DESC 
END 
GO
