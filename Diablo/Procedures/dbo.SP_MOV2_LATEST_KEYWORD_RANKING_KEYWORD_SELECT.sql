USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_LATEST_KEYWORD_RANKING_KEYWORD_SELECT
■ DESCRIPTION				: 검색_최신키워드랭킹_KEYWORD
■ INPUT PARAMETER			: CUS_NO
■ EXEC						: 
    -- EXEC SP_MOV2_LATEST_KEYWORD_RANKING_KEYWORD_SELECT '파리', '2017-09-28', '2017-10-05', 1, 10

■ MEMO						: 검색_최신키워드랭킹_KEYWORD
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION			최초생성
   2017-11-15		IBSOLUTION			키워드 테이블 변경(VGLOG.DBO.KEYWORD_LOG)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_LATEST_KEYWORD_RANKING_KEYWORD_SELECT]
	@KEYWORD		VARCHAR(100),
	@START_DATE		VARCHAR(20),
	@END_DATE		VARCHAR(20),
	@FROM			INT,
	@TO				INT

AS
BEGIN

	DECLARE @SQLSTRING NVARCHAR(1000), @PARMDEFINITION NVARCHAR(100);
	SET @SQLSTRING = N'
		SELECT * FROM
		(
			SELECT A.*,ROW_NUMBER() OVER (ORDER BY RANKING) AS NUM
			FROM (
				SELECT RANK() OVER(ORDER BY COUNT(KEYWORD) DESC) AS RANKING ,  KEYWORD, COUNT(KEYWORD) CNT
				FROM VGLOG.DBO.KEYWORD_LOG  WITH(NOLOCK)
				WHERE NEW_DATE BETWEEN CONVERT(DATETIME,@START_DATE + '' 00:00:00'') AND CONVERT(DATETIME,@END_DATE + '' 23:59:59'') 
				AND KEYWORD LIKE ''%'' + @KEYWORD + ''%''
				GROUP BY KEYWORD
			) A
		) A
		WHERE A.NUM BETWEEN @FROM AND @TO ';

	SET @PARMDEFINITION = N'@KEYWORD VARCHAR(20), @START_DATE VARCHAR(20), @END_DATE VARCHAR(20), @FROM INT, @TO INT';
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @KEYWORD, @START_DATE, @END_DATE, @FROM, @TO;


END           


GO
