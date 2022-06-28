USE [Cuve]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PRODUCT_RECOMMEND_LOG_DAILY_DELETE
■ DESCRIPTION				: 추천 데이타 데일리 삭제
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_PRODUCT_RECOMMEND_LOG_DAILY_DELETE
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2017-07-19		정지용			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_PRODUCT_RECOMMEND_LOG_DAILY_DELETE]	
AS
BEGIN
	DECLARE @LOG_MIN_DATE DATETIME;
	SELECT TOP 1 @LOG_MIN_DATE = IN_DATE FROM TMP_1YEAR_LOG WITH(NOLOCK) ORDER BY SEQ_NO ASC;
	
	DELETE FROM TMP_1YEAR_LOG WHERE IN_DATE >= CONVERT(VARCHAR(10), @LOG_MIN_DATE, 121) + ' 00:00:00' AND IN_DATE <= CONVERT(VARCHAR(10), @LOG_MIN_DATE, 121) + ' 23:59:59'
END

GO
