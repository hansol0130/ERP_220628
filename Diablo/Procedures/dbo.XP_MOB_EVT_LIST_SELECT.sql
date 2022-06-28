USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Server					: 
■ Database					: DIABLO
■ USP_Name					: XP_MOB_EVT_LIST_SELECT
■ Description				: 모바일 갤러리 및 리스트 출력
■ Input Parameter			: 
		
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

	declare @prevSeq int
	declare @nextSeq int
	exec [dbo].[XP_MOB_EVT_LIST_SELECT] @prevSeq output, @nextSeq output, 'PlanType=R&SignCode=&AttrCode=&ProductCode=&EventName=', 2217, 0
	select @prevSeq
	select @nextSeq

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-10-01		이동호			최초생성	
-------------------------------------------------------------------------------------------------*/ 

 CREATE PROCEDURE [dbo].[XP_MOB_EVT_LIST_SELECT] 
 ( 
	@PREVSEQ INT OUTPUT,
	@NEXTSEQ INT OUTPUT,
	@KEY	varchar(200),
	@EVT_SEQ INT, 
	@ORDER_BY	int
) 
AS 
BEGIN 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);

	DECLARE @PLAN_TYPE CHAR(1)
	DECLARE @SIGN_CODE CHAR(1)
	DECLARE @ATT_CODE VARCHAR(2)
	DECLARE @PRO_CODE VARCHAR(20)
	DECLARE @EVT_NAME VARCHAR(100)
	DECLARE @EVT_YN CHAR(1)
	DECLARE @CLOSE_YN CHAR(1)
	DECLARE @BEST_YN CHAR(1)
	
	SELECT
		@PLAN_TYPE = DBO.FN_PARAM(@KEY, 'PlanType'),
		@SIGN_CODE = DBO.FN_PARAM(@KEY, 'SignCode'),
		@ATT_CODE = DBO.FN_PARAM(@KEY, 'AttrCode'),
		@PRO_CODE = DBO.FN_PARAM(@KEY, 'ProductCode'),
		@EVT_NAME = DBO.FN_PARAM(@KEY, 'EventName'),
		@EVT_YN = DBO.FN_PARAM(@KEY, 'IsEvent'),
		@CLOSE_YN = DBO.FN_PARAM(@KEY, 'IsClose'),
		@BEST_YN = DBO.FN_PARAM(@KEY, 'IsBest')
				
	SET @WHERE = ' AND SHOW_YN = ''Y'' '

	IF @CLOSE_YN = 'Y'
		SET @WHERE = @WHERE + ' AND (CONVERT(VARCHAR(10), GETDATE(), 120) > CONVERT(VARCHAR(10), END_DATE, 120)) '
	ELSE 
		SET @WHERE = @WHERE + ' AND (END_DATE IS NULL OR CONVERT(VARCHAR(10), GETDATE(), 120) <= CONVERT(VARCHAR(10), END_DATE, 120) ) '

	IF ISNULL(@PLAN_TYPE, 'R') = 'R'
		SET @WHERE = @WHERE + ' AND (SIGN_CODE IS NOT NULL OR SIGN_CODE <> '''') '

	IF @PLAN_TYPE = 'B'
		SET @WHERE = @WHERE + ' AND DEP_AIRLINE_CODE = ''PUS'' '
	ELSE
		SET @WHERE = @WHERE + ' AND DEP_AIRLINE_CODE <> ''PUS'' '


	IF ISNULL(@SIGN_CODE, '') <> ''
		SET @WHERE = @WHERE + ' AND SIGN_CODE LIKE ''%'' + @SIGN_CODE + ''%'' '

	IF ISNULL(@ATT_CODE, '') <> ''
		SET @WHERE = @WHERE + ' AND ATT_CODE LIKE ''%'' + @ATT_CODE + ''%'' '

	IF ISNULL(@PRO_CODE, '') <> ''
			SET @WHERE = @WHERE + ' AND PRO_CODE = @PRO_CODE '

	IF ISNULL(@EVT_NAME, '') <> ''
			SET @WHERE = @WHERE + ' AND EVT_NAME LIKE ''%'' + @EVT_NAME + ''%'' '

	IF ISNULL(@EVT_YN, '') <> '' 
			SET @WHERE = @WHERE + ' AND EVT_YN = ''' + @EVT_YN + ''''  

	IF ISNULL(@BEST_YN, '') <> '' 
			SET @WHERE = @WHERE + ' AND BEST_YN = ''' + @BEST_YN + ''''  
	ELSE 
			SET @WHERE = @WHERE + ' AND BEST_YN = ''N'' '  
			


	IF @EVT_SEQ = 0
		
		SET @SQLSTRING = N'		
			SELECT TOP 1 @EVT_SEQ = A.EVT_SEQ
			FROM PUB_EVENT A WITH(NOLOCK)
			WHERE 1=1 ' + @WHERE + ' ORDER BY NEW_DATE DESC

			SELECT EVT_SEQ, EVT_NAME, EVT_SHORT_REMARK, EVT_URL, BANNER_URL, NEW_DATE
			FROM PUB_EVENT A WITH(NOLOCK)
			WHERE 1=1 AND EVT_SEQ = @EVT_SEQ
			
			-- 이전글 
			SELECT TOP 1 @PREVSEQ = EVT_SEQ
			FROM PUB_EVENT A WITH(NOLOCK)
			WHERE 1=1 AND EVT_SEQ > @EVT_SEQ ' + @WHERE + '
			ORDER BY NEW_DATE ASC

			-- 다음글
			SELECT TOP 1 @NEXTSEQ = EVT_SEQ
			FROM PUB_EVENT A WITH(NOLOCK)
			WHERE 1=1 AND EVT_SEQ < @EVT_SEQ ' + @WHERE + '
			ORDER BY NEW_DATE DESC'

	ELSE 

		SET @SQLSTRING = N'				
			SELECT EVT_SEQ, EVT_NAME, EVT_SHORT_REMARK, EVT_URL, BANNER_URL, NEW_DATE
			FROM PUB_EVENT A WITH(NOLOCK)
			WHERE 1=1 AND EVT_SEQ = @EVT_SEQ 
			
			-- 이전글
			SELECT TOP 1 @PREVSEQ = EVT_SEQ
			FROM PUB_EVENT A WITH(NOLOCK)
			WHERE 1=1 AND EVT_SEQ > @EVT_SEQ ' + @WHERE + '
			ORDER BY NEW_DATE ASC

			-- 다음글 
			SELECT TOP 1 @NEXTSEQ = EVT_SEQ
			FROM PUB_EVENT A WITH(NOLOCK)
			WHERE 1=1 AND EVT_SEQ < @EVT_SEQ ' + @WHERE + '
			ORDER BY NEW_DATE DESC'
	


		SET @PARMDEFINITION = N'
			@PLAN_TYPE CHAR(1),
			@SIGN_CODE CHAR(1),
			@ATT_CODE VARCHAR(2),
			@PRO_CODE VARCHAR(20),
			@EVT_NAME VARCHAR(100),
			@CLOSE_YN CHAR(1),
			@EVT_SEQ INT,	
			@PREVSEQ INT OUTPUT,
			@NEXTSEQ INT OUTPUT';

		EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
			@PLAN_TYPE,
			@SIGN_CODE,
			@ATT_CODE,
			@PRO_CODE,
			@EVT_NAME,
			@CLOSE_YN,
			@EVT_SEQ,
			@PREVSEQ OUTPUT,
			@NEXTSEQ OUTPUT;


END
GO
