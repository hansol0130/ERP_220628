USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ Server					: 
■ Database					: DIABLO
■ USP_Name					: SP_WEB_SEARCH_LIST
■ Description				: 키워드를 통한 여행 상품을 검색한다.
■ Input Parameter			:                  
		@FLAG				:
		@CATEGORY			:
		@SORT_CODE			:
		@PAGE_SIZE			:
		@PAGE_INDEX			:
		@SEARCH_TEXT		:
		@PROVIDER			: 
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_WEB_SEARCH_LIST  
■ Author					:  
■ Date						: 
■ Memo						: 
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------
									최초생성
	2010-12-08       이규식			메인화면의 통합검색 함수
	2011-03-10       박형만			PROVIDER 조건 PKG_MASTER_AFFILIATE 와 조인
	2011-04-14		박형만			임시 씽크엔젤PROVIDER=16 나오도록 
	2011-12-26		김현진			자유여행만 조회 추가
	2012-09-25		박형만			특정 마스터 코드 검색 안됨 UNION 으로 해결 (SQL FULLTEXT SEARCH BUG,,?)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_WEB_SEARCH_LIST]
(
	@FLAG   CHAR(1),
	@CATEGORY INT,
	@SORT_CODE  INT,
	@PAGE_SIZE  INT,
	@PAGE_INDEX  INT,
	@SEARCH_TEXT VARCHAR(100),
	@PROVIDER  INT
)
AS  
--DECLARE @FLAG   CHAR(1),
--	@CATEGORY INT,
--	@SORT_CODE  INT,
--	@PAGE_SIZE  INT,
--	@PAGE_INDEX  INT,
--	@SEARCH_TEXT VARCHAR(100),
--	@PROVIDER  INT
--SELECT @SORT_CODE=1,@PAGE_INDEX=0,@PAGE_SIZE=20,@SEARCH_TEXT=N'홍콩 자유여행',@CATEGORY=0,@PROVIDER=5,@FLAG=N'L'

	BEGIN  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED		
		DECLARE @LEFTTABLE NVARCHAR(1000)
		DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);
		DECLARE @KEYWORD NVARCHAR(4000), @SORT_STRING VARCHAR(100), @DESC VARCHAR(10), @FROM INT, @TO INT;
		DECLARE @TMP VARCHAR(2000);
		DECLARE @MASTER_SEQ VARCHAR(50)
		
		SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;  
		SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;  

		-- 상품 검색일 경우의 처리
		IF @CATEGORY = 0 OR @CATEGORY = 5
		BEGIN
			-- WHERE 조건 만들기
			SET @WHERE = 'WHERE A.SHOW_YN = ''Y'' AND A.LAST_DATE >= GETDATE() + 3 '
			SET @LEFTTABLE = ''
   
			-- 자유여행은 자유여행만 조회
			IF @CATEGORY = 5
			BEGIN
				SET @WHERE = @WHERE + 'AND A.ATT_CODE = ''F'' '
			END
			
			IF ISNULL(@SEARCH_TEXT, '') <> ''  
			BEGIN
				SELECT @KEYWORD = STUFF((SELECT (' AND ' + DATA ) AS [text()] FROM [DBO].[FN_SPLIT] (@SEARCH_TEXT, ' ') WHERE DATA <> '' FOR XML PATH('')), 1, 5, '')
			END
			
			SET @LEFTTABLE = 'INNER JOIN  CONTAINSTABLE(PKG_MASTER, *, ''' + @KEYWORD + ''') B 
				ON B.[KEY] = A.MASTER_CODE AND A.MASTER_CODE <> @SEARCH_TEXT ' --마스터 코드 조건일경우 UNION 으로 가져오기 때문에 INNER JOIN 에서 제거 

			-- SORT 조건 만들기  
			SELECT @SORT_STRING = (  
				CASE @SORT_CODE  
					WHEN 1 THEN 'RANK'
					WHEN 2 THEN 'LOW_PRICE'
					WHEN 3 THEN 'HIGH_PRICE'
				END
			)
			
			SELECT @DESC = (
				CASE @SORT_CODE
					WHEN 1 THEN ' DESC'
					WHEN 3 THEN ' DESC'
					ELSE ''
				END
			)
			
			IF @FLAG = 'C'  
			BEGIN  
				SET @SQLSTRING = N'
					SELECT COUNT(*)
					FROM (
						SELECT A.MASTER_CODE
						FROM PKG_MASTER A WITH(NOLOCK)
						WHERE A.MASTER_CODE = @SEARCH_TEXT
						UNION ALL 
						SELECT A.MASTER_CODE
						FROM PKG_MASTER A WITH(NOLOCK)
						' + @LEFTTABLE
						
				IF (@PROVIDER NOT IN(0,5,16))
					--SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_PROVIDER Z WITH(NOLOCK) ON Z.PROVIDER = ' + CAST(@PROVIDER AS VARCHAR) + ' AND A.MASTER_CODE = Z.CODE
					SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = ' + CAST(@PROVIDER AS VARCHAR) + ' AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''
						'
						
				SET @SQLSTRING = @SQLSTRING + @WHERE + '
						GROUP BY A.MASTER_CODE
					) A'
					
			END  
			ELSE IF @FLAG = 'L'  
			BEGIN  
				SET @SQLSTRING = N'
					WITH LIST AS
					(
						SELECT ROW_NUMBER() OVER (ORDER BY ' + @SORT_STRING + ') AS [ROWNUMBER], MASTER_CODE, ' + @SORT_STRING + '
						FROM 
						(
							SELECT A.MASTER_CODE, 1 AS RANK , A.LOW_PRICE , A.HIGH_PRICE 
							FROM PKG_MASTER A WITH(NOLOCK)
							WHERE A.MASTER_CODE = @SEARCH_TEXT
							UNION ALL 
							SELECT A.MASTER_CODE, B.RANK , A.LOW_PRICE , A.HIGH_PRICE 
							FROM PKG_MASTER A WITH(NOLOCK)
							' + @LEFTTABLE
							
				IF (@PROVIDER NOT IN(0,5,16))
					--SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_PROVIDER Z WITH(NOLOCK) ON Z.PROVIDER = ' + CAST(@PROVIDER AS VARCHAR) + ' AND A.MASTER_CODE = Z.CODE
					SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = ' + CAST(@PROVIDER AS VARCHAR) + ' AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''
						'
							
				SET @SQLSTRING = @SQLSTRING + @WHERE + '
						)TBL
						GROUP BY MASTER_CODE, ' + @SORT_STRING + '
					)
					SELECT
						B.MASTER_CODE, B.MASTER_NAME, B.PKG_COMMENT, B.PKG_SUMMARY, B.LOW_PRICE, B.HIGH_PRICE, B.EVENT_NAME, B.NEXT_DATE   
						, B.EVENT_PRO_CODE, B.EVENT_DEP_DATE  
						, (SELECT SUM(GRADE) / COUNT(GRADE) FROM PRO_COMMENT WHERE MASTER_CODE = A.MASTER_CODE) AS [GRADE]  
						, (SELECT COUNT(*) FROM HBS_DETAIL WHERE MASTER_SEQ = ''1'' AND MASTER_CODE = A.MASTER_CODE) AS [TRAVEL]  
						, C.*, D.TWO_COUNT, D.THREE_COUNT, D.FOUR_COUNT, D.FIVE_COUNT,  
						D.TWO_PERCENT, D.THREE_PERCENT, D.FOUR_PERCENT, D.FIVE_PERCENT  
						, DBO.FN_GET_TOUR_NIGHY_DAY_TEXT(B.MASTER_CODE,0) AS TOUR_NIGHT_DAY
						, B.ATT_CODE
					FROM LIST A  
					INNER JOIN PKG_MASTER B  WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE  
					LEFT OUTER JOIN INF_FILE_MASTER C  WITH(NOLOCK) ON B.MAIN_FILE_CODE = C.FILE_CODE  
					LEFT OUTER JOIN STS_PKG_RES_COUNT D  WITH(NOLOCK) ON A.MASTER_CODE = D.MASTER_CODE  
					WHERE A.ROWNUMBER BETWEEN @FROM AND @TO  
				ORDER BY ' + @SORT_STRING + @DESC
			END  
		END
		-- 여행후기 검색
		ELSE IF @CATEGORY = 3 OR @CATEGORY = 4
		BEGIN
			IF @CATEGORY = 3 
			BEGIN
				SET @MASTER_SEQ = '1'
			END
			ELSE
			BEGIN
				SET @MASTER_SEQ = '2,4,5,7,12,15,17'
			END
			
			-- WHERE 조건 만들기
			SET @WHERE = ' A.MASTER_SEQ IN (' + @MASTER_SEQ + ') AND A.NOTICE_YN = ''N''  AND A.LEVEL = 0 AND A.DEL_YN = ''N'' '
			SET @LEFTTABLE = ''
			
			IF ISNULL(@SEARCH_TEXT, '') <> ''  
			BEGIN
				SELECT @KEYWORD = STUFF((SELECT (' AND ' + DATA ) AS [text()] FROM [DBO].[FN_SPLIT] (@SEARCH_TEXT, ' ') WHERE DATA <> '' FOR XML PATH('')), 1, 5, '')
			END
			
			SET @LEFTTABLE = ' INNER JOIN  CONTAINSTABLE(HBS_DETAIL, *, ''' + @KEYWORD + ''') C ON C.[KEY] = A.SEARCH_PK '

			-- SORT 조건 만들기  
			SELECT @SORT_STRING = (  
				CASE @SORT_CODE  
					WHEN 1 THEN 'RANK'
					ELSE 'RANK'
				END
			)
			
			SELECT @DESC = (
				CASE @SORT_CODE
					WHEN 1 THEN ' DESC'
					WHEN 3 THEN ' DESC'
					ELSE ''
				END
			)

			IF @FLAG = 'C'  
			BEGIN  
				SET @SQLSTRING = N'
					SELECT COUNT(*)
					FROM (
						SELECT A.SEARCH_PK
						FROM HBS_DETAIL A WITH(NOLOCK)
						' + @LEFTTABLE + ' WHERE '
						
				SET @SQLSTRING = @SQLSTRING + @WHERE + '
						GROUP BY A.SEARCH_PK
					) A'
					
			END  
			ELSE IF @FLAG = 'L'  
			BEGIN  
				SET @SQLSTRING = N'
					WITH LIST AS
					(
						SELECT ROW_NUMBER() OVER (ORDER BY ' + @SORT_STRING + ') AS [ROWNUMBER], A.SEARCH_PK, C.RANK
						FROM HBS_DETAIL A WITH(NOLOCK)
						' + @LEFTTABLE  + ' WHERE '
							

				SET @SQLSTRING = @SQLSTRING + @WHERE + '
					)
					SELECT
							B.MASTER_SEQ,		B.BOARD_SEQ,		B.SUBJECT,			B.SHOW_COUNT,	
							B.LEVEL,			B.STEP,				B.COMPLETE_YN,		B.EDIT_PASS,
							B.LOCK_YN,			B.MASTER_CODE,		B.REGION_NAME,		B.NICKNAME,
							B.NEW_DATE,			B.DEL_YN,			B.NEW_CODE AS CUS_NO,					
							C.CATEGORY_NAME,	B.CATEGORY_SEQ,		B.CONTENTS,
							dbo.FN_CUS_GET_CUS_NAME(B.NEW_CODE) AS CUS_NAME, B.NEW_CODE,
							(SELECT COUNT(*) FROM HBS_COMMENT WHERE MASTER_SEQ = B.MASTER_SEQ AND BOARD_SEQ = B.BOARD_SEQ AND DEL_YN = ''N'') AS COMMENT_COUNT,
							(SELECT COUNT(*) FROM HBS_FILE WHERE MASTER_SEQ = B.MASTER_SEQ AND BOARD_SEQ = B.BOARD_SEQ) AS FILE_COUNT
					FROM LIST A  
					INNER JOIN HBS_DETAIL B ON B.SEARCH_PK = A.SEARCH_PK
					LEFT JOIN HBS_CATEGORY C ON C.MASTER_SEQ = B.MASTER_SEQ AND C.CATEGORY_SEQ = B.CATEGORY_SEQ 
					WHERE A.ROWNUMBER BETWEEN @FROM AND @TO  
				ORDER BY ' + @SORT_STRING + @DESC
			END  
		END
		
		
		SET @PARMDEFINITION = N'@FROM INT, @TO INT, @SEARCH_TEXT VARCHAR(100)';  

		--PRINT @SQLSTRING
		
		EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @FROM, @TO, @SEARCH_TEXT;  

	END
GO
