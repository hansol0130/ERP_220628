USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ USP_Name					: XP_AGT_PKG_MASTER_SELECT_LIST
■ Description				: 
■ Input Parameter			:                  
	@SIGN_CODE		VARCHAR(1),    --지역코드
	@ATT_CODE	VARCHAR(1),    -- 상품속성
	@MASTER_CODE	MASTER_CODE,   --마스터코드
	@MASTER_NAME	NVARCHAR(200),   --마스터명
	@START_DATE		DATETIME, -- 출발일시작
	@END_DATE		DATETIME -- 출발일끝
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						:  XP_AGT_PKG_MASTER_SELECT_LIST  @SIGN_CODE = 'A' , @ATT_CODE = null , @MASTER_CODE = null, @MASTER_NAME = null,@START_DATE = null ,@END_DATE = null 
■ Author					:  
■ Date						: 
■ Memo						: 제휴사 예약조회

SP_PKG_DETAIL_SELECT_LIST_5 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
									최초생성  
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[XP_AGT_PKG_MASTER_SELECT_LIST]
(
	@SIGN_CODE		VARCHAR(1),  
	@ATT_CODE	VARCHAR(1),    -- 필수
	@MASTER_CODE	MASTER_CODE,  
	@MASTER_NAME	NVARCHAR(200),  
	@START_DATE		DATETIME,
	@END_DATE		DATETIME
)
AS

BEGIN

--GO 


--DECLARE @SIGN_CODE		VARCHAR(1),  
--	@ATT_CODE	VARCHAR(1),    -- 필수
--	@MASTER_CODE	MASTER_CODE,  
--	@MASTER_NAME	NVARCHAR(300),  
--	@START_DATE		DATETIME,
--	@END_DATE		DATETIME
----SELECT @SIGN_CODE = '' , @ATT_CODE = '' , @MASTER_CODE = '', @MASTER_NAME = '' ,@START_DATE ='2013-01-12' ,@END_DATE ='2013-04-12'
--SELECT @SIGN_CODE = null , @ATT_CODE = null , @MASTER_CODE = null, @MASTER_NAME = null,@START_DATE = null ,@END_DATE = null 


	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	-- 변수 선언
	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @START VARCHAR(10), @END VARCHAR(10) , @WHERE NVARCHAR(1000)
	  
	-- WHERE 조건 만들기  
	SET @SQLSTRING = '';  
	SET @START = ISNULL(CONVERT(NVARCHAR(10), @START_DATE, 120), '')  
	SET @END = ISNULL(CONVERT(NVARCHAR(10), DATEADD(DAY, 1, @END_DATE), 120), '')  
	SET @WHERE = '' 
	  
	-- 마스터코드  
	IF ISNULL(@MASTER_CODE, '') <> '' 
	BEGIN  
		SET @WHERE = @WHERE + ' AND  A.MASTER_CODE = @MASTER_CODE  '  
	END 
	ELSE
	BEGIN
		-- 마스터명  
		IF ISNULL(@MASTER_NAME, '') <> '' 
		BEGIN  
			--SET @MASTER_NAME = '%' + @MASTER_NAME +'%'
			SET @WHERE = @WHERE + ' AND  A.MASTER_NAME LIKE  ''%'' + @MASTER_NAME  + ''%'' '  
		END 

		IF ISNULL(@START, '') <> '' AND ISNULL(@END, '') <> ''  
		BEGIN  
			SET @WHERE = @WHERE + ' AND (  (A.NEXT_DATE BETWEEN CONVERT(DATETIME,@START) AND CONVERT(DATETIME,@END) )'
			SET @WHERE = @WHERE + '  OR  (A.LAST_DATE BETWEEN CONVERT(DATETIME,@START) AND CONVERT(DATETIME,@END) )  )'
		END  

		-- 지역 
		IF ISNULL(@SIGN_CODE, '') <> '' 
		BEGIN  
			SET @WHERE = @WHERE + ' AND  A.SIGN_CODE = @SIGN_CODE  '  
		END 

		-- 상품속성
		IF ISNULL(@ATT_CODE, '') <> '' 
		BEGIN  
			SET @WHERE = @WHERE + ' AND A.MASTER_CODE   IN (SELECT MASTER_CODE FROM PKG_ATTRIBUTE WITH(NOLOCK) WHERE ATT_CODE = @ATT_CODE)  '  
		END 
	END 
	

	SET @SQLSTRING = N'
SELECT A.MASTER_CODE, A.MASTER_NAME, A.SECTION_YN,
	A.NEXT_DATE,A.LAST_DATE,A.LOW_PRICE , A.HIGH_PRICE 
FROM PKG_MASTER A WITH(NOLOCK)
WHERE SHOW_YN = ''Y''
	--AND (SECTION_YN = ''Y'' OR A.NEXT_DATE >= CONVERT(VARCHAR(10), GETDATE(), 120))
	--AND (SHOW_YN = ''Y'' OR SECTION_YN = ''Y'')
	' + @WHERE + ' 
ORDER BY A.REGION_ORDER;'

	SET @PARMDEFINITION = N'@SIGN_CODE	VARCHAR(1),@ATT_CODE VARCHAR(1),@MASTER_CODE MASTER_CODE,@MASTER_NAME	NVARCHAR(300), @START VARCHAR(10), @END VARCHAR(10) ';  

	--PRINT @SQLSTRING  
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @SIGN_CODE,@ATT_CODE,@MASTER_CODE,@MASTER_NAME,@START, @END



END  




GO
