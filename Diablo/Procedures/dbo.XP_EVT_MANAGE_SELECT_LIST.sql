USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_EVT_MANAGE_SELECT_LIST
■ DESCRIPTION				: 이벤트 관리 조회 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	declare @p5 int
set @p5=0
exec XP_EVT_MANAGE_SELECT_LIST @PAGE_INDEX=0,@PAGE_SIZE=20,@KEY=N'ProductType=P&RegionCode=&AttCode=&EventYN=Y&BestYN=&ShowYN=&DevYN=&KeyWord=&TeamCode=529&EmpCode=',@ORDER_BY=0,@TOTAL_COUNT=@p5 output
select @p5
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
	2018-11-26		박형만			최초생성
	2018-12-27		박형만			건수추가
	2020-04-21      오준혁           제목검색 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_EVT_MANAGE_SELECT_LIST]
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(500),
	@ORDER_BY	int
AS 
BEGIN

--SELECT EVT_SEQ FROM PUB_EVENT_DATA WHERE MASTER_CODE = @MASTER_CODE  AND SHOW_YN ='Y' 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);

	DECLARE @MASTER_CODE     VARCHAR(20)
	       ,@PRO_CODE        VARCHAR(50)
	       ,@PRO_TYPE        VARCHAR(1)
	       ,@SIGN_CODE       VARCHAR(1)
	       ,@ATT_CODE        VARCHAR(1)
	       ,@EVT_YN          VARCHAR(1)
	       ,@BEST_YN         VARCHAR(1)
	       ,@SHOW_YN         VARCHAR(1)
	       ,@DEV_YN          VARCHAR(1)
	       ,@KEYWORD         VARCHAR(500)
	       ,@TEAM_CODE       VARCHAR(10)
	       ,@EMP_CODE        VARCHAR(10)

	SELECT
		--@EVT_SEQ = DBO.FN_PARAM(@KEY, 'EvtSeq'),
		@MASTER_CODE = DBO.FN_PARAM(@KEY, 'MasterCode'),
		@PRO_CODE = DBO.FN_PARAM(@KEY, 'ProductCode'),
		@PRO_TYPE = DBO.FN_PARAM(@KEY, 'ProductType'),
		@SIGN_CODE = DBO.FN_PARAM(@KEY, 'RegionCode'),
		@ATT_CODE = DBO.FN_PARAM(@KEY, 'AttCode'),
		@EVT_YN = DBO.FN_PARAM(@KEY, 'EventYN'),
		@BEST_YN = DBO.FN_PARAM(@KEY, 'BestYN'),
		@SHOW_YN = DBO.FN_PARAM(@KEY, 'ShowYN'),
		@DEV_YN = DBO.FN_PARAM(@KEY, 'DevYN'),
		@KEYWORD = DBO.FN_PARAM(@KEY, 'KeyWord'),
		@TEAM_CODE = DBO.FN_PARAM(@KEY, 'TeamCode'),
		@EMP_CODE = DBO.FN_PARAM(@KEY, 'EmpCode')


	SET @WHERE = ' 1=1 ';
	
	-- 마스터,행사코드 검색시 
	IF ISNULL(@MASTER_CODE,'')  <> '' OR ISNULL(@PRO_CODE,'')  <> '' 
	BEGIN
		IF ISNULL(@MASTER_CODE,'')  <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.EVT_SEQ IN (SELECT EVT_SEQ FROM PUB_EVENT_DATA WITH(NOLOCK) WHERE MASTER_CODE = @MASTER_CODE  AND SHOW_YN =''Y'') ' ;
		END
		ELSE IF ISNULL(@PRO_CODE,'')  <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.EVT_SEQ IN (SELECT EVT_SEQ FROM PUB_EVENT_DATA WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE  AND SHOW_YN =''Y'') ' ;
		END
	END 
	ELSE 
	BEGIN
		IF ISNULL(@PRO_TYPE,'')  <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.PRO_CODE = @PRO_TYPE ' ;
		END


		IF ISNULL(@SIGN_CODE,'')  <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.SIGN_CODE = @SIGN_CODE ' ;
		END
		IF ISNULL(@ATT_CODE,'')  <> ''  -- 중복검색 가능 
		BEGIN
			SET @WHERE = @WHERE + ' AND A.ATT_CODE = @ATT_CODE ' ;
		END
		IF ISNULL(@EVT_YN,'')  <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.EVT_YN = @EVT_YN ' ;
		END
		IF ISNULL(@BEST_YN,'')  <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.BEST_YN = @BEST_YN ' ;
		END
		IF ISNULL(@SHOW_YN,'')  <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.SHOW_YN = @SHOW_YN ' ;
		END
		IF ISNULL(@DEV_YN,'')  <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.DEV_YN = @DEV_YN ' ;
		END
		IF ISNULL(@KEYWORD,'')  <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.EVT_NAME LIKE ''%'' + @KEYWORD + ''%'' ' ;
		END

		-- 사원코드 우선, 아니면 팀코드 
		IF ISNULL(@EMP_CODE,'')  <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.NEW_CODE = @EMP_CODE ' ;
		END
		ELSE IF ISNULL(@TEAM_CODE,'')  <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.NEW_CODE IN ( SELECT EMP_CODE FROM EMP_MASTER WHERE TEAM_CODE =@TEAM_CODE )  ' ;
		END
		

	END 
	

	

	SELECT @SORT_STRING = (  
		CASE @ORDER_BY  
			WHEN 1 THEN ' A.EVT_SEQ DESC'
			ELSE ' A.EVT_SEQ DESC'
		END
	)
	-- 특정글 예외처리
	/*
	IF ISNULL(@ORDER_BY, '')  = 1 
	BEGIN
		SET @WHERE = @WHERE + ' AND B.SEQ_NO NOT IN (388)'
	END
	*/
	SET @SQLSTRING = N'
	SELECT
		@TOTAL_COUNT = COUNT(*)
	FROM PUB_EVENT A 
	WHERE ' + @WHERE + ';

	SELECT * 
	, (SELECT KOR_NAME FROM EMP_MASTER WITH(NOLOCK) WHERE EMP_CODE = A.NEW_CODE )  AS EMP_NAME 
	, (SELECT COUNT(*) FROM PUB_EVENT_CATEGORY WITH(NOLOCK) WHERE EVT_SEQ = A.EVT_SEQ ) AS CATE_COUNT 
	, (SELECT COUNT(*) FROM PUB_EVENT_DATA WITH(NOLOCK) WHERE EVT_SEQ = A.EVT_SEQ AND SHOW_YN =''Y'' ) AS PROD_COUNT 
	, STUFF(( 
		SELECT ('',''+PUB_VALUE) as [text()] FROM COD_PUBLIC WHERE PUB_TYPE = ''EVENT.REGION'' AND  charindex( PUB_CODE ,A.SIGN_CODE  ) > 0  
		FOR XML PATH('''')), 1, 1, '''') AS REGION_NAME
	FROM PUB_EVENT A WITH(NOLOCK)
	WHERE ' + @WHERE + '
	ORDER BY EVT_SEQ DESC
	OFFSET (@PAGE_INDEX * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY
	'
	--PRINT @SQLSTRING;
	
	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,

		
		@MASTER_CODE VARCHAR(20),
		@PRO_CODE VARCHAR(50),
		@PRO_TYPE VARCHAR(1),
		@SIGN_CODE VARCHAR(1),
		@ATT_CODE VARCHAR(1),
		@EVT_YN VARCHAR(1),
		@BEST_YN VARCHAR(1),
		@SHOW_YN VARCHAR(1),
		@DEV_YN VARCHAR(1), 
		@KEYWORD VARCHAR(500),
		@TEAM_CODE VARCHAR(10),
		@EMP_CODE VARCHAR(10)
		'

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		
		@MASTER_CODE,
		@PRO_CODE,
		@PRO_TYPE,
		@SIGN_CODE, 
		@ATT_CODE,
		@EVT_YN,
		@BEST_YN,
		@SHOW_YN,
		@DEV_YN,
		@KEYWORD ,
		@TEAM_CODE,
		@EMP_CODE

END


GO
