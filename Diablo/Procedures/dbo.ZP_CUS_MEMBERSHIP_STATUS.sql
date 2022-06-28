USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME									: ZP_CUS_MEMBERSHIP_STATUS
■ DESCRIPTION								: 멤버쉽현황
■ INPUT PARAMETER							: 
	@TYPE									: 타입 1,2,3
	@START_DATE/@END_DATE					: 가입일
■ OUTPUT PARAMETER							: 
■ EXEC										: 

EXEC ZP_CUS_MEMBERSHIP_STATUS '1',' 2021-07-01', '2021-07-02'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2021-07-22		김영민		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_CUS_MEMBERSHIP_STATUS]
(
	@TYPE			CHAR(1),
	@START_DATE		DATETIME = '',
	@END_DATE		DATETIME = ''
)
AS

BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	BEGIN
		IF @TYPE = '1' 
		BEGIN 
			
			SELECT 
			  SUM(F.송출_회원) AS OLDMEMBER, 
			  SUM(F.MALE) AS MALE, 
			  SUM(F.FAMALE) AS FAMALE, 
			  SUM(F.AGE1) AS AGE1, 
			  SUM(F.AGE2) AS AGE2, 
			  SUM(F.AGE3) AS AGE3, 
			  SUM(F.AGE4) AS AGE4, 
			  SUM(F.AGE5) AS AGE5, 
			  SUM(F.AGE6) AS AGE6 
			FROM 
			  (
				SELECT 
				  SUM(PERSON_COUNT) AS 송출_회원, 
				  '' AS MALE, 
				  '' AS FAMALE, 
				  '' AS AGE1, 
				  '' AS AGE2, 
				  '' AS AGE3, 
				  '' AS AGE4, 
				  '' AS AGE5, 
				  '' AS AGE6 
				FROM 
				  (
					SELECT 
					  COUNT(1) AS PERSON_COUNT 
					FROM 
					  RES_CUSTOMER_DAMO RC 
					  INNER JOIN RES_MASTER_DAMO RM ON RC.RES_CODE = RM.RES_CODE 
					  INNER JOIN VIEW_MEMBER VM ON VM.CUS_NO = RC.CUS_NO 
					WHERE 
					  RM.DEP_DATE BETWEEN @START_DATE 
					  AND @END_DATE 
					  AND RM.RES_STATE < 7 
					  AND RC.RES_STATE = 0 
					  AND RC.SALE_PRICE <> 0 
					GROUP BY 
					  DATEDIFF(DD, VM.NEW_DATE, RM.DEP_DATE)
				  ) A 
				UNION ALL 
				SELECT 
				  '' AS 송출_회원, 
				  SUM(CASE WHEN SEX = 'M' THEN GENDER END) AS MALE, 
				  SUM(CASE WHEN SEX = 'F' THEN GENDER END) AS FAMALE, 
				  '' AS AGE1, 
				  '' AS AGE2, 
				  '' AS AGE3, 
				  '' AS AGE4, 
				  '' AS AGE5, 
				  '' AS AGE6 
				FROM 
				  (
					SELECT 
					  ISNULL(RC.GENDER, VM.GENDER) SEX, 
					  COUNT(1) AS GENDER 
					FROM 
					  RES_CUSTOMER_DAMO RC 
					  INNER JOIN RES_MASTER_DAMO RM ON RC.RES_CODE = RM.RES_CODE 
					  INNER JOIN VIEW_MEMBER VM ON VM.CUS_NO = RC.CUS_NO 
					WHERE 
					  RM.DEP_DATE BETWEEN @START_DATE 
					  AND @END_DATE 
					  AND RM.RES_STATE < 7 
					  AND RC.RES_STATE = 0 
					  AND RC.SALE_PRICE <> 0 
					GROUP BY 
					  ISNULL(RC.GENDER, VM.GENDER)
				  ) A 
				UNION ALL 
				  --연령별
				SELECT 
				  '' 송출_회원, 
				  '' AS MALE, 
				  '' AS FAMALE, 
				  AGE1, 
				  AGE2, 
				  AGE3, 
				  AGE4, 
				  AGE5, 
				  AGE6 
				FROM 
				  (
					SELECT 
					  SUM(
						CASE WHEN AGE > 0 
						AND AGE < 20 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE1, 
					  SUM(
						CASE WHEN AGE >= 20 
						AND AGE < 30 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE2, 
					  SUM(
						CASE WHEN AGE >= 30 
						AND AGE < 40 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE3, 
					  SUM(
						CASE WHEN AGE >= 40 
						AND AGE < 50 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE4, 
					  SUM(
						CASE WHEN AGE >= 50 
						AND AGE < 60 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE5, 
					  SUM(
						CASE WHEN AGE >= 60 
						AND AGE < 200 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE6 
					FROM 
					  (
						SELECT 
						  dbo.FN_CUS_GET_AGE_BY_BIRTH(
							ISNULL(RC.BIRTH_DATE, VM.BIRTH_DATE), 
							RM.DEP_DATE
						  ) AS AGE, 
						  COUNT(1) AS PERSON_COUNT 
						FROM 
						  RES_CUSTOMER_DAMO RC 
						  INNER JOIN RES_MASTER_DAMO RM ON RC.RES_CODE = RM.RES_CODE 
						  INNER JOIN VIEW_MEMBER VM ON VM.CUS_NO = RC.CUS_NO 
						WHERE 
						  RM.DEP_DATE BETWEEN @START_DATE 
						  AND @END_DATE 
						  AND RM.RES_STATE < 7 
						  AND RC.RES_STATE = 0 
						  AND RC.SALE_PRICE <> 0 
						GROUP BY 
						  dbo.FN_CUS_GET_AGE_BY_BIRTH(
							ISNULL(RC.BIRTH_DATE, VM.BIRTH_DATE), 
							RM.DEP_DATE
						  )
					  ) A
				  ) B
			  ) F 
		
		END 
		ELSE IF @TYPE = '2' 
		BEGIN 
			
			SELECT 
			  SUM(F.기존회원) - SUM(F.송출회원중_신규회원) AS OLDMEMBER,
			  SUM(F.송출회원중_신규회원) AS NEWMEMBER, 
			  SUM(F.MALE) AS MALE, 
			  SUM(F.FAMALE) AS FAMALE, 
			  SUM(F.AGE1) AS AGE1, 
			  SUM(F.AGE2) AS AGE2, 
			  SUM(F.AGE3) AS AGE3, 
			  SUM(F.AGE4) AS AGE4, 
			  SUM(F.AGE5) AS AGE5, 
			  SUM(F.AGE6) AS AGE6 
			FROM 
			  (
			  	SELECT 
				  SUM(PERSON_COUNT) AS 기존회원,
				  '' AS 송출회원중_신규회원,  
				  '' AS MALE, 
				  '' AS FAMALE, 
				  '' AS AGE1, 
				  '' AS AGE2, 
				  '' AS AGE3, 
				  '' AS AGE4, 
				  '' AS AGE5, 
				  '' AS AGE6 
				FROM 
				  (
					SELECT 
					  COUNT(1) AS PERSON_COUNT 
					FROM 
					  RES_CUSTOMER_DAMO RC 
					  INNER JOIN RES_MASTER_DAMO RM ON RC.RES_CODE = RM.RES_CODE 
					  INNER JOIN VIEW_MEMBER VM ON VM.CUS_NO = RC.CUS_NO 
					WHERE 
					  RM.DEP_DATE BETWEEN @START_DATE 
					  AND @END_DATE 
					  AND RM.RES_STATE < 7 
					  AND RC.RES_STATE = 0 
					  AND RC.SALE_PRICE <> 0 
					GROUP BY 
					  DATEDIFF(DD, VM.NEW_DATE, RM.DEP_DATE)
				  ) A 
				UNION ALL 
				SELECT 
				  '' AS 기존회원,
				  COUNT(1) AS 송출회원중_신규회원, 
				  '' AS MALE, 
				  '' AS FAMALE, 
				  '' AS AGE1, 
				  '' AS AGE2, 
				  '' AS AGE3, 
				  '' AS AGE4, 
				  '' AS AGE5, 
				  '' AS AGE6 
				FROM 
				  RES_CUSTOMER_DAMO RC 
				  INNER JOIN RES_MASTER_DAMO RM ON RC.RES_CODE = RM.RES_CODE 
				  INNER JOIN VIEW_MEMBER VM ON VM.CUS_NO = RC.CUS_NO 
				WHERE 
				  RM.DEP_DATE BETWEEN @START_DATE 
				  AND @END_DATE 
				  AND RM.RES_STATE < 7 
				  AND RC.RES_STATE = 0 
				  AND RC.SALE_PRICE <> 0 
				  AND DATEDIFF(DD, VM.NEW_DATE, RM.DEP_DATE) BETWEEN -30 
				  AND 30 
				UNION ALL 
				SELECT 
				  '' AS 기존회원,
				  '' AS 송출회원중_성별구분, 
				  SUM(CASE WHEN SEX = 'M' THEN GENDER END) AS MALE, 
				  SUM(CASE WHEN SEX = 'F' THEN GENDER END) AS FAMALE, 
				  '' AS AGE1, 
				  '' AS AGE2, 
				  '' AS AGE3, 
				  '' AS AGE4, 
				  '' AS AGE5, 
				  '' AS AGE6 
				FROM 
				  (
					SELECT 
					  ISNULL(RC.GENDER, VM.GENDER) SEX, 
					  COUNT(1) AS GENDER 
					FROM 
					  RES_CUSTOMER_DAMO RC 
					  INNER JOIN RES_MASTER_DAMO RM ON RC.RES_CODE = RM.RES_CODE 
					  INNER JOIN VIEW_MEMBER VM ON VM.CUS_NO = RC.CUS_NO 
					WHERE 
					  RM.DEP_DATE BETWEEN @START_DATE 
					  AND @END_DATE 
					  AND RM.RES_STATE < 7 
					  AND RC.RES_STATE = 0 
					  AND RC.SALE_PRICE <> 0 
					  AND DATEDIFF(DD, VM.NEW_DATE, RM.DEP_DATE) BETWEEN -30 
					  AND 30 
					GROUP BY 
					  ISNULL(RC.GENDER, VM.GENDER)
				  ) A 
				UNION ALL 
				  --연령별
				SELECT 
				  '' AS 기존회원,
				  '' 송출회원중_성별구분, 
				  '' AS MALE, 
				  '' AS FAMALE, 
				  AGE1, 
				  AGE2, 
				  AGE3, 
				  AGE4, 
				  AGE5, 
				  AGE6 
				FROM 
				  (
					SELECT 
					  SUM(
						CASE WHEN AGE > 0 
						AND AGE < 20 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE1, 
					  SUM(
						CASE WHEN AGE >= 20 
						AND AGE < 30 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE2, 
					  SUM(
						CASE WHEN AGE >= 30 
						AND AGE < 40 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE3, 
					  SUM(
						CASE WHEN AGE >= 40 
						AND AGE < 50 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE4, 
					  SUM(
						CASE WHEN AGE >= 50 
						AND AGE < 60 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE5, 
					  SUM(
						CASE WHEN AGE >= 60 
						AND AGE < 200 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE6 
					FROM 
					  (
						SELECT 
						  dbo.FN_CUS_GET_AGE_BY_BIRTH(
							ISNULL(RC.BIRTH_DATE, VM.BIRTH_DATE), 
							RM.DEP_DATE
						  ) AS AGE, 
						  COUNT(1) AS PERSON_COUNT 
						FROM 
						  RES_CUSTOMER_DAMO RC 
						  INNER JOIN RES_MASTER_DAMO RM ON RC.RES_CODE = RM.RES_CODE 
						  INNER JOIN VIEW_MEMBER VM ON VM.CUS_NO = RC.CUS_NO 
						WHERE 
						  RM.DEP_DATE BETWEEN @START_DATE 
						  AND @END_DATE 
						  AND RM.RES_STATE < 7 
						  AND RC.RES_STATE = 0 
						  AND RC.SALE_PRICE <> 0 
						  AND DATEDIFF(DD, VM.NEW_DATE, RM.DEP_DATE) BETWEEN -30 
						  AND 30 
						GROUP BY 
						  dbo.FN_CUS_GET_AGE_BY_BIRTH(
							ISNULL(RC.BIRTH_DATE, VM.BIRTH_DATE), 
							RM.DEP_DATE
						  )
					  ) A
				  ) B
			  ) F 
		  
		END 
		
		ELSE 
			BEGIN 
				
			SELECT 
			  SUM(z.송출인원_비회원) AS NONMEMBER, 
			  SUM(
				z.월별_송출_번호있는_비회원
			  ) AS MONTH_NONMEMBER, 
			  SUM(z.MALE) AS MALE, 
			  SUM(z.FAMALE) AS FAMALE, 
			  SUM(z.NONGENDER) AS NONGENDER, 
			  SUM(Z.AGE1) AS AGE1, 
			  SUM(Z.AGE2) AS AGE2, 
			  SUM(Z.AGE3) AS AGE3, 
			  SUM(Z.AGE4) AS AGE4, 
			  SUM(Z.AGE5) AS AGE5, 
			  SUM(Z.AGE6) AS AGE6, 
			  SUM(Z.TEEN0) AS AGE0 
			FROM 
			  (
				SELECT 
				  count(1) AS 송출인원_비회원, 
				  '' AS 월별_송출_번호있는_비회원, 
				  '' AS MALE, 
				  '' AS FAMALE, 
				  '' AS NONGENDER, 
				  '' AS AGE1, 
				  '' AS AGE2, 
				  '' AS AGE3, 
				  '' AS AGE4, 
				  '' AS AGE5, 
				  '' AS AGE6, 
				  '' AS TEEN0 
				FROM 
				  RES_CUSTOMER_DAMO RC 
				  INNER JOIN RES_MASTER_DAMO RM ON RC.RES_CODE = RM.RES_CODE 
				  LEFT OUTER JOIN VIEW_MEMBER VM ON VM.CUS_NO = RC.CUS_NO 
				WHERE 
				  RM.DEP_DATE BETWEEN @START_DATE 
				  AND @END_DATE 
				  AND RM.RES_STATE < 7 
				  AND RC.RES_STATE = 0 
				  AND RC.SALE_PRICE <> 0 
				  AND VM.CUS_NO IS NULL 
				UNION ALL 
				SELECT 
				  '' AS 송출인원_비회원, 
				  COUNT(*) AS 월별_송출_번호있는_비회원, 
				  '' AS MALE, 
				  '' AS FAMALE, 
				  '' AS NONGENDER, 
				  '' AS AGE1, 
				  '' AS AGE2, 
				  '' AS AGE3, 
				  '' AS AGE4, 
				  '' AS AGE5, 
				  '' AS AGE6, 
				  '' AS TEEN0 
				FROM 
				  RES_CUSTOMER_DAMO RC 
				  INNER JOIN RES_MASTER_DAMO RM ON RC.RES_CODE = RM.RES_CODE 
				  LEFT OUTER JOIN VIEW_MEMBER VM ON VM.CUS_NO = RC.CUS_NO 
				WHERE 
				  RM.DEP_DATE BETWEEN @START_DATE 
				  AND @END_DATE 
				  AND RM.RES_STATE < 7 
				  AND RC.RES_STATE = 0 
				  AND RC.SALE_PRICE <> 0 
				  AND VM.CUS_NO IS NULL 
				  AND LEN(
					RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3
				  ) > 9 
				  AND RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3 not like '0100%' 
				  AND RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3 not like '0101%' 
				UNION ALL 
				SELECT 
				  '' AS 송출인원_비회원, 
				  '' AS 월별_송출_번호있는_비회원, 
				  SUM(CASE WHEN SEX = 'M' THEN GENDER END) AS MALE, 
				  SUM(CASE WHEN SEX = 'F' THEN GENDER END) AS FAMALE, 
				  SUM(CASE WHEN SEX = 'X' THEN GENDER END) AS NONGENDER, 
				  '' AS AGE1, 
				  '' AS AGE2, 
				  '' AS AGE3, 
				  '' AS AGE4, 
				  '' AS AGE5, 
				  '' AS AGE6, 
				  '' AS TEEN0 
				FROM 
				  (
					SELECT 
					  ISNULL(RC.GENDER, 'X') as SEX, 
					  COUNT(1) AS GENDER 
					FROM 
					  RES_CUSTOMER_DAMO RC 
					  INNER JOIN RES_MASTER_DAMO RM ON RC.RES_CODE = RM.RES_CODE 
					  LEFT OUTER JOIN VIEW_MEMBER VM ON VM.CUS_NO = RC.CUS_NO 
					WHERE 
					  RM.DEP_DATE BETWEEN @START_DATE 
					  AND @END_DATE 
					  AND RM.RES_STATE < 7 
					  AND RC.RES_STATE = 0 
					  AND RC.SALE_PRICE <> 0 
					  AND VM.CUS_NO IS NULL 
					  AND VM.CUS_NO IS NULL 
					  AND LEN(
						RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3
					  ) > 9 
					  AND RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3 not like '0100%' 
					  AND RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3 not like '0101%' 
					GROUP BY 
					  RC.GENDER --ORDER BY RC.GENDER DESC
					  ) F 
				UNION ALL 
				SELECT 
				  '' AS 송출인원_비회원, 
				  '' AS 월별_송출_번호있는_비회원, 
				  '' AS MALE, 
				  '' AS FAMALE, 
				  '' AS NONGENDER, 
				  AGE1, 
				  AGE2, 
				  AGE3, 
				  AGE4, 
				  AGE5, 
				  AGE6, 
				  TEEN0 
				FROM 
				  (
					SELECT 
					  SUM(
						CASE WHEN AGE > 0 
						AND AGE < 20 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE1, 
					  SUM(
						CASE WHEN AGE >= 20 
						AND AGE < 30 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE2, 
					  SUM(
						CASE WHEN AGE >= 30 
						AND AGE < 40 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE3, 
					  SUM(
						CASE WHEN AGE >= 40 
						AND AGE < 50 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE4, 
					  SUM(
						CASE WHEN AGE >= 50 
						AND AGE < 60 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE5, 
					  SUM(
						CASE WHEN AGE >= 60 
						AND AGE < 200 THEN PERSON_COUNT ELSE 0 END
					  ) AS AGE6, 
					  SUM(
						CASE WHEN AGE = -1 THEN PERSON_COUNT ELSE 0 END
					  ) AS TEEN0 
					FROM 
					  (
						SELECT 
						  dbo.FN_CUS_GET_AGE_BY_BIRTH(RC.BIRTH_DATE, RM.DEP_DATE) AS AGE, 
						  COUNT(1) AS PERSON_COUNT 
						FROM 
						  RES_CUSTOMER_DAMO RC 
						  INNER JOIN RES_MASTER_DAMO RM ON RC.RES_CODE = RM.RES_CODE 
						  LEFT OUTER JOIN VIEW_MEMBER VM ON VM.CUS_NO = RC.CUS_NO 
						WHERE 
						  RM.DEP_DATE BETWEEN @START_DATE 
						  AND @END_DATE 
						  AND RM.RES_STATE < 7 
						  AND RC.RES_STATE = 0 
						  AND RC.SALE_PRICE <> 0 
						  AND VM.CUS_NO IS NULL 
						  AND LEN(
							RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3
						  ) > 9 
						  AND RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3 not like '0100%' 
						  AND RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3 not like '0101%' 
						GROUP BY 
						  dbo.FN_CUS_GET_AGE_BY_BIRTH(RC.BIRTH_DATE, RM.DEP_DATE)
					  ) A
				  ) B
			  ) Z 
		  
		  END
	
	END

END


GO
