USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_PREFER_LIST_SELECT
■ DESCRIPTION				: BTMS 거래처 선호/비선호 상품 조회
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@PRE_SEQ				: 출장그룹 순번
■ OUTPUT PARAMETER			: 

	EXEC XP_COM_PREFER_LIST_SELECT '92756', 0

■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-31		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_PREFER_LIST_SELECT]
	@AGT_CODE		VARCHAR(10),
	@PRE_SEQ		INT
AS 
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(1000);

	IF @PRE_SEQ > 0
	BEGIN
		SELECT @WHERE = ' AND A.PRE_SEQ = @PRE_SEQ'
	END
	ELSE
	BEGIN
		SELECT @WHERE = ''
	END

	SET @SQLSTRING = N'
	WITH LIST AS
	(
		SELECT *
		FROM COM_PREFER A WITH(NOLOCK)
		WHERE A.AGT_CODE = @AGT_CODE' + @WHERE + N'
	)
	SELECT A.AGT_CODE, A.PRE_SEQ, A.PRO_TYPE, A.PREFER_YN, A.PRE_CODE, B.KOR_NAME, B.ENG_NAME
	FROM LIST A
	INNER JOIN PUB_AIRLINE B WITH(NOLOCK) ON A.PRE_CODE = B.AIRLINE_CODE
	WHERE A.PRO_TYPE = ''A''
	UNION ALL
	SELECT A.AGT_CODE, A.PRE_SEQ, A.PRO_TYPE, A.PREFER_YN, A.PRE_CODE, B.PUB_VALUE, B.PUB_VALUE2
	FROM LIST A
	INNER JOIN COD_PUBLIC B WITH(NOLOCK) ON B.PUB_TYPE = ''BTMS.HOTEL.CHAIN'' AND A.PRE_CODE = B.PUB_CODE
	WHERE A.PRO_TYPE = ''H'''

	/*
	SELECT * FROM COD_PUBLIC WHERE PUB_TYPE = 'BTMS.HOTEL.CHAIN'
	
	INSERT INTO COD_PUBLIC (PUB_TYPE, PUB_CODE, PUB_VALUE, PUB_VALUE2, USE_YN)
	SELECT 'BTMS.HOTEL.CHAIN', 'HT', '힐튼', 'Hilton', 'Y'
	*/


	SET @PARMDEFINITION = N'
		@AGT_CODE VARCHAR(10),
		@PRE_SEQ INT';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@AGT_CODE,
		@PRE_SEQ;

END

GO
