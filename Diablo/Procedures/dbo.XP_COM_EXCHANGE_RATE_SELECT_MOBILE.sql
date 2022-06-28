USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_EXCHANGE_RATE_SELECT_MOBILE
■ DESCRIPTION				: BTMS 환율정보 검색 모바일
■ INPUT PARAMETER			: NONE
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-07-06		저스트고(강태영)			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EXCHANGE_RATE_SELECT_MOBILE]
	
AS 
BEGIN
	-- 환율정보 --
	SELECT
		A.SEQ_NO,
		A.CURRENCY_CODE,
		B.CODE_KOR,
		B.CURRENCY_KOR,
		(B.CODE_KOR + ' ' + B.CURRENCY_KOR + ' ' + A.CURRENCY_CODE) AS CURRENCY_NAME,
		BUY_CASH,
		SELL_CASH,
		SEND_CASH,
		RECV_CASH,
		SELL_CHECK,
		EXCHANGE_RATE,
		(CONVERT(VARCHAR(20), EXCHANGE_RATE) + ',' + A.CURRENCY_CODE + ',' + B.CURRENCY_KOR) AS EXCHANGE_RATE_MOBILE,
		USD_RATE,
		CONVERT_RATE,
		A.USE_YN,
		A.UPDATE_DATE,
		A.UPDATE_COUNT
	FROM COM_EXCHANGE_RATE A
	LEFT JOIN COM_CURRENCY_CODE B ON A.CURRENCY_CODE = B.CURRENCY_CODE
	WHERE A.CURRENCY_CODE <> 'ESP'

END 
GO
