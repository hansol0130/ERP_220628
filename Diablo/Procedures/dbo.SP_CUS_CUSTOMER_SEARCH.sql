USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CUS_CUSTOMER_SEARCH
■ DESCRIPTION				: 고객 검색 팝업
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

exec SP_CUS_CUSTOMER_SEARCH @CUS_ID=NULL,@IPIN_DUP_INFO=NULL,@CUS_NAME='박형만', @BIRTH_DATE='1980-01-01 00:00:00',@GENDER='M',@EMAIL=NULL,@NOR_TEL1='010',@NOR_TEL2='9185',@NOR_TEL3='2481'
exec SP_CUS_CUSTOMER_SEARCH @CUS_ID=NULL,@IPIN_DUP_INFO=NULL,@CUS_NAME='남미경', @BIRTH_DATE='1974-03-20',@GENDER='F',@EMAIL=NULL,@NOR_TEL1='010',@NOR_TEL2='2039',@NOR_TEL3='7049'

exec sp_cus_customer_search '', '', '유영순', '', '', '', '', '', '010', '3783', '0028'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR		DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2010-05-07		박형만		신규 작성 
	2010-06-03		박형만		암호화 적용
	2012-03-02					READ UNCOMMITTED 설정
	2012-10-24					주민번호 없는 정회원(아이핀) 검색 되도록 수정 
	2012-12-14					주민번호 제거 반영 
	2013-06-18					예약자인지 여부 
	2013-10-17					전체컬럼 --> 필요컬럼만
	2013-12-06					주요정보는 정회원테이블에서 가져오도록
	2013-12-27					이름검색은 CUSTOMER,MEMBER 둘다에서
	2015-03-03		김성호		주민번호 삭제, 생년월일 추가
	2015-03-12		정지용		지난예약 / 진행중인 예약 추가..속도는괜찬은디.. 더러워서 쿼리 생각좀 해보겠음다.
	2015-03-12		박형만		Email like 검색
	2015-05-06		박형만		GENDER 조건 추가 ( 비회원 정보를 정확하게 찾기 위함 ) 
	2018-02-28		김성호		CUS_GRADE 추가, 고객등급 우선 정렬
	2018-04-05		박형만		최근여권으로 추가
	2021-01-25		김성호		고객조회 CUS_MEMBER -> VIEW_MEMBER 로 변경
	2022-03-17      오준혁       등급조회 (A.CUS_GRADE => dbo.FN_CUS_GET_CUS_GRADE_CODE)
================================================================================================================*/
CREATE PROC [dbo].[SP_CUS_CUSTOMER_SEARCH]
	@CUS_ID VARCHAR(20),
	@IPIN_DUP_INFO CHAR(64),
	@CUS_NAME VARCHAR(20),
	@BIRTH_DATE DATETIME ,
	@GENDER CHAR(1),
	@EMAIL  VARCHAR(100),
	@NOR_TEL1   VARCHAR(6),
	@NOR_TEL2   VARCHAR(5),
	@NOR_TEL3  VARCHAR(4)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	--------------------------------------------------------------------
	DECLARE @SQLSTRING NVARCHAR(4000)
	DECLARE @PARMDEFINITION NVARCHAR(1000)
	DECLARE @STR_WHERE NVARCHAR(1000)
	SET @STR_WHERE =''
	--고객이름
	IF ISNULL(@CUS_NAME, '') <> ''
	BEGIN
		SET @STR_WHERE = @STR_WHERE + ' 
		AND A.CUS_NAME = @CUS_NAME '
	END 
	--고객아이디
	IF ISNULL(@CUS_ID, '') <> ''
	BEGIN
		SET @STR_WHERE = @STR_WHERE + ' 
		AND A.CUS_ID = @CUS_ID'
	END 
	--생년월일
	IF(@BIRTH_DATE IS NOT NULL) 
	BEGIN
		SET @STR_WHERE = @STR_WHERE +' 
		AND A.BIRTH_DATE = @BIRTH_DATE '
	END 
	--성별
	IF(ISNULL(@GENDER,'') <>'') 
	BEGIN
		SET @STR_WHERE = @STR_WHERE +' 
		AND A.GENDER = @GENDER '
	END 
	--이메일
	IF(ISNULL(@EMAIL,'') <>'') 
	BEGIN
		SET @STR_WHERE = @STR_WHERE +' 
		AND A.EMAIL LIKE @EMAIL +''%'' '
	END 

	--휴대폰
	IF ISNULL(@NOR_TEL1, '') <> ''
	BEGIN
		SET @STR_WHERE = @STR_WHERE + ' AND A.NOR_TEL1 = @NOR_TEL1'
	END 
	IF ISNULL(@NOR_TEL2, '') <> ''
	BEGIN
		SET @STR_WHERE = @STR_WHERE + ' AND A.NOR_TEL2 = @NOR_TEL2'
	END 
	IF ISNULL(@NOR_TEL3, '') <> ''
	BEGIN
		SET @STR_WHERE = @STR_WHERE + ' AND A.NOR_TEL3 = @NOR_TEL3'
	END 

	IF( @STR_WHERE <> '')
	BEGIN
		--최대 5천건으로 제한
		SET @SQLSTRING = N' 
SELECT TOP 5000 
	ISNULL(B.CUS_NO,A.CUS_NO) AS CUS_NO ,
	ISNULL(B.CUS_ID,A.CUS_ID) AS CUS_ID , 
	ISNULL(B.CUS_PASS,A.CUS_PASS) AS CUS_PASS , 
	ISNULL(B.CUS_STATE,A.CUS_STATE) AS CUS_STATE , 
	ISNULL(B.CUS_NAME,A.CUS_NAME) AS CUS_NAME , 
	ISNULL(B.LAST_NAME,A.LAST_NAME) AS LAST_NAME , 
	ISNULL(B.FIRST_NAME,A.FIRST_NAME) AS FIRST_NAME , 
	ISNULL(B.NICKNAME,A.NICKNAME) AS NICKNAME , 
	dbo.FN_CUS_GET_CUS_GRADE_CODE(ISNULL(B.CUS_NO,A.CUS_NO), YEAR(GETDATE())) AS CUS_GRADE,
	A.EMAIL AS EMAIL , 
	ISNULL(B.GENDER,A.GENDER) AS GENDER , 
	A.NOR_TEL1 AS NOR_TEL1,
	A.NOR_TEL2 AS NOR_TEL2,
	A.NOR_TEL3 AS NOR_TEL3,
	A.COM_TEL1 AS COM_TEL1,
	A.COM_TEL2 AS COM_TEL2,
	A.COM_TEL3 AS COM_TEL3,
	A.PASS_YN AS PASS_YN,
	( SELECT TOP 1 damo.dbo.dec_varchar(''DIABLO'', ''dbo.RES_CUSTOMER'', ''PASS_NUM'', SEC_PASS_NUM) 
		FROM RES_CUSTOMER_DAMO WHERE CUS_NO = A.CUS_NO AND RES_STATE = 0 AND SEC_PASS_NUM IS NOT NULL ORDER BY NEW_DATE DESC ) AS PASS_NUM ,
	A.PASS_EXPIRE,
	A.PASS_ISSUE,
	A.[NATIONAL],
	A.FOREIGNER_YN,
	A.RCV_EMAIL_YN,
	A.RCV_SMS_YN,
	A.ADDRESS1,
	A.ADDRESS2,
	A.ZIP_CODE,
	A.NEW_DATE,
	A.NEW_CODE,

	A.EDT_DATE,
	A.EDT_CODE,
	A.EDT_MESSAGE,
	A.CXL_DATE,A.CXL_CODE,A.CXL_REMARK,A.OLD_YN,A.CU_YY,A.CU_SEQ,A.RCV_DM_YN,A.POINT_CONSENT,A.POINT_CONSENT_DATE,
	ISNULL(B.IPIN_DUP_INFO,A.IPIN_DUP_INFO) AS IPIN_DUP_INFO,
	ISNULL(B.IPIN_CONN_INFO,A.IPIN_CONN_INFO) AS IPIN_CONN_INFO,
	ISNULL(B.IPIN_ACC_DATE,A.IPIN_ACC_DATE) AS IPIN_ACC_DATE,
	A.EMAIL_AGREE_DATE,
	A.SMS_AGREE_DATE,
	A.EMAIL_INFLOW_TYPE,
	A.SMS_INFLOW_TYPE,
	A.RCV_EMP_CODE,
	ISNULL(B.SAFE_ID,A.SAFE_ID) AS SAFE_ID,
	ISNULL(B.BIRTH_DATE,A.BIRTH_DATE) AS BIRTH_DATE , 
	ISNULL((SELECT TOP 1 TOTAL_PRICE FROM CUS_POINT WITH(NOLOCK) WHERE A.CUS_NO = CUS_NO ORDER BY POINT_NO DESC ) , 0 ) AS POINT_PRICE ,
	CASE WHEN EXISTS (SELECT CUS_NO FROM RES_MASTER_DAMO WITH(NOLOCK) WHERE CUS_NO = A.CUS_NO /*AND NEW_DATE > CONVERT(DATETIME,DATEADD(MM,-6,GETDATE()))*/ ) THEN ''Y'' ELSE ''N'' END AS MASTER_YN,
	B.CERT_YN,
	(
		SELECT			
			ISNULL(SUM(CASE WHEN A.DEP_DATE > GETDATE() THEN 1 END), 0) AS PROCESS_RES
		FROM ( 
			SELECT RM.RES_CODE 
			FROM Diablo.dbo.RES_MASTER_damo RM WITH(NOLOCK) 
			WHERE RM.CUS_NO = A.CUS_NO 
			AND RM.VIEW_YN =''Y''
			AND RM.RES_STATE NOT IN ( 7,8,9 )
			UNION ALL 	
			SELECT RM.RES_CODE
			FROM Diablo.dbo.RES_MASTER_damo RM WITH(NOLOCK) 
			INNER JOIN Diablo.dbo.RES_CUSTOMER_DAMO RC WITH(NOLOCK) 
				ON RM.RES_CODE = RC.RES_CODE 
				AND RM.CUS_NO <> RC.CUS_NO 
			WHERE RC.CUS_NO = A.CUS_NO 
			AND RC.RES_STATE = 0
			AND RC.VIEW_YN =''Y''
			AND RM.RES_STATE NOT IN ( 7,8,9 )
			) RES 
		INNER JOIN Diablo.dbo.RES_MASTER_damo A ON RES.RES_CODE = A.RES_CODE 
	) AS RES_PROGRESS_CNT,
	(
		SELECT			
			ISNULL(SUM(CASE WHEN A.DEP_DATE < GETDATE() THEN 1 END), 0) AS END_RES
		FROM ( 
			SELECT RM.RES_CODE 
			FROM Diablo.dbo.RES_MASTER_damo RM WITH(NOLOCK) 
			WHERE RM.CUS_NO = A.CUS_NO 
			AND RM.VIEW_YN =''Y''
			AND RM.RES_STATE NOT IN ( 7,8,9 )
			UNION ALL 	
			SELECT RM.RES_CODE
			FROM Diablo.dbo.RES_MASTER_damo RM WITH(NOLOCK) 
			INNER JOIN Diablo.dbo.RES_CUSTOMER_DAMO RC WITH(NOLOCK) 
				ON RM.RES_CODE = RC.RES_CODE 
				AND RM.CUS_NO <> RC.CUS_NO 
			WHERE RC.CUS_NO = A.CUS_NO 
			AND RC.RES_STATE = 0
			AND RC.VIEW_YN =''Y''
			AND RM.RES_STATE NOT IN ( 7,8,9 )
			) RES 
		INNER JOIN Diablo.dbo.RES_MASTER_damo A ON RES.RES_CODE = A.RES_CODE 
	) AS RES_LAST_CNT
FROM CUS_CUSTOMER_damo AS A  WITH(NOLOCK) 
	LEFT JOIN VIEW_MEMBER AS B  WITH(NOLOCK)  
		ON A.CUS_NO = B.CUS_NO 
WHERE 1=1
AND A.CUS_STATE = ''Y''

		 ' + @STR_WHERE +'
ORDER BY A.CUS_GRADE DESC, A.CUS_ID DESC, A.NEW_DATE DESC' 

		SET @PARMDEFINITION = N'
		@CUS_ID VARCHAR(20),
		@IPIN_DUP_INFO CHAR(64),
		@CUS_NAME VARCHAR(20),
		@BIRTH_DATE DATETIME ,
		@GENDER CHAR(1),
		@EMAIL  VARCHAR(100),
		@NOR_TEL1   VARCHAR(6),
		@NOR_TEL2   VARCHAR(5),
		@NOR_TEL3  VARCHAR(4)
		'
		EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,@CUS_ID,
		@IPIN_DUP_INFO,
		@CUS_NAME,
		@BIRTH_DATE,
		@GENDER,
		@EMAIL,
		@NOR_TEL1  ,
		@NOR_TEL2  ,
		@NOR_TEL3 
	END 
	PRINT( @SQLSTRING )
END 




GO
