USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_PRO_AIRLINE_EXC_QCHARGE_LIST_SELECT
■ DESCRIPTION				: 항공사별 유류할증료 예외 리스트 검색
■ INPUT PARAMETER			: 
	@AIRLINE_CODE CHAR(2)	: 항공사코드
	@START_DATE DATETIME	: 적용시작일
	@END_DATE DATETIME		: 적용종료일
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_PRO_AIRLINE_EXC_QCHARGE_LIST_SELECT 'KE', NULL, NULL
	EXEC XP_PRO_AIRLINE_EXC_QCHARGE_LIST_SELECT 'KE', '2014-01-21', '2014-02-05'


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-01-21		김성호			최초생성 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_PRO_AIRLINE_EXC_QCHARGE_LIST_SELECT]
(
	@AIRLINE_CODE CHAR(2),
	@START_DATE DATETIME,
	@END_DATE DATETIME
) 
AS 
BEGIN

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(100);

	IF @START_DATE IS NULL
	BEGIN
		SET @WHERE = N' AND A.END_DATE > GETDATE()'
	END
	ELSE
	BEGIN
		SET @WHERE = N' AND A.START_DATE < @END_DATE AND A.END_DATE > @START_DATE'
	END


	SET @SQLSTRING = N'
	SELECT A.*, DBO.FN_CUS_GET_EMP_NAME(A.NEW_CODE) AS [NEW_NAME]
	FROM AIRLINE_EXC_QCHARGE A WITH(NOLOCK)
	WHERE A.AIRLINE_CODE = @AIRLINE_CODE' + @WHERE

	SET @PARMDEFINITION = N'
		@AIRLINE_CODE CHAR(2),
		@START_DATE DATETIME,
		@END_DATE DATETIME';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@AIRLINE_CODE,
		@START_DATE,
		@END_DATE;

END 
GO
