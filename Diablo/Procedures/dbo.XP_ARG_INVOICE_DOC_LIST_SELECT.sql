USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ARG_INVOICE_DOC_LIST_SELECT
■ DESCRIPTION				: 지결서 인보이스 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	DECLARE @COUNT INT
	EXEC DBO.XP_ARG_INVOICE_DOC_LIST_SELECT @COUNT OUTPUT, 'ProductCode=APP5042-130925&EdiCode=1310289799'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-10-26		김완기			최초생성
   2014-01-10		박형만			상태값 추가
   2014-04-09		김성호			스키마 변경으로 수정
   2014-04-24		박형만			정산결재,정산완료 동시에 보이기 
   2014-12-12		정지용			PAR_GRP_SEQ_NO 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_INVOICE_DOC_LIST_SELECT]
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(200)
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);

	DECLARE @PRO_CODE VARCHAR(20)
	DECLARE @EDI_CODE VARCHAR(10)
	DECLARE @ARG_STATUS VARCHAR(10)

	SELECT
		@PRO_CODE = DBO.FN_PARAM(@KEY, 'ProductCode'),
		@EDI_CODE = DBO.FN_PARAM(@KEY, 'EdiCode') , 
		@ARG_STATUS =  DBO.FN_PARAM(@KEY, 'ArgStatus')
		
	SET @WHERE = 'WHERE 1 = 1 '   
	
	IF ISNULL(@PRO_CODE, '') <> ''
		SET @WHERE = @WHERE + ' AND A.PRO_CODE = ''' + @PRO_CODE + ''' '

	IF ISNULL(@EDI_CODE, '') <> ''
		SET @WHERE = @WHERE + ' AND D.EDI_CODE = ''' + @EDI_CODE + ''' '

	IF ISNULL(@ARG_STATUS, '') <> ''
	BEGIN
		--정산결재 요청시 , 정산완료 상태에서도 보이도록 
		IF( @ARG_STATUS  = '9')
		BEGIN
			SET @ARG_STATUS = '9,10' 
		END 
		SET @WHERE = @WHERE + ' AND  B.ARG_STATUS IN (' + @ARG_STATUS + ') '

	END 

	SET @SQLSTRING = N'
		SELECT @TOTAL_COUNT = COUNT(A.ARG_CODE)
		FROM ARG_MASTER A WITH(NOLOCK)
		INNER JOIN ARG_DETAIL B WITH(NOLOCK) ON A.ARG_CODE = B.ARG_CODE
		INNER JOIN ARG_INVOICE C WITH(NOLOCK) ON B.ARG_CODE = C.ARG_CODE AND B.GRP_SEQ_NO = C.GRP_SEQ_NO 
		INNER JOIN SET_LAND_AGENT D WITH(NOLOCK) ON A.PRO_CODE = D.PRO_CODE AND C.LAND_SEQ_NO = D.LAND_SEQ_NO
		' + @WHERE + ';
		
		SELECT
			A.ARG_CODE,
			A.AGT_CODE,
--			A.RES_CODE,
			A.PRO_CODE,
			B.DEP_DATE,
			B.ARR_DATE,
			B.DAY,
			B.NIGHTS,
			(SELECT KOR_NAME FROM AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = A.AGT_CODE) AS AGT_NAME,
			B.GRP_SEQ_NO,
			B.PAR_GRP_SEQ_NO,
			B.TITLE,
			B.ARG_TYPE,
			B.CFM_CODE,
			B.CFM_DATE,
			B.ARG_STATUS,
			B.NEW_CODE,
			B.NEW_DATE,
			C.LAND_SEQ_NO,
			D.CUR_TYPE,
			D.EXC_RATE,
			D.PAY_PRICE,
			D.RES_COUNT
		FROM ARG_MASTER A WITH(NOLOCK) 
		INNER JOIN ARG_DETAIL B WITH(NOLOCK) ON A.ARG_CODE = B.ARG_CODE 
		INNER JOIN ARG_INVOICE C WITH(NOLOCK) ON B.ARG_CODE = C.ARG_CODE AND B.GRP_SEQ_NO = C.GRP_SEQ_NO 
		INNER JOIN SET_LAND_AGENT D WITH(NOLOCK) ON A.PRO_CODE = D.PRO_CODE AND C.LAND_SEQ_NO = D.LAND_SEQ_NO
		' + @WHERE + '
		ORDER BY C.LAND_SEQ_NO';

		PRINT @SQLSTRING
		SET @PARMDEFINITION = N'
			@PRO_CODE VARCHAR(20),
			@EDI_CODE VARCHAR(10),
			@TOTAL_COUNT INT OUTPUT';


		EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
			@PRO_CODE,
			@EDI_CODE,
			@TOTAL_COUNT OUTPUT;
END

GO
