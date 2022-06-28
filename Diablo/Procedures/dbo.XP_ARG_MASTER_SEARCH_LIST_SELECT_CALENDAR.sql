USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ARG_MASTER_SEARCH_LIST_SELECT_CALENDAR
■ DESCRIPTION				: 수배현황 검색(달력)
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	EXEC DBO.XP_ARG_MASTER_SEARCH_LIST_SELECT_CALENDAR 'ArrangeStatus=&StartDate=2013-06-01&EndDate=2013-06-30&NewDate1=&NewDate2=&TeamCode=&EmpCode=', 1
	EXEC DBO.XP_ARG_MASTER_SEARCH_LIST_SELECT_CALENDAR 'ArrangeStatus=&StartDate=&EndDate=&NewDate1=2013-06-01&NewDate2=2013-06-30&TeamCode=&EmpCode=', 2
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-06-11		김완기			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_MASTER_SEARCH_LIST_SELECT_CALENDAR]
	@KEY	varchar(200),
	@ORDER_BY	int
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);

	DECLARE @ARG_STATUS VARCHAR(1)
	DECLARE @START_DATE VARCHAR(10)
	DECLARE @END_DATE VARCHAR(10)
	DECLARE @NEW_DATE1 VARCHAR(10)
	DECLARE @NEW_DATE2 VARCHAR(10)
	DECLARE @TEAM_CODE	VARCHAR(4)
	DECLARE @EMP_CODE	VARCHAR(7)

	SELECT
		@ARG_STATUS = DBO.FN_PARAM(@KEY, 'ArrangeStatus'),
		@START_DATE = DBO.FN_PARAM(@KEY, 'StartDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'EndDate'),
		@NEW_DATE1 = DBO.FN_PARAM(@KEY, 'NewDate1'),
		@NEW_DATE2 = DBO.FN_PARAM(@KEY, 'NewDate2'),
		@TEAM_CODE = DBO.FN_PARAM(@KEY, 'TeamCode'),
		@EMP_CODE = DBO.FN_PARAM(@KEY, 'EmpCode')
		
	SET @WHERE = ''
	
	IF ISNULL(@ARG_STATUS, '') <> ''
		SET @WHERE = @WHERE + ' AND B.ARG_DETAIL_STATUS = @ARG_STATUS'

	IF ISNULL(@START_DATE, '') <> '' AND ISNULL(@NEW_DATE1, '') = ''
		BEGIN
			IF ISNULL(@START_DATE, '') <> ''
				SET @WHERE = @WHERE + ' AND A.DEP_DATE >= @START_DATE'

			IF ISNULL(@END_DATE, '') <> ''
				SET @WHERE = @WHERE + ' AND A.ARR_DATE <= @END_DATE'
		END
	ELSE IF ISNULL(@START_DATE, '') = '' AND ISNULL(@NEW_DATE1, '') <> ''
		BEGIN
			IF ISNULL(@NEW_DATE1, '') <> ''
				SET @WHERE = @WHERE + ' AND B.NEW_DATE >= @NEW_DATE1'

			IF ISNULL(@NEW_DATE2, '') <> ''
				SET @WHERE = @WHERE + ' AND B.NEW_DATE <= @NEW_DATE2'
		END

	IF ISNULL(@EMP_CODE, '') <> ''
		BEGIN
			SET @WHERE = ' AND B.NEW_CODE = @EMP_CODE'
		END
	ELSE
		BEGIN
			IF ISNULL(@TEAM_CODE, '') <> ''
				BEGIN
					SET @WHERE = ' AND B.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE = @TEAM_CODE)'
				END
		END

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = (  
		CASE @ORDER_BY  
			WHEN 1 THEN ' A.DEP_DATE, A.ARG_SEQ_NO, B.GRP_SEQ_NO'
			WHEN 2 THEN ' A.ARG_SEQ_NO, B.GRP_SEQ_NO'
			ELSE ' A.ARG_SEQ_NO, B.GRP_SEQ_NO'
		END
	)

	SET @SQLSTRING = N'
			SELECT
				A.ARG_SEQ_NO,
				A.AGT_CODE,
				A.RES_CODE,
				A.PRO_CODE,
				A.ARG_STATUS,
				A.DEP_DATE,
				A.ARR_DATE,
				A.DAY,
				A.NIGHTS,
				B.GRP_SEQ_NO,
				B.TITLE,
				B.ARG_TYPE,
				DBO.XN_COM_GET_EMP_NAME(B.CFM_CODE) AS CFM_NAME,
				DBO.XN_COM_GET_TEAM_NAME(B.CFM_CODE) AS CFM_TEAM_NAME,
				B.CFM_CODE,
				B.CFM_DATE,
				B.ARG_DETAIL_STATUS,
				B.NEW_CODE,
				DBO.XN_COM_GET_EMP_NAME(B.NEW_CODE) AS NEW_NAME,
				DBO.XN_COM_GET_TEAM_NAME(B.NEW_CODE) AS NEW_TEAM_NAME,
				B.NEW_DATE,
				DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS RES_COUNT,
				(SELECT COUNT(CUS_SEQ_NO) FROM ARG_CUSTOMER WHERE ARG_SEQ_NO = A.ARG_SEQ_NO AND GRP_SEQ_NO = B.GRP_SEQ_NO) AS CUS_COUNT
			FROM ARG_MASTER A WITH(NOLOCK)
			INNER JOIN ARG_DETAIL B WITH(NOLOCK) ON A.ARG_SEQ_NO = B.ARG_SEQ_NO
			WHERE 1=1 ' + @WHERE + '
			ORDER BY '+ @SORT_STRING 

		--PRINT @SQLSTRING
		SET @PARMDEFINITION = N'
			@ARG_STATUS VARCHAR(1),
			@START_DATE VARCHAR(10),
			@END_DATE VARCHAR(10),
			@NEW_DATE1 VARCHAR(10),
			@NEW_DATE2 VARCHAR(10),
			@TEAM_CODE	VARCHAR(4),
		    @EMP_CODE	VARCHAR(7)';


		EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
			@ARG_STATUS,
			@START_DATE,
			@END_DATE,
			@NEW_DATE1,
			@NEW_DATE2,
			@TEAM_CODE,
			@EMP_CODE;
END

GO
