USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_CUS_MERGE_TARGET_BATCH_SELECT
■ DESCRIPTION				: 고객정보 매핑 통합 대상 배치 처리 대상 목록 조회 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
XP_CUS_MERGE_TARGET_BATCH_INSERT '2017-08-31',1
XP_CUS_MERGE_TARGET_BATCH_INSERT '2017-08-01',0 ,'RP1706149785'
XP_CUS_MERGE_TARGET_BATCH_INSERT '2017-08-01',0,'RP1705185821'




exec XP_CUS_MERGE_LIST_SELECT @CUS_ID=NULL,@CUS_NAME='',@CUS_BIRTH='',@CUS_TEL='--',@CUS_EMAIL=NULL,@PASS_NUM=NULL,@CUS_NO='9833882,9840605'
인솔자 

XP_CUS_MERGE_TARGET_BATCH_SELECT '2017-08-01',0,-1,'RP1705228575'

XP_CUS_MERGE_TARGET_BATCH_SELECT '2017-08-01',0,-1,'RP1705185821'


XP_CUS_MERGE_TARGET_BATCH_SELECT '2017-08-01',0 , 1, 'RP1705185821'
XP_CUS_MERGE_TARGET_BATCH_SELECT '2017-08-01',0 , -1, 'RP1705185821'

XP_CUS_MERGE_TARGET_BATCH_SELECT '2017-09-01',0,-1,'RP1708082965'

XP_CUS_MERGE_TARGET_BATCH_SELECT '2017-08-01',0,-1,'RP1707173107'
XP_CUS_MERGE_TARGET_BATCH_SELECT '2017-09-01',0 , -1,'RP1708170858'

XP_CUS_MERGE_TARGET_BATCH_SELECT '2017-09-01',0 , 1 'RP1703092095'  -- 예약자 있지만 정보 꼬임 

XP_CUS_MERGE_TARGET_BATCH_SELECT '2017-09-01',0 ,'RP1703092095'  -- 예약자 있지만 정보 꼬임 
XP_CUS_MERGE_TARGET_BATCH_SELECT '2017-09-01',0 ,'RP1706260899'  -- 출발자만 있음 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2018-05-17		박형만			최초생성 
	2018-07-04		박형만			기간검색
	2018-08-23		김성호			WITH(NOLOCK) 옵션 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_CUS_MERGE_TARGET_BATCH_SELECT] 
	@DEP_SDATE DATETIME,
	@DEP_EDATE DATETIME,
	@CUS_TYPE INT  , 
	@STATUS INT =0 ,-- ,  0 미처리,1 처리완료
	@RES_CODE RES_CODE = NULL 
AS 
BEGIN 

	DECLARE @SQLSTRING NVARCHAR(MAX),@PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(MAX)
	
	SELECT @WHERE = '' 

	IF ISNULL(@RES_CODE,'') <> ''
	BEGIN
		SET @WHERE  = @WHERE + ' AND A.RES_CODE = @RES_CODE  ' 
	END 
	ELSE 
	BEGIN
		SET @WHERE  = @WHERE +  ' AND A.DEP_DATE >= @DEP_SDATE  ' 
		SET @WHERE  = @WHERE +  ' AND A.DEP_DATE < DATEADD(dd,1, @DEP_EDATE ) ' 
	END 

	IF @CUS_TYPE > 0 
	BEGIN
		SET @WHERE  = @WHERE +  (CASE WHEN  @CUS_TYPE = 1  THEN ' AND A.SEQ_NO > 0 ' 
									WHEN  @CUS_TYPE = 2  THEN ' AND A.SEQ_NO = 0 '  ELSE '' END )
	END 

	IF(@STATUS > -1 )
	BEGIN
		SET @WHERE  = @WHERE+ ' AND A.STATUS = @STATUS  ' 
	END 
	 
	 SET @SQLSTRING = N'
SELECT A.ROW_SEQ, B.PRO_CODE, A.RES_CODE , A.SEQ_NO , A.DEP_DATE, A.OLD_CUS_NO , A.TARGET_CUS_NO , A.TARGET_CNT , A.NEW_CUS_NO ,
CASE WHEN C.CUS_NAME IS NOT NULL AND A.SEq_NO > 0    AND (SELECT TOP 1 RES_NAME FROM RES_MASTER_DAMO  WITH(NOLOCK)
		WHERE RES_CODE = B.RES_CODE AND RES_NAME = C.CUS_NAME ) = C.CUS_NAME 
		THEN ''Y'' ELSE ''N'' END AS IS_MASTER,
(CASE WHEN C.CUS_NAME IS NULL THEN B.RES_NAME ELSE C.CUS_NAME END ) AS CUS_NAME , 
(CASE WHEN C.CUS_NAME IS NULL THEN B.BIRTH_DATE ELSE C.BIRTH_DATE END ) AS BIRTH_DATE , 
(CASE WHEN C.CUS_NAME IS NULL THEN B.GENDER ELSE C.GENDER END ) AS GENDER , 
(CASE WHEN C.CUS_NAME IS NULL THEN B.NOR_TEL1 ELSE C.NOR_TEL1 END ) AS NOR_TEL1 , 
(CASE WHEN C.CUS_NAME IS NULL THEN B.NOR_TEL2 ELSE C.NOR_TEL2 END ) AS NOR_TEL2 , 
(CASE WHEN C.CUS_NAME IS NULL THEN B.NOR_TEL3 ELSE C.NOR_TEL3 END ) AS NOR_TEL3  ,
damo.dbo.dec_varchar(''DIABLO'', ''dbo.RES_CUSTOMER'', ''PASS_NUM'', C.SEC_PASS_NUM) AS PASS_NUM,C.FIRST_NAME ,C.LAST_NAME ,
(CASE WHEN C.CUS_NAME IS NULL THEN B.RES_EMAIL ELSE C.EMAIL END ) AS EMAIL  ,
A.TARGET_TYPE,A.CHK_TYPE,A.CHK_TEXT,A.STATUS,A.NEW_DATE,A.EXEC_CODE,A.EXEC_DATE,A.MERGE_INFO,A.COMP_YN,A.REMARK
FROM CUS_CLEAR_TARGET A	 WITH(NOLOCK)
	INNER JOIN RES_MASTER_DAMO B  WITH(NOLOCK)
		ON A.RES_CODE = B.RES_CODE 
	LEFT JOIN RES_CUSTOMER_DAMO C WITH(NOLOCK)
		ON A.RES_CODE = C.RES_CODE 
		AND A.SEQ_NO = C.SEQ_NO 
WHERE  1=1
' + @WHERE +N'
ORDER BY A.DEP_DATE , B.PRO_CODE,B.RES_CODE,C.SEq_NO, A.ROW_SEQ '

	
	SET @PARMDEFINITION = N'
		@DEP_SDATE DATETIME,
		@DEP_EDATE DATETIME,
		@STATUS INT,
		@RES_CODE VARCHAR(12) '


	--PRINT @SQLSTRING
	--SELECT LEN(@SQLSTRING)

	EXEC SP_EXECUTESQL @SQLSTRING  , @PARMDEFINITION,
		@DEP_SDATE,
		@DEP_EDATE,
		@STATUS,
		@RES_CODE




END 









GO
