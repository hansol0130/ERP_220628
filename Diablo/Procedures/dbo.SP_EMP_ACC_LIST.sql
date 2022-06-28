USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: SP_EMP_ACC_LIST  
■ Description				: 팀별 계좌관리 조회
■ Input Parameter			:                  
		@TEAM_CODE			: 팀 코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_EMP_ACC_LIST  
■ Author					: 임형민  
■ Date						: 2010-08-26 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2010-08-26       임형민			최초생성  
   2012-03-02		박형만			WITH(NOLOCK) 추가
   2012-08-21		김성호			계좌명 검색 추가
-------------------------------------------------------------------------------------------------*/ 

CREATE PROC [dbo].[SP_EMP_ACC_LIST]
(	
	@TEAM_CODE						CHAR(3),
	@ACC_NAME						VARCHAR(1000)
)

AS

BEGIN

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);

	SET @SQLSTRING = N'
	-- 팀 관리계좌를 조회 한다.
	SELECT ACC_SEQ,
		   ACC_NAME,
		   ACC_HOLDER,
		   BANK_NAME,
		   damo.dbo.dec_varchar(''DIABLO'',''dbo.EMP_TEAM_ACC'',''ACC_NUM'', SEC_ACC_NUM) AS ACC_NUM,
		   SORT_NUM
	FROM DBO.EMP_TEAM_ACC_DAMO  WITH(NOLOCK)
	WHERE ISNULL(DEL_YN, ''N'') = ''N''
	  AND TEAM_CODE = @TEAM_CODE'

	IF @ACC_NAME <> ''
		SET @SQLSTRING = @SQLSTRING + N'
		AND ACC_NAME LIKE ''%'' + @ACC_NAME + ''%'''
		
	SET @SQLSTRING = @SQLSTRING + N'
	ORDER BY SORT_NUM, ACC_NAME, ACC_HOLDER, BANK_NAME'
	
	SET @PARMDEFINITION = N'@TEAM_CODE CHAR(3), @ACC_NAME VARCHAR(1000)';  

		--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @TEAM_CODE, @ACC_NAME;
END
GO
