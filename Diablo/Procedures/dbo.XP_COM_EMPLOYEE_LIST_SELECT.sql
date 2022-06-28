USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_EMPLOYEE_LIST_SELECT
■ DESCRIPTION				: BTMS 거래처 직원 리스트 검색
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@KEY		VARCHAR(400): 검색 키
	@ORDER_BY	INT			: 정렬 순서
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 항목 수
■ EXEC						: 

	DECLARE @TOTAL INT
	EXEC DBO.XP_COM_EMPLOYEE_LIST_SELECT 1, 100, 1000, 'AgentCode=93881&TeamSeq=&EmpName=&', 4

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-20		김성호			최초생성
   2016-02-03		정지용			직원번호 검색 추가
   2016-02-15		정지용			MANAGER_YN 추가
   2016-02-29		박형만			직급,팀이 없어도 나오도록 INNER JOIN -> LEFT JOIN 
   2016-04-13		박형만			cus_no 매칭정보 조회 
   2016-04-22		박형만			파라미터 추가 (ERP 직원검색)
   2016-05-12		이유라			관리자 TOP 1 ORDERBY 4번 추가
   2016-05-20		박형만			TEAM_SEQ 추가 
   2016-07-20		이유라			PARENT_TEAM_SEQ
   2018-01-22		박형만			DEL_YN 삭제된것 안나오게 적용 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EMPLOYEE_LIST_SELECT]
	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY		VARCHAR(400),
	@ORDER_BY	INT
AS 
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(4000), @SORT_STRING VARCHAR(100);

	DECLARE @AGT_CODE VARCHAR(10), @TEAM_SEQ INT, @KOR_NAME VARCHAR(20), @EMP_SEQ INT,
	
	--4.22 추가  파라미터 
	@POS_SEQ INT , @GENDER VARCHAR(10),
	@EMP_ID VARCHAR(20),@BIRTH_DATE VARCHAR(10),@HP_NUMBER VARCHAR(20),@EMAIL VARCHAR(50)

	SELECT
		@AGT_CODE = DBO.FN_PARAM(@KEY, 'AgentCode'),
		@TEAM_SEQ = DBO.FN_PARAM(@KEY, 'TeamSeq'),
		@KOR_NAME = DBO.FN_PARAM(@KEY, 'EmpName'),
		@EMP_SEQ = DBO.FN_PARAM(@KEY, 'EmpSeq'),
		
		--4.22 추가  파라미터 
		@POS_SEQ = DBO.FN_PARAM(@KEY, 'PosSeq'),
		@GENDER = DBO.FN_PARAM(@KEY, 'Gender'),
		@EMP_ID = DBO.FN_PARAM(@KEY, 'EmpId'),
		@BIRTH_DATE = DBO.FN_PARAM(@KEY, 'BirthDate'),
		@HP_NUMBER = DBO.FN_PARAM(@KEY, 'HpNumber'),
		@EMAIL = DBO.FN_PARAM(@KEY, 'Email')


	SELECT @WHERE = 'WHERE A.AGT_CODE = @AGT_CODE AND A.DEL_YN =''N'' '

	IF @TEAM_SEQ > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND A.TEAM_SEQ = @TEAM_SEQ'
	END

	IF LEN(@KOR_NAME) > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND A.KOR_NAME LIKE ''%'' + @KOR_NAME + ''%'''
	END

	IF @EMP_SEQ > 0
	BEGIN
		SET @WHERE  = @WHERE + ' AND A.EMP_SEQ = @EMP_SEQ'
	END

	--4.22 추가  파라미터 
	IF @POS_SEQ > 0
	BEGIN
		SET @WHERE  = @WHERE + ' AND A.POS_SEQ = @POS_SEQ'
	END
	IF ISNULL(@GENDER,'') <> ''
	BEGIN
		SET @WHERE  = @WHERE + ' AND A.GENDER = @GENDER'
	END
	IF ISNULL(@EMP_ID,'') <> ''
	BEGIN
		SET @WHERE  = @WHERE + ' AND A.EMP_ID = @EMP_ID'
	END
	IF ISNULL(@BIRTH_DATE,'') <> ''
	BEGIN
		SET @WHERE  = @WHERE + ' AND A.BIRTH_DATE = @BIRTH_DATE'
	END
	IF ISNULL(@HP_NUMBER,'') <> ''
	BEGIN
		SET @WHERE  = @WHERE + ' AND A.HP_NUMBER = @HP_NUMBER'
	END
	IF ISNULL(@EMAIL,'') <> ''
	BEGIN
		SET @WHERE  = @WHERE + ' AND A.EMAIL = @EMAIL'
	END

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = (  
		CASE @ORDER_BY
			WHEN 1 THEN 'A.JOIN_DATE DESC'
			WHEN 2 THEN 'A.KOR_NAME'
			WHEN 3 THEN 'A.WORK_TYPE'
			WHEN 4 THEN '(CASE A.EMP_SEQ WHEN 100 THEN 1 ELSE 2 END), A.KOR_NAME'
			ELSE 'A.JOIN_DATE DESC'
		END
	)

	SET @SQLSTRING = N'
		-- 전체 조회 갯수
		SELECT @TOTAL_COUNT = COUNT(*)
		FROM COM_EMPLOYEE A WITH(NOLOCK)
		' + @WHERE + N';

		-- 리스트 조회
		WITH LIST AS
		(
			SELECT A.AGT_CODE, A.EMP_SEQ
			FROM COM_EMPLOYEE A WITH(NOLOCK)
			' + @WHERE + N'
			ORDER BY ' + @SORT_STRING + '
			OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
			ROWS ONLY
		)
		SELECT A.AGT_CODE, A.EMP_SEQ, A.EMP_ID, A.KOR_NAME, A.LAST_NAME, A.FIRST_NAME, A.BIRTH_DATE, A.JOIN_DATE, A.GENDER, B.TEAM_SEQ, B.TEAM_NAME, B.PARENT_TEAM_SEQ, C.POS_SEQ, C.POS_NAME, A.HP_NUMBER, A.WORK_TYPE, A.EMAIL, A.MANAGER_YN
		, D.CUS_NO 
		FROM LIST Z
		LEFT JOIN COM_EMPLOYEE A WITH(NOLOCK) ON Z.AGT_CODE = A.AGT_CODE AND Z.EMP_SEQ = A.EMP_SEQ
		LEFT JOIN COM_TEAM B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.TEAM_SEQ = B.TEAM_SEQ
		LEFT JOIN COM_POSITION C WITH(NOLOCK) ON A.AGT_CODE = C.AGT_CODE AND A.POS_SEQ = C.POS_SEQ
		LEFT JOIN COM_EMPLOYEE_MATCHING D WITH(NOLOCK) ON A.AGT_CODE = D.AGT_CODE AND A.EMP_SEQ = D.EMP_SEQ
		ORDER BY ' + @SORT_STRING


	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@AGT_CODE VARCHAR(10),
		@TEAM_SEQ INT,
		@EMP_SEQ INT,
		@KOR_NAME VARCHAR(20),

		@POS_SEQ INT , 
		@GENDER VARCHAR(10),
		@EMP_ID VARCHAR(20),
		@BIRTH_DATE VARCHAR(10),
		@HP_NUMBER VARCHAR(20),
		@EMAIL VARCHAR(50)';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@AGT_CODE,
		@TEAM_SEQ,
		@EMP_SEQ,
		@KOR_NAME,
		@POS_SEQ  , 
		@GENDER ,
		@EMP_ID,
		@BIRTH_DATE,
		@HP_NUMBER ,
		@EMAIL;

END 



GO
