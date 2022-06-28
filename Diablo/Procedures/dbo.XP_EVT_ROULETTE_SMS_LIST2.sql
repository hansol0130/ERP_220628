USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_EVT_ROULETTE_SMS_LIST2
■ DESCRIPTION				: 룰렛이벤트 SMS 전송 리스트 (종료로 인한 확인 문자 대상자 )
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
사용 후 삭제 예정
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-18		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[XP_EVT_ROULETTE_SMS_LIST2]
AS 
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--SELECT '정지용' AS CUS_NAME, '010' AS NOR_TEL1, '3444' AS NOR_TEL2, '1147' AS NOR_TEL3
	/*
	SELECT 
		B.CUS_NAME,
		B.NOR_TEL1,
		B.NOR_TEL2,
		B.NOR_TEL3,
		GETDATE()
	FROM (
		SELECT
			CUS_CODE, COUNT(1) AS CNT
		FROM EVT_ROULETTE
		GROUP BY CUS_CODE, COP_USE_YN HAVING COP_USE_YN = 'N'	
	) A 
	INNER JOIN CUS_MEMBER B ON A.CUS_CODE = B.CUS_NO
	WHERE NOR_TEL1 IS NOT NULL AND NOR_TEL2 IS NOT NULL AND NOR_TEL3 IS NOT NULL
	ORDER BY B.CUS_NAME ASC
	

	select top 100 * from RES_SND_SMS where SND_TYPE = 34 order by SND_NO desc
	SELECT * FROM EVT_ROULETTE_SMS_TEMP
	*/
	-- 후에 사용시 비우고 시작
	SELECT CUS_NAME, NOR_TEL1, NOR_TEL2, NOR_TEL3 FROM EVT_ROULETTE_SMS_TEMP WHERE SEQ >= 13001 AND SEQ <= 15000
END 

GO
