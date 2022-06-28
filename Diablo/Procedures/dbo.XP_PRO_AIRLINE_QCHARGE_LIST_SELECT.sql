USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PRO_AIRLINE_QCHARGE_LIST_SELECT
■ DESCRIPTION				: 항공사별 유류할증료 리스트 검색
■ INPUT PARAMETER			: 
	@@XML NVARCHAR(MAX)		: SaleProductRQ 클래스의 SerializeXml 문자열
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_PRO_AIRLINE_QCHARGE_LIST_SELECT 'KE', 1, NULL, NULL
	EXEC XP_PRO_AIRLINE_QCHARGE_LIST_SELECT 'KE', 1, '2014-01-21', '2014-02-05'

	exec XP_PRO_AIRLINE_QCHARGE_LIST_SELECT @AIRLINE_CODE=N'KE',@GROUP_SEQ=1,@START_DATE=NULL,@END_DATE=NULL
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-01-21		김성호			최초생성
   2014-01-27		박형만			적용국가, 적용 공항명 표시 
   2014-06-17		박형만			QchargePrice -> Adult,Child,Infant 로 세분화
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_PRO_AIRLINE_QCHARGE_LIST_SELECT]
(
	@AIRLINE_CODE CHAR(2),
	@GROUP_SEQ	INT,
	@START_DATE DATETIME,
	@END_DATE DATETIME
) 
AS 
BEGIN

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(100);

	IF @START_DATE IS NULL
	BEGIN
		SET @WHERE = N'WHERE AA.END_DATE > CONVERT(DATETIME,DATEADD(DD,-1,GETDATE())) '
	END
	ELSE
	BEGIN
		SET @WHERE = N'WHERE AA.START_DATE < @END_DATE AND AA.END_DATE > @START_DATE'
	END


	SET @SQLSTRING = N'

	SELECT A.REGION_NAME, A.AIRLINE_CODE, A.GROUP_SEQ, A.REGION_SEQ, B.QCHARGE_SEQ, B.START_DATE, B.END_DATE, 
		B.ADT_QCHARGE,B.CHD_QCHARGE,B.INF_QCHARGE, B.NEW_CODE, B.NEW_DATE
		, DBO.FN_CUS_GET_EMP_NAME(B.NEW_CODE) AS [NEW_NAME]
		,STUFF(
		(SELECT '','',CAST(BB.KOR_NAME AS VARCHAR) + ''(''+ BB.NATION_CODE +'')'' FROM DBO.FN_SPLIT(NATION_CODES,'','') AA 
			INNER JOIN PUB_NATION BB ON BB.NATION_CODE = AA.DATA FOR XML PATH(''''))
		,1,1,'''')  AS NATION_NAMES ,
		STUFF(
		(SELECT '','',CAST( ISNULL(BB.KOR_NAME,BB.ENG_NAME) AS VARCHAR) + ''(''+ BB.AIRPORT_CODE +'')'' FROM DBO.FN_SPLIT(AIRPORT_CODES,'','') AA 
			INNER JOIN PUB_AIRPORT BB ON BB.AIRPORT_CODE = AA.DATA FOR XML PATH(''''))
		,1,1,'''')  AS AIRPORT_NAMES  
	FROM AIRLINE_REGION A WITH(NOLOCK)
	LEFT JOIN (
		 SELECT *
		 FROM AIRLINE_QCHARGE AA WITH(NOLOCK)
		 ' + @WHERE + '
	) B ON A.AIRLINE_CODE = B.AIRLINE_CODE AND A.GROUP_SEQ = B.GROUP_SEQ AND A.REGION_SEQ = B.REGION_SEQ
	WHERE A.AIRLINE_CODE = @AIRLINE_CODE AND A.GROUP_SEQ = @GROUP_SEQ'

	SET @PARMDEFINITION = N'
		@AIRLINE_CODE CHAR(2),
		@GROUP_SEQ INT,
		@START_DATE DATETIME,
		@END_DATE DATETIME';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@AIRLINE_CODE,
		@GROUP_SEQ,
		@START_DATE,
		@END_DATE;

END 


GO
