USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_CARD_INFO_SELECT_LIST
■ DESCRIPTION				: 카드 무이자 할부 정보 검색
■ INPUT PARAMETER			: 
	@ENDDATE_YEAR			: 해당 년도
	@ENDDATE_MONTH			: 해당 월
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec ZP_CARD_INFO_SELECT_LIST "2019","06"

	SELECT CARD_TYPE, TITLE, START_DATE, END_DATE, FREE_INFO,NEW_DATE 
	FROM PUB_CARD_INFO WHERE END_DATE LIKE @ENDDATE_YEAR='2019' AND END_DATE LIKE @ENDDATE_MONTH='06' 
	ORDER BY CARD_TYPE 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-08-29		지니웍스		최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[ZP_CARD_INFO_SELECT_LIST]
(
	@ENDDATE_YEAR	VARCHAR(4),
	@ENDDATE_MONTH	VARCHAR(2)
)

AS  
BEGIN
	SELECT CARD_TYPE, TITLE, START_DATE, END_DATE, FREE_INFO,NEW_DATE 
	FROM PUB_CARD_INFO 
	WHERE END_DATE LIKE @ENDDATE_YEAR AND END_DATE LIKE @ENDDATE_MONTH 
	ORDER BY CARD_TYPE 

	--SELECT CARD_TYPE, TITLE, START_DATE, END_DATE, FREE_INFO,NEW_DATE 
	--FROM PUB_CARD_INFO 
	--WHERE END_DATE LIKE '2019' AND END_DATE LIKE '06' 
	--ORDER BY CARD_TYPE 
	

END

GO
