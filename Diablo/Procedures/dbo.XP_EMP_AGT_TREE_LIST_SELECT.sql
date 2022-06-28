USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_EMP_AGT_TREE_LIST_SELECT
■ DESCRIPTION				: 대외업무 사내메일 사내주소록을 위한 대외업체 직원 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_EMP_AGT_TREE_LIST_SELECT '2008011'
	exec XP_EMP_AGT_TREE_LIST_SELECT 'A130001'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-07		김성호			최초생성
   2014-01-14		정지용			SYS_YN = ''Y'' 제거
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_EMP_AGT_TREE_LIST_SELECT]
(
	@EMP_CODE	CHAR(7)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(1000), @PARMDEFINITION NVARCHAR(100), @WHERE NVARCHAR(100);

	IF SUBSTRING(@EMP_CODE,1,1) = 'T'
		BEGIN 
			SET @WHERE = ' AND A.AGT_TYPE_CODE = ''30'''
		END
	ELSE 
		BEGIN
				IF DBO.XN_COM_GET_VGL_YN(@EMP_CODE) = 'N'
					SELECT @WHERE =  ' AND A.AGT_CODE = (SELECT AGT_CODE FROM AGT_MEMBER AA WHERE MEM_CODE = @EMP_CODE)'
				ELSE
					SET @WHERE = ''
		END 


	SET @SQLSTRING = N'
	WITH LIST AS
	(
		SELECT NULL AS [PARENT_CODE], KOR_NAME AS [EMP_NAME], CONVERT(VARCHAR(10), A.AGT_CODE) AS [CODE]
			, (SELECT COUNT(*) FROM AGT_MEMBER AA WHERE AA.AGT_CODE = A.AGT_CODE AND AA.WORK_TYPE = ''1'') AS [EMPLOYEE_COUNT]
			, ''T'' AS [FLAG], A.AGT_TYPE_CODE AS [INFO]
			, ROW_NUMBER() OVER(ORDER BY KOR_NAME ASC) AS [SORT]
		FROM AGT_MASTER A
		WHERE 1=1' + @WHERE + '
	)
	SELECT *
	FROM LIST A
	WHERE EMPLOYEE_COUNT > 0
	
	UNION ALL
	SELECT A.AGT_CODE, A.KOR_NAME, CONVERT(VARCHAR(10), A.MEM_CODE), 0, ''E'', B.KOR_NAME, ''999''
	FROM AGT_MEMBER A
	INNER JOIN AGT_MASTER B ON A.AGT_CODE = B.AGT_CODE
	WHERE WORK_TYPE = ''1'' AND A.AGT_CODE IN (SELECT CODE FROM LIST)
	ORDER BY SORT, EMP_NAME'
	
	SET @PARMDEFINITION = N'@EMP_CODE  CHAR(7)';

	--SELECT @SQLSTRING
	--PRINT @SQLSTRING
			
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @EMP_CODE;

END


GO
