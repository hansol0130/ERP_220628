USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_DOC_PARENT_TEAM
■ Description				: 팀장이 지정되어 있는 상급부서 코드를 리턴
■ Input Parameter			:                  
		@TEAM_CODE			: 부서코드
		@EMP_CODE			: 문서작성장 또는 결재자
		@MAX_DUTY_TYPE		: 결재 최종 직책
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

	SELECT DBO.FN_DOC_PARENT_TEAM('611', '       ', '5')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2017-04-03		김성호			최초생성
	2017-04-11		김성호			최종 수신자 직책 조건 추가
	2018-12-11		김성호			팀장 공석 시 예외처리 및 최대 직책 체크 값 수정
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_DOC_PARENT_TEAM]  
(
	@TEAM_CODE		VARCHAR(10),
	@EMP_CODE		VARCHAR(7),
	@MAX_DUTY_TYPE	VARCHAR(10)
)  
RETURNS VARCHAR(10)  
  
AS  

BEGIN

	DECLARE @PARENT_TEAM VARCHAR(10);

	WITH LIST AS
	(
		SELECT A.TEAM_CODE, A.PARENT_CODE, A.TEAM_EMP_CODE, ISNULL(B.DUTY_TYPE, 0) AS [DUTY_TYPE], 1 AS [LEVEL]
		FROM EMP_TEAM A WITH(NOLOCK)
		LEFT JOIN EMP_MASTER_damo B WITH(NOLOCK) ON A.TEAM_EMP_CODE = B.EMP_CODE
		WHERE A.TEAM_CODE = @TEAM_CODE
		UNION ALL
		SELECT A.TEAM_CODE, A.PARENT_CODE, A.TEAM_EMP_CODE, ISNULL(B.DUTY_TYPE, C.DUTY_TYPE), C.LEVEL + 1 AS [LEVEL]
		FROM EMP_TEAM A WITH(NOLOCK)
		INNER JOIN EMP_MASTER_damo B WITH(NOLOCK) ON A.TEAM_EMP_CODE = B.EMP_CODE
		INNER JOIN LIST C ON A.TEAM_CODE = C.PARENT_CODE AND C.DUTY_TYPE <= @MAX_DUTY_TYPE
	)
	, LIST2 AS
	(
		SELECT TOP 1 A.TEAM_CODE, A.PARENT_CODE, A.TEAM_EMP_CODE, A.LEVEL
		FROM LIST A
		WHERE A.TEAM_EMP_CODE <> @EMP_CODE AND A.TEAM_EMP_CODE <> ''
		UNION ALL
		SELECT '', '', '', 999
	)
	SELECT TOP 1 @PARENT_TEAM = A.TEAM_CODE
	FROM LIST2 A
	ORDER BY A.LEVEL;

	RETURN @PARENT_TEAM;
  
END  




GO
