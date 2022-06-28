USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_LIST_SELECT_4
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 리스트 검색(내부용)
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

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=10,@KEY=N'EmpCode=&TeamCode=&ProCode=&ProName=&SDate=2013-02-01&EDate=2013-08-30&ReportState=3&AssignName=&AgentCode=92685&AgentName=',@ORDER_BY=2

	exec XP_ASG_EVT_REPORT_LIST_SELECT_4 @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-07-20		김완기
   2013-01-09		정지용			PRO_CODE like 검색으로 수정
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_ASG_EVT_REPORT_LIST_SELECT_4]
(
	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY		VARCHAR(600),
	@ORDER_BY	INT
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(4000), @WHERE2 NVARCHAR(4000), @ORDER NVARCHAR(4000);

	DECLARE
		@EMP_CODE	CHAR(7),
		@PRO_CODE   VARCHAR(20), --행사코드
		@PRO_NAME	NVARCHAR(100), --행사명
		@START_DATE VARCHAR(20) , 
		@END_DATE	VARCHAR(20) ,
		@REPORT_STATE CHAR(1),  --출장보고서 상태
		@ASSIGN_NAME		VARCHAR(20) --인솔자명
	DECLARE @AGT_CODE VARCHAR(20), @AGT_NAME VARCHAR(50)
	DECLARE @TEAM_CODE	VARCHAR(4)

	SELECT
		@EMP_CODE = DBO.FN_PARAM(@KEY, 'EmpCode'),
		@PRO_CODE = DBO.FN_PARAM(@KEY, 'ProCode'),
		@PRO_NAME = DBO.FN_PARAM(@KEY, 'ProName'), 
		@START_DATE = DBO.FN_PARAM(@KEY, 'StartDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'EndDate'),
		@REPORT_STATE = DBO.FN_PARAM(@KEY, 'ReportState'),
		@ASSIGN_NAME = DBO.FN_PARAM(@KEY, 'AssignName'),
		@AGT_CODE = DBO.FN_PARAM(@KEY, 'AgentCode'),
		@AGT_NAME = DBO.FN_PARAM(@KEY, 'AgentName'),
		@TEAM_CODE = DBO.FN_PARAM(@KEY, 'TeamCode'),
		@WHERE = '',
		@WHERE2 = '',
		@ORDER = ' A.DEP_DATE DESC'

   
	-- WHERE 조건 만들기
	IF ISNULL(@PRO_CODE, '') <> '' --행사코드
		SET @WHERE = ' AND A.PRO_CODE LIKE ''' + @PRO_CODE + '%'' '
    ELSE 
	BEGIN
		IF ISNULL(@EMP_CODE, '') <> ''
			BEGIN
				SET @WHERE = @WHERE + ' AND A.NEW_CODE = ''' + @EMP_CODE + ''' '
			END
		ELSE
			BEGIN
				IF ISNULL(@TEAM_CODE, '') <> ''
					BEGIN
						SET @WHERE = @WHERE + ' AND A.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE = ''' + @TEAM_CODE + ''') '
					END
			END

		IF ISNULL(@PRO_NAME, '') <> '' -- 행사명
			SET @WHERE =@WHERE + ' AND A.PRO_NAME LIKE ''%' + @PRO_NAME + '%'' '
			
		IF ISNULL(@ASSIGN_NAME, '') <> '' -- 인솔자명
			SET @WHERE =@WHERE + ' AND DBO.XN_COM_GET_EMP_NAME(A.TC_CODE) LIKE ''%' + @ASSIGN_NAME + '%'' '

		IF (ISNULL(@START_DATE, '') <> '' AND ISNULL(@END_DATE, '') <> '' )-- 출발일
			SET @WHERE =@WHERE + ' AND A.DEP_DATE >= @START_DATE AND A.DEP_DATE < DATEADD(DAY, 1, @END_DATE) '
    	IF ISNULL(@REPORT_STATE, '') <> '' -- 출장보고서
		BEGIN
		     IF @REPORT_STATE = '0'
				SET @WHERE =@WHERE + ' AND V.OTR_STATE IS NULL'
			 ELSE
				SET @WHERE =@WHERE + ' AND V.OTR_STATE = ''' + @REPORT_STATE + ''' '
			 
		END
	END

	IF ISNULL(@AGT_NAME, '') <> ''
		BEGIN
			SET @WHERE2 = @WHERE2 + ' AND A.AGT_NAME LIKE ''%' + @AGT_NAME + '%'' '
		END
		
	IF ISNULL(@AGT_CODE, '') <> ''
		BEGIN
			SET @WHERE2 = @WHERE2 + ' AND A.AGT_CODE = ''' + @AGT_CODE + ''' '
		END


	--ORDER BY 조건 만들기

	IF @ORDER_BY = 1 -- 작성여부
		SET @ORDER = ' OTR_STATE  '
	IF  @ORDER_BY = 2 -- 출발일
		SET @ORDER = ' DEP_DATE DESC '
	IF  @ORDER_BY = 3 -- 담당자명
		SET @ORDER = ' NEW_NAME ASC  '
	IF  @ORDER_BY = 4 -- 지역
		SET @ORDER = ' SIGN_KOR_NAME  '
	ELSE SET @ORDER = ' DEP_DATE DESC '



	--상태 -- 0 예정:해당인솔자에게 배정되고 출발일이 지나지 않은 행사 --1 완료: 해당인솔자에게 배정되고 출발이 지난행사

	SET @SQLSTRING = N'				 
				SELECT @TOTAL_COUNT = COUNT(*)
				  FROM (SELECT *
						  FROM (SELECT A.PRO_CODE, B.AGT_CODE
						               ,(SELECT KOR_NAME FROM AGT_MASTER WHERE AGT_CODE = B.AGT_CODE) AS AGT_NAME
								  FROM PKG_DETAIL A WITH(NOLOCK)
								 INNER JOIN dbo.PKG_MASTER Y WITH(NOLOCK) ON A.MASTER_CODE = Y.MASTER_CODE
								  LEFT OUTER JOIN dbo.PUB_REGION X WITH(NOLOCK) ON Y.SIGN_CODE = X.SIGN
								  LEFT OUTER JOIN dbo.OTR_MASTER V WITH(NOLOCK) ON A.PRO_CODE = V.PRO_CODE
								  LEFT OUTER JOIN dbo.OTR_POL_MASTER B WITH(NOLOCK) ON (V.OTR_SEQ = B.OTR_SEQ AND ISNULL(B.GUIDE_NAME, '''') != '''')
								WHERE A.TC_ASSIGN_YN =''Y'' ' + @WHERE + ' ) A
						 WHERE  A.PRO_CODE IS NOT NULL  '+ @WHERE2 + '
						 GROUP  BY A.PRO_CODE, A.AGT_CODE, A.AGT_NAME) A

				
				SELECT  MAX(A.SIGN_KOR_NAME) AS SIGN_KOR_NAME
				       ,MAX(A.SIGN_CODE) AS SIGN_CODE
					   ,MAX(A.DEP_DATE) AS DEP_DATE
					   ,A.PRO_CODE
					   ,MAX(A.PRO_NAME) AS PRO_NAME
					   ,MAX(A.TOUR_NIGHT) AS TOUR_NIGHT
					   ,MAX(A.TOUR_DAY) AS TOUR_DAY
					   ,MAX(A.RESCUSTOMERCOUNT) AS RESCUSTOMERCOUNT
					   ,MAX(A.NEW_NAME) AS NEW_NAME
					   ,MAX(A.REPORT_STATE) AS REPORT_STATE
					   ,MAX(A.RES_STATE) AS RES_STATE
					   ,MAX(A.EDI_CODE) AS EDI_CODE
					   ,MAX(A.ASSIGN_NAME) AS ASSIGN_NAME
					   ,MAX(A.TOTAL_VALUATION) AS TOTAL_VALUATION
					   ,A.AGT_CODE
					   ,MAX(A.AGT_NAME) AS AGT_NAME
			      FROM (SELECT   X.KOR_NAME AS SIGN_KOR_NAME 
								,Y.SIGN_CODE -- 지역
								,A.DEP_DATE --출발일
								,A.PRO_CODE --행사코드
								,A.PRO_NAME --행사명
								,A.TOUR_NIGHT --박
								,A.TOUR_DAY -- 일
								,(SELECT COUNT(B.RES_CODE) FROM dbo.Res_master_damo B WITH(NOLOCK)
								LEFT OUTER JOIN dbo.RES_CUSTOMER_damo C WITH(NOLOCK) ON B.RES_CODE = C.RES_CODE
								WHERE B.PRO_CODE = A.PRO_CODE AND C.RES_STATE = 0) AS RESCUSTOMERCOUNT--예약자수
								,DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME--담당자
								,ISNULL(V.OTR_STATE , ''0'') AS REPORT_STATE -- 보고서 상태 
								,CASE WHEN DATEDIFF(DAY,GETDATE(),A.DEP_DATE) <0 THEN 1 
								WHEN GETDATE() BETWEEN A.DEP_DATE AND A.ARR_DATE THEN 3
								ELSE 2 END AS RES_STATE --상태
								,V.EDI_CODE 
								,DBO.XN_COM_GET_EMP_NAME(A.TC_CODE) AS ASSIGN_NAME -- 인솔자
								,V.TOTAL_VALUATION -- 종합평가
								,B.AGT_CODE
								,(SELECT KOR_NAME FROM AGT_MASTER WHERE AGT_CODE = B.AGT_CODE) AS AGT_NAME
						FROM dbo.PKG_DETAIL A WITH(NOLOCK) 
						INNER JOIN dbo.PKG_MASTER Y WITH(NOLOCK) ON A.MASTER_CODE = Y.MASTER_CODE
						LEFT OUTER JOIN dbo.PUB_REGION X WITH(NOLOCK) ON Y.SIGN_CODE = X.SIGN
						LEFT OUTER JOIN dbo.OTR_MASTER V WITH(NOLOCK) ON A.PRO_CODE = V.PRO_CODE
						LEFT OUTER JOIN dbo.OTR_POL_MASTER B WITH(NOLOCK) ON (V.OTR_SEQ = B.OTR_SEQ AND ISNULL(B.GUIDE_NAME, '''') != '''')
						WHERE A.TC_ASSIGN_YN =''Y'' '+ @WHERE + ' ) A
				 WHERE  A.PRO_CODE IS NOT NULL  '+ @WHERE2 + '
				 GROUP  BY A.PRO_CODE, A.AGT_CODE, A.AGT_NAME
				ORDER BY ' + @ORDER + '
				OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
				ROWS ONLY '


	SET @PARMDEFINITION = N'@PAGE_INDEX  INT, @PAGE_SIZE  INT, @TOTAL_COUNT INT OUTPUT, @EMP_CODE CHAR(7), @PRO_CODE VARCHAR(20),@PRO_NAME NVARCHAR(100), @START_DATE DATETIME ,@END_DATE	DATETIME ,@REPORT_STATE INT ,@AGT_NAME VARCHAR(50), @TEAM_CODE VARCHAR(4)';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @PAGE_INDEX, @PAGE_SIZE, @TOTAL_COUNT OUTPUT, @EMP_CODE, @PRO_CODE,@PRO_NAME , @START_DATE ,@END_DATE,@REPORT_STATE,@AGT_NAME, @TEAM_CODE;

END



GO
