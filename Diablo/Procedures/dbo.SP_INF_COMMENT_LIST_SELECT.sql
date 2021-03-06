USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- AUTHOR:		<김성호>
-- CREATE DATE: <2009-04-17>
-- DESCRIPTION:	<컨텐츠 댓글 정보 PAGING>
-- 2012-03-02 박형만 WITH(NOLOCK) 추가 	
-- =============================================
CREATE PROCEDURE [dbo].[SP_INF_COMMENT_LIST_SELECT]
	@FLAG			CHAR(1),
	@PAGE_SIZE		INT	= 10,
	@PAGE_INDEX		INT = 0,
	@CNT_CODE		INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000),	@FROM INT,	@TO INT;
	SET @SQLSTRING = '';

	SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;
	SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;

	-- 검색된 데이타의 카운트를 돌려준다.
	IF @FLAG = 'C'
	BEGIN
			SET @SQLSTRING = N'
			--SELECT COUNT(*) AS [COUNT], AVG(GRADE) AS [AVG]
			SELECT CONVERT(VARCHAR(10), ISNULL(COUNT(*), 0)) + ''|'' + CONVERT(VARCHAR(10), ISNULL(AVG(GRADE), 0))
			FROM INF_COMMENT WITH(NOLOCK)
			WHERE CNT_CODE = @CNT_CODE';
	END
	-- 검색된 데이타의 리스트를 돌려준다.
	ELSE IF @FLAG = 'L'
	BEGIN
		SET @SQLSTRING = N'WITH TMP_INF_COMMENT AS (
				SELECT 
					ROW_NUMBER() OVER (ORDER BY NEW_DATE DESC) AS ROWNUMBER,
					CNT_CODE, COM_SEQ
				FROM INF_COMMENT A WITH(NOLOCK)
				WHERE CNT_CODE = @CNT_CODE
		)
		SELECT B.*
		FROM TMP_INF_COMMENT A 
		INNER JOIN INF_COMMENT B WITH(NOLOCK) ON A.CNT_CODE = B.CNT_CODE AND A.COM_SEQ = B.COM_SEQ
		WHERE ROWNUMBER BETWEEN @FROM AND @TO
		ORDER BY B.NEW_DATE DESC';
	END
	SET @PARMDEFINITION=N'@FROM INT, @TO INT, @CNT_CODE INT';
	--PRINT @SQLSTRING + ' ' + @PARMDEFINITION
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @FROM, @TO, @CNT_CODE;
END

GO
