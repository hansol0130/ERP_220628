USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_GUIDE_DETAIL_SELECT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 가이드평가현황 상세 검색
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

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=10,@KEY=N'AgtCode=12005&MemCode=L130002&GuideName=랜드',@ORDER_BY=0
	
	exec XP_ASG_EVT_REPORT_GUIDE_DETAIL_SELECT @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-25		이상일			최초생성    
================================================================================================================*/ 

 CREATE  PROCEDURE [dbo].[XP_ASG_EVT_REPORT_GUIDE_DETAIL_SELECT]
(
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@TOTAL_COUNT	INT OUTPUT,
	@KEY			VARCHAR(400),
	@ORDER_BY		INT
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(4000),@ORDER NVARCHAR(4000);

	DECLARE
		@AGT_CODE	VARCHAR(10),
		@MEM_CODE   VARCHAR(7),
		@GUIDE_NAME  VARCHAR(20)

	SELECT
		@AGT_CODE = DBO.FN_PARAM(@KEY, 'AgtCode'),
		@MEM_CODE = DBO.FN_PARAM(@KEY, 'MemCode'),
		@GUIDE_NAME = DBO.FN_PARAM(@KEY, 'GuideName'),
		@ORDER = 0


	SET @SQLSTRING = N'
	
				SELECT @TOTAL_COUNT = COUNT(AGT_CODE)
					FROM (SELECT A.AGT_CODE
						FROM OTR_POL_MASTER A WITH(NOLOCK)
						INNER JOIN OTR_MASTER C WITH(NOLOCK) ON (A.OTR_SEQ = C.OTR_SEQ AND C.OTR_STATE = ''3'')
						INNER JOIN AGT_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
						INNER JOIN PKG_DETAIL D WITH(NOLOCK) ON C.PRO_CODE = D.PRO_CODE
						INNER JOIN PKG_MASTER E WITH(NOLOCK) ON D.MASTER_CODE = E.MASTER_CODE
						WHERE A.POL_type =''2'' AND A.AGT_CODE = @AGT_CODE AND ISNULL(A.MEM_CODE, '''') = @MEM_CODE AND A.GUIDE_NAME = @GUIDE_NAME
						GROUP BY A.AGT_CODE, A.MEM_CODE, A.GUIDE_NAME, B.KOR_NAME, C.PRO_CODE) A ;

				
				 SELECT A.AGT_CODE,
						C.PRO_CODE, 
						B.KOR_NAME, 
						A.MEM_CODE, 
						A.GUIDE_NAME,
						MAX(D.DEP_DATE) AS DEP_DATE,
						DBO.XN_COM_GET_EMP_NAME(MAX(A.NEW_CODE)) AS NEW_NAME,
						MAX(A.NEW_DATE) AS NEW_DATE,
						MAX(E.SIGN_CODE) AS SIGN_CODE,
						(SELECT KOR_NAME FROM PUB_REGION WITH(NOLOCK) WHERE SIGN = MAX(E.SIGN_CODE)) AS SIGN_NAME,
						(SELECT ROUND((SUM(CONVERT(INT,L.EXAMPLE_DESC)) / CONVERT(FLOAT,COUNT(K.OTR_POL_EXAMPLE_SEQ))),1)
							FROM OTR_MASTER H WITH(NOLOCK)
							INNER JOIN dbo.OTR_POL_MASTER I WITH(NOLOCK) ON H.OTR_SEQ = I.OTR_SEQ AND I.POL_TYPE =''2''
							INNER JOIN dbo.OTR_POL_QUESTION J WITH(NOLOCK) ON I.OTR_POL_MASTER_SEQ = J.OTR_POL_MASTER_SEQ AND J.QUS_TYPE=''1''
							INNER JOIN dbo.OTR_POL_ANSWER K WITH(NOLOCK) ON J.OTR_POL_MASTER_SEQ = K.OTR_POL_MASTER_SEQ AND J.OTR_POL_QUESTION_SEQ = K.OTR_POL_QUESTION_SEQ
							INNER JOIN dbo.OTR_POL_DETAIL L WITH(NOLOCK) ON K.OTR_POL_MASTER_SEQ = L.OTR_POL_MASTER_SEQ AND K.OTR_POL_QUESTION_SEQ = L.OTR_POL_QUESTION_SEQ AND K.OTR_POL_EXAMPLE_SEQ =L.OTR_POL_EXAMPLE_SEQ 
							WHERE H.OTR_STATE = ''3'' AND H.PRO_CODE = C.PRO_CODE AND I.AGT_CODE = A.AGT_CODE AND ISNULL(I.MEM_CODE, '''') = ISNULL(A.MEM_CODE, '''') AND I.GUIDE_NAME = A.GUIDE_NAME) AS AVG_NUM,
						(SELECT COUNT(DISTINCT(G.PRO_CODE))
							FROM OTR_POL_MASTER F WITH(NOLOCK) 
							INNER JOIN OTR_MASTER G WITH(NOLOCK) ON (F.OTR_SEQ = G.OTR_SEQ AND G.OTR_STATE = ''3'')
							WHERE F.AGT_CODE = A.AGT_CODE AND ISNULL(F.MEM_CODE, '''') = ISNULL(A.MEM_CODE, '''') AND F.GUIDE_NAME = A.GUIDE_NAME) AS T_COUNT,
						(SELECT ROUND((SUM(CONVERT(INT,L.EXAMPLE_DESC)) / CONVERT(FLOAT,COUNT(K.OTR_POL_EXAMPLE_SEQ))),1)
							FROM OTR_MASTER H WITH(NOLOCK)
							INNER JOIN dbo.OTR_POL_MASTER I WITH(NOLOCK) ON H.OTR_SEQ = I.OTR_SEQ AND I.POL_TYPE =''2''
							INNER JOIN dbo.OTR_POL_QUESTION J WITH(NOLOCK) ON I.OTR_POL_MASTER_SEQ = J.OTR_POL_MASTER_SEQ AND J.QUS_TYPE=''1''
							INNER JOIN dbo.OTR_POL_ANSWER K WITH(NOLOCK) ON J.OTR_POL_MASTER_SEQ = K.OTR_POL_MASTER_SEQ AND J.OTR_POL_QUESTION_SEQ = K.OTR_POL_QUESTION_SEQ
							INNER JOIN dbo.OTR_POL_DETAIL L WITH(NOLOCK) ON K.OTR_POL_MASTER_SEQ = L.OTR_POL_MASTER_SEQ AND K.OTR_POL_QUESTION_SEQ = L.OTR_POL_QUESTION_SEQ AND K.OTR_POL_EXAMPLE_SEQ =L.OTR_POL_EXAMPLE_SEQ 
							WHERE H.OTR_STATE = ''3'' AND I.AGT_CODE = A.AGT_CODE AND ISNULL(I.MEM_CODE, '''') = ISNULL(A.MEM_CODE, '''') AND I.GUIDE_NAME = A.GUIDE_NAME) AS T_AVG_NUM
				FROM OTR_POL_MASTER A WITH(NOLOCK)
				INNER JOIN OTR_MASTER C WITH(NOLOCK) ON (A.OTR_SEQ = C.OTR_SEQ AND C.OTR_STATE = ''3'')
				INNER JOIN AGT_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
				INNER JOIN PKG_DETAIL D WITH(NOLOCK) ON C.PRO_CODE = D.PRO_CODE
				INNER JOIN PKG_MASTER E WITH(NOLOCK) ON D.MASTER_CODE = E.MASTER_CODE
				WHERE A.POL_type =''2'' AND A.AGT_CODE = @AGT_CODE AND ISNULL(A.MEM_CODE, '''') = @MEM_CODE AND A.GUIDE_NAME = @GUIDE_NAME
				GROUP BY A.AGT_CODE, A.MEM_CODE, A.GUIDE_NAME, B.KOR_NAME, C.PRO_CODE	
				ORDER BY C.PRO_CODE DESC
				OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
				ROWS ONLY '

	SET @PARMDEFINITION = N'
		@PAGE_INDEX  INT, 
		@PAGE_SIZE  INT, 
		@TOTAL_COUNT INT OUTPUT, 
		@AGT_CODE CHAR(10), 
		@MEM_CODE VARCHAR(7), 
		@GUIDE_NAME VARCHAR(20)';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@AGT_CODE,
		@MEM_CODE,
		@GUIDE_NAME;

END
GO
