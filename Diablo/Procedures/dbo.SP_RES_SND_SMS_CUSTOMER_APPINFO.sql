USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_RES_SND_SMS_CUSTOMER_APPINFO
■ DESCRIPTION				: 앱정보 출발 일주일 전 고객에게 문자발송
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: EXEC SP_RES_SND_SMS_CUSTOMER_APPINFO
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2016-08-04			정지용			최초생성
2018-07-25			김성호			사용안함 (SP_RES_SND_APP_INFO_INSERT 로 대체)
================================================================================================================*/ 
CREATE PROC [dbo].[SP_RES_SND_SMS_CUSTOMER_APPINFO]
AS
BEGIN
	SELECT --A.MASTER_CODE, A.RES_CODE, A.DEP_DATE, B.*
		A.RES_CODE, B.NOR_TEL1, B.NOR_TEL2, B.NOR_TEL3
		, '[참좋은여행] 여행 출발 3일전입니다. 참좋은여행APP ''나만의여행가이드''로 여행준비 하고 계신가요?데이터 오프라인시에도 지도를 통한 여행일정과 출입국신고서를 확인할 수 있으니, 출발 전 여행일정을 다운받아 준비해보세요.* 다운로드 : https://goo.gl/uUhSgb (안드로이드만 가능)' AS MSG
	FROM RES_MASTER_damo A WITH(NOLOCK)
		INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		INNER JOIN PKG_DETAIL C WITH(NOLOCK) ON A.PRO_CODE = C.PRO_CODE
		INNER JOIN PKG_MASTER D WITH(NOLOCK) ON C.MASTER_CODE = D.MASTER_CODE
		INNER JOIN PKG_DETAIL_PRICE E WITH(NOLOCK) ON A.PRO_CODE = E.PRO_CODE  AND A.PRICE_SEQ = E.PRICE_SEQ
		WHERE A.DEP_DATE >= DATEADD(DAY, 2, GETDATE()) 
			AND A.DEP_DATE < DATEADD(DAY, 3, GETDATE()) 
			AND A.PRO_CODE NOT LIKE 'K%'  --[국내해외여부] 해외 
			AND C.TRANSFER_TYPE = 1 -- [교통편] 항공편
			AND A.RES_STATE < 7 AND B.RES_STATE = 0 
			AND D.ATT_CODE IN ('P','R','W','G')  --[마스터 대표속성] 패키지,실시간항공,허니문,골프
			AND A.PRO_TYPE = 1 AND D.SIGN_CODE <> 'K' 
			AND (B.NOR_TEL1 IS NOT NULL OR B.NOR_TEL2 IS NOT NULL OR B.NOR_TEL3 IS NOT NULL)
	GROUP BY A.RES_CODE, B.NOR_TEL1, B.NOR_TEL2, B.NOR_TEL3
	UNION
	SELECT --A.MASTER_CODE, A.RES_CODE, A.DEP_DATE, B.*
		A.RES_CODE, B.NOR_TEL1, B.NOR_TEL2, B.NOR_TEL3
		, '[참좋은여행] 여행 출발 3일전입니다. 참좋은여행APP ''나만의여행가이드''로 여행준비 하고 계신가요?데이터 오프라인시에도 지도를 통한 여행일정과 출입국신고서를 확인할 수 있으니, 출발 전 여행일정을 다운받아 준비해보세요.* 다운로드 : https://goo.gl/uUhSgb (안드로이드만 가능)' AS MSG
	FROM RES_MASTER_damo A WITH(NOLOCK)
		INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		WHERE A.DEP_DATE >= DATEADD(DAY, 2, GETDATE()) 
			AND A.DEP_DATE < DATEADD(DAY, 3, GETDATE()) 
			AND A.RES_STATE < 7 
			AND B.RES_STATE = 0 
			AND A.PRO_TYPE = 2 
			AND A.MASTER_CODE NOT LIKE 'K%'
			AND (B.NOR_TEL1 IS NOT NULL OR B.NOR_TEL2 IS NOT NULL OR B.NOR_TEL3 IS NOT NULL)
	GROUP BY A.RES_CODE, B.NOR_TEL1, B.NOR_TEL2, B.NOR_TEL3
	ORDER BY A.RES_CODE

	--SELECT --A.MASTER_CODE, A.RES_CODE, A.DEP_DATE, B.*
	--	A.RES_CODE, B.CUS_NAME, B.NOR_TEL1, B.NOR_TEL2, B.NOR_TEL3
	--	, '[참좋은여행] 여행 출발 일주일 전입니다.  오프라인 시에도 여행 일정 및 지도를 통한 이동 경로와 출입국 신고서를 확인할 수 있으니, 출발 전 오프라인 정보를 다운받으세요. https://play.google.com/store/apps/details?id=com.verygoodtour.smartcare (안드로이드버젼만 가능)' AS MSG
	--FROM RES_MASTER_damo A WITH(NOLOCK)
	--	INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	--	INNER JOIN PKG_DETAIL C WITH(NOLOCK) ON A.PRO_CODE = C.PRO_CODE
	--	INNER JOIN PKG_MASTER D WITH(NOLOCK) ON C.MASTER_CODE = D.MASTER_CODE
	--	WHERE A.DEP_DATE >= DATEADD(DAY, 7, GETDATE()) AND A.DEP_DATE < DATEADD(DAY, 8, GETDATE()) AND A.RES_STATE < 7 AND B.RES_STATE = 0 AND A.PRO_TYPE = 1 AND D.SIGN_CODE <> 'K' AND D.ATT_CODE = 'P'
	--UNION
	--SELECT --A.MASTER_CODE, A.RES_CODE, A.DEP_DATE, B.*
	--	A.RES_CODE, B.CUS_NAME, B.NOR_TEL1, B.NOR_TEL2, B.NOR_TEL3
	--	, '[참좋은여행] 여행 출발 일주일 전입니다.  오프라인 시에도 여행 일정 및 지도를 통한 이동 경로와 출입국 신고서를 확인할 수 있으니, 출발 전 오프라인 정보를 다운받으세요. https://play.google.com/store/apps/details?id=com.verygoodtour.smartcare (안드로이드버젼만 가능)' AS MSG
	--FROM RES_MASTER_damo A WITH(NOLOCK)
	--	INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	--	WHERE A.DEP_DATE >= DATEADD(DAY, 7, GETDATE()) AND A.DEP_DATE < DATEADD(DAY, 8, GETDATE()) AND A.RES_STATE < 7 AND B.RES_STATE = 0 AND A.PRO_TYPE = 2 AND A.MASTER_CODE NOT LIKE 'K%'
END
GO
