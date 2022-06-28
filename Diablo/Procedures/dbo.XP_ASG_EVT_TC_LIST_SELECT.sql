USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_TC_LIST_SELECT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 배정행사 리스트 검색
■ INPUT PARAMETER			: 
	@PRO_CODE	VARCHAR(20), : 행사코드
	@FLAG		CHAR(1)		 : 1: 미배정, 2: 배정
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_ASG_EVT_TC_LIST_SELECT 'CPP456-130503', '인솔', '1',''
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-25		이상일			최초생성    
   2014-01-17		김성호			미배정인솔자 리스트 수정
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_ASG_EVT_TC_LIST_SELECT]
(
	@PRO_CODE	  VARCHAR(20),
	@ASSIGN_NAME  VARCHAR(50),
	@FLAG		  CHAR(1),
	@TEAM_CODE	VARCHAR(4)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @SORTING VARCHAR(200), @WHERE VARCHAR(1000), @WHERE1 VARCHAR(1000),@SQLSTRING NVARCHAR(4000)
	DECLARE @DEP_DATE DATETIME, @ARR_DATE DATETIME

	SELECT	@DEP_DATE = DEP_DATE , @ARR_DATE = ARR_DATE  FROM PKG_DETAIL  WHERE	PRO_CODE = @PRO_CODE
	
	SET @WHERE = 'AND '''+CONVERT(VARCHAR(10), @DEP_DATE, 121)+''' <= AA.ARR_DATE AND '''+CONVERT(VARCHAR(10), @ARR_DATE, 121)+''' >= AA.DEP_DATE'


	IF @TEAM_CODE != ''
	BEGIN
		SET @WHERE1 = ' AND B.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE = ''' + @TEAM_CODE + ''') '
	END 

SET @SQLSTRING = N'
				WITH LIST AS
				(
					SELECT B.* FROM AGT_MASTER A
					INNER JOIN AGT_MEMBER B ON A.AGT_CODE = B.AGT_CODE
					WHERE AGT_TYPE_CODE = 30 AND B.WORK_TYPE IN (''1'',''2'') 
					'+@WHERE1+'
				)
				SELECT
					a.MEM_CODE, a.KOR_NAME, isnull(a.AGT_GRADE, '''') AS AGT_GRADE,
					a.GENDER, a.BIRTH_DATE,
					a.WORK_TYPE,
					(SELECT ISNULL(COUNT(PRO_CODE),0) FROM PKG_DETAIL WHERE TC_CODE = a.MEM_CODE AND PRO_CODE != '''+@PRO_CODE+''') AS TC_CNT,
					ISNULL((SELECT TOP 1 CONVERT(VARCHAR(10), ARR_DATE, 121) FROM PKG_DETAIL WHERE TC_CODE = a.MEM_CODE AND PRO_CODE != '''+@PRO_CODE+''' ORDER BY ARR_DATE DESC), ''-'') AS TC_LAST_DATE,
					ISNULL((SELECT TOP 1 ISNULL(PRO_CODE, ''-'') FROM PKG_DETAIL WHERE TC_CODE = a.MEM_CODE AND PRO_CODE != '''+@PRO_CODE+''' ORDER BY ARR_DATE DESC), ''-'') AS TC_PRO_CODE,
					''N'' AS TC_ASSIGN_YN
				FROM LIST A
				inner join AGT_MASTER b on a.AGT_CODE = b.AGT_CODE
				LEFT JOIN (
					SELECT TC_CODE 
					FROM PKG_DETAIL AA
					WHERE TC_CODE IN (SELECT MEM_CODE FROM LIST) ' +@WHERE+ ' 
				) c ON A.MEM_CODE = c.TC_CODE
				WHERE c.TC_CODE IS NULL'


 print @SQLSTRING
 EXEC SP_EXECUTESQL @SQLSTRING
END 
GO
