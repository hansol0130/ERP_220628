USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PPT_MASTER_LIST_SELECT
■ DESCRIPTION				: 여권사본 수신함 LIST
■ INPUT PARAMETER			: 
	@MASTER_CODE_STRING		: 마스터 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2016-05-01   		김낙겸			최초 생성 
2019-02-18          김남훈          수신함에 필요없는 카운팅 제거 및 속도개선
2020-01-06          박형만	        수신일 종료일에 +1일 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_PPT_MASTER_LIST_SELECT]
	@FLAG			char(1),
	@PAGE_SIZE		INT,
	@PAGE_INDEX		INT,	
	@RES_CODE		char(12),
	@PRO_CODE		varchar(20),
	@CUS_NAME		varchar(20),
	@NOR_TEL1		varchar(6),
	@NOR_TEL2		varchar(5),
	@NOR_TEL3		varchar(4),
	@SALE_EMP_CODE	char(7),
	@SALE_TEAM_CODE varchar(3),
	@START_DATE		VARCHAR(12),
	@END_DATE		VARCHAR(12)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SQLSTRING_1 NVARCHAR(4000),	@FROM INT,	@TO INT;
	SET @SQLSTRING = '';
	SET @SQLSTRING_1 = '';
	

	SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;
	SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;

	IF (@RES_CODE <> '')
	BEGIN
		SET @SQLSTRING = @SQLSTRING + '
				AND A.RES_CODE = @RES_CODE';
	END
	IF (@PRO_CODE <> '')
	BEGIN
		SET @SQLSTRING = @SQLSTRING + '
				AND A.PRO_CODE = @PRO_CODE';
	END					
	IF (@CUS_NAME <> '')
	BEGIN
		SET @SQLSTRING = @SQLSTRING + '
				AND A.CUS_NAME LIKE ''%'' + @CUS_NAME + ''%'''
	END
	IF(@NOR_TEL1 <> '' AND @NOR_TEL1 IS NOT NULL)
	BEGIN
		SET @SQLSTRING = @SQLSTRING + ' 
				AND A.NOR_TEL1 = @NOR_TEL1';
	END
	IF(@NOR_TEL2 <> '' AND @NOR_TEL2 IS NOT NULL)
	BEGIN
			SET @SQLSTRING = @SQLSTRING + ' 
					AND A.NOR_TEL2 = @NOR_TEL2';
	END
	IF(@NOR_TEL3 <> '' AND @NOR_TEL3 IS NOT NULL)
	BEGIN
			SET @SQLSTRING = @SQLSTRING + ' 
					AND A.NOR_TEL3 = @NOR_TEL3';
	END
	IF(@START_DATE <> '' AND @START_DATE IS NOT NULL)
	BEGIN
		SET @SQLSTRING = @SQLSTRING + ' AND A.NEW_DATE >= CONVERT(DATETIME,@START_DATE)'; 
	END 
	IF(@END_DATE <> '' AND @END_DATE IS NOT NULL)
	BEGIN
		SET @SQLSTRING = @SQLSTRING + ' AND A.NEW_DATE < DATEADD(DD,1,CONVERT(DATETIME,@END_DATE))'; 
	END			
	IF (@SALE_EMP_CODE <> '')
	BEGIN
		SET @SQLSTRING = @SQLSTRING + '
				AND A.SALE_EMP_CODE = @SALE_EMP_CODE';
	END	
	IF (@SALE_TEAM_CODE <> '')
	BEGIN
		SET @SQLSTRING = @SQLSTRING + '
				AND A.SALE_TEAM_CODE = @SALE_TEAM_CODE';
	END	

	-- 검색된 데이타의 카운트를 돌려준다.
	IF @FLAG = 'C'
	BEGIN
		SET @SQLSTRING = N'
	SELECT COUNT(*) AS COUNT
	FROM
	(
		SELECT *,ROW_NUMBER()OVER(ORDER BY NEW_DATE DESC)AS NUM
		FROM
		(
			SELECT A.RES_CODE,A.PASS_STATUS,A.CUS_NAME,A.NOR_TEL1,A.NOR_TEL2,A.NOR_TEL3,A.PRO_CODE,A.PRO_NAME,A.NEW_DATE,A.NEW_TEAM_CODE AS SALE_TEAM_CODE,A.NEW_CODE AS SALE_EMP_CODE,A.CUS_NO
			FROM
			(
				SELECT A.RES_CODE,A.PASS_STATUS,A.CUS_NAME,A.NOR_TEL1,A.NOR_TEL2,A.NOR_TEL3,A.PRO_CODE,A.PRO_NAME,A.NEW_DATE,A.NEW_TEAM_CODE,A.NEW_CODE,A.CUS_NO
				FROM
				(
					SELECT 
					PM.RES_CODE,
					CC.CUS_NAME,
					CC.NOR_TEL1,
					CC.NOR_TEL2,
					CC.NOR_TEL3,
					RM.PRO_CODE,
					RM.PRO_NAME,
					PM.NEW_DATE,
					PM.PASS_STATUS,
					RM.NEW_TEAM_CODE,
					RM.NEW_CODE,
					CC.CUS_NO
					,RANK() OVER(PARTITION BY PM.RES_CODE ORDER BY PM.NEW_DATE DESC) AS RANKING
					FROM PPT_MASTER PM WITH(NOLOCK) ,
					CUS_CUSTOMER_DAMO CC WITH(NOLOCK) ,
					RES_MASTER_DAMO RM WITH(NOLOCK)
					WHERE PM.CUS_NO = CC.CUS_NO AND PM.RES_CODE = RM.RES_CODE
					AND RM.RES_STATE < 7
					AND PM.NEW_DATE >= CONVERT(DATETIME,@START_DATE)
					AND PM.NEW_DATE < DATEADD(DD,1,CONVERT(DATETIME,@END_DATE))
				) A
				WHERE A.RANKING =1 
			) A
		)A
	)A		
	WHERE 1 = 1
					' + @SQLSTRING;
	END
	-- 검색된 데이타의 리스트를 돌려준다.
	ELSE IF @FLAG = 'L'
	BEGIN
		SET @SQLSTRING = N'
	SELECT *
	FROM
	(
			SELECT *,ROW_NUMBER()OVER(ORDER BY PASS_STATUS, NEW_DATE DESC)AS NUM
			FROM
			(
				SELECT *
				FROM
				(
					SELECT PM.RES_CODE,
					CC.CUS_NAME,
					CC.NOR_TEL1,
					CC.NOR_TEL2,
					CC.NOR_TEL3,
					RM.PRO_CODE,
					RM.PRO_NAME,
					PM.NEW_DATE,
					PM.PASS_STATUS,
					CC.CUS_NO,
					PM.PPT_NO,
					PM.CUS_YN,
					RM.NEW_TEAM_CODE AS SALE_TEAM_CODE,
					RM.NEW_CODE  AS SALE_EMP_CODE
					,RANK() OVER(PARTITION BY PM.RES_CODE ORDER BY PM.NEW_DATE DESC) AS RANKING
					,(SELECT CUS_NAME FROM RES_CUSTOMER_DAMO WITH(NOLOCK) WHERE SEQ_NO = PM.RES_NO AND RES_CODE = PM.RES_CODE) AS CUS_NAME_BAL
					FROM PPT_MASTER PM WITH(NOLOCK) ,
					CUS_CUSTOMER_DAMO CC WITH(NOLOCK) ,
					RES_MASTER_DAMO RM WITH(NOLOCK)
					WHERE PM.CUS_NO = CC.CUS_NO AND PM.RES_CODE = RM.RES_CODE
					AND RM.RES_STATE < 7
					AND PM.NEW_DATE >= CONVERT(DATETIME,@START_DATE)
					AND PM.NEW_DATE < DATEADD(DD,1,CONVERT(DATETIME,@END_DATE))
				) A
				WHERE A.RANKING =1
			) A
		WHERE 1 = 1
		' + @SQLSTRING + ' 
	)A								 
	WHERE A.NUM BETWEEN @FROM AND @TO';
	END
	SET @PARMDEFINITION=N'@FROM INT, @TO INT, @RES_CODE CHAR(12), @PRO_CODE VARCHAR(20), @CUS_NAME VARCHAR(20), @NOR_TEL1 VARCHAR(6), @NOR_TEL2 VARCHAR(5), @NOR_TEL3 VARCHAR(4), @SALE_EMP_CODE CHAR(7), @SALE_TEAM_CODE VARCHAR(3),@START_DATE VARCHAR(12),@END_DATE VARCHAR(12) ';
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @FROM, @TO, @RES_CODE, @PRO_CODE, @CUS_NAME, @NOR_TEL1, @NOR_TEL2, @NOR_TEL3, @SALE_EMP_CODE, @SALE_TEAM_CODE, @START_DATE, @END_DATE;
END
GO
