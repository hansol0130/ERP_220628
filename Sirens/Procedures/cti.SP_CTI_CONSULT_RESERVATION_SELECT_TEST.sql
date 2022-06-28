USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_CONSULT_RESERVATION_SELECT_TEST
■ DESCRIPTION				: 고객약속/콜백처리
■ INPUT PARAMETER			: 
	@PAGE_INDEX				: 페이징 번호
	@PAGE_SIZE				: 페이지 사이즈(ROW 갯수)
	@EMP_CODE				: 상담사 키
	@TEAM_CODE				: 팀코드
	@SDATE					: 기간검색 시작일
	@EDATE					: 기간검색 종료일
	@CONSULT_RESULT			: 상담사 결과코드
	@GUBUN					: 고객약속/콜백처리 코드
	@ORDERBY				: 정렬필드명
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_CONSULT_RESERVATION_SELECT 1,20, '', '' , '2014-02-02','2014-06-06','0','A','',''
	exec cti.SP_CTI_CONSULT_RESERVATION_SELECT 1, 10, null, null, '', '', null, null ,'CONSULT_RES_DATE','ASC'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   GUBUN_NAME	CONSULT_RESULT_NAME	NEW_DATE		CUS_TEL		CUS_NAME   EDT_DATE				CONSULT_RES_CONTENT CUS_NO
------------------------------------------------------------------------------------------------------------------
  고객약속				완료	2014-10-20 10:11:12 010-277-3654 고객명   2014-10-20 10:11:12       상담내용		  2142354


 ------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-00		정승원			최초생성
   2014-10-30		곽병삼			고객약속, 콜백 구분 필드, CONSULT_RES_SEQ 필드 조회 추가.
									CONSULT_RES_DATE 기준 조회로 변경.
									약속일,약속일자로 변경, 작성자명 추가.
   2014-11-01		곽병삼			고객명, 고객전화번 쿼리 위치 변경.
================================================================================================================*/ 



CREATE PROCEDURE [cti].[SP_CTI_CONSULT_RESERVATION_SELECT_TEST]

	@PAGE_INDEX			INT=1
	,@PAGE_SIZE			INT=10
	,@EMP_CODE			VARCHAR(10)=''
	,@TEAM_CODE			VARCHAR(10)=''
	,@SDATE				VARCHAR(10)=''
	,@EDATE				VARCHAR(10)=''
	,@CONSULT_RESULT	VARCHAR(10)=''
	,@SEARCH_TYPE		VARCHAR(10)=''
	,@COLS_NAME			VARCHAR(50)='CONSULT_RES_DATE'
	,@SORT				VARCHAR(50)='DESC'
	,@CUS_NAME			VARCHAR(100)=''
	,@CUS_TEL			VARCHAR(15)=''

	
AS

	--SET @CATEGORY = 'CTI000'
	--SET @USE_YN = 'Y'

SET NOCOUNT ON
	
	DECLARE @SQL VARCHAR(8000)
	DECLARE @BSQL VARCHAR(8000)
	DECLARE @WHERE VARCHAR(8000)
	DECLARE @T1_WHERE	VARCHAR(1000)
	SET @WHERE=''
	SET @T1_WHERE = ''
	
	IF @COLS_NAME IS NULL OR @COLS_NAME = ''
		SET @COLS_NAME = 'CONSULT_RES_DATE'
		
	IF @SORT IS NULL OR @SORT=''
		SET @SORT = 'DESC'
		
	IF @CONSULT_RESULT IS NULL OR @CONSULT_RESULT=''
		SET @CONSULT_RESULT = ''
		
	IF @SEARCH_TYPE IS NULL OR @SEARCH_TYPE=''
		SET @SEARCH_TYPE = ''

	IF ISNULL(@CUS_NAME,'')<>'' 
		--SET @WHERE  += ' AND CUS_NAME LIKE ''%' + @CUS_NAME + '%'''
		SET @T1_WHERE =  ' WHERE CUS_NAME LIKE ''%' + @CUS_NAME + '%'''
	
	IF ISNULL(@CUS_TEL, '') <> ''
	BEGIN
		IF LEN(@CUS_TEL) = 4
		BEGIN
			SET @WHERE  += ' AND RIGHT(CUS_TEL,4) =''' +  @CUS_TEL  + ''''
		END
		ELSE IF LEN(@CUS_TEL) > 4
		BEGIN
			SET @WHERE  += ' AND CUS_TEL =''' +  @CUS_TEL  + ''''
		END
	END

	SET @BSQL = '
			SELECT 
				ROW_NUMBER() OVER(ORDER BY ' + @COLS_NAME + ' ' + @SORT + ' ) AS RNO
					,CONSULT_RES_SEQ
					 ,SEARCH_TYPE_NAME
					,CONSULT_RESULT_NAME
					,CONSULT_RES_DATE
					,CUS_TEL
					,CUS_NAME
					,EDT_DATE
					,CONSULT_RES_CONTENT
					,CUS_NO	
					,CONSULT_RESULT	
					,KOR_NAME		
					,' + @COLS_NAME + ' AS SORT_KEY
				
				FROM (SELECT 
					CONSULT_RES_SEQ,
					(SELECT MAIN_NAME  FROM sirens.cti.CTI_CODE_MASTER WITH(NOLOCK) WHERE CATEGORY=''CTI100'' AND MAIN_CODE=''A'' AND USE_YN=''Y'') AS SEARCH_TYPE_NAME
					,(SELECT MAIN_NAME  FROM sirens.cti.CTI_CODE_MASTER WITH(NOLOCK) WHERE CATEGORY=''CTI101'' AND MAIN_CODE=CONRV.CONSULT_RESULT AND USE_YN=''Y'') AS CONSULT_RESULT_NAME
					,CONRV.CONSULT_RES_DATE
					,CONRV.CUS_TEL
					,(SELECT CUS_NAME FROM Diablo.dbo.CUS_CUSTOMER_damo WITH(NOLOCK) WHERE CUS_NO = CONRV.CUS_NO) AS CUS_NAME
					,CASE WHEN CONRV.CONSULT_RESULT <> ''1'' THEN CONRV.EDT_DATE ELSE NULL END EDT_DATE
					,CONRV.CONSULT_RES_CONTENT
					,CONRV.CUS_NO	
					,CONRV.CONSULT_RESULT
					,EMP.KOR_NAME
					
				FROM sirens.cti.CTI_CONSULT_RESERVATION CONRV  WITH(NOLOCK)
					INNER JOIN	DIABLO..EMP_MASTER AS EMP WITH(NOLOCK)  ON CONRV.NEW_CODE=EMP.EMP_CODE 
				WHERE (''' + ISNULL(@EMP_CODE,'') + '''='''' OR CONRV.EMP_CODE =''' + ISNULL(@EMP_CODE,'') + ''')
					AND (''' + ISNULL(@TEAM_CODE,'') + '''='''' OR CONRV.TEAM_CODE=''' + ISNULL(@TEAM_CODE,'') + ''') 
					AND	CONRV.CONSULT_RES_DATE BETWEEN CONVERT(DATETIME,''' + @SDATE + '''+'' 00:00:00.000'') AND CONVERT(DATETIME,''' + @EDATE + '''+'' 23:59:59.997'')
					AND (''' + ISNULL(@CONSULT_RESULT,'') + '''='''' OR CONRV.CONSULT_RESULT=''' + ISNULL(@CONSULT_RESULT,'''') +''' )
					AND (''' + ISNULL(@SEARCH_TYPE,'') + '''='''' OR  ''' + ISNULL(@SEARCH_TYPE,'') + '''=''R'' )'
					+ @WHERE +
				')T1' + @T1_WHERE

					--AND (''' + ISNULL(@SDATE,'') + '''='''' OR CONRV.CONSULT_RES_DATE>=''' + ISNULL(@SDATE,'') + ' 00:00:00'' )
					--AND (''' + ISNULL(@EDATE,'') + '''='''' OR CONRV.CONSULT_RES_DATE<=''' + ISNULL(@EDATE,'') + ' 23:59:59'' )
		/*List*/
	SET @SQL=''
	SET @SQL = '	
		SELECT 
			''R'' AS GUBUN
			,T1.CONSULT_RES_SEQ
			,T1.SEARCH_TYPE_NAME
			,T1.CONSULT_RESULT_NAME
			,T1.CONSULT_RES_DATE
			,T1.CUS_TEL
			,T1.CUS_NAME
			,T1.EDT_DATE
			,T1.CONSULT_RES_CONTENT
			,T1.CUS_NO	
			,T1.CONSULT_RESULT
			,T1.KOR_NAME
			,T1.SORT_KEY
			,ISNULL(B.CUS_GRADE, 0) AS CUS_GRADE
		FROM (' + @BSQL + ')T1
		LEFT JOIN DIABLO..CUS_CUSTOMER B WITH(NOLOCK) ON T1.CUS_NO = B.CUS_NO
		WHERE RNO>=' + CONVERT(VARCHAR(100),(( @PAGE_INDEX-1 )*@PAGE_SIZE)+1) + '	and RNO<=' + CONVERT(VARCHAR(100),@PAGE_INDEX*@PAGE_SIZE) + ' 
	'

	EXECUTE(@SQL)
	
	-- 					AND CONVERT(VARCHAR(10),CONRV.CONSULT_RES_DATE,120) BETWEEN ''' + @SDATE + ''' AND ''' + @EDATE + '''
	
	/*OutPut*/

	SET @SQL = '
		SELECT
			ISNULL(SUM(CASE WHEN CONSULT_RESULT=''0'' THEN 1 ELSE 0 END ),0) AS CONSULT_RESULT0_COUNT
			,ISNULL(SUM(CASE WHEN CONSULT_RESULT=''1'' THEN 1 ELSE 0 END ),0) AS CONSULT_RESULT1_COUNT
			,ISNULL(SUM(CASE WHEN CONSULT_RESULT=''2'' THEN 1 ELSE 0 END ),0) AS CONSULT_RESULT2_COUNT
			,ISNULL(SUM(CASE WHEN CONSULT_RESULT=''3'' THEN 1 ELSE 0 END ),0) AS CONSULT_RESULT3_COUNT
			,COUNT(*) AS TOTAL_COUNT
		FROM (' + @BSQL + ')T1
	'	
	EXEC(@SQL)
	
SET NOCOUNT OFF
GO
