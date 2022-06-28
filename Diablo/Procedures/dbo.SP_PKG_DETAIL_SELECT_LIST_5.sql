USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: SP_PKG_DETAIL_SELECT_LIST_5
■ Description				: 
■ Input Parameter			:                  
		@MASTER_CODE		:  
		@PRO_CODE			:
		@TEAM_CODE			:
		@START_DATE			:
		@END_DATE			:
		@REGION_CODE		:
		@ATT_CODE			: 
		@GRP_CODE			:
		@CITY_CODE			:
		@RES_YN				:
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
■ Author					:  
■ Date						: 
■ Memo						: 2010년 3월10일부터는 LIST_4 를 사용하지 않고 LIST_5로 사용  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
2014-05-14		박형만	도시코드 검색 MAINCITY_YN ='Y' 인것만 
2014-07-07		박형만	상품가 총액추가
---------------------------------------------------------------------------------------------------
									최초생성  
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[SP_PKG_DETAIL_SELECT_LIST_5]
(
	@MASTER_CODE				VARCHAR(10),  
	@PRO_CODE					VARCHAR(20),  
	@TEAM_CODE					VARCHAR(3),  
	@START_DATE					DATETIME,  
	@END_DATE					DATETIME,  
	@REGION_CODE				VARCHAR(1),  
	@ATT_CODE					VARCHAR(1),  
	@GRP_CODE					VARCHAR(10),
	@CITY_CODE					VARCHAR(10)					= '',
	@RES_YN						INT,
	@KEYWORD					VARCHAR(100),
	@PRICE						INT
)
  
AS

	BEGIN
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		-- 변수 선언
		DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @START VARCHAR(10), @END VARCHAR(10); 
	  
		-- WHERE 조건 만들기  
		SET @SQLSTRING = '';  
		SET @START = ISNULL(CONVERT(VARCHAR(10), @START_DATE, 120), '')  
		SET @END = ISNULL(CONVERT(VARCHAR(10), DATEADD(DAY, 1, @END_DATE), 120), '')  
	  
		-- 마스터코드  
		IF ISNULL(@MASTER_CODE, '') <> '' 
		BEGIN  
			SET @SQLSTRING = @SQLSTRING + ' A.MASTER_CODE = @MASTER_CODE AND'  
		END 

		-- 행사코드  
		IF ISNULL(@PRO_CODE, '') <> ''  
		BEGIN  
			SET @SQLSTRING = @SQLSTRING + ' A.PRO_CODE LIKE @PRO_CODE + ''%'' AND'  
		END 

		-- 출발일  
		IF ISNULL(@START, '') <> '' AND ISNULL(@END, '') <> ''  
		BEGIN  
			SET @SQLSTRING = @SQLSTRING + ' A.DEP_DATE >= CAST(@START AS DATETIME) AND A.DEP_DATE < CAST(@END AS DATETIME) AND'  
		END  
		ELSE IF ISNULL(@START_DATE, '') <> '' AND ISNULL(@END_DATE, '') = ''  
		BEGIN  
			SET @SQLSTRING = @SQLSTRING + ' A.DEP_DATE >= CAST(@START_DATE AS DATETIME) AND'  
		END  
		ELSE IF ISNULL(@START_DATE, '') = '' AND ISNULL(@END_DATE, '') <> ''  
		BEGIN  
			SET @SQLSTRING = @SQLSTRING + ' A.DEP_DATE < CAST(@END_DATE AS DATETIME) + 1 AND'  
		END 
		
		--검색조건 추가 
	
		-- 키워드입력  
		IF ISNULL(@KEYWORD, '') <> ''  
		BEGIN  
			SET @SQLSTRING = @SQLSTRING + ' C.KEYWORD LIKE ''%'' + @KEYWORD + ''%'' AND'  
		END 
		
		--가격검색
		IF @PRICE > 0  
		BEGIN  
			SET @SQLSTRING = @SQLSTRING + ' C.LOW_PRICE >= @PRICE'  
		END
		
		--검색조건 추가 
	  
		-- 지역  
		IF ISNULL(@REGION_CODE, '') <> ''  
		BEGIN  
			SET @SQLSTRING = @SQLSTRING + ' C.SIGN_CODE = @REGION_CODE AND';  
		END  
		-- 속성  
		IF ISNULL(@ATT_CODE, '') <> ''  
		BEGIN  
			SET @SQLSTRING = @SQLSTRING + ' @ATT_CODE IN (SELECT ATT_CODE FROM PKG_ATTRIBUTE WHERE MASTER_CODE = C.MASTER_CODE)  AND';  
		END  

		-- 팀코드  
		IF ISNULL(@TEAM_CODE, '') <> ''  
		BEGIN  
			SET @SQLSTRING = @SQLSTRING + ' A.NEW_CODE IN (SELECT EMP_CODE  FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE = @TEAM_CODE) AND'  
		END  
	  
		-- @예약자 유무  
		IF @RES_YN > 0  
		BEGIN  
			SET @SQLSTRING = @SQLSTRING + ' (DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) > 0 OR A.SALE_TYPE IN (2, 3) ) AND'  
--			SET @SQLSTRING = @SQLSTRING + ' AND ' + CASE @RES_YN WHEN 2 THEN 'NOT ' ELSE '' END + 'EXISTS(SELECT 1 FROM RES_MASTER_damo WHERE PRO_CODE = A.PRO_CODE AND RES_STATE <= 7)'
		END    

		-- @그룹코드
		IF ISNULL(@GRP_CODE, '') <> '' 
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' C.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_GROUP WHERE GROUP_CODE= @GRP_CODE) AND'
		END  
		
		-- @도시코드
		IF ISNULL(@CITY_CODE, '') <> '' 
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' C.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_MASTER_SCH_CITY WHERE CITY_CODE= @CITY_CODE AND MAINCITY_YN =''Y'' ) AND'
		END  

		SET @SQLSTRING = N'SELECT A.DEP_CFM_YN, A.CONFIRM_YN, A.RES_ADD_YN, DBO.FN_PRO_GET_ACCOUNT_STATE(A.PRO_CODE) AS [ACCOUNT_TYPE],  
								  A.PRO_CODE, A.DEP_DATE, B.DEP_DEP_TIME AS [DEP_TIME],
								  (SELECT TOP 1 ADT_PRICE FROM PKG_DETAIL_PRICE WHERE PRO_CODE = A.PRO_CODE) AS [PRO_PRICE],  
								  ISNULL(dbo.XN_PRO_DETAIL_SALE_PRICE_CUTTING(A.PRO_CODE,0) , 0) AS [PRO_SALE_PRICE], --추가  
								  B.DEP_TRANS_CODE, B.DEP_TRANS_NUMBER, A.PRO_NAME,
								  DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS [RES_COUNT],  
								  FAKE_COUNT, MAX_COUNT, MIN_COUNT, B.SEAT_COUNT, C.SIGN_CODE, A.SALE_TYPE, A.PRICE_TYPE, A.PKG_INSIDE_REMARK  
						  FROM PKG_DETAIL A WITH(NOLOCK)   
						  INNER JOIN PKG_MASTER C WITH(NOLOCK) ON C.MASTER_CODE = A.MASTER_CODE   
						  LEFT OUTER JOIN PRO_TRANS_SEAT B  WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE  
						  WHERE' + SUBSTRING(@SQLSTRING, 0, LEN(@SQLSTRING) - 3) + '  
						  ORDER BY A.DEP_DATE'  
	  
		SET @PARMDEFINITION = N'@MASTER_CODE VARCHAR(10), @PRO_CODE VARCHAR(20), @TEAM_CODE VARCHAR(3), @START VARCHAR(10), @END VARCHAR(10), @ATT_CODE VARCHAR(1), @RES_YN INT, @REGION_CODE VARCHAR(1), 
		@GRP_CODE VARCHAR(10), @CITY_CODE VARCHAR(10), @KEYWORD NVARCHAR(4000), @PRICE INT';  

		PRINT @SQLSTRING  
		EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @MASTER_CODE, @PRO_CODE, @TEAM_CODE, @START, @END, @ATT_CODE, @RES_YN, @REGION_CODE, @GRP_CODE, @CITY_CODE, @KEYWORD, @PRICE
	END  
  
-- @MASTER_CODE, @PRO_CODE, @TEAM_CODE, @START_DATE, @END_DATE, @RES_YN  
-- SP_PKG_DETAIL_SELECT_LIST_2 '', '', '', '2009-06-01', '2009-08-31', 0  
  
--   

--select top 10 * from PKG_DETAIL

GO
