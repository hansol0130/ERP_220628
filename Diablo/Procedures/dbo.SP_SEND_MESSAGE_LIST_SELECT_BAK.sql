USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_SEND_MESSAGE_LIST_SELECT_BAK
■ DESCRIPTION				: 발송내역 페이징 검색 (반영전 기존 프로시져 백업 )
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	DECLARE @p5 INT
	SET @p5=NULL
	EXEC SP_SEND_MESSAGE_LIST_SELECT_BAK @PAGE_INDEX=1,@PAGE_SIZE=15,@KEY=N'CusNo=15',@ORDER_BY=0,@TOTAL_COUNT=@p5 OUTPUT
	SELECT @p5

	DECLARE @p5 INT
	SET @p5=NULL
	EXEC SP_SEND_MESSAGE_LIST_SELECT_BAK @PAGE_INDEX=1,@PAGE_SIZE=10,@KEY=N'Phone=01032536841&StartDate=2018-06-01&EndDate=2018-07-03',@ORDER_BY=0,@TOTAL_COUNT=@p5 OUTPUT
	SELECT @p5
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-07-04		김성호			최초생성
   2018-07-05		정지용			팀코드, 사원코드 검색 추가 및 SORT 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_SEND_MESSAGE_LIST_SELECT_BAK]
(
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	VARCHAR(200),
	@ORDER_BY	INT
) 
AS 
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000), @WHERE1 NVARCHAR(1000) = '', @SORT_STRING VARCHAR(50);
	DECLARE @CODE VARCHAR(20), @AGT_CODE VARCHAR(10), @CUS_NO INT, @START_DATE VARCHAR(10), @END_DATE VARCHAR(10), @PHONE_NUM VARCHAR(20), @TEAM_CODE CHAR(3), @EMP_CODE CHAR(7);

	SELECT 
		@CODE = DBO.FN_PARAM(@KEY, 'Code'),
		@AGT_CODE = DBO.FN_PARAM(@KEY, 'AgtCode'),
		@CUS_NO = DBO.FN_PARAM(@KEY, 'CusNo'),
		@PHONE_NUM = DBO.FN_PARAM(@KEY, 'Phone'),
		@TEAM_CODE = DBO.FN_PARAM(@KEY, 'TeamCode'),
		@EMP_CODE = DBO.FN_PARAM(@KEY, 'EmpCode'),
		@START_DATE = DBO.FN_PARAM(@KEY, 'StartDate'),
		@END_DATE = DATEADD(DD, 1, CONVERT(DATE, DBO.FN_PARAM(@KEY, 'EndDate')));		-- 출발일 + 1


	-- 행사, 예약코드
	IF EXISTS(SELECT 1 FROM DIABLO.DBO.PKG_DETAIL A WITH(NOLOCK) WHERE A.PRO_CODE = @CODE)
	BEGIN
		SELECT @WHERE1 = N'AND A.RES_CODE IN (SELECT RES_CODE FROM DIABLO.DBO.RES_MASTER_DAMO A WITH(NOLOCK) WHERE A.PRO_CODE = @CODE) '
	END
	ELSE IF EXISTS(SELECT 1 FROM DIABLO.DBO.RES_MASTER_DAMO A WITH(NOLOCK) WHERE A.RES_CODE = @CODE)
	BEGIN
		SELECT @WHERE1 = N'AND A.RES_CODE = @CODE '
	END

	-- 고객번호
	IF LEN(@AGT_CODE) = 0 AND @CUS_NO > 0
		SELECT @WHERE1 = @WHERE1 + N'AND A.CUS_NO = @CUS_NO '

	-- 신안테이블에는 행사,예약코드, 회원번호 조건 만 사용
	--IF LEN(@WHERE1) > 5
	--	SELECT @WHERE2 = N'WHERE ' + SUBSTRING(@WHERE1, 5, 1000)

	-- 업체코드
	IF LEN(@AGT_CODE) > 0
		SELECT @WHERE1 = @WHERE1 + N'AND A.AGT_CODE = @AGT_CODE AND AND A.EMP_SEQ = @CUS_NO '

	-- 수신번호
	IF LEN(@PHONE_NUM) >= 10
	BEGIN
		SELECT @WHERE1 = @WHERE1 + N'AND B.PHONE_NUM = @PHONE_NUM '

		--SELECT @SUB_WHERE1 = @SUB_WHERE1 + N'AND PHONE_NUM = @PHONE_NUM '
		--	, @SUB_WHERE2 = @SUB_WHERE2 + N'AND TRAN_PHONE = @PHONE_NUM '
	END

	IF LEN(@TEAM_CODE) > 0
	BEGIN
		SELECT @WHERE1 = @WHERE1 + N'AND B.REQ_DEPT_CD = @TEAM_CODE '
	END

	IF LEN(@EMP_CODE) > 0
	BEGIN
		SELECT @WHERE1 = @WHERE1 + N'AND B.REQ_USR_ID = @EMP_CODE '
	END

	IF LEN(@START_DATE) > 0 AND LEN(@END_DATE) > 0
	BEGIN
		SELECT @WHERE1 = @WHERE1 + N'AND B.SND_DATE >= @START_DATE AND B.SND_DATE < @END_DATE'

		--SELECT @SUB_WHERE1 = @SUB_WHERE1 + N'AND ISNULL(SMS_SND_DTM, SND_DTM) LIKE  = @PHONE_NUM '
		--	, @SUB_WHERE2 = @SUB_WHERE2 + N'AND TRAN_PHONE = @PHONE_NUM '
	END


	IF LEN(@WHERE1) > 5
		SELECT @WHERE1 = N'WHERE ' + SUBSTRING(@WHERE1, 5, 1000)

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = (  
		CASE @ORDER_BY
			WHEN 1 THEN 'A.SN'
			ELSE 'SN DESC'
		END
	)

	SET @SQLSTRING = N'
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM (
		SELECT A.SN
		FROM SEND.DBO.ALT_MESSAGE_MASTER A WITH(NOLOCK)
		INNER JOIN (
			SELECT AA.SN, AA.PHONE_NUM, CONVERT(DATETIME, STUFF(STUFF(STUFF(ISNULL(AA.SMS_SND_DTM, AA.SND_DTM), 9, 0, '' ''), 12, 0, '':''), 15, 0, '':'')) AS SND_DATE, AA.REQ_DEPT_CD, AA.REQ_USR_ID
			FROM SEND.dbo.MZSENDTRAN AA WITH(NOLOCK) WHERE AA.PHONE_NUM IS NOT NULL
			UNION ALL
			SELECT BB.SN, BB.PHONE_NUM, CONVERT(DATETIME, STUFF(STUFF(STUFF(ISNULL(BB.SMS_SND_DTM, BB.SND_DTM), 9, 0, '' ''), 12, 0, '':''), 15, 0, '':'')) AS SND_DATE, BB.REQ_DEPT_CD, BB.REQ_USR_ID
			FROM SEND.dbo.MZSENDLOG BB WITH(NOLOCK) WHERE BB.PHONE_NUM IS NOT NULL
		) B ON A.SN = B.SN
		' + @WHERE1 + N'
		UNION ALL
		SELECT A.SN
		FROM SEND.DBO.ALT_MESSAGE_MASTER A WITH(NOLOCK)
		INNER JOIN (
			SELECT AA.TRAN_PR, AA.TRAN_PHONE AS [PHONE_NUM], AA.TRAN_RSLTDATE AS SND_DATE, AA.REQ_DEPT_ID AS REQ_DEPT_CD, AA.REQ_USER_ID AS REQ_USR_ID FROM SEND.dbo.em_tran AA WITH(NOLOCK)
			UNION ALL
			SELECT BB.TRAN_PR, BB.TRAN_PHONE AS [PHONE_NUM], BB.TRAN_RSLTDATE AS SND_DATE, BB.REQ_DEPT_ID AS REQ_DEPT_CD, BB.REQ_USER_ID AS REQ_USR_ID FROM SEND.dbo.em_log BB WITH(NOLOCK)
		) B ON A.TRAN_SN = B.TRAN_PR
		' + @WHERE1 + N'
	) A;'

	SET @SQLSTRING = @SQLSTRING + N'

	WITH KEY_LIST AS
	(
		SELECT A.SN
		FROM (
			SELECT A.SN
			FROM SEND.DBO.ALT_MESSAGE_MASTER A WITH(NOLOCK)
			INNER JOIN (
				SELECT AA.SN, AA.PHONE_NUM, CONVERT(DATETIME, STUFF(STUFF(STUFF(ISNULL(AA.SMS_SND_DTM, AA.SND_DTM), 9, 0, '' ''), 12, 0, '':''), 15, 0, '':'')) AS SND_DATE, AA.REQ_DEPT_CD, AA.REQ_USR_ID
				FROM SEND.dbo.MZSENDTRAN AA WITH(NOLOCK) WHERE AA.PHONE_NUM IS NOT NULL
				UNION ALL
				SELECT BB.SN, BB.PHONE_NUM, CONVERT(DATETIME, STUFF(STUFF(STUFF(ISNULL(BB.SMS_SND_DTM, BB.SND_DTM), 9, 0, '' ''), 12, 0, '':''), 15, 0, '':'')) AS SND_DATE, BB.REQ_DEPT_CD, BB.REQ_USR_ID
				FROM SEND.dbo.MZSENDLOG BB WITH(NOLOCK) WHERE BB.PHONE_NUM IS NOT NULL
			) B ON A.SN = B.SN
			' + @WHERE1 + N'
			UNION ALL
			SELECT A.SN
			FROM SEND.DBO.ALT_MESSAGE_MASTER A WITH(NOLOCK)
			INNER JOIN (
				SELECT AA.TRAN_PR, AA.TRAN_PHONE AS [PHONE_NUM], AA.TRAN_RSLTDATE AS SND_DATE, AA.REQ_DEPT_ID AS REQ_DEPT_CD, AA.REQ_USER_ID AS REQ_USR_ID FROM SEND.dbo.em_tran AA WITH(NOLOCK)
				UNION ALL
				SELECT BB.TRAN_PR, BB.TRAN_PHONE AS [PHONE_NUM], BB.TRAN_RSLTDATE AS SND_DATE, BB.REQ_DEPT_ID AS REQ_DEPT_CD, BB.REQ_USER_ID AS REQ_USR_ID FROM SEND.dbo.em_log BB WITH(NOLOCK)
			) B ON A.TRAN_SN = B.TRAN_PR
			' + @WHERE1 + N'
		) A
		ORDER BY ' + @SORT_STRING + '
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
		ROWS ONLY
	)
	, ALRIM_LIST AS (
		-- 알림톡 + 알림톡 대체 SMS(엠엔와이즈)
		SELECT
			A.*,
			(CASE WHEN B.SMS_SND_DTM IS NULL THEN 117 ELSE 118 END) AS [SND_TYPE],
			DIABLO.DBO.FN_STRING_TELNUMBER_FORMAT(B.SMS_SND_NUM) AS [SND_NUMBER],
			B.SND_MSG AS BODY, 
			ISNULL(D.RST_CODE, C.RST_CODE) AS SND_RESULT,
			ISNULL(D.RST_INFO, C.RST_INFO) AS SND_RESULT_MESSAGE,
			LEFT(B.PHONE_NUM, 3) AS [RCV_NUMBER1],
			(CASE
				WHEN LEN(B.PHONE_NUM) = 10 THEN SUBSTRING(B.PHONE_NUM, 4, 3)
				WHEN LEN(B.PHONE_NUM) = 11 THEN SUBSTRING(B.PHONE_NUM, 4, 4)
				ELSE '''' END) AS [RCV_NUMBER2],
			REVERSE(SUBSTRING(REVERSE(B.PHONE_NUM), 1,4)) AS [RCV_NUMBER3],
			--ISNULL(A.CUS_NAME, E.CUS_NAME) AS [RCV_NAME],
			B.REQ_USR_ID AS [NEW_CODE],
			CONVERT(DATETIME, STUFF(STUFF(STUFF(B.REQ_DTM, 9, 0, '' ''), 12, 0, '':''), 15, 0, '':'')) AS NEW_DATE,
			CONVERT(DATETIME, STUFF(STUFF(STUFF(B.SND_DTM, 9, 0, '' ''), 12, 0, '':''), 15, 0, '':'')) AS SND_DATE,
			(CASE WHEN B.TR_TYPE_CD = ''R'' THEN 0 ELSE 1 END) AS [SND_METHOD]		-- 즉시전송 = 0, 예약전송 = 1
		FROM SEND.DBO.ALT_MESSAGE_MASTER A WITH(NOLOCK)
		INNER JOIN (
			SELECT * FROM SEND.dbo.MZSENDTRAN AA WITH(NOLOCK) WHERE AA.PHONE_NUM IS NOT NULL
			UNION ALL
			SELECT * FROM SEND.dbo.MZSENDLOG BB WITH(NOLOCK) WHERE BB.PHONE_NUM IS NOT NULL
		) B ON A.SN = B.SN
		LEFT JOIN SEND.DBO.ALT_RESULT_MESSAGE C WITH(NOLOCK) ON C.RST_TYPE = ''A'' AND B.RSLT_CD = C.RST_CODE
		LEFT JOIN SEND.DBO.ALT_RESULT_MESSAGE D WITH(NOLOCK) ON D.RST_TYPE = ''S'' AND B.SMS_RSLT_CD = D.RST_CODE
		LEFT JOIN DIABLO.DBO.CUS_CUSTOMER_DAMO E WITH(NOLOCK) ON A.CUS_NO = E.CUS_NO
		WHERE A.SN IN (SELECT AA.SN FROM KEY_LIST AA)
		UNION ALL
		-- SMS(엠엔와이즈)
		SELECT
			A.*,
			118 AS [SND_TYPE],
			DIABLO.DBO.FN_STRING_TELNUMBER_FORMAT(B.TRAN_CALLBACK) AS SND_NUMBER,
			ISNULL(C.mms_body, B.TRAN_MSG) AS BODY,
			D.RST_CODE AS SND_RESULT,
			D.RST_INFO AS SND_RESULT_MESSAGE,
			LEFT(B.TRAN_PHONE, 3) AS [RCV_NUBER1],
			(CASE
				WHEN LEN(B.TRAN_PHONE) = 10 THEN SUBSTRING(B.TRAN_PHONE, 4, 3)
				WHEN LEN(B.TRAN_PHONE) = 11 THEN SUBSTRING(B.TRAN_PHONE, 4, 4)
				ELSE '''' END) AS [RCV_NUMBER2],
			REVERSE(SUBSTRING(REVERSE(B.TRAN_PHONE), 1,4)) AS [RCV_NUMBER3],
			---ISNULL(A.CUS_NAME, E.CUS_NAME) AS [RCV_NAME],
			B.REQ_USER_ID AS [EMP_CODE],
			B.TRAN_DATE AS NEW_DATE,
			B.TRAN_REPORTDATE AS SND_DATE,
			0 AS [SND_METHOD]
		FROM SEND.DBO.ALT_MESSAGE_MASTER A WITH(NOLOCK)
		INNER JOIN (
			SELECT * FROM SEND.dbo.em_tran AA WITH(NOLOCK)
			UNION ALL
			SELECT * FROM SEND.dbo.em_log BB WITH(NOLOCK)
		) B ON A.TRAN_SN = B.TRAN_PR
		LEFT JOIN SEND.DBO.EM_TRAN_MMS C WITH(NOLOCK) ON B.tran_etc4 = C.MMS_SEQ
		LEFT JOIN SEND.DBO.ALT_RESULT_MESSAGE D WITH(NOLOCK) ON D.RST_TYPE = ''S'' AND B.TRAN_RSLT = D.RST_CODE
		WHERE A.SN IN (SELECT AA.SN FROM KEY_LIST AA)
	)'

	SET @SQLSTRING = @SQLSTRING + N'
	, TOTAL_LIST AS
	(
		-- 알림톡 + SMS (엠엔와이즈)
		SELECT ''A'' AS [TYPE],
			A.SN, A.SND_TYPE, A.SND_NUMBER, A.BODY, A.SND_RESULT, A.SND_RESULT_MESSAGE, 
			A.RCV_NUMBER1, A.RCV_NUMBER2, A.RCV_NUMBER3, ISNULL(A.CUS_NAME, B.CUS_NAME) AS [RCV_NAME], 
			A.NEW_CODE, A.NEW_DATE, A.SND_DATE, A.SND_METHOD, A.RES_CODE, A.CUS_NO, A.AGT_CODE, A.EMP_SEQ
		FROM ALRIM_LIST A
		LEFT JOIN DIABLO.DBO.CUS_CUSTOMER_damo B WITH(NOLOCK) ON A.CUS_NO = B.CUS_NO
	)
	SELECT A.*, B.KOR_NAME AS [NEW_NAME]
	FROM TOTAL_LIST A
	LEFT JOIN DIABLO.DBO.EMP_MASTER_DAMO B WITH(NOLOCK) ON A.NEW_CODE = B.EMP_CODE ORDER BY ' + @SORT_STRING + '';

	SET @PARMDEFINITION = N'
		@CODE		VARCHAR(20),
		@AGT_CODE	VARCHAR(10),
		@CUS_NO		INT,
		@TEAM_CODE  CHAR(3),
		@EMP_CODE	CHAR(7),
		@START_DATE VARCHAR(10),
		@END_DATE	VARCHAR(10),
		@PHONE_NUM	VARCHAR(20),
		@TOTAL_COUNT INT OUTPUT,
		@PAGE_INDEX INT,
		@PAGE_SIZE INT';

--	PRINT @SQLSTRING;

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@CODE,
		@AGT_CODE,
		@CUS_NO,
		@TEAM_CODE,
		@EMP_CODE,
		@START_DATE,
		@END_DATE,
		@PHONE_NUM,
		@TOTAL_COUNT OUTPUT,
		@PAGE_INDEX,
		@PAGE_SIZE;


/*
	SELECT CONVERT(DATETIME, '20180619 13:37:25')

	select TOP 100 * from send.dbo.em_log WITH(NOLOCK) ORDER BY tran_pr DESC



	select TOP 100 sn, REQ_DEPT_CD, REQ_USR_ID
	from send.dbo.MZSENDTRAN WITH(NOLOCK)
	where sn in ('20180618-000090', '20180619-000027', '20180619-000036', '20180619-000919')
	
	select TOP 100 *
	from send.dbo.em_tran WITH(NOLOCK)
	where seq in ('20180618-000090', '20180619-000027', '20180619-000036', '20180619-000919')
	

	
SELECT TOP 100
		CONVERT(VARCHAR(100), SND_NO) AS SND_NO, SND_TYPE, SND_NUMBER, BODY, SND_RESULT, RCV_NUMBER1, RCV_NUMBER2, RCV_NUMBER3,  
		RCV_NAME, DIABLO.DBO.XN_COM_GET_EMP_NAME(NEW_CODE) AS NEW_NAME, NEW_CODE, NEW_DATE, SND_METHOD, SND_DATE, RES_CODE, CUS_NO
	FROM DIABLO.DBO.RES_SND_SMS A WITH(NOLOCK) 
	WHERE A.RES_CODE = 'RP1805154285'

SELECT *
FROM SEND.DBO.ALT_MESSAGE_MASTER

	SELECT 
		A.SN AS SND_NO, 
		117 AS SND_TYPE, 
		DBO.FN_STRING_TELNUMBER_FORMAT(B.SMS_SND_NUM) AS SND_NUMBER, 
		B.SND_MSG AS BODY, 
		1 AS SND_RESULT, 
		CASE WHEN ISNULL(B.PHONE_NUM, '') <> '' THEN LEFT(B.PHONE_NUM, 3) ELSE '' END AS RCV_NUMBER1,
		CASE WHEN ISNULL(B.PHONE_NUM, '') <> '' THEN 
			CASE 
				WHEN LEN(B.PHONE_NUM) = 10 THEN SUBSTRING(B.PHONE_NUM, 4, 3)
				WHEN LEN(B.PHONE_NUM) = 11 THEN SUBSTRING(B.PHONE_NUM, 4, 4)
			ELSE '' END 
		ELSE '' END AS RCV_NUMBER2,
		CASE WHEN ISNULL(B.PHONE_NUM, '') <> '' THEN 
			CASE 
				WHEN LEN(B.PHONE_NUM) = 10 THEN SUBSTRING(B.PHONE_NUM, 7, LEN(B.PHONE_NUM)) 
				WHEN LEN(B.PHONE_NUM) = 11 THEN SUBSTRING(B.PHONE_NUM, 8, LEN(B.PHONE_NUM))
			ELSE '' END 
		ELSE '' END AS RCV_NUMBER3,
		CASE WHEN C.CUS_NAME IS NULL THEN '' ELSE C.CUS_NAME END AS RCV_NAME, 
		DBO.XN_COM_GET_EMP_NAME(B.REQ_USR_ID) AS NEW_NAME, 
		REQ_USR_ID AS NEW_CODE,
		CONVERT(DATETIME, STUFF(STUFF(STUFF(REQ_DTM, 9, 0, ' '), 12, 0, ':'), 15, 0, ':')) AS NEW_DATE, 
		0 AS SND_METHOD, 
		CONVERT(DATETIME, STUFF(STUFF(STUFF(SND_DTM, 9, 0, ' '), 12, 0, ':'), 15, 0, ':')) AS SND_DATE, 
		A.RES_CODE, A.CUS_NO  
	FROM SEND.dbo.ALT_SEND_MASTER A WITH(NOLOCK)
	INNER JOIN (
		SELECT * FROM SEND.dbo.MZSENDTRAN A WITH(NOLOCK)
		UNION
		SELECT * FROM SEND.dbo.MZSENDLOG B WITH(NOLOCK)
	) B ON A.SN = B.SN
	LEFT JOIN Diablo.dbo.CUS_CUSTOMER C WITH(NOLOCK) ON A.CUS_NO = C.CUS_NO
	LEFT JOIN Diablo.dbo.RES_MASTER D WITH(NOLOCK) ON A.RES_CODE = D.RES_CODE
	WHERE A.SN IN (
		SELECT SN FROM SEND.dbo.ALT_SEND_MASTER A WITH(NOLOCK) 
		WHERE (
				(ISNULL(@FLAG, '') = 1 AND A.RES_CODE = @CODE) 
					OR (ISNULL(@FLAG, '') = 0 AND A.RES_CODE IN (SELECT RES_CODE FROM RES_MASTER WITH(NOLOCK) WHERE PRO_CODE = @CODE))
		)
	)

	UNION ALL

	SELECT 
		CONVERT(VARCHAR(100), SND_NO) AS SND_NO, SND_TYPE, SND_NUMBER, BODY, SND_RESULT, RCV_NUMBER1, RCV_NUMBER2, RCV_NUMBER3,  
		RCV_NAME, DBO.XN_COM_GET_EMP_NAME(NEW_CODE) AS NEW_NAME, NEW_CODE, NEW_DATE, SND_METHOD, SND_DATE, RES_CODE, CUS_NO
	FROM RES_SND_SMS A WITH(NOLOCK) 
	WHERE (
			(ISNULL(@FLAG, '') = 1 AND A.RES_CODE = @CODE) 
				OR (ISNULL(@FLAG, '') = 0 AND A.RES_CODE IN (SELECT RES_CODE FROM RES_MASTER WITH(NOLOCK) WHERE PRO_CODE = @CODE))
	);

*/

END 
GO
