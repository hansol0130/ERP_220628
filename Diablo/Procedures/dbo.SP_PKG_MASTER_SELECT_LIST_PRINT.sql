USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: SP_PKG_MASTER_SELECT_LIST_PRINT
■ Description				: 마스터 출력을 위한 LIST
■ Input Parameter			:                  
		@EMP_CODE			:
		@TEAM_CODE			:
		@MASTER_CODE		:
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_PKG_MASTER_SELECT_LIST_PRINT  
■ Author					:   
■ Date						: 
■ Memo						: 사움님 지시사항으로 상품마스터 행사리뷰를 일괄 출력하기 위한 함수
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
2011-03-09			이규식          최초생성  
2011-04-04			김성호			@MASTER_CODE 마스터코드 복수 처리
2011-05-16			이규식			상무님 지시사항으로 마스터->행사 단위로 변경
-------------------------------------------------------------------------------------------------*/ 

CREATE PROCEDURE [dbo].[SP_PKG_MASTER_SELECT_LIST_PRINT]
(
	@EMP_CODE					VARCHAR(7),
	@TEAM_CODE					VARCHAR(3),
	@MASTER_CODE				VARCHAR(100),
	@START_DATE				VARCHAR(20)
)

AS

	BEGIN
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(1000), @WHERE2 NVARCHAR(1000),@PARMDEFINITION NVARCHAR(1000), @FROM INT, @TO INT;

		SET @WHERE2 = ''
		-- 마스터코드
		IF LEN(ISNULL(@MASTER_CODE, '')) > 10
		BEGIN
			SELECT @MASTER_CODE = '''' + REPLACE(@MASTER_CODE, ',', ''',''') + ''''
			SET @WHERE2 = 'AND A.PRO_CODE IN (' + @MASTER_CODE + ')'
			SET @START_DATE = CONVERT(VARCHAR(10), GETDATE(), 120)
		END
		ELSE IF LEN(ISNULL(@MASTER_CODE, '')) >= 3
		BEGIN
			--SET @SQLSTRING = 'WHERE 1 = 2'
			SET @WHERE2 = 'AND A.PRO_CODE LIKE @MASTER_CODE + ''%'' '
		END
		ELSE
		BEGIN
			---SET @WHERE = ''        ---------------------------------------아래로 변경         
			SET  @WHERE = ' WHERE ' 
		
			-- 담당자코드(없으면 팀 전체, 팀 코드가 없으면 전체)
			IF ISNULL(@EMP_CODE, '') <> ''
				SET @WHERE = @WHERE + ' A.NEW_CODE = @EMP_CODE AND'
			ELSE IF ISNULL(@TEAM_CODE, '') <> ''
				SET @WHERE = @WHERE + ' A.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER  WITH(NOLOCK) WHERE TEAM_CODE = @TEAM_CODE) AND'
			
			IF LEN(@WHERE) > 0
				--SET @SQLSTRING = @SQLSTRING + ' OR (' + SUBSTRING(@WHERE, 1, (LEN(@WHERE) - 4)) + ')'   ---------------------------------------아래로 변경     
				SET  @WHERE =  SUBSTRING(@WHERE, 1, (LEN(@WHERE) - 4))
				
				
		END
		
		
		SET @SQLSTRING = N'
			SELECT A.PRO_CODE AS MASTER_CODE, A.PRO_NAME AS MASTER_NAME, A.PKG_REVIEW
			FROM PKG_DETAIL A WITH(NOLOCK)
			' + CASE WHEN @WHERE2 = '' THEN
					'
					INNER JOIN (
						SELECT MASTER_CODE, 
						(SELECT TOP 1 DEP_DATE FROM PKG_DETAIL Z  WHERE Z.MASTER_CODE = A.MASTER_CODE AND Z.DEP_DATE >= @START_DATE AND Z.SHOW_YN = ''Y'' ORDER BY Z.DEP_DATE) AS DEP_DATE
						FROM PKG_MASTER A
						' + @WHERE + '
					)B ON B.MASTER_CODE = A.MASTER_CODE AND A.DEP_DATE = B.DEP_DATE'
				ELSE ''
				END +			
			' WHERE A.SHOW_YN = ''Y'' ' + @WHERE2 + ' 
			ORDER BY 1
			';
	
		SET @PARMDEFINITION = N'@EMP_CODE VARCHAR(7), @TEAM_CODE VARCHAR(3), @MASTER_CODE VARCHAR(100), @START_DATE VARCHAR(20)';

		--PRINT @SQLSTRING
		EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @EMP_CODE, @TEAM_CODE, @MASTER_CODE, @START_DATE;
	END
	
	
	
GO
