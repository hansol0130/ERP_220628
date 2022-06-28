USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_LIST_SELECT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 배정행사 리스트 검색
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

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=10,@KEY=N'EmpCode=T130114&ProCode=&ProName=&SDate=&EDate=&ReportState=&ResState=2',@ORDER_BY=2

	exec XP_ASG_EVT_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-21		오인규			최초생성    출장보고서 상태값 검색 추가해야함
   2014-01-16		이동호						상태값 노출 수정(완료,진행,예정)
   2014-02-19		이동호						정렬값 수정
   2014-02-27		이동호						출장보고서 상태 컬럼 추가
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_ASG_EVT_LIST_SELECT]
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

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(4000) ,@ORDERBY NVARCHAR(1000);

	DECLARE
		@EMP_CODE	CHAR(7),
		@PRO_CODE   VARCHAR(20), --행사코드
		@PRO_NAME	NVARCHAR(100), --행사명
		@START_DATE DATETIME , 
		@END_DATE	DATETIME ,
		@REPORT_STATE CHAR(1),  --출장보고서 상태
		@RES_STATE CHAR(1)

	SELECT
		@EMP_CODE = DBO.FN_PARAM(@KEY, 'EmpCode'),
		@PRO_CODE = DBO.FN_PARAM(@KEY, 'ProCode'),
		@PRO_NAME = DBO.FN_PARAM(@KEY, 'ProName'), 
		@START_DATE = DBO.FN_PARAM(@KEY, 'SDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'EDate'),
		@REPORT_STATE = DBO.FN_PARAM(@KEY, 'ReportState'),
		@RES_STATE = DBO.FN_PARAM(@KEY, 'ResState'),
		@WHERE = ''


	-- WHERE 조건 만들기
	IF ISNULL(@PRO_CODE, '') <> '' --행사코드
		SET @WHERE = ' AND A.PRO_CODE LIKE @PRO_CODE + ''%'' '
    else
	BEGIN 
		IF ISNULL(@PRO_NAME, '') <> '' -- 행사명
			SET @WHERE =@WHERE + ' AND A.PRO_NAME LIKE ''%'' + @PRO_NAME + ''%'' '
		IF (ISNULL(@START_DATE, '') <> '' AND ISNULL(@END_DATE, '') <> '' )-- 출발일
			SET @WHERE =@WHERE + ' AND A.DEP_DATE BETWEEN @START_DATE AND @END_DATE '
		IF ISNULL(@REPORT_STATE, '') <> '' -- 출장보고서
		    BEGIN
		     IF @REPORT_STATE = '0'
				SET @WHERE =@WHERE + ' AND V.OTR_STATE IS NULL'
			 ELSE
				SET @WHERE =@WHERE + ' AND V.OTR_STATE = @REPORT_STATE'			 
			 END

		IF ISNULL(@RES_STATE, '') <> ''
			BEGIN
				IF @RES_STATE = '1'
					SET @WHERE = @WHERE +  ' AND DATEDIFF(DAY,GETDATE(),A.ARR_DATE) < 0 ' --완료
				ELSE IF @RES_STATE = '2'
					SET @WHERE = @WHERE +  ' AND DATEDIFF(DAY,A.DEP_DATE,GETDATE()) < 0 ' --예정
				ELSE IF @RES_STATE = '3'
					SET @WHERE = @WHERE +  ' AND GETDATE() BETWEEN A.DEP_DATE AND A.ARR_DATE ' --진행
			END
			 
    END
	
	SET @ORDERBY =' A.DEP_DATE DESC'

	--상태 -- 0 예정:해당인솔자에게 배정되고 출발일이 지나지 않은 행사 --1 완료: 해당인솔자에게 배정되고 출발이 지난행사

	SET @SQLSTRING = N'
				SELECT @TOTAL_COUNT = COUNT(*)
				FROM PKG_DETAIL A
				LEFT OUTER JOIN dbo.OTR_MASTER V ON A.PRO_CODE = V.PRO_CODE
				WHERE A.TC_CODE = @EMP_CODE AND A.TC_ASSIGN_YN =''Y''
				' + @WHERE + ' ;

				WITH LIST AS
				(
					SELECT 
							A.PRO_CODE --행사코드
					FROM PKG_DETAIL A WITH(NOLOCK)
					LEFT OUTER JOIN dbo.OTR_MASTER V WITH(NOLOCK) ON A.PRO_CODE = V.PRO_CODE
					WHERE A.TC_CODE = @EMP_CODE AND A.TC_ASSIGN_YN =''Y'' '+ @WHERE + '
					ORDER BY ' + @ORDERBY + '
					OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
					ROWS ONLY
				)
				SELECT  
						CASE WHEN DATEDIFF(DAY,GETDATE(),A.ARR_DATE) < 0 THEN 1 -- 완료
						WHEN GETDATE() BETWEEN A.DEP_DATE AND A.ARR_DATE THEN 3 -- 진행
						ELSE 2 END AS RES_STATE --상태 
						,A.DEP_DATE --출발일
						,A.PRO_CODE --행사코드
						,A.PRO_NAME --행사명
						,A.TOUR_NIGHT --박
						,A.TOUR_DAY -- 일
						,(SELECT COUNT(B.RES_CODE) FROM dbo.Res_master_damo B WITH(NOLOCK)
						LEFT OUTER JOIN dbo.RES_CUSTOMER_damo C WITH(NOLOCK) ON B.RES_CODE = C.RES_CODE
						WHERE B.PRO_CODE = A.PRO_CODE AND C.RES_STATE = 0) AS RESCUSTOMERCOUNT--예약자수
						,DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME--담당자
						,ISNULL(V.OTR_STATE , ''0'') AS REPORT_STATE --출장보고서 상태	
						,(SELECT COUNT(C.RES_CODE) FROM dbo.Res_master_damo C WITH(NOLOCK)						
		WHERE C.PRO_CODE  = A.PRO_CODE) AS RESCOUNT  
				FROM LIST Z
				INNER JOIN PKG_DETAIL A WITH(NOLOCK) ON A.PRO_CODE = Z.PRO_CODE
				LEFT OUTER JOIN dbo.OTR_MASTER V WITH(NOLOCK) ON A.PRO_CODE = V.PRO_CODE
				WHERE A.TC_CODE = @EMP_CODE AND A.TC_ASSIGN_YN =''Y'' '+ @WHERE + '
				ORDER BY ' + @ORDERBY 


	SET @PARMDEFINITION = N'@PAGE_INDEX  INT, @PAGE_SIZE  INT, @TOTAL_COUNT INT OUTPUT, @EMP_CODE CHAR(7), @PRO_CODE VARCHAR(20),@PRO_NAME NVARCHAR(100), @START_DATE DATETIME ,@END_DATE	DATETIME ,@REPORT_STATE CHAR(1), @RES_STATE CHAR(1) ';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @PAGE_INDEX, @PAGE_SIZE, @TOTAL_COUNT OUTPUT, @EMP_CODE, @PRO_CODE,@PRO_NAME , @START_DATE ,@END_DATE,@REPORT_STATE, @RES_STATE;

END


GO
