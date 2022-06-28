USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_LATEST_KEYWORD_RANKING_ALL_SELECT
■ DESCRIPTION				: 검색_최신키워드랭킹_ALL
■ INPUT PARAMETER			: START_DATE, END_DATE, FROM, TO, AGE
■ EXEC						: 
    -- EXEC SP_MOV2_LATEST_KEYWORD_RANKING_ALL_SELECT '2017-09-28', '2017-10-05', 1, 10, 0 

■ MEMO						: 검색_최신키워드랭킹_ALL
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION			최초생성
   2017-11-15		IBSOLUTION			키워드 테이블 변경(VGLOG.DBO.KEYWORD_LOG)
   2018-01-02		IBSOLUTION			연령대 구분 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_LATEST_KEYWORD_RANKING_ALL_SELECT]
	@START_DATE		VARCHAR(20),
	@END_DATE		VARCHAR(20),
	@FROM			INT,
	@TO				INT,
	@AGE			INT


AS
BEGIN

	DECLARE @SQLSTRING NVARCHAR(1000), @PARMDEFINITION NVARCHAR(100), @START_AGE INT, @END_AGE INT;

	IF @AGE = 0 
		BEGIN
			SET @START_AGE = 0;
			SET @END_AGE = 200;
		END
	ELSE 
		BEGIN
			SET @START_AGE = (@AGE - 1) * 10;
			SET @END_AGE = @AGE * 10 - 1;
			IF @AGE = 9
				BEGIN 
					SET @END_AGE = 200;
				END 
		END


	IF @AGE = 0 
		BEGIN
			SET @SQLSTRING = N'
				SELECT * FROM
				(
					SELECT A.*,ROW_NUMBER() OVER (ORDER BY RANKING) AS NUM
					FROM (
						SELECT RANK() OVER(ORDER BY COUNT(KEYWORD) DESC) as RANKING ,  KEYWORD, COUNT(KEYWORD) CNT
						FROM VGLOG.DBO.KEYWORD_LOG A WITH(NOLOCK)
						WHERE NEW_DATE BETWEEN CONVERT(DATETIME,@START_DATE + '' 00:00:00'') AND CONVERT(DATETIME,@END_DATE + '' 23:59:59'') 
						GROUP BY KEYWORD
					) A
				) A
				WHERE A.NUM BETWEEN @FROM AND @TO ';
		END
	ELSE
		BEGIN
			SET @SQLSTRING = N'
				SELECT * FROM
				(
					SELECT A.*,ROW_NUMBER() OVER (ORDER BY RANKING) AS NUM
					FROM (
						SELECT RANK() OVER(ORDER BY COUNT(A.KEYWORD) DESC) as RANKING ,  A.KEYWORD, COUNT(A.KEYWORD) CNT
							FROM VGLOG.DBO.KEYWORD_LOG A WITH(NOLOCK)
								INNER JOIN CUS_CUSTOMER_damo B WITH(NOLOCK)
									ON A.CUS_NO = B.CUS_NO
						WHERE 
							A.CUS_NO > 0
							AND B.BIRTH_DATE IS NOT NULL 
							AND DATEDIFF(YEAR,B.BIRTH_DATE,GETDATE()) + 1 >= ' + CONVERT(VARCHAR(3),@START_AGE) + ' AND DATEDIFF(YEAR,B.BIRTH_DATE,GETDATE()) + 1 <= ' + CONVERT(VARCHAR(3),@END_AGE) + '
							AND A.NEW_DATE BETWEEN CONVERT(DATETIME,@START_DATE + '' 00:00:00'') AND CONVERT(DATETIME,@END_DATE + '' 23:59:59'') 
						GROUP BY A.KEYWORD
					) A
				) A
				WHERE A.NUM BETWEEN @FROM AND @TO ';
		END

	PRINT @SQLSTRING;

	SET @PARMDEFINITION = N'@START_DATE VARCHAR(20), @END_DATE VARCHAR(20), @FROM INT, @TO INT';
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @START_DATE, @END_DATE, @FROM, @TO;
END           



GO
