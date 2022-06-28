USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_CONSULT_DAILY_SELECT_LIST
■ DESCRIPTION				: 당일 상담내역 조회 (CS에 적용)
■ INPUT PARAMETER			: 
	@EMP_CODE				: 상담원코드
	@SDATE					: 조회일자
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_CTI_CONSULT_DAILY_SELECT_LIST '2013069' , '2014-12-17'
	SAVE_TYPE CONSULT_SEQ    POINT_YN CONSULT_DATE            CONSULT_TIME                 CUS_TEL              CONSULT_RES_SEQ RES_DATE   RES_TIME      CUS_NO      CUS_NAME
--------- -------------- -------- ----------------------- ---------------------------- -------------------- --------------- ---------- ------------- ----------- --------------------
9         20141217006069 N        2014-12-17 21:33:07.000 21시 33분   00분22초             01054754346          NULL                                     6814087     곽병삼
8         20141217006068 N        2014-12-17 21:32:15.000 21시 32분   00분12초             01054754346          NULL                                     6814087     곽병삼

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------

 ------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-17		곽병삼			최초생성
   2015-01-09		박노민			SAVE TYPE이 0인 내용 표시
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CONSULT_DAILY_SELECT_LIST]
--DECLARE
	@EMP_CODE	VARCHAR(7),
	@SDATE		VARCHAR(10)

AS

--SET @EMP_CODE = '2013069'
--SET @SDATE = '2014-12-17'

SET NOCOUNT ON

	SELECT
		TOP 15
		A.SAVE_TYPE,
		A.CONSULT_SEQ,
		A.POINT_YN,
		A.CONSULT_DATE,
		ISNULL((LEFT(CONVERT(VARCHAR(5),A.CONSULT_DATE,108),2) + '시 ' + RIGHT(CONVERT(VARCHAR(5),A.CONSULT_DATE,108),2) + '분'),'') + '   ' + RIGHT('00' + CONVERT(VARCHAR(2),A.DURATION_TIME/60),2) + '분' + RIGHT('00' + CONVERT(VARCHAR,A.DURATION_TIME%60),2) + '초' AS CONSULT_TIME,
		A.CUS_TEL,
		B.CONSULT_RES_SEQ,
		ISNULL(CONVERT(VARCHAR(10),B.CONSULT_RES_DATE,120),'') AS RES_DATE,
		ISNULL((LEFT(CONVERT(VARCHAR(5),B.CONSULT_RES_DATE,108),2) + '시 ' + RIGHT(CONVERT(VARCHAR(5),B.CONSULT_RES_DATE,108),2) + '분'),'') AS RES_TIME,
		A.CUS_NO,
		ISNULL((SELECT CUS_NAME FROM Diablo.dbo.CUS_CUSTOMER_damo WITH(NOLOCK) WHERE CUS_NO = A.CUS_NO),'') AS CUS_NAME
	FROM sirens.cti.CTI_CONSULT A WITH(NOLOCK)
	LEFT OUTER JOIN sirens.cti.CTI_CONSULT_RESERVATION B WITH(NOLOCK) ON A.CONSULT_SEQ = B.CONSULT_SEQ
	WHERE A.CONSULT_DATE BETWEEN CONVERT(DATETIME,@SDATE+' 00:00:00.000') AND CONVERT(DATETIME, @SDATE+' 23:59:59.997')
	AND A.EMP_CODE = @EMP_CODE
	-- AND A.SAVE_TYPE <> '0'
	ORDER BY A.CONSULT_SEQ DESC

SET NOCOUNT OFF
GO
