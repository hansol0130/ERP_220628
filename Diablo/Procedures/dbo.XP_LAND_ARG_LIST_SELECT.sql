USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_LAND_ARG_LIST_SELECT
■ DESCRIPTION				: 랜드사 수배현황 리스트 검색
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@KEY		VARCHAR(400): 검색 키
	@ORDER_BY	INT			: 정렬 순서
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 검색된 수       
■ EXEC						: 
	DECLARE @PAGE_INDEX INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT, 
	@KEY		VARCHAR(400),
	@ORDER_BY	INT

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=10,@KEY=N'NewName=&ProCode=&ProName=&SDate=&EDate=&ArgPsstatus=&ArgState1=&AgtName=&AgtCode=12005&DateType=1',@ORDER_BY=7

	exec XP_LAND_ARG_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-09		오인규			최초생성    
================================================================================================================*/ 

 CREATE PROCEDURE [dbo].[XP_LAND_ARG_LIST_SELECT] 
 ( 
    @PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY		VARCHAR(400),
	@ORDER_BY	INT
) 
AS 
BEGIN 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(4000),@ORDER NVARCHAR(4000);

	DECLARE
		@PRO_CODE   VARCHAR(20), --행사코드
		@PRO_NAME	NVARCHAR(100), --행사명
		@START_DATE DATETIME , 
		@END_DATE	DATETIME ,
		@ARG_PSTATUS CHAR(1), -- /* 수배 진행상태 : 1-수배, 2-정산, 3-완료, 4-취소 */
		@ARG_STATE CHAR(1),  -- /* 수배 상태 : 1-미확인, 2-확인, 3-대기, 4-이동, 5-취소,  */
		@NEW_NAME	VARCHAR(20), --작성자
		@AGT_NAME	VARCHAR(50), -- 작성자 소속회사명 
		@AGT_CODE	VARCHAR(10), -- 수배서 랜드사코드
		@DATE_TYPE  CHAR(1)  -- 출발일 1 작성일 2

	SELECT
		@NEW_NAME = DBO.FN_PARAM(@KEY, 'NewName'),
		@PRO_CODE = DBO.FN_PARAM(@KEY, 'ProCode'), --
		@PRO_NAME = DBO.FN_PARAM(@KEY, 'ProName'), --
		@DATE_TYPE = DBO.FN_PARAM(@KEY, 'DateType'), --
		@START_DATE = DBO.FN_PARAM(@KEY, 'SDate'), --
		@END_DATE = DBO.FN_PARAM(@KEY, 'EDate'), --
		@ARG_PSTATUS = DBO.FN_PARAM(@KEY, 'ArgPsstatus'),--
		@ARG_STATE = DBO.FN_PARAM(@KEY, 'ArgState'),--
		@AGT_NAME = DBO.FN_PARAM(@KEY, 'AgtName'),
		@AGT_CODE = DBO.FN_PARAM(@KEY, 'AgtCode'),
		@WHERE = '',
		@ORDER = ' A.NEW_DATE DESC'
   
	-- WHERE 조건 만들기
	SET @WHERE = ' A.AGT_CODE = @AGT_CODE '

	IF ISNULL(@PRO_CODE, '') <> '' --행사코드
		SET @WHERE = @WHERE + ' AND A.PRO_CODE = @PRO_CODE '
    ELSE 
	BEGIN
		IF ISNULL(@PRO_NAME, '') <> '' -- 행사명
			SET @WHERE =@WHERE + ' AND A.PRO_NAME LIKE ''%'' + @PRO_NAME + ''%'' '
        IF ISNULL(@DATE_TYPE, '') = '1' AND (ISNULL(@START_DATE, '') <> '' AND ISNULL(@END_DATE, '') <> '' ) -- 출발일
			SET @WHERE =@WHERE + ' AND A.DEP_DATE BETWEEN @START_DATE AND @END_DATE '
		IF ISNULL(@DATE_TYPE, '') = '2' AND (ISNULL(@START_DATE, '') <> '' AND ISNULL(@END_DATE, '') <> '' )-- 작성일
			SET @WHERE =@WHERE + ' AND A.NEW_DATE BETWEEN @START_DATE AND @END_DATE '
    	IF ISNULL(@ARG_PSTATUS, '') <> '' -- 
			SET @WHERE = @WHERE +' AND A.ARG_PSTATUS = @ARG_PSTATUS '
		IF ISNULL(@ARG_STATE, '') <> '' -- 
			SET @WHERE = @WHERE +' AND A.ARG_STATUS = @ARG_STATE '
		IF ISNULL(@NEW_NAME, '') <> '' -- 
			SET @WHERE = @WHERE +' AND B.KOR_NAME LIKE ''%'' + @NEW_NAME +''%'' '
		IF ISNULL(@AGT_NAME, '') <> '' -- 
			SET @WHERE = @WHERE +' AND C.KOR_NAME LIKE ''%'' + @AGT_NAME +''%'' '
		
	END


	--ORDER BY 조건 만들기 진행/상태/행사코드/출발일/인원/작성자/작성일

	IF @ORDER_BY = 1 -- 진행
		SET @ORDER = ' A.ARG_PSTATUS  '
	IF  @ORDER_BY = 2 -- 상태
		SET @ORDER = ' A.ARG_STATUS '
	IF  @ORDER_BY = 3 -- 행사코드
		SET @ORDER = ' A.PRO_CODE   '
	IF  @ORDER_BY = 4 -- 출발일
		SET @ORDER = ' A.DEP_DATE '
	IF  @ORDER_BY = 5 -- 인원
		SET @ORDER = ' A.RES_COUNT  '
	IF  @ORDER_BY = 6 -- 작성자
		SET @ORDER = ' A.NEW_CODE  '
	IF  @ORDER_BY = 7 -- 작성일
		SET @ORDER = ' A.NEW_DATE DESC  '


		SET @SQLSTRING = N'
			SELECT  @TOTAL_COUNT = COUNT(*)
			FROM	dbo.ARG_MASTER  A LEFT OUTER JOIN dbo.AGT_MEMBER B ON A.NEW_CODE = B.MEM_CODE LEFT OUTER JOIN dbo.AGT_MASTER C ON C.AGT_CODE = B.AGT_CODE
			WHERE   ' + @WHERE + ' ;

			WITH LIST AS
			(
				SELECT 
						A.ARG_MASTER_SEQ
				FROM	dbo.ARG_MASTER  A LEFT OUTER JOIN dbo.AGT_MEMBER B ON A.NEW_CODE = B.MEM_CODE LEFT OUTER JOIN dbo.AGT_MASTER C ON C.AGT_CODE = B.AGT_CODE
				WHERE   ' + @WHERE + '  
				ORDER BY ' + @ORDER + '
				OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
				ROWS ONLY
			)
			SELECT 
					 A.ARG_MASTER_SEQ                 --  
					 ,A.ARG_GROUP
					 ,A.ARG_GROUP2
					 , A.PRO_CODE                       --  
					 , A.PRO_NAME                       --  
					 , A.DEP_DATE                       --  
					 , A.ARR_DATE                       --  
					 , A.ARG_GUBUN                      --  
					 , A.ARG_STATUS                     --  
					 , A.ARG_PSTATUS                    --  
					 , A.RES_COUNT                      --  
					 , A.ARG_TITLE                      --  
					 , A.ARG_CONTENT                    --  
					 , A.NEW_DATE                       --  
					 , A.NEW_CODE                       --  
					 , B.KOR_NAME AS NEW_NAME
					 , C.KOR_NAME AS NEW_AGT_NAME
			FROM LIST Z
			INNER JOIN dbo.ARG_MASTER A ON A.ARG_MASTER_SEQ = Z.ARG_MASTER_SEQ LEFT OUTER JOIN dbo.AGT_MEMBER B ON A.NEW_CODE = B.MEM_CODE LEFT OUTER JOIN dbo.AGT_MASTER C ON C.AGT_CODE = B.AGT_CODE
			WHERE  ' + @WHERE + '  
			ORDER BY ' + @ORDER
		
			
	SET @PARMDEFINITION = N'@PAGE_INDEX  INT, @PAGE_SIZE  INT, @TOTAL_COUNT INT OUTPUT, @NEW_NAME VARCHAR(20), @PRO_CODE VARCHAR(20),@PRO_NAME NVARCHAR(100), @START_DATE DATETIME ,@END_DATE	DATETIME ,@ARG_PSTATUS CHAR(1) ,@ARG_STATE CHAR(1), @AGT_NAME VARCHAR(50), @AGT_CODE VARCHAR(10) ,@DATE_TYPE  CHAR(1) ';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @PAGE_INDEX, @PAGE_SIZE, @TOTAL_COUNT OUTPUT, @NEW_NAME, @PRO_CODE ,@PRO_NAME , @START_DATE  ,@END_DATE	 ,@ARG_PSTATUS  ,@ARG_STATE , @AGT_NAME , @AGT_CODE ,@DATE_TYPE;			 
 
END 


GO
