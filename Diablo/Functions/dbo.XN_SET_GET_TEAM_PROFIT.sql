USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_SET_GET_TEAM_PROFIT
■ Description				: 팀 기간 별 수익률 검색
■ Input Parameter			:                  
	@START_DATE				: 검색 시작일
	@END_DATE				: 검색 종료일
	@TEAM_CODE				: 팀 코드
■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 

	SELECT * FROM DBO.XN_SET_GET_TEAM_PROFIT('2015-01-01', '2015-01-31', '501')
	
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2015-02-06		김성호			최초생성
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_SET_GET_TEAM_PROFIT]
(
	@START_DATE DATE,
	@END_DATE	DATE,
	@TEAM_CODE	VARCHAR(3)
)
RETURNS TABLE
AS
RETURN
(
	WITH LIST AS 
	(
		SELECT
			A.PRO_CODE, A.SALE_PRICE,
			(A.PERSON_ETC_PRICE + A.AGENT_COM_PRICE + A.PAY_COM_PRICE) AS [기타경비],
			(A.AIR_PRICE + A.LAND_PRICE + A.PERSON_PRICE + A.GROUP_PRICE + A.AIR_PROFIT + A.AIR_ETC_PRICE + (A.PERSON_ETC_PRICE + A.AGENT_COM_PRICE + A.PAY_COM_PRICE)) AS [총지출금],
			(A.SALE_PRICE - (A.AIR_PRICE + A.LAND_PRICE + A.PERSON_PRICE + A.GROUP_PRICE + A.AIR_PROFIT + A.AIR_ETC_PRICE + (A.PERSON_ETC_PRICE + A.AGENT_COM_PRICE + A.PAY_COM_PRICE)) + (A.PERSON_ETC_PRICE + A.AGENT_COM_PRICE + A.PAY_COM_PRICE)) AS [알선수익]
		FROM (
			SELECT
				A.PRO_CODE, 
				A.SET_STATE, 
				ISNULL(Diablo.dbo.FN_PRO_GET_TOTAL_PRICE(A.PRO_CODE), 0) AS SALE_PRICE, 
				ISNULL(B.AIR_PROFIT, 0) AS AIR_PROFIT, 
				ISNULL(B.AIR_PRICE, 0) AS AIR_PRICE, 
				ISNULL(C.LAND_PRICE, 0) AS LAND_PRICE, 
				ISNULL(D.GROUP_PRICE, 0) AS GROUP_PRICE, 
				ISNULL(E.PERSON_PRICE, 0) AS PERSON_PRICE, 
				ISNULL(E.PERSON_ETC_PRICE, 0) AS PERSON_ETC_PRICE, 
				ISNULL(F.AGENT_COM_PRICE, 0) AS AGENT_COM_PRICE, 
				ISNULL(G.PAY_COM_PRICE, 0) AS PAY_COM_PRICE, 
				ISNULL(H.AIR_ETC_PRICE, 0) AS AIR_ETC_PRICE
			FROM Diablo.dbo.SET_MASTER A WITH(NOLOCK)
			LEFT OUTER JOIN (
				-- 항공기 거래처별 고객
				SELECT
					PRO_CODE, 
					SUM(ISNULL(COMM_PRICE, 0)) AS AIR_PROFIT, 
					SUM(ISNULL(PAY_PRICE, 0)) AS AIR_PRICE
				FROM Diablo.dbo.SET_AIR_CUSTOMER WITH (NOLOCK)
				GROUP BY PRO_CODE
			) AS B ON B.PRO_CODE = A.PRO_CODE
			LEFT OUTER JOIN (
				-- 지상비 거래처
				SELECT
					PRO_CODE, 
					SUM(ISNULL(PAY_PRICE, 0) + ISNULL(VAT_PRICE, 0)) AS LAND_PRICE
				FROM Diablo.dbo.SET_LAND_AGENT WITH (NOLOCK)
				GROUP BY PRO_CODE
			) AS C ON C.PRO_CODE = A.PRO_CODE
			LEFT OUTER JOIN (
				-- 공동 경비
				SELECT
					PRO_CODE, 
					SUM(CASE WHEN PROFIT_YN = 'N' THEN ISNULL(PRICE, 0) ELSE 0 END) AS GROUP_PRICE
				FROM Diablo.dbo.SET_GROUP WITH (NOLOCK)
				GROUP BY PRO_CODE
			) AS D ON D.PRO_CODE = A.PRO_CODE
			LEFT OUTER JOIN (
				-- 개인 경비
				SELECT
					PRO_CODE, 
					SUM(ISNULL(INS_PRICE, 0) + ISNULL(PASS_PRICE, 0) + ISNULL(VISA_PRICE, 0) + ISNULL(TAX_PRICE, 0)) AS PERSON_PRICE, 
					SUM(ISNULL(ETC_PROFIT, 0)) AS PERSON_PROFIT, SUM(ISNULL(ETC_PRICE, 0)) AS PERSON_ETC_PRICE
				FROM Diablo.dbo.SET_CUSTOMER WITH (NOLOCK)
			GROUP BY PRO_CODE
			) AS E ON E.PRO_CODE = A.PRO_CODE
			LEFT OUTER JOIN (

				SELECT
					PRO_CODE, 
					SUM(CASE WHEN COMM_RATE = 0 THEN ISNULL(COMM_AMT, 0) ELSE ISNULL(COMM_RATE, 0) * ISNULL(Diablo.dbo.FN_RES_GET_SALE_PRICE(RES_CODE), 0) * 0.01 END) AS AGENT_COM_PRICE
				FROM Diablo.dbo.RES_MASTER_DAMO WITH (NOLOCK)
				WHERE (RES_STATE NOT IN (8, 9)) AND (SALE_COM_CODE IS NOT NULL)
				GROUP BY PRO_CODE
			) AS F ON F.PRO_CODE = A.PRO_CODE
			LEFT OUTER JOIN (
				-- 입금내역
				SELECT
					B.PRO_CODE, 
					SUM(CASE WHEN A.COM_RATE = 0 AND A.COM_PRICE <> 0 AND A.PAY_TYPE = 12 THEN A.COM_PRICE ELSE ISNULL(ISNULL(A.COM_RATE, 0) * ISNULL(B.PART_PRICE, 0) * 0.01, 0) END) AS PAY_COM_PRICE
				FROM Diablo.dbo.PAY_MASTER_damo AS A WITH (NOLOCK)
				INNER JOIN Diablo.dbo.PAY_MATCHING AS B WITH (NOLOCK) ON B.PAY_SEQ = A.PAY_SEQ
				WHERE (B.CXL_YN = 'N')
				GROUP BY B.PRO_CODE
			) AS G ON G.PRO_CODE = A.PRO_CODE
			LEFT OUTER JOIN (
				-- 항공비 거래처
				SELECT
					PRO_CODE, 
					SUM(ISNULL(AIR_ETC_PRICE, 0)) AS AIR_ETC_PRICE
				FROM Diablo.dbo.SET_AIR_AGENT WITH (NOLOCK)
				GROUP BY PRO_CODE
			) AS H ON H.PRO_CODE = A.PRO_CODE
			WHERE A.DEP_DATE >= @START_DATE AND A.DEP_DATE < DATEADD(D, 1, @END_DATE) AND A.SET_STATE = 2 AND A.PROFIT_TEAM_CODE = @TEAM_CODE
		) A
	)
	SELECT
		--A.PRO_CODE, A.SALE_PRICE, A.총지출금,
		SUM(A.SALE_PRICE) AS [총판매금], SUM(A.총지출금) AS [총지출금],
		ROUND((SUM(A.SALE_PRICE) - SUM(A.총지출금)) * 100 / SUM(A.SALE_PRICE), 2) AS [수익률]
		--(CASE WHEN A.알선수익 < 11000 THEN A.알선수익 ELSE ROUND((A.알선수익 / 1.1), 0) END) AS [알선수수료]
	FROM LIST A
)

GO
