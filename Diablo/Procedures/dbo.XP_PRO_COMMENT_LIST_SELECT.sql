USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_PRO_COMMENT_LIST_SELECT
■ DESCRIPTION				: 고객상품평 검색
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@KEY		VARCHAR(400): 검색 키
	@ORDER_BY	INT			: 정렬 순서
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 항목 수
■ EXEC						: 

	DECLARE @PAGE_INDEX INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT, 
	@KEY		VARCHAR(400),
	@ORDER_BY	INT

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=5,@KEY=N'Code=CPP4018',@ORDER_BY=1

	exec XP_PRO_COMMENT_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-04		김성호			최초생성
   2013-06-04		박형만			나의참여내역 상품평 가져오기 CUS_NO KEY 추가
   2019-11-12		박형만			정렬순서 
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_PRO_COMMENT_LIST_SELECT]
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

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(100), @CODE VARCHAR(20), @CUS_NO INT;

	SELECT
		@CODE = DBO.FN_PARAM(@KEY, 'Code'),
		@CUS_NO = CONVERT(INT, DBO.FN_PARAM(@KEY, 'CusNo')),
		@WHERE  = 'WHERE 1=1 '

	IF @CODE  <> ''
	BEGIN
		IF EXISTS(SELECT 1 FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @CODE)
		BEGIN
			SELECT @CODE = MASTER_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @CODE;
		END 
		
		SET @WHERE = @WHERE + ' AND MASTER_CODE = @CODE '
	END 
	IF @CUS_NO > 0  --고객번호 있을때:나의참여내역
	BEGIN
		SET @WHERE = @WHERE + ' AND CUS_NO = @CUS_NO '
	END 

	SET @SQLSTRING = N'
	

	WITH LIST AS
	(
		SELECT A.MASTER_CODE, A.COM_SEQ
		FROM PRO_COMMENT A WITH(NOLOCK)
		' + @WHERE + N'
		ORDER BY A.NEW_DATE DESC
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
		ROWS ONLY
	)
	SELECT B.*, C.CUS_NAME
	FROM LIST A
	INNER JOIN PRO_COMMENT B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE AND A.COM_SEQ = B.COM_SEQ
	LEFT JOIN CUS_CUSTOMER C WITH(NOLOCK) ON B.CUS_NO = C.CUS_NO
	ORDER BY B.NEW_DATE DESC 
	;
	
	-- 전체 마스터 수
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM PRO_COMMENT WITH(NOLOCK)
	' + @WHERE


	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@CODE VARCHAR(20),
		@CUS_NO INT';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@CODE,
		@CUS_NO;

END
GO
