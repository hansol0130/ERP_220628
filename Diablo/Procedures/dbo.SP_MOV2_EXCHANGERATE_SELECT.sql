USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_EXCHANGERATE_SELECT
■ DESCRIPTION				: 검색_도시별환율정보
■ INPUT PARAMETER			: CUS_NO, PAGE_INDEX, PAGE_SIZE
■ EXEC						: 
    -- 
	exec SP_MOV2_EXCHANGERATE_SELECT 'TYO'

■ MEMO						: 도시별환율정보
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-24		IBSOLUTION				최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_EXCHANGERATE_SELECT]
	@CITY_CODE		CHAR(3)
AS
BEGIN

	SELECT AA.EXCHANGE_RATE,B.SEQ_NO, B.CURRENCY_CODE,B.CURRENCY_KOR,B.CODE_KOR,B.USE_YN,AA.UPDATE_DATE
	FROM COM_EXCHANGE_RATE AA WITH (NOLOCK) 
	INNER JOIN (
		SELECT 
		CCC.SEQ_NO,
		CCC.CURRENCY_CODE,
		CCC.CURRENCY_KOR,
		CCC.CODE_KOR ,
		CCC.USE_YN
		FROM COM_CURRENCY_CODE CCC WITH (NOLOCK)
		INNER JOIN (
			SELECT PN.KOR_NAME FROM PUB_NATION PN WITH (NOLOCK)
				INNER JOIN PUB_CITY PC WITH (NOLOCK)
				ON PC.NATION_CODE = PN.NATION_CODE
			WHERE PC.CITY_CODE = @CITY_CODE
		) A 
		ON CCC.CODE_KOR = A.KOR_NAME
		Where CCC.USE_YN = 'Y'
	) B
	ON B.CURRENCY_CODE = AA.CURRENCY_CODE

END           


GO
