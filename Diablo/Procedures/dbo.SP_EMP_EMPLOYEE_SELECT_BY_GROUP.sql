USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*-------------------------------------------------------------------------------------------------
■ USP_Name					: SP_EMP_EMPLOYEE_SELECT_BY_GROUP  
■ Description				: 주소록 그룹별 검색
							: PartTypeEnum { 영업 = 1, 비영업, 임원, 지점, 외부, 기타 = 9 }
■ Exec						: EXEC SP_EMP_EMPLOYEE_SELECT_BY_GROUP  
■ Author					: 김성호
■ Date						: 2011-11-11
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2011-11-11       김성호			최초생성  
   2012-03-02		박형만			WITH(NOLOCK) 추가 	
-------------------------------------------------------------------------------------------------*/ 

CREATE PROC [dbo].[SP_EMP_EMPLOYEE_SELECT_BY_GROUP]
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH LIST AS
	(
		SELECT
			NULL AS [PARENT_CODE]
			, PUB_VALUE AS [EMP_NAME]
			, CONVERT(VARCHAR(7), PUB_CODE) AS [CODE]
			, (
				SELECT COUNT(*) FROM EMP_MASTER_damo WHERE WORK_TYPE = '1' AND DUTY_TYPE = A.PUB_CODE AND GROUP_TYPE IN (1, 2, 3, 4) AND EXISTS(SELECT 1 FROM EMP_TEAM WHERE USE_YN = 'Y' AND VIEW_YN = 'Y' AND TEAM_CODE = EMP_MASTER_damo.TEAM_CODE)
			) AS [EMPLOYEE_COUNT]
			, 'T' AS [FLAG]
			, '' AS [INFO]
			, ('9' + PUB_CODE) AS [SORT]
		FROM COD_PUBLIC A
		WHERE PUB_TYPE = 'EMP.DUTYTYPE' AND PUB_VALUE2 = 'Y'
		UNION ALL
		SELECT NULL, '영업', '10', (SELECT COUNT(*) FROM EMP_MASTER_damo A WHERE A.WORK_TYPE = '1' AND A.GROUP_TYPE = 1), 'T', '', 5
		UNION ALL
		SELECT NULL, '마케팅/WEB', '11', (SELECT COUNT(*) FROM EMP_MASTER_damo A WHERE A.WORK_TYPE = '1' AND A.GROUP_TYPE = 2 AND A.TEAM_CODE IN (518, 538)), 'T', '', 4
		UNION ALL
		SELECT NULL, '관리지원', '12', (SELECT COUNT(*) FROM EMP_MASTER_damo A WHERE A.WORK_TYPE = '1' AND A.GROUP_TYPE = 2 AND A.TEAM_CODE IN (521, 522)), 'T', '', 3
		UNION ALL
		SELECT NULL, '시스템', '13', (SELECT COUNT(*) FROM EMP_MASTER_damo A WHERE A.WORK_TYPE = '1' AND A.GROUP_TYPE = 2 AND A.TEAM_CODE = 529), 'T', '', 2
		UNION ALL
		SELECT NULL, '외부직원', '99', (SELECT COUNT(*) FROM EMP_MASTER_damo A WHERE A.WORK_TYPE = '1' AND A.GROUP_TYPE = 5), 'T', '', 1
	)
	SELECT *
	FROM LIST
	UNION ALL
	SELECT
		A.DUTY_TYPE
		, A.KOR_NAME
		, (CONVERT(VARCHAR(7), A.EMP_CODE)+ '_1') AS [CODE]
		, 0 AS [EMPLOYEE_COUNT]
		, 'E' AS [FLAG]
		, B.TEAM_NAME AS [INFO]
		, '' AS [SORT]
	FROM EMP_MASTER_damo A
	INNER JOIN EMP_TEAM B ON A.TEAM_CODE = B.TEAM_CODE
	WHERE A.WORK_TYPE = '1' AND B.USE_YN = 'Y' AND B.VIEW_YN = 'Y' AND A.GROUP_TYPE IN (1, 2, 3, 4)
	UNION ALL
	SELECT * FROM (
		SELECT (
			CASE
				WHEN A.GROUP_TYPE = 1 THEN '10'
				WHEN A.GROUP_TYPE = 2 AND A.TEAM_CODE IN (518, 538) THEN '11'
				WHEN A.GROUP_TYPE = 2 AND A.TEAM_CODE IN (521, 522) THEN '12'
				WHEN A.GROUP_TYPE = 2 AND A.TEAM_CODE = 529 THEN '13'
				WHEN A.GROUP_TYPE = 5 THEN '99'
			END) AS [DUTY_TYPE]
			, A.KOR_NAME
			, (CONVERT(VARCHAR(7), A.EMP_CODE) + '_2') AS [CODE]
			, 0 AS [EMPLOYEE_COUNT]
			, 'E' AS [FLAG]
			, B.TEAM_NAME AS [INFO]
			, '' AS [SORT]
		FROM EMP_MASTER_damo A
		INNER JOIN EMP_TEAM B ON A.TEAM_CODE = B.TEAM_CODE
		WHERE A.WORK_TYPE = '1' AND B.USE_YN = 'Y' AND B.VIEW_YN = 'Y' AND A.GROUP_TYPE < 9
	) A
	WHERE A.DUTY_TYPE IS NOT NULL
	ORDER BY PARENT_CODE, SORT DESC, EMP_NAME
END

GO
