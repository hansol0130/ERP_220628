USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_IVR_FIRST_CUSTOMER_SELECT
■ DESCRIPTION				: 고객 최초 전화 시 고객코드와 해당 상담원정보를 검색
							: IVR 사용 SP는 최종 검색 결과에 대한 순서 수정 불가
■ INPUT PARAMETER			: 
	@TEL1					: 전화번호1
	@TEL2					: 전화번호2
	@TEL3					: 전화번호3
■ OUTPUT PARAMETER			: 
■ EXEC						: 

-- 이전
exec cti.SP_IVR_FIRST_CUSTOMER_SELECT_180319  '010','9939','5582', '4000'

-- 적용
exec cti.SP_IVR_FIRST_CUSTOMER_SELECT  '010','2809','0669', '2441'

SOURCE
0 : 우선연결
1 : 고객약속
2 : 고객상담
3 : 예약자
4 : 출발자
5 : VIP
6 : 정회원
7 : 휴면회원
8 : 비회원
9 : 無

SELECT * FROM DIABLO.DBO.EMP_MASTER_DAMO A WITH(NOLOCK) WHERE EMP_CODE = '2017013'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-16		김성호			최초생성
   2014-10-17		김성호			수신번호에 따라 담당자 정책 변경 (직통번호는 번호 담당자로 연결)
   2014-10-24		김성호			상황별 부서 코드 추가
   2014-10-28		김성호			고객과의 약속 정렬 조건 보강
   2014-10-31		김성호			검색 출처 (1: 고객약속, 2: 상담이력, 3: 예약내역, 기타)
   2014-11-12		김성호			CTI 사용자 중에서만 최적의 상담원을 검색하도록 변경
   2014-11-25		김성호			@변수 혼용으로 인한 오류 수정
   2014-12-02		김성호			내선번호 팀 검색 시 ISNULL 일때 545(서비스혁신) DEFAULT 설정
   2015-01-15		김성호			팀 대표번호 수신에 대한 예외 처리
   2015-01-19		김성호			전화번호 구분값 NUMBER_TYPE 추가 (1: 팀, 2: 개인, 3: 대표)
   2015-01-22		김성호			고객약속 우선순위 변경 (고객약속 등록일이 늦을수록 약속일이 빠를수록)
   2015-06-11		김성호			수신번호제한 고객 예외 처리
   2015-09-04		정지용			휴면계정작업으로 인해 회원조회 변경
   2016-05-04		김성호			특별 고객 우선 연결 작업 추가
   2017-02-22		김성호			오류 테스트를 위해 지정번호 무조건 첫 전화로 인식하는 구문 추가
   2018-03-22		김성호			고객상담 유무 체크시 AS콜 팀은 제외, SP 단순화
   2018-12-17		김성호			VIP 우선연결 오류시 디폴트 VIP고객센터로 지정
   2019-01-04		김성호			IT개발팀, 시스템관리팀 패스 로직 적용
   2019-04-16		김남훈			휴대폰 번호 아닌분들 일단 제거, EMP_MASTER 인덱스 적용, 로그 로직 적용
   2019-04-17		김남훈			LOCK 레벨 임시 변경
   2020-04-08		김성호			패스 로직부분 4000번일경우 메인팀으로 설정되도록 처리
   2020-12-09		김성호			고객 등급 위치 변경 (CUS_VIP_HISTRORY)
================================================================================================================*/
CREATE PROCEDURE [cti].[SP_IVR_FIRST_CUSTOMER_SELECT]
(
	@TEL1			VARCHAR(4),
	@TEL2			VARCHAR(4),
	@TEL3			VARCHAR(4),
	@INNER_NUMBER	VARCHAR(4)
)

AS  
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE
		@CUS_NO INT, @CUS_NAME VARCHAR(20), @CUS_COUNT INT, @SOURCE INT, @NUMBER_TYPE VARCHAR(1),
		@EMP_CODE VARCHAR(10), @TEAM_INNER_NUMBER VARCHAR(4), @TEAM_CODE VARCHAR(3),
		@MAIN_NUMBER VARCHAR(4), @MAIN_TEAM VARCHAR(3), @NOW DATETIME;

	-- 팀 대표번호 세팅 (변경시 해당 번호 수정)
	-- NUMBER_TYPE (1: 팀, 2: 개인, 3: 대표)
	SELECT @MAIN_NUMBER = '4000', @MAIN_TEAM = '545', @NUMBER_TYPE = '3', @NOW = GETDATE();

	-- 전화번호 예외처리
	IF (@TEL1 + @TEL2 + @TEL3) IN ('01032536841', '01091852481', '01065701527', '01089368090', '01099395582', '01075716520')
	BEGIN
		
		SELECT TOP 1
			@CUS_NO = ISNULL(B.CUS_NO, 0),
			@CUS_NAME = B.CUS_NAME,
			@CUS_COUNT = 1,
			@EMP_CODE = A.EMP_CODE,
			@TEAM_INNER_NUMBER = ISNULL(A.INNER_NUMBER3, '4680'),
			@TEAM_CODE = (CASE WHEN @INNER_NUMBER = @MAIN_NUMBER THEN @MAIN_TEAM ELSE ISNULL(A.TEAM_CODE, '529') END), 
			--@TEAM_CODE = ISNULL(A.TEAM_CODE, '529'),
			@SOURCE = '9',
			@NUMBER_TYPE = A.NUMBER_TYPE
		FROM (
			SELECT A.EMP_CODE, A.INNER_NUMBER3, A.TEAM_CODE, '2' AS [NUMBER_TYPE]
			FROM Diablo.DBO.EMP_MASTER_damo A WITH(NOLOCK)
			WHERE A.INNER_NUMBER3 = @INNER_NUMBER AND A.WORK_TYPE = 1
			UNION
			SELECT NULL, @INNER_NUMBER, A.TEAM_CODE, '1'
			FROM Diablo.DBO.EMP_TEAM A WITH(NOLOCK) 
			WHERE A.USE_YN = 'Y' AND A.VIEW_YN = 'Y' AND CHARINDEX(@INNER_NUMBER, A.KEY_NUMBER) > 0 
		) A
		CROSS JOIN (
			SELECT TOP 1 AA.CUS_NO, AA.CUS_NAME
			FROM Diablo.DBO.CUS_CUSTOMER_damo AA WITH(NOLOCK)
			WHERE AA.NOR_TEL1 = @TEL1 AND AA.NOR_TEL2 = @TEL2 AND AA.NOR_TEL3 = @TEL3
		) B

	END
	-- VIP 우선연결
	ELSE IF EXISTS(SELECT 1 FROM Diablo.dbo.CUS_SPECIAL A WITH(NOLOCK) WHERE A.NO1 = @TEL1 AND A.NO2 = @TEL2 AND A.NO3 = @TEL3 AND A.USE_YN = 'Y')
	BEGIN
		-- 특별 고객 우선 연결
		SELECT
			@CUS_NO = A.CUS_NO,
			@CUS_NAME = B.CUS_NAME,
			@CUS_COUNT = 1,
			@EMP_CODE = A.CONNECT_CODE,
			@TEAM_INNER_NUMBER = ISNULL(C.INNER_NUMBER3, '4150'),
			@TEAM_CODE = ISNULL(C.TEAM_CODE, '561'),
			@SOURCE = '0',
			@NUMBER_TYPE = '2'	-- 개인
		FROM Diablo.dbo.CUS_SPECIAL A WITH(NOLOCK)
		INNER JOIN Diablo.dbo.CUS_CUSTOMER_damo B WITH(NOLOCK) ON A.CUS_NO = B.CUS_NO
		LEFT JOIN Diablo.dbo.EMP_MASTER_damo C WITH(NOLOCK) ON A.CONNECT_CODE = C.EMP_CODE AND C.WORK_TYPE = 1
		WHERE A.NO1 = @TEL1 AND A.NO2 = @TEL2 AND A.NO3 = @TEL3
	END
	ELSE
	BEGIN
		-- 대상 고객 검색
		DECLARE @CUS_LIST TABLE (CUS_NO INT PRIMARY KEY NONCLUSTERED, CUS_NAME VARCHAR(20), MEMBER_TYPE INT, NEW_DATE DATETIME);

		INSERT INTO @CUS_LIST (CUS_NO, CUS_NAME, MEMBER_TYPE, NEW_DATE)
		SELECT A.CUS_NO, A.CUS_NAME, A.MEMBER_TYPE, A.DATE 
		FROM (
			SELECT A.*, ROW_NUMBER() OVER (PARTITION BY A.CUS_NO ORDER BY A.MEMBER_TYPE, A.DATE DESC) AS [ROWNUMBER]
			FROM (
				SELECT A.CUS_NO, A.CUS_NAME, (CASE WHEN CVH.CUS_GRADE > 0 THEN 5 ELSE 8 END) AS [MEMBER_TYPE], (CASE WHEN A.EDT_DATE IS NULL THEN A.NEW_DATE ELSE A.EDT_DATE END) AS [DATE]
				FROM Diablo.dbo.CUS_CUSTOMER_damo A WITH(NOLOCK)
				LEFT JOIN Diablo.DBO.CUS_VIP_HISTORY CVH WITH(NOLOCK) ON A.CUS_NO = CVH.CUS_NO AND CVH.VIP_YEAR = YEAR(GETDATE())
				WHERE (A.NOR_TEL3 = @TEL3 AND A.NOR_TEL2 = @TEL2 AND A.NOR_TEL1 = @TEL1)
				UNION
				SELECT A.CUS_NO, A.CUS_NAME, (CASE WHEN A.SLEEP_YN = 'N' THEN 6 ELSE 7 END) AS [MEMBER_TYPE], A.NEW_DATE AS [DATE]
				FROM Diablo.dbo.VIEW_MEMBER A WITH(NOLOCK)
				WHERE (A.NOR_TEL3 = @TEL3 AND A.NOR_TEL2 = @TEL2 AND A.NOR_TEL1 = @TEL1)
			) A
		) A
		WHERE A.ROWNUMBER = 1;

		SELECT
			@CUS_NO = A.CUS_NO,
			@CUS_NAME = A.CUS_NAME,
			@CUS_COUNT = (SELECT COUNT(CUS_NO) FROM @CUS_LIST),
			@EMP_CODE = (CASE WHEN C.CODE_TYPE = 'E' THEN C.EMP_CODE ELSE A.EMP_CODE END),
			@TEAM_INNER_NUMBER = (
				CASE
					WHEN C.CODE_TYPE = 'E' THEN @INNER_NUMBER
					WHEN B.INNER_NUMBER3 IS NOT NULL THEN B.INNER_NUMBER3
					WHEN C.CODE_TYPE = 'T' THEN @INNER_NUMBER
					ELSE @MAIN_NUMBER
				END),
			@TEAM_CODE = (
				CASE
					WHEN C.CODE_TYPE = 'E' THEN C.TEAM_CODE
					WHEN A.EMP_CODE IS NOT NULL THEN B.TEAM_CODE
					WHEN C.CODE_TYPE = 'T' THEN C.TEAM_CODE
					-- 예외처리삭제 19.03.18
					--WHEN @INNER_NUMBER = @MAIN_NUMBER THEN @MAIN_TEAM	-- 4000 대표번호는 서비스혁신팀 픽스
					--WHEN @INNER_NUMBER = '4160' THEN '512'				-- 4160 자유여행번호는 유럽자유여행팀 픽스
					ELSE @MAIN_TEAM
				END),
			@SOURCE = A.MEMBER_TYPE,
			@NUMBER_TYPE = (
				CASE
					WHEN C.CODE_TYPE = 'E' THEN '2'
					WHEN A.EMP_CODE IS NOT NULL THEN '2'
					WHEN C.CODE_TYPE = 'T' AND @INNER_NUMBER = @MAIN_NUMBER THEN '3'
					WHEN C.CODE_TYPE = 'T' THEN '1'
					ELSE '1'
				END)
		FROM (
			SELECT TOP 1 A.CUS_NO, A.CUS_NAME, A.EMP_CODE, A.MEMBER_TYPE, A.SEQ
			FROM (
				-- 고객약속
				SELECT A.CUS_NO, 1 AS MEMBER_TYPE, A.CUS_NAME, A.EMP_CODE, ROW_NUMBER() OVER(ORDER BY A.NEW_DATE DESC, A.CONSULT_RES_DATE) AS [SEQ]
				FROM Sirens.cti.CTI_CONSULT_RESERVATION A WITH(NOLOCK) 
				WHERE A.CUS_NO IN (SELECT CUS_NO FROM @CUS_LIST) AND A.CONSULT_SEQ >= (CONVERT(CHAR(8), DATEADD(M, -1, @NOW), 112) + '000000') AND A.CONSULT_RESULT = '1'
				UNION
				-- 고객상담 (AS콜팀은 발신업무 전용으로 상담 연결에서는 배제
				SELECT A.CUS_NO, 2, A.CUS_NAME, A.EMP_CODE, ROW_NUMBER() OVER(ORDER BY A.CONSULT_DATE DESC)
				FROM Sirens.cti.CTI_CONSULT A WITH(NOLOCK) WHERE A.CUS_NO IN (SELECT CUS_NO FROM @CUS_LIST) AND A.CONSULT_SEQ >= (CONVERT(CHAR(8), DATEADD(M, -1, @NOW), 112) + '000000') AND A.TEAM_CODE <> 622
				UNION
				-- 예약유무
				SELECT A.CUS_NO, A.MEMBER_TYPE, A.CUS_NAME, A.NEW_CODE, ROW_NUMBER() OVER(ORDER BY A.DEP_DATE)
				FROM (
					SELECT A.CUS_NO, A.RES_NAME AS [CUS_NAME], (CASE WHEN A.DEP_DATE > @NOW THEN 3 ELSE 4 END) AS [MEMBER_TYPE], A.DEP_DATE, A.NEW_CODE
					FROM Diablo.DBO.RES_MASTER_damo A WITH(NOLOCK)
					WHERE A.RES_STATE < 9 AND A.CUS_NO IN (SELECT CUS_NO FROM @CUS_LIST) AND A.DEP_DATE > @NOW
					UNION
					SELECT B.CUS_NO, B.CUS_NAME, (CASE WHEN A.DEP_DATE > GETDATE() THEN 3 ELSE 4 END) AS [MEMBER_TYPE], A.DEP_DATE, A.NEW_CODE
					FROM Diablo.DBO.RES_MASTER_damo A WITH(NOLOCK)
					INNER JOIN Diablo.DBO.RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
					WHERE A.RES_STATE < 9 AND B.RES_STATE = 0 AND B.CUS_NO IN (SELECT CUS_NO FROM @CUS_LIST) AND A.DEP_DATE > @NOW
				) A
				UNION
				-- 회원정보
				SELECT A.CUS_NO, A.MEMBER_TYPE, A.CUS_NAME, NULL, ROW_NUMBER() OVER(ORDER BY A.MEMBER_TYPE, A.NEW_DATE DESC)	-- 정회원, 가입일 우선
				FROM @CUS_LIST A
				UNION
				SELECT 0, 9, NULL, NULL, NULL
			) A
			LEFT JOIN Diablo.DBO.EMP_MASTER_DAMO B ON A.EMP_CODE = B.EMP_CODE
			WHERE A.EMP_CODE IS NULL OR B.CTI_USE_YN = 'Y'
			ORDER BY A.MEMBER_TYPE, A.SEQ
		) A
		LEFT JOIN Diablo.DBO.EMP_MASTER B WITH(NOLOCK) ON A.EMP_CODE = B.EMP_CODE
		CROSS JOIN (
			SELECT TOP 1 * 
			FROM (
				SELECT TOP 1 'E' AS [CODE_TYPE], A.EMP_CODE, A.TEAM_CODE
				FROM Diablo.dbo.EMP_MASTER A WITH(NOLOCK)
				WHERE A.WORK_TYPE = 1 AND A.INNER_NUMBER3 = @INNER_NUMBER
				ORDER BY A.GROUP_TYPE, A.JOIN_DATE DESC
				UNION ALL
				SELECT TOP 1 'T', NULL, (CASE WHEN @INNER_NUMBER = @MAIN_NUMBER THEN @MAIN_TEAM ELSE A.TEAM_CODE END) 
				FROM Diablo.dbo.EMP_TEAM A WITH(NOLOCK)
				WHERE CHARINDEX(@INNER_NUMBER, A.KEY_NUMBER) > 0 AND A.USE_YN = 'Y' AND A.VIEW_YN = 'Y' AND A.TEAM_TYPE > 0
				UNION ALL
				-- 무조건 행 출력을 위한 디폴트값
				SELECT 'Z', NULL, NULL
			) A
			ORDER BY CODE_TYPE

		) C

	END
	
	-- 고객의 최신예약 정보
	SELECT *
	FROM (
		SELECT
			@EMP_CODE AS [EMP_CODE], @TEAM_INNER_NUMBER AS [INNER_NUMBER], @TEAM_CODE AS [TEAM_CODE], 
			@CUS_NO AS [CUS_NO], @CUS_NAME AS [CUS_NAME], @CUS_COUNT AS [CUS_COUNT], @SOURCE AS [SOURCE], @NUMBER_TYPE AS [NUMBER_TYPE]
	) A
	CROSS JOIN (
		SELECT TOP 1 A.PRO_CODE, A.PRICE_SEQ, A.RES_CODE
		FROM (
			SELECT A.RES_CODE, A.PRICE_SEQ, A.PRO_CODE, A.DEP_DATE
			FROM Diablo.DBO.RES_MASTER_damo A WITH(NOLOCK)
			WHERE A.DEP_DATE > @NOW AND A.RES_STATE <= 7 AND A.CUS_NO = @CUS_NO
			UNION ALL
			SELECT A.RES_CODE, A.PRICE_SEQ, A.PRO_CODE, A.DEP_DATE
			FROM Diablo.DBO.RES_MASTER_damo A WITH(NOLOCK)
			INNER JOIN Diablo.DBO.RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
			WHERE A.DEP_DATE > @NOW AND A.RES_STATE <= 7 AND B.RES_STATE = 0 AND B.CUS_NO = @CUS_NO
			UNION ALL
			-- 무조건 행 출력을 위한 디폴트값
			SELECT NULL, NULL, NULL, '2999-12-31'
		) A
		ORDER BY A.DEP_DATE
	) B

END

GO
