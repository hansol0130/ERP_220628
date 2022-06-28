USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BTMS_EMPLOYEE_MANAGEMENTLIST
■ DESCRIPTION				: BTMS 거래처 직원 리스트 페이징
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@PAGE_INDEX				: 페이지 인덱스
	@PAGE_SIZE				: 페이지 사이즈
	@ORDER_TYPE				: 정렬 타입
■ OUTPUT PARAMETER			: 
■ EXEC		
	DECLARE @TOTAL INT
	EXEC DBO.XP_COM_BTMS_EMPLOYEE_MANAGEMENTLIST 0, 1000, @TOTAL OUTPUT, 'AgtCode=92756&TeamSeq=&EmpKorName=&EmpId=&ManagerYn=&OrderType=1'
	SELECT @TOTAL AS TOTAL_COUNT

	DECLARE @TOTAL INT
	EXEC DBO.XP_COM_BTMS_EMPLOYEE_MANAGEMENTLIST 0, 1000, @TOTAL OUTPUT, 'AgtCode=&TeamSeq=&EmpKorName=&EmpId=&ManagerYn=&OrderType=5'
	SELECT @TOTAL AS TOTAL_COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE					AUTHOR				DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-05-02		저스트고강태영			최초 생성
   2016-05-18		정지용					입사일, 영문성, 영문이름, 회사전화번호, 팩스번호 추가
   2016-05-20		백경훈					상위부서 추가(NULL 일때 자신의 팀을 가져옴)
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BTMS_EMPLOYEE_MANAGEMENTLIST]
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@TOTAL_COUNT	INT OUTPUT,
	@KEY			VARCHAR(1000)
AS 
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(4000), @SORT_STRING VARCHAR(100);
	DECLARE @AGT_CODE VARCHAR(10), @TEAM_SEQ INT, @EMP_KOR_NAME VARCHAR(20), @EMP_ID VARCHAR(20), @MANAGER_YN VARCHAR(1), @ORDER_TYPE INT;
	
	SELECT
		@AGT_CODE = DBO.FN_PARAM(@KEY, 'AgtCode'),
		@TEAM_SEQ = DBO.FN_PARAM(@KEY, 'TeamSeq'),
		@EMP_KOR_NAME = DBO.FN_PARAM(@KEY, 'EmpKorName'),
		@EMP_ID = DBO.FN_PARAM(@KEY, 'EmpId'),
		@MANAGER_YN = DBO.FN_PARAM(@KEY, 'ManagerYn'),
		@ORDER_TYPE = DBO.FN_PARAM(@KEY, 'OrderType')

	SELECT @WHERE = 'WHERE 1 = 1'
	
	IF(LEN(@AGT_CODE) > 0)
	BEGIN
		SET @WHERE = @WHERE + ' AND A.AGT_CODE = @AGT_CODE '
	END

	IF(@TEAM_SEQ <> '')
	BEGIN
		SET @WHERE = @WHERE + ' AND A.TEAM_SEQ = @TEAM_SEQ '
	END

	IF(LEN(@EMP_KOR_NAME) > 0)
	BEGIN
		SET @WHERE = @WHERE + ' AND A.KOR_NAME LIKE ''%'' + @EMP_KOR_NAME + ''%'' '
	END

	IF(LEN(@EMP_ID) > 0)
	BEGIN
		SET @WHERE = @WHERE + ' AND A.EMP_ID = @EMP_ID '
	END

	IF(LEN(@MANAGER_YN) > 0)
	BEGIN
		SET @WHERE = @WHERE + ' AND A.MANAGER_YN = @MANAGER_YN '
	END

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = (  
		CASE @ORDER_TYPE
			WHEN 1 THEN 'B.ORDER_NUM'
			WHEN 2 THEN 'A.KOR_NAME ASC, B.ORDER_NUM'
			WHEN 3 THEN 'A.TEAM_SEQ ASC, B.ORDER_NUM'
			WHEN 4 THEN 'A.WORK_TYPE ASC, B.ORDER_NUM'
			WHEN 5 THEN 'D.KOR_NAME ASC, B.ORDER_NUM'
		END
	)

	SET @SQLSTRING = N'
		-- 전체 조회 갯수
		SELECT @TOTAL_COUNT = COUNT(*)
		FROM COM_EMPLOYEE A WITH(NOLOCK)
		LEFT JOIN COM_POSITION B ON A.AGT_CODE = B.AGT_CODE AND A.POS_SEQ = B.POS_SEQ
		LEFT JOIN COM_TEAM C ON A.AGT_CODE = C.AGT_CODE AND A.TEAM_SEQ = C.TEAM_SEQ
		LEFT JOIN AGT_MASTER D ON A.AGT_CODE = D.AGT_CODE
		' + @WHERE + N';

		DECLARE @FROM INT,	@TO INT;

		SET @FROM = (@PAGE_INDEX * @PAGE_SIZE) + 1;
		SET @TO = (@PAGE_INDEX + 1) * @PAGE_SIZE;

		-- 리스트 조회
		WITH LIST AS
		(
			SELECT
				ROW_NUMBER() OVER (ORDER BY ' + @SORT_STRING + ') AS ROW_NUM,
				A.AGT_CODE, A.KOR_NAME, A.EMP_SEQ, A.TEAM_SEQ, A.POS_SEQ,
				A.JOIN_DATE, A.FIRST_NAME, A.LAST_NAME, A.COM_NUMBER, A.FAX_NUMBER
				FROM COM_EMPLOYEE A WITH(NOLOCK)
				LEFT JOIN COM_POSITION B ON A.AGT_CODE = B.AGT_CODE AND A.POS_SEQ = B.POS_SEQ
				LEFT JOIN COM_TEAM C ON A.AGT_CODE = C.AGT_CODE AND A.TEAM_SEQ = C.TEAM_SEQ
				LEFT JOIN AGT_MASTER D ON A.AGT_CODE = D.AGT_CODE
				' + @WHERE + N'
		)
		SELECT
			@TOTAL_COUNT - ( ROW_NUM - 1) AS SEQ_NO,
			A.AGT_CODE,
			D.KOR_NAME,
			A.EMP_SEQ,
			A.TEAM_SEQ,
			C.TEAM_NAME,
			ISNULL((SELECT TEAM_NAME FROM COM_TEAM K WHERE K.TEAM_SEQ = C.PARENT_TEAM_SEQ AND K.AGT_CODE = A.AGT_CODE),C.TEAM_NAME) AS PARENT_TEAM_NAME,
			A.EMP_ID,
			A.EMAIL,
			A.KOR_NAME AS EMP_KOR_NAME,
			A.BIRTH_DATE,
			A.POS_SEQ,
			B.POS_NAME,
			B.ORDER_NUM,
			A.GENDER,
			A.WORK_TYPE,
			A.HP_NUMBER,
			A.MANAGER_YN,
			A.JOIN_DATE, A.FIRST_NAME, A.LAST_NAME, A.COM_NUMBER, A.FAX_NUMBER
		FROM LIST Z
		INNER JOIN COM_EMPLOYEE A WITH(NOLOCK) ON Z.AGT_CODE = A.AGT_CODE AND Z.EMP_SEQ = A.EMP_SEQ
		LEFT JOIN COM_POSITION B ON A.AGT_CODE = B.AGT_CODE AND A.POS_SEQ = B.POS_SEQ
		LEFT JOIN COM_TEAM C ON A.AGT_CODE = C.AGT_CODE AND A.TEAM_SEQ = C.TEAM_SEQ
		LEFT JOIN AGT_MASTER D ON A.AGT_CODE = D.AGT_CODE AND D.BTMS_YN = ''Y''

		WHERE Z.ROW_NUM BETWEEN @FROM AND @TO
		ORDER BY Z.ROW_NUM, ' + @SORT_STRING

	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@AGT_CODE VARCHAR(10),
		@TEAM_SEQ INT,
		@EMP_KOR_NAME VARCHAR(20),
		@EMP_ID VARCHAR(20),
		@MANAGER_YN VARCHAR(1),
		@ORDER_TYPE INT';

	--PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@AGT_CODE,
		@TEAM_SEQ,
		@EMP_KOR_NAME,
		@EMP_ID,
		@MANAGER_YN,
		@ORDER_TYPE;

END

GO