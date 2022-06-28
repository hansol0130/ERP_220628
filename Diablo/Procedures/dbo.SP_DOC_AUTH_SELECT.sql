USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_DOC_AUTH_SELECT
■ DESCRIPTION				: 전자결재 권한 체크
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec dbo.SP_DOC_AUTH_SELECT '1808076997', '2012041'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2008-04-26		김성호			최초생성
   2012-03-02		김성호			WITH(NOLOCK) 추가
   2015-04-02		김성호			경영지원팀 대기함 한지훈 부장 추가
   2015-04-10		김성호			윤사장님 예외처리(일단 삭제)
   2016-11-03		김성호			환불지결 작성자와 동일팀 문서 권한 부여
   2016-11-30		김성호			공동경비지결 작성자와 동일팀 문서 권한 부여
   2018-01-03		김성호			경영관리결재, 재무결재 중 해당팀 권한 부여
   2018-08-10		김성호			한지훈상무님 요청으로 신지혜, 윤동명 열람 권한 부여
   2019-02-11		김성호			경영관리팀 요청 이종우 상무님 권한 부여 및 정리
   2019-09-03		박형만			기획/시스템담당팀(오운) 관리함 권한 추가
   2019-10-25		박형만			권한추가
   2020-07-13		김성호			권한삭제(신지혜, 박형만), 문서완료 시 작성자와 동일 그룹 연람 가능 기능 삭제(type=6)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_DOC_AUTH_SELECT]
	@EDI_CODE	VARCHAR(10),
	@EMP_CODE	VARCHAR(7)
AS
BEGIN

	DECLARE @QUERY NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @GROUP_CODES NVARCHAR(500) = '';

	WITH GROUP_LIST AS
	(
		SELECT A.GROUP_CODE, A.PARENT_CODE, 0 AS [DEPTH]
		FROM EMP_GROUP_MASTER A WITH(NOLOCK)
		WHERE A.GROUP_CODE LIKE (SELECT (GROUP_CODE + '_') FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = @EMP_CODE)
		UNION ALL
		SELECT A.GROUP_CODE, A.PARENT_CODE, B.[DEPTH] + 1
		FROM EMP_GROUP_MASTER A WITH(NOLOCK)
		INNER JOIN GROUP_LIST B ON A.PARENT_CODE = B.GROUP_CODE
	)
	SELECT @GROUP_CODES = ISNULL((STUFF ((SELECT (', ''' + GROUP_CODE + '''') AS [text()] FROM GROUP_LIST FOR XML PATH('')), 1, 2, '')), '');
	
	IF @GROUP_CODES = ''
	BEGIN
		SET @GROUP_CODES = 'SELECT TEAM_CODE FROM EMP_MASTER_damo AA WITH(NOLOCK) WHERE AA.EMP_CODE = @EMP_CODE';
	END
	ELSE
	BEGIN
		SET @GROUP_CODES = 'SELECT TEAM_CODE FROM EMP_GROUP_DETAIL AA WITH(NOLOCK) WHERE GROUP_CODE IN (' + @GROUP_CODES + ')';
	END

	SET @QUERY = '
		SELECT 1 FROM EDI_APPROVAL A WITH(NOLOCK)														-- 결재자
		WHERE A.EDI_CODE = @EDI_CODE AND A.APP_CODE = @EMP_CODE
		UNION ALL
		SELECT 2 FROM EDI_REFERENCE A WITH(NOLOCK)														-- 참조자
		WHERE A.EDI_CODE = @EDI_CODE AND A.REF_CODE = @EMP_CODE
		UNION ALL
		SELECT 3 FROM EDI_MASTER_DAMO A WITH(NOLOCK)													-- 작성자
		WHERE A.EDI_CODE = @EDI_CODE AND A.NEW_CODE = @EMP_CODE
		UNION ALL
		SELECT 4 FROM EDI_MASTER_DAMO A WITH(NOLOCK)													-- 수신부서
		WHERE A.EDI_CODE = @EDI_CODE AND A.RCV_TEAM_CODE IN (' + @GROUP_CODES + ')
		UNION ALL
		SELECT 5 FROM EDI_MASTER_DAMO A WITH(NOLOCK)													-- 작성자와 동일팀 권한 부여
		INNER JOIN EMP_MASTER_DAMO B WITH(NOLOCK) ON A.NEW_CODE = B.EMP_CODE
		WHERE A.EDI_CODE = @EDI_CODE AND B.TEAM_CODE IN (
			SELECT TEAM_CODE FROM EMP_MASTER_DAMO AA WITH(NOLOCK) WHERE AA.EMP_CODE = @EMP_CODE
		)
		--UNION ALL
		--SELECT 6 FROM EDI_MASTER_DAMO A WITH(NOLOCK)													-- 작성자 상급부서
		--INNER JOIN EMP_MASTER_damo B WITH(NOLOCK) ON A.NEW_CODE = B.EMP_CODE
		--WHERE A.EDI_CODE = @EDI_CODE AND B.TEAM_CODE IN (' + @GROUP_CODES + ')
		UNION ALL
		-- 성호, 규식, 우미, 병철, 윤동명, 이종우
		SELECT 7 WHERE @EMP_CODE IN (''2008011'', ''2007044'', ''2006005'', ''2010003'', ''2016109'', ''2019004'')';

	IF EXISTS(SELECT 1 FROM EDI_MASTER_DAMO WHERE EDI_CODE = @EDI_CODE AND EDI_STATUS = '1')
	BEGIN
		SET @QUERY = @QUERY + '
			UNION ALL
			SELECT 8 FROM EDI_MASTER_DAMO WITH(NOLOCK)													-- 관리팀대기함
			WHERE EDI_CODE = @EDI_CODE AND APP_TYPE = ''3''
			AND EXISTS(
				SELECT * FROM EMP_MASTER_damo WITH(NOLOCK)
				WHERE EMP_CODE = @EMP_CODE AND TEAM_CODE IN (''418'',''421'', ''522'', ''564'', ''570'') AND WORK_TYPE = 1
				--418:기획/시스템(오운),421:경영기획본부,522:경영관리,564:기획,570:시스템관리
				--WHERE EMP_CODE = @EMP_CODE AND TEAM_CODE IN (''411'', ''418'', ''564'', ''522'', ''570'') AND WORK_TYPE = 1
			)	-- 411:한지훈, 418:오운, 564:기획감사, 522:경영관리
			UNION ALL
			SELECT 9 FROM EDI_MASTER_DAMO WITH(NOLOCK)													-- 재무팀대기함
			WHERE EDI_CODE = @EDI_CODE AND APP_TYPE = ''2''
			AND EXISTS(
				SELECT * FROM EMP_MASTER_damo WITH(NOLOCK)
				WHERE EMP_CODE = @EMP_CODE AND TEAM_CODE IN (''421'', ''419'', ''521'') AND WORK_TYPE = 1
			)	-- 421:경영기획본부,419:재무회계/대외협력담당,521:재무회계'
	END


--	PRINT @QUERY;

	SET @PARMDEFINITION = N'@EDI_CODE VARCHAR(10), @EMP_CODE VARCHAR(7)';

	EXEC SP_EXECUTESQL @QUERY, @PARMDEFINITION, @EDI_CODE, @EMP_CODE;


END
GO
