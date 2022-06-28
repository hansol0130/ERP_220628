USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_LIST_SELECT_2
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

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=10,@KEY=N'EmpCode=&ProCode=&ProName=&SDate=2013-04-01&EDate=2013-04-30&ReportState=&signCode=',@ORDER_BY=4

	exec XP_ASG_EVT_REPORT_LIST_SELECT_2 @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-20		이상일			최초생성    
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_ASG_EVT_REPORT_LIST_SELECT_2]
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
		@EMP_CODE	CHAR(7),
		@PRO_CODE   VARCHAR(20), --행사코드
		@PRO_NAME	NVARCHAR(100), --행사명
		@START_DATE VARCHAR(20) , 
		@END_DATE	VARCHAR(20) ,
		@REPORT_STATE CHAR(1),  --출장보고서 상태
		@SIGN_CODE		VARCHAR(1), --지역코드
		@ASSIGN_NAME		VARCHAR(20) --인솔자명

	SELECT
		@EMP_CODE = DBO.FN_PARAM(@KEY, 'EmpCode'),
		@PRO_CODE = DBO.FN_PARAM(@KEY, 'ProCode'),
		@PRO_NAME = DBO.FN_PARAM(@KEY, 'ProName'), 
		@START_DATE = DBO.FN_PARAM(@KEY, 'StartDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'EndDate'),
		@REPORT_STATE = DBO.FN_PARAM(@KEY, 'ReportState'),
		@SIGN_CODE = DBO.FN_PARAM(@KEY, 'SignCode'),
		@ASSIGN_NAME = DBO.FN_PARAM(@KEY, 'AssignName'),
		@WHERE = '',
		@ORDER = ' A.DEP_DATE DESC'

   
	-- WHERE 조건 만들기
	IF ISNULL(@PRO_CODE, '') <> '' --행사코드
		SET @WHERE = ' AND A.PRO_CODE LIKE @PRO_CODE + ''%'' '
    ELSE 
	BEGIN
		IF ISNULL(@EMP_CODE, '') <> '' -- 인솔자 코드
			SET @WHERE =@WHERE + ' AND A.TC_CODE = @EMP_CODE'

		IF ISNULL(@PRO_NAME, '') <> '' -- 행사명
			SET @WHERE =@WHERE + ' AND A.PRO_NAME LIKE ''%'' + @PRO_NAME + ''%'' '
			
		IF ISNULL(@ASSIGN_NAME, '') <> '' -- 인솔자명
			SET @WHERE =@WHERE + ' AND DBO.XN_COM_GET_EMP_NAME(A.TC_CODE) = @ASSIGN_NAME'

		IF (ISNULL(@START_DATE, '') <> '' AND ISNULL(@END_DATE, '') <> '' )-- 출발일
			SET @WHERE =@WHERE + ' AND A.DEP_DATE >= @START_DATE AND A.DEP_DATE < DATEADD(DAY, 1, @END_DATE) '
    	IF ISNULL(@REPORT_STATE, '') <> '' -- 출장보고서
		BEGIN
		     IF @REPORT_STATE = '0'
				SET @WHERE =@WHERE + ' AND V.OTR_STATE IS NULL'
			 ELSE
				SET @WHERE =@WHERE + ' AND V.OTR_STATE = @REPORT_STATE'
			 
		END
  	IF ISNULL(@SIGN_CODE, '') <> '' -- 지역
			 SET @WHERE =@WHERE + ' AND Y.SIGN_CODE = @SIGN_CODE'
	END


	--ORDER BY 조건 만들기

	IF @ORDER_BY = 1 -- 작성여부
		SET @ORDER = ' V.OTR_STATE  '
	IF  @ORDER_BY = 2 -- 출발일
		SET @ORDER = ' A.DEP_DATE DESC '
	IF  @ORDER_BY = 3 -- 담당자명
		SET @ORDER = ' DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE)   '
	IF  @ORDER_BY = 4 -- 지역
		SET @ORDER = ' X.KOR_NAME  '



	--상태 -- 0 예정:해당인솔자에게 배정되고 출발일이 지나지 않은 행사 --1 완료: 해당인솔자에게 배정되고 출발이 지난행사

	SET @SQLSTRING = N'
				SELECT @TOTAL_COUNT = COUNT(*)
				FROM PKG_DETAIL A
				INNER JOIN dbo.PKG_MASTER Y ON A.MASTER_CODE = Y.MASTER_CODE
				LEFT OUTER JOIN dbo.OTR_MASTER V ON A.PRO_CODE = V.PRO_CODE
				WHERE A.TC_ASSIGN_YN =''Y''
				' + @WHERE + ' ;

				WITH LIST AS
				(
					SELECT 
							A.PRO_CODE --행사코드
					FROM dbo.PKG_DETAIL A INNER JOIN dbo.PKG_MASTER Y ON A.MASTER_CODE = Y.MASTER_CODE
					LEFT OUTER JOIN dbo.OTR_MASTER V ON A.PRO_CODE = V.PRO_CODE
					WHERE A.TC_ASSIGN_YN =''Y'' '+ @WHERE + '
					ORDER BY A.DEP_DATE DESC
					OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
					ROWS ONLY
				)
				SELECT   X.KOR_NAME AS SIGN_KOR_NAME 
				        ,Y.SIGN_CODE -- 지역
						,A.DEP_DATE --출발일
						,A.PRO_CODE --행사코드
						,A.PRO_NAME --행사명
						,A.TOUR_NIGHT --박
						,A.TOUR_DAY -- 일
						,(SELECT COUNT(B.RES_CODE) FROM dbo.Res_master_damo B
						LEFT OUTER JOIN dbo.RES_CUSTOMER_damo C ON B.RES_CODE = C.RES_CODE
						WHERE B.PRO_CODE = A.PRO_CODE AND C.RES_STATE = 0) AS RESCUSTOMERCOUNT--예약자수
						,DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME--담당자
						,ISNULL(V.OTR_STATE , ''0'') AS REPORT_STATE -- 보고서 상태 
						,CASE WHEN DATEDIFF(DAY,GETDATE(),A.DEP_DATE) <0 THEN 1 
						WHEN GETDATE() BETWEEN A.DEP_DATE AND A.ARR_DATE THEN 3
						ELSE 2 END AS RES_STATE --상태
						,V.EDI_CODE 
						,DBO.XN_COM_GET_EMP_NAME(A.TC_CODE) AS ASSIGN_NAME -- 인솔자
						,V.TOTAL_VALUATION -- 종합평가
				FROM LIST Z
				INNER JOIN dbo.PKG_DETAIL A ON A.PRO_CODE = Z.PRO_CODE
				INNER JOIN dbo.PKG_MASTER Y ON A.MASTER_CODE = Y.MASTER_CODE
				LEFT OUTER JOIN dbo.PUB_REGION X ON Y.SIGN_CODE = X.SIGN
				LEFT OUTER JOIN dbo.OTR_MASTER V ON A.PRO_CODE = V.PRO_CODE
				WHERE A.TC_ASSIGN_YN =''Y'' '+ @WHERE + '
				ORDER BY ' + @ORDER


	SET @PARMDEFINITION = N'@PAGE_INDEX  INT, @PAGE_SIZE  INT, @TOTAL_COUNT INT OUTPUT, @EMP_CODE CHAR(7), @PRO_CODE VARCHAR(20),@PRO_NAME NVARCHAR(100), @START_DATE DATETIME ,@END_DATE	DATETIME ,@REPORT_STATE INT ,@SIGN_CODE CHAR(1), @ASSIGN_NAME VARCHAR(20)';

--	PRINT @SQLSTRING
	
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @PAGE_INDEX, @PAGE_SIZE, @TOTAL_COUNT OUTPUT, @EMP_CODE, @PRO_CODE,@PRO_NAME , @START_DATE ,@END_DATE,@REPORT_STATE,@SIGN_CODE, @ASSIGN_NAME;

END



GO
