USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_TEST_PROC_L
■ DESCRIPTION				: 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
		EXEC [SP_TEST_PROC_L] @PHONE_NUM = '01065701527'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   201		
================================================================================================================*/ 
CREATE PROC [dbo].[SP_TEST_PROC_L]
	(
 --	@PAGE_INDEX  INT,
	--@PAGE_SIZE  INT
	@PHONE_NUM VARCHAR(20)
) 
AS 
BEGIN
	DECLARE @STR_QUERY NVARCHAR(4000),
		 @STR_PARAMS NVARCHAR(1000),
		 @WHERE1 NVARCHAR(1000) = '',
		 @WHERE2 NVARCHAR(1000) = '',
		 @WHERE3 NVARCHAR(1000) = '',
		 @WHERE4 NVARCHAR(1000) = ''

	IF (ISNULL(@PHONE_NUM, '') <> '')
	BEGIN
		SET @WHERE1 = ' AND A.PHONE_NUM = ''' + @PHONE_NUM + '''';
		SET @WHERE2 = ' AND AA.PHONE_NUM = ''' + @PHONE_NUM + '''';
		SET @WHERE3 = ' AND C.tran_phone = ''' + @PHONE_NUM + '''';
		SET @WHERE4 = ' AND CC.tran_phone = ''' + @PHONE_NUM + '''';
	END
	ELSE
	BEGIN
		SET @WHERE1 = ' AND CONVERT(DATETIME, STUFF(STUFF(STUFF(A.SND_DTM,13,0,'':''),11,0,'':''),9,0,'' '')) >= DATEADD(HOUR, -2, GETDATE())'
		SET @WHERE2 = ' AND CONVERT(DATETIME, STUFF(STUFF(STUFF(AA.SND_DTM,13,0,'':''),11,0,'':''),9,0,'' '')) >= DATEADD(HOUR, -2, GETDATE())'
		SET @WHERE3 = ' AND C.tran_date >= DATEADD(HOUR, -2, GETDATE())'
		SET @WHERE4 = ' AND CC.tran_date >= DATEADD(HOUR, -2, GETDATE())'
	END

SET @STR_QUERY = N'
SELECT DISTINCT TOP 15 TT.TYPE, B.CUS_NAME AS RCV_NAME, TT.PHONE_NUM, TT.SND_DATE, LEFT(SubString(TT.BODY, PatIndex(''%[0-9]%'', TT.BODY), LEN(TT.BODY)),PatIndex(''%[^0-9]%'', SubString(TT.BODY, PatIndex(''%[0-9]%'', TT.BODY),  LEN(TT.BODY)))-1 ) AS BODY, TT.SND_RESULT_MESSAGE, B.REMARK, B.COMP_YN
FROM (
	--알림톡
SELECT ''알림톡'' AS TYPE, PHONE_NUM AS PHONE_NUM, CONVERT(DATETIME, STUFF(STUFF(STUFF(A.SND_DTM,13,0,'':''),11,0,'':''),9,0,'' '')) AS SND_DATE, A.SND_MSG AS BODY, B.RST_INFO AS SND_RESULT_MESSAGE
FROM SEND.dbo.MZSENDLOG A
	INNER JOIN SEND.[dbo].[ALT_RESULT_MESSAGE] B ON A.RSLT_CD = B.RST_CODE
WHERE TMPL_CD = ''SYS_AT_0063''
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
' + @WHERE1 + '
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION ALL
SELECT ''알림톡'' AS TYPE, PHONE_NUM AS PHONE_NUM, CONVERT(DATETIME, STUFF(STUFF(STUFF(AA.SND_DTM,13,0,'':''),11,0,'':''),9,0,'' '')) AS SND_DATE, AA.SND_MSG AS BODY, BB.RST_INFO AS SND_RESULT_MESSAGE
FROM SEND.dbo.MZSENDTRAN AA
	INNER JOIN SEND.[dbo].[ALT_RESULT_MESSAGE] BB ON AA.RSLT_CD = BB.RST_CODE
WHERE TMPL_CD = ''SYS_AT_0063''
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
' + @WHERE2 + '
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION ALL
	--SMS
SELECT ''SMS'' AS TYPE, tran_phone AS PHONE_NUM, C.tran_date AS SND_DATE, C.tran_msg AS BODY, D.RST_INFO AS SND_RESULT_MESSAGE
FROM SEND.dbo.em_log C
	INNER JOIN SEND.[dbo].[ALT_RESULT_MESSAGE] D ON C.tran_rslt = D.RST_CODE
WHERE tran_msg LIKE ''%를 입력해주세요%'' AND tran_msg LIKE ''%인증번호%''
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
' + @WHERE3 + '
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION ALL
SELECT ''SMS'' AS TYPE, tran_phone AS PHONE_NUM, CC.tran_date AS SND_DATE, CC.tran_msg AS BODY, DD.RST_INFO AS SND_RESULT_MESSAGE
FROM SEND.dbo.em_tran CC
	INNER JOIN SEND.[dbo].[ALT_RESULT_MESSAGE] DD ON CC.tran_rslt = DD.RST_CODE
WHERE tran_msg LIKE ''%를 입력해주세요%'' AND tran_msg LIKE ''%인증번호%''
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
' + @WHERE4 + '
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	) AS TT
	LEFT JOIN CUS_PHONE_AUTH B ON TT.PHONE_NUM = B.NOR_TEL1 + B.NOR_TEL2 + B.NOR_TEL3 AND LEFT(SubString(TT.BODY, PatIndex(''%[0-9]%'', TT.BODY), LEN(TT.BODY)),PatIndex(''%[^0-9]%'', SubString(TT.BODY, PatIndex(''%[0-9]%'', TT.BODY),  LEN(TT.BODY))) -1 ) = B.AUTH_NO
ORDER BY SND_DATE DESC
--OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
--ROWS ONLY
'

SET @STR_PARAMS = N'@PHONE_NUM VARCHAR(20)'

EXEC SP_EXECUTESQL @STR_QUERY, @STR_PARAMS, @PHONE_NUM

END 


GO
