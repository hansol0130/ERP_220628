USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_SMS_SEND_SELECT_LIST
■ DESCRIPTION				: SMS발송내역
■ INPUT PARAMETER			: 
	@PAGE_INDEX				: 페이징 번호
	@PAGE_SIZE				: 페이지 사이즈(ROW 갯수)
	@KEY					: 조회 Parameter
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT			: 총건수
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------

 ------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-20		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ERP_SMS_SEND_SELECT_LIST]
--DECLARE
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@TOTAL_COUNT	INT OUTPUT,
	@KEY			VARCHAR(200)

AS

SET NOCOUNT ON

	DECLARE
		@COLS_NAME			VARCHAR(50)='',
		@SORT				VARCHAR(50)='DESC',
		@SDATE	VARCHAR(10),
		@EDATE	VARCHAR(10),
		@TEAM_CODE	VARCHAR(3),
		@EMP_CODE	VARCHAR(7),
		@CUS_NAME	VARCHAR(20),
		@CUS_TEL	VARCHAR(15),
		@WHERE NVARCHAR(4000),
		@SQL NVARCHAR(4000),
		@BSQL NVARCHAR(4000),
		@PARM NVARCHAR(1000)

	--SET @SDATE = '2014-11-01'
	--SET @EDATE = '2014-11-17'
	--SET @TEAM_CODE = '538'
	--SET @EMP_CODE = '2012010''
	--SET @CUS_NAME = ''
	--SET @CUS_TEL = ''

	SELECT
		@SDATE = Diablo.DBO.FN_PARAM(@KEY, 'SDate'),
		@EDATE = Diablo.DBO.FN_PARAM(@KEY, 'EDate'),
		@TEAM_CODE = Diablo.DBO.FN_PARAM(@KEY, 'Team'),
		@EMP_CODE = Diablo.DBO.FN_PARAM(@KEY, 'Emp'),
		@CUS_NAME = Diablo.DBO.FN_PARAM(@KEY, 'CusName'),
		@CUS_TEL = Diablo.DBO.FN_PARAM(@KEY, 'CusTel');

	SET @WHERE = '';

	IF @COLS_NAME IS NULL OR @COLS_NAME = ''
		SET @COLS_NAME = 'SMS.NEW_DATE'
		
	IF @SORT IS NULL OR @SORT=''
		SET @SORT = 'DESC'

	IF ISNULL(@TEAM_CODE,'') <> ''
	BEGIN
		SET @WHERE += ' AND EMP.TEAM_CODE = ''' + @TEAM_CODE + ''''
	END

	IF ISNULL(@EMP_CODE,'') <> ''
	BEGIN
		SET @WHERE += ' AND SMS.NEW_CODE = ''' + @EMP_CODE + ''''
	END

	IF ISNULL(@CUS_NAME,'') <> ''
	BEGIN
		SET @WHERE += ' AND SMS.RCV_NAME LIKE ''%' + @CUS_NAME + '%'''
	END

	IF ISNULL(@CUS_TEL, '') <> ''
		BEGIN
			IF LEN(@CUS_TEL) = 4
			BEGIN
				SET @WHERE  += ' AND SMS.RCV_NUMBER3 =''' +  @CUS_TEL  + ''''
			END
			ELSE IF LEN(@CUS_TEL) > 4
			BEGIN
				SET @WHERE  += ' AND (SMS.RCV_NUMBER1 + SMS.RCV_NUMBER2 + SMS.RCV_NUMBER3)  =''' +  @CUS_TEL  + ''''
			END
		END


	SET @BSQL = '
		SELECT
			ROW_NUMBER() OVER(ORDER BY SMS.NEW_DATE DESC ) AS RNO,
			SMS.NEW_DATE,
			SMS.RCV_NUMBER1 + SMS.RCV_NUMBER2 + SMS.RCV_NUMBER3 AS RCV_NUMBER,
			SMS.RCV_NAME,
			SMS.SND_NUMBER,
			TEAM.TEAM_NAME,
			EMP.KOR_NAME,
			SMS.BODY,
			SMS.SND_RESULT,
			SMS.NEW_DATE AS SORT_KEY
		FROM	Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK)
		LEFT OUTER JOIN Diablo.dbo.EMP_MASTER EMP WITH(NOLOCK)
		ON SMS.NEW_CODE = EMP.EMP_CODE
		LEFT OUTER JOIN Diablo.dbo.EMP_TEAM TEAM WITH(NOLOCK)
		ON EMP.TEAM_CODE = TEAM.TEAM_CODE
		WHERE	CONVERT(VARCHAR(10),SMS.NEW_DATE,120) BETWEEN ''' + @SDATE + ''' AND ''' + @EDATE + ''' '
		+ @WHERE
	
	EXECUTE(@SQL)

	SET @SQL=''
	SET @SQL = '	
		SELECT 
			NEW_DATE,
			RCV_NUMBER,
			RCV_NAME,
			SND_NUMBER,
			TEAM_NAME,
			KOR_NAME,
			BODY,
			SND_RESULT
		FROM (' + @BSQL + ')T1
		WHERE RNO>=' + CONVERT(VARCHAR(100),(( @PAGE_INDEX-1 )*@PAGE_SIZE)+1) + '	and RNO<=' + CONVERT(VARCHAR(100),@PAGE_INDEX*@PAGE_SIZE)

	EXECUTE(@SQL)

	SET @SQL = 'SELECT @TOTAL_COUNT = COUNT(*) FROM (' + @BSQL + ')T1'

	

	SET @PARM = N'@SDATE VARCHAR(10), @EDATE VARCHAR(10), @TEAM_CODE VARCHAR(3), @EMP_CODE VARCHAR(7), @CUS_NAME VARCHAR(20),@CUS_TEL VARCHAR(15), @TOTAL_COUNT INT OUTPUT'
	EXEC SP_EXECUTESQL @SQL, @PARM, @SDATE, @EDATE, @TEAM_CODE, @EMP_CODE, @CUS_NAME, @CUS_TEL, @TOTAL_COUNT OUTPUT

SET NOCOUNT OFF
GO
