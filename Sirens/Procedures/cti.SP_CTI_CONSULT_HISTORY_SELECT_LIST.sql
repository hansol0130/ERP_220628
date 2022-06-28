USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_CONSULT_HISTORY_SELECT_LIST
■ DESCRIPTION				: CTI 상담이력조회
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@@TOTAL_COUNT			: 전체count
	@KEY VARCHAR(100)		: 검색 키
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 상담 내역
■ EXEC						: 

	DECLARE @TOTAL_COUNT INT, @KEY VARCHAR(100)
	SELECT @KEY = N'CusNo=15'
	exec CTI.SP_CTI_CONSULT_HISTORY_SELECT_LIST 1, 50, @TOTAL_COUNT OUTPUT, @KEY
	SELECT @TOTAL_COUNT


	CONSULT_SEQ    CONSULT_TYPE CONSULT_TYPE1 CONSULT_TYPE2 CONSULT_TYPE3 CONSULT_DATE        DURATION_TIME CALL_TIME TEAM_NAME            EMP_NAME             CONSULT_CALL_TYPE CONSULT_CONTENT                                                                                                                                                                                                                                                  POINT_YN CONSULT_FILE_NAME              EDT_DATE            EDT_NAME             EDT_CODE CONSULT_RES_DATE        RES_TEAM_CODE RES_TEAM_NAME        RES_EMP_CODE RES_EMP_NAME         RES_RESULT D_TIME
-------------- ------------ ------------- ------------- ------------- ------------------- ------------- --------- -------------------- -------------------- ----------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -------- ------------------------------ ------------------- -------------------- -------- ----------------------- ------------- -------------------- ------------ -------------------- ---------- -----------
20150122000315 C            0             0             0             2015-01-22 09:37:22 00:00         0         시스템개발                김성호                  S                 상담내용없음                                                                                                                                                                                                                                                           N        NULL                           2015-01-22 11:35:01 김성호                  2008011  NULL                    NULL          NULL                 NULL         NULL                 NULL       11341
20150122000310 C            0             0             0             2015-01-22 09:36:44 00:00         0         시스템개발                김성호                  S                 부재중                                                                                                                                                                                                                                                              N        NULL                           NULL                NULL                 2008011  NULL                    NULL          NULL                 NULL         NULL                 NULL       11341


-----------
104

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-20		곽병삼			최초생성
   2014-10-24		김성호			페이징쿼리 추가
   2014-10-28		곽병삼			SAVE TYPE이 초기저장(1) 은 조회 제외.
   2014-10-29		곽병삼			작업 상담원 코드 추가.
   2014-11-04		정지용			중요상담내역 SORT 조건 추가
   2014-11-11		곽병삼			총통화시간 OUTPUT
   2014-11-24		곽병삼			상담구분 테이블(CTI_CONSULT_TYPE) 내용 추가
   2014-12-17		곽병삼			SAVE TYPE이 0인 내용 제외.
   2015-01-09		박노민			SAVE TYPE이 0인 내용 표시
   2015-02-05		박노민			설명추가
   2018-03-28		정지용			STT_FILE_NAME 추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CONSULT_HISTORY_SELECT_LIST]
--DECLARE
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@TOTAL_COUNT	INT OUTPUT,
	--@D_TIME			INT OUTPUT,
	@KEY			VARCHAR(100)

--SET @CUS_NO = 4284582
AS
SET NOCOUNT ON

	DECLARE @CUS_NO INT;
	DECLARE @POINT_YN CHAR(1);
	DECLARE @D_TIME INT;

	SELECT
		@CUS_NO = Diablo.DBO.FN_PARAM(@KEY, 'CusNo'),
		@POINT_YN = Diablo.DBO.FN_PARAM(@KEY, 'IsPoint');

	SELECT @TOTAL_COUNT = COUNT(*), @D_TIME = SUM(DURATION_TIME)
	FROM sirens.cti.CTI_CONSULT CTI WITH(NOLOCK)
	LEFT JOIN Diablo.DBO.EMP_MASTER EMP WITH(NOLOCK) ON CTI.EDT_CODE = EMP.EMP_CODE
	WHERE CTI.CUS_NO = @CUS_NO;
	-- AND CTI.SAVE_TYPE <> '0';
	
	SELECT
		CTI.CONSULT_SEQ,
		CTI.CONSULT_TYPE,
		(SELECT COUNT(CONSULT_TYPE) FROM CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = 'C') AS CONSULT_TYPE1,
		(SELECT COUNT(CONSULT_TYPE) FROM CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = 'R') AS CONSULT_TYPE2,
		(SELECT COUNT(CONSULT_TYPE) FROM CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = 'P') AS CONSULT_TYPE3,
		CONVERT(VARCHAR(19), CTI.CONSULT_DATE, 120) AS CONSULT_DATE,
		RIGHT('00' + CONVERT(VARCHAR(2),CTI.DURATION_TIME/60),2) + ':' + RIGHT('00' + CONVERT(VARCHAR,CTI.DURATION_TIME%60),2) AS DURATION_TIME,
		CTI.DURATION_TIME AS CALL_TIME,
		CTI.TEAM_NAME,
		--CTI.EMP_NAME,
		(SELECT KOR_NAME FROM Diablo.dbo.EMP_MASTER WHERE EMP_CODE = CTI.EMP_CODE) AS EMP_NAME,
		CTI.CONSULT_CALL_TYPE,
		CTI.CONSULT_CONTENT,
		CTI.POINT_YN,
		RTRIM(CTI.CONSULT_FILE_NAME) AS CONSULT_FILE_NAME,
		RTRIM(CTI.STT_FILE_NAME) AS STT_FILE_NAME,
		CONVERT(VARCHAR(19), CTI.EDT_DATE, 120) AS EDT_DATE,
		EMP.KOR_NAME AS EDT_NAME,
		ISNULL(CTI.EDT_CODE,CTI.NEW_CODE) AS EDT_CODE,
		RES.CONSULT_RES_DATE,
		RES.TEAM_CODE AS RES_TEAM_CODE,
		RES.TEAM_NAME AS RES_TEAM_NAME,
		RES.EMP_CODE AS RES_EMP_CODE,
		RES.EMP_NAME AS RES_EMP_NAME,
		RES.CONSULT_RESULT AS RES_RESULT,
		@D_TIME AS D_TIME
	FROM sirens.cti.CTI_CONSULT CTI WITH(NOLOCK)
	LEFT OUTER JOIN sirens.cti.CTI_CONSULT_RESERVATION RES WITH(NOLOCK)
	ON CTI.CONSULT_SEQ = RES.CONSULT_SEQ
	LEFT JOIN Diablo.DBO.EMP_MASTER EMP WITH(NOLOCK) ON CTI.EDT_CODE = EMP.EMP_CODE
	WHERE CTI.CUS_NO = @CUS_NO
	-- AND CTI.SAVE_TYPE <> '0'
	ORDER BY --CTI.CONSULT_DATE DESC
		CASE WHEN @POINT_YN = 'Y' THEN POINT_YN ELSE CONVERT(VARCHAR(19), CTI.CONSULT_DATE, 20) END DESC, CTI.CONSULT_DATE DESC
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY;

SET NOCOUNT OFF
GO
