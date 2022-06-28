USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_SEND_SMS_SELECT
■ DESCRIPTION				: sms 발송내역
■ INPUT PARAMETER			: 
	@EMP_CODE				: 상담사 키
	@SND_DATE_S				: 기간검색 시작일
	@SND_DATE_E				: 기간검색 종료일
	@RCV_NAME				: 고객명
	@RCV_NUMBER			: 고객 전화번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	DECLARE @TOTAL_COUNT INT
	exec SP_CTI_SEND_SMS_SELECT 1,10,'9999999', '2014-01-01','2014-10-21','길동',null,'NEW_DATE','ASC',@TOTAL_COUNT OUTPUT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   NEW_DATE	            RCV_NUMBER		RCV_NAME		SND_NUMBER		TEAM_NAME   KOR_NAME		BODY		SND_RESULT
------------------------------------------------------------------------------------------------------------------
  2014-10-20 10:11:12	010-277-3654	고객명    	     010-000-0000   팀명         상담사명     SMS 내용       성공
================================================================================================================*/ 


CREATE PROCEDURE [cti].[SP_CTI_SEND_SMS_SELECT]
--DECLARE
	@PAGE_INDEX			INT=1,
	@PAGE_SIZE			INT=10,
	@EMP_CODE			VARCHAR(10)='',
	@SND_DATE_S			VARCHAR(10)='',
	@SND_DATE_E			VARCHAR(10)='',
	@RCV_NAME			VARCHAR(100)='',
	@RCV_NUMBER			VARCHAR(10)='',
	@COLS_NAME			VARCHAR(50)='NEW_DATE',
	@SORT				VARCHAR(50)='DESC'	,
	@TOTAL_COUNT INT OUTPUT
AS


SET NOCOUNT ON


	DECLARE @BSQL VARCHAR(8000)
	DECLARE @SQL VARCHAR(8000)
	

	IF @COLS_NAME IS NULL OR @COLS_NAME = ''
		SET @COLS_NAME = 'NEW_DATE'
		
	IF @SORT IS NULL OR @SORT=''
		SET @SORT = 'DESC'
	
	
	

	
	SELECT * INTO #TEMP  FROM
		 ( SELECT 
				
				SMS.NEW_DATE,
				SMS.RCV_NUMBER1 + '-' + SMS.RCV_NUMBER2 + '-' + SMS.RCV_NUMBER3 AS RCV_NUMBER,
				SMS.RCV_NAME,
				SMS.SND_NUMBER,
				TEAM.TEAM_NAME,
				EMP.KOR_NAME,
				SMS.BODY,
				SMS.SND_RESULT
			FROM DIABLO..RES_CUSTOMER AS RES WITH(NOLOCK) 
				INNER JOIN  DIABLO..RES_SND_SMS AS SMS WITH(NOLOCK)  ON RES.RES_CODE = SMS.RES_CODE
				INNER JOIN	DIABLO..EMP_MASTER AS EMP WITH(NOLOCK)  ON RES.NEW_CODE=EMP.EMP_CODE
				INNER JOIN	DIABLO..EMP_TEAM AS TEAM WITH(NOLOCK)  ON TEAM.TEAM_CODE=EMP.TEAM_CODE 
			WHERE EMP.EMP_CODE = @EMP_CODE
				AND (isnull(@SND_DATE_S,'')='' OR SMS.NEW_DATE>=@SND_DATE_S + ' 00:00:00' )
				AND (isnull(@SND_DATE_E,'')='' OR SMS.NEW_DATE<=@SND_DATE_E + ' 23:59:59' )
				AND (isnull(@RCV_NAME,'')='' OR SMS.RCV_NAME like '%'+@RCV_NAME+'%')
				AND (isnull(@RCV_NUMBER,'')='' OR RCV_NUMBER1 + '' + RCV_NUMBER2 + '' + RCV_NUMBER3 =  @RCV_NUMBER  )
			)T1
	

		
		SET @SQL = '
			SELECT  *
			FROM (
				SELECT
					ROW_NUMBER() OVER(ORDER BY  ' + @COLS_NAME + ' ' + @SORT + '  ) AS RNO,
					NEW_DATE,
					RCV_NUMBER,
					RCV_NAME,
					SND_NUMBER,
					TEAM_NAME,
					KOR_NAME,
					BODY,
					SND_RESULT
				FROM #TEMP
				)T1
			WHERE RNO>=' + CONVERT(VARCHAR(100), (( @PAGE_INDEX-1 )*@PAGE_SIZE)+1 ) + '	and RNO<=' + CONVERT(VARCHAR(100), @PAGE_INDEX*@PAGE_SIZE ) + ' 
	'
	EXEC(@SQL)

	SET @TOTAL_COUNT = 0
	SELECT  @TOTAL_COUNT=COUNT(*) FROM #TEMP



		DROP TABLE #TEMP



SET NOCOUNT OFF
GO
