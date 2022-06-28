USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_BREAKREASON_LIST_SELECT
■ DESCRIPTION				: BTMS 거래처 취소 사유 리스트 검색
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@REASON_SEQ				: 사유 순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_COM_BREAKREASON_LIST_SELECT 92756, 0, 0 , ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-01		김성호			최초생성
   2016-06-01		박형만			항공,호텔 분기 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BREAKREASON_LIST_SELECT]
	@AGT_CODE		VARCHAR(10),
	@REASON_SEQ		INT,
	@PRO_TYPE_CODE	CHAR(1),
	@USE_YN			CHAR(1)
AS 
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(1000);

	SELECT @WHERE = 'WHERE A.AGT_CODE = @AGT_CODE'

	IF @REASON_SEQ > 0
	BEGIN
		SELECT @WHERE = @WHERE + ' AND A.REASON_SEQ = @REASON_SEQ'
	END
	
	--항공,호텔 구분값이 올경우 공통도 같이 나오도록 
	IF ISNULL(@PRO_TYPE_CODE,'') <> '' 
	BEGIN
		SELECT @WHERE =  @WHERE + ' AND A.PRO_TYPE IN( @PRO_TYPE_CODE ,''C'') '
	END

	IF LEN(@USE_YN) > 0
	BEGIN
		IF (@USE_YN <> 'A')
		BEGIN
			SELECT @WHERE =  @WHERE + ' AND A.USE_YN = @USE_YN'
		END
	END


	-- 리스트 조회
	SET @SQLSTRING = N'
	SELECT A.AGT_CODE, A.REASON_SEQ, A.PRO_TYPE, (CASE A.PRO_TYPE WHEN ''A'' THEN ''항공'' WHEN''C'' THEN ''공통'' ELSE ''호텔'' END) AS [PRO_TYPE_NAME]
		, A.REASON_REMARK, A.USE_YN, A.NEW_DATE, A.NEW_SEQ
	FROM COM_BREAK_REASON A WITH(NOLOCK)
	' + @WHERE +'
	ORDER BY REASON_SEQ DESC '
	SET @PARMDEFINITION = N'
		@AGT_CODE VARCHAR(10),
		@REASON_SEQ INT,
		@PRO_TYPE_CODE CHAR(1),
		@USE_YN CHAR(1)';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@AGT_CODE,
		@REASON_SEQ,
		@PRO_TYPE_CODE,
		@USE_YN;

END
GO
