USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: SP_PKG_MASTER_SELECT_LIST_4  
■ Description				: 마스터 검색
■ Input Parameter			:                  
		@FLAG				:
		@PAGE_SIZE			:
		@PAGE_INDEX			:
		@EMP_CODE			:
		@TEAM_CODE			:
		@MASTER_CODE		:
		@MASTER_NAME		:
		@CITY_CODE			:
		@SHOW_YN			:
		@ORDERBY			:
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_PKG_MASTER_SELECT_LIST_4  
■ Author					:   
■ Date						: 
■ Memo						: 2009-10-20부터 SP_PKG_MASTER_SELECT_LIST_2를 사용하지 않고 SP_PKG_MASTER_SELECT_LIST_4를 사용
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
									최초생성  
-------------------------------------------------------------------------------------------------*/ 

CREATE PROCEDURE [dbo].[SP_PKG_MASTER_SELECT_LIST_4]
(
	@FLAG						CHAR(1),
	@PAGE_SIZE					INT,
	@PAGE_INDEX					INT,
	@EMP_CODE					VARCHAR(7),
	@TEAM_CODE					VARCHAR(3),
	@MASTER_CODE				VARCHAR(10),
	@MASTER_NAME				NVARCHAR(100),
	@CITY_CODE					CHAR(3),
	@SHOW_YN					CHAR(1)						= '',
	@ORDERBY					INT
)

AS

	BEGIN
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(1000), @PARMDEFINITION NVARCHAR(1000), @FROM INT, @TO INT;

		SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;
		SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;

		-- WHERE 조건 만들기
		SET @SQLSTRING = 'WHERE (A.SECTION_YN = ''Y'' AND A.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER  WITH(NOLOCK) WHERE TEAM_CODE = @TEAM_CODE))';
		
			-- 마스터코드
		IF LEN(ISNULL(@MASTER_CODE, '')) >= 3
		BEGIN
			--SET @SQLSTRING = 'WHERE 1 = 2'
			SET @WHERE = 'WHERE A.MASTER_CODE LIKE @MASTER_CODE + ''%'''
		END
		ELSE
		BEGIN
			---SET @WHERE = ''        ---------------------------------------아래로 변경         
			SET  @WHERE = ' WHERE ' 
		
			-- 담당자코드(없으면 팀 전체, 팀 코드가 없으면 전체)
			IF ISNULL(@EMP_CODE, '') <> ''
				SET @WHERE = @WHERE + ' A.NEW_CODE = @EMP_CODE AND'
			ELSE IF ISNULL(@TEAM_CODE, '') <> ''
				SET @WHERE = @WHERE + ' A.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER  WITH(NOLOCK) WHERE TEAM_CODE = @TEAM_CODE) AND'
			
			-- 도시코드
			IF ISNULL(@CITY_CODE, '') <> ''
			BEGIN
				SET @WHERE = @WHERE + ' EXISTS(SELECT 1 FROM PKG_MASTER_SCH_CITY  WITH(NOLOCK) WHERE MASTER_CODE = A.MASTER_CODE AND CITY_CODE = @CITY_CODE) AND'
			END
			
			-- 상품명
			IF ISNULL(@MASTER_NAME, '') <> ''
			BEGIN
				--SET @MASTER_NAME = '%' + @MASTER_NAME + '%'
				SET @WHERE = @WHERE + ' A.MASTER_NAME LIKE (''%'' + @MASTER_NAME + ''%'') AND'
			END
			
			-- 노출여부 (없으면 전체)
			IF ISNULL(@SHOW_YN, '') <> ''
			BEGIN
				SET @WHERE = @WHERE + ' A.SHOW_YN = @SHOW_YN AND'
			END
			
			IF LEN(@WHERE) > 6
				--SET @SQLSTRING = @SQLSTRING + ' OR (' + SUBSTRING(@WHERE, 1, (LEN(@WHERE) - 4)) + ')'   ---------------------------------------아래로 변경     
				SET  @WHERE =  SUBSTRING(@WHERE, 1, (LEN(@WHERE) - 4))
			ELSE
				SET @WHERE = ''
		END
		
		IF @FLAG = 'C'					-- 전체 글수
		BEGIN
		--	SET @SQLSTRING = N'SELECT COUNT(*) FROM PKG_MASTER A  WITH(NOLOCK) ' + @SQLSTRING;  ---------------------------------------아래로 변경     
		SET @SQLSTRING = N'
			SELECT COUNT(*) FROM (
				SELECT MASTER_CODE
				FROM PKG_MASTER A WITH(NOLOCK) ' + @SQLSTRING + '
				UNION 
				SELECT MASTER_CODE 
				FROM PKG_MASTER A WITH(NOLOCK) ' + @WHERE + '
			) A' ;
		END
		ELSE IF @FLAG = 'L'				-- 검색
		BEGIN
			SET @SQLSTRING = N'
			WITH LIST AS
			(
				SELECT ROW_NUMBER() OVER (ORDER BY A.MASTER_CODE) AS [ROWNUMBER], A.MASTER_CODE
				FROM (
					SELECT MASTER_CODE 
					FROM PKG_MASTER A WITH(NOLOCK)                      ---------------------------------------아래로 변경  시작
					' + @SQLSTRING + '
					UNION 
					SELECT MASTER_CODE 
					FROM PKG_MASTER A WITH(NOLOCK) ' + @WHERE + ' 
				) A														---------------------------------------아래로 변경 끝
			)
			SELECT A.ROWNUMBER, A.MASTER_CODE, B.MASTER_NAME, B.LOW_PRICE, B.HIGH_PRICE, B.TOUR_DAY, B.SHOW_YN, B.NEW_DATE, B.EDT_DATE,
				(SELECT TOP 1 DEP_DATE FROM PKG_DETAIL  WITH(NOLOCK) WHERE MASTER_CODE = A.MASTER_CODE AND GETDATE() < DEP_DATE ORDER BY DEP_DATE ) AS [FIRST_DATE],
				(SELECT TOP 1 DEP_DATE FROM PKG_DETAIL  WITH(NOLOCK) WHERE MASTER_CODE = A.MASTER_CODE AND GETDATE() < DEP_DATE ORDER BY DEP_DATE DESC ) AS [LAST_DATE],
				(SELECT KOR_NAME FROM EMP_MASTER  WITH(NOLOCK) WHERE EMP_CODE = B.NEW_CODE) AS [NEW_NAME],
				B.REGION_ORDER, B.SECTION_YN
			FROM LIST A
			INNER JOIN PKG_MASTER B  WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
			WHERE ROWNUMBER BETWEEN @FROM AND @TO';
	--		ORDER BY B.MASTER_CODE;';

			IF @ORDERBY = 0
			BEGIN
				SET @SQLSTRING = @SQLSTRING + ' ORDER BY B.REGION_ORDER;';
			END
			ELSE IF @ORDERBY = 1
			BEGIN
				SET @SQLSTRING = @SQLSTRING + ' ORDER BY B.MASTER_CODE;';
			END
		END

		SET @PARMDEFINITION = N'@FROM INT, @TO INT, @EMP_CODE VARCHAR(7), @TEAM_CODE VARCHAR(3), @MASTER_CODE VARCHAR(10), @MASTER_NAME NVARCHAR(100), @CITY_CODE CHAR(3), @SHOW_YN CHAR(1)';

		--PRINT @SQLSTRING
		EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @FROM, @TO, @EMP_CODE, @TEAM_CODE, @MASTER_CODE, @MASTER_NAME, @CITY_CODE, @SHOW_YN;
	END
GO
