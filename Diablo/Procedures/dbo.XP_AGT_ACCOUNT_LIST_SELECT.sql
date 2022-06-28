USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_AGT_ACCOUNT_LIST_SELECT
■ DESCRIPTION				: 거래처 계좌정보 리스트
■ INPUT PARAMETER			: 
	@AGT_CODE   VARCHAR(10)	: 랜드사코드
	@SHOW_YN	VARCHAR(1)	: 사용유무

■ OUTPUT PARAMETER			: 
   
■ EXEC						: 

	exec XP_AGT_ACCOUNT_LIST_SELECT '11005', 'N'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-06-04		김완기			최초생성
   2014-01-14		김성호			쿼리수정
================================================================================================================*/ 

 CREATE  PROCEDURE [dbo].[XP_AGT_ACCOUNT_LIST_SELECT]
(
	@AGT_CODE		VARCHAR(10),
	@SHOW_YN		VARCHAR(1)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(MAX);

	SET @WHERE = '';

   
	-- WHERE 조건 만들기
	IF ISNULL(@SHOW_YN, '') <> '' 
		SET @WHERE = ' AND A.SHOW_YN = @SHOW_YN'
	ELSE
		SET @WHERE = '';

	SET @SQLSTRING = N'			
	SELECT A.*
	FROM AGT_ACCOUNT A WITH(NOLOCK)
	WHERE A.AGT_CODE = @AGT_CODE ' + @WHERE + '
	ORDER BY A.ACC_SEQ ASC '
			 
	SET @PARMDEFINITION = N'@AGT_CODE VARCHAR(10), @SHOW_YN VARCHAR(1)';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @AGT_CODE, @SHOW_YN;

END

GO
