USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이규식
-- Create date: 2009-11-4
-- Description:	행사코드의 모든 예약들에 대한 수익현황을 가져온다.
-- 로직의 변경이 생긴다면 FN_SET_GET_RES_COMPLETE 도 변경해야 한다
-- =============================================
CREATE FUNCTION [dbo].[FN_SET_GET_PRO_COMPLETE]
(	
	@PRO_CODE VARCHAR(20)
)
RETURNS 
@RESULT_TABLE TABLE 
(
	PRO_CODE	VARCHAR(20),
	PRO_TYPE	INT,
	RES_CODE	VARCHAR(20),
	SEQ_NO		INT,
	CUS_NAME	VARCHAR(40), 
	LAST_NAME	VARCHAR(20),
	FIRST_NAME	VARCHAR(20),
	AGE_TYPE	INT,
	GENDER		CHAR(1),
	SALE_PRICE	MONEY,
	RES_STATE	INT,
	PROFIT_EMP_CODE VARCHAR(10),
	PROFIT_TEAM_CODE VARCHAR(10),
	PROFIT_TEAM_NAME VARCHAR(50),
	PERSON_PRICE	MONEY,
	PERSON_PROFIT	MONEY,
	PERSON_ETC_PRICE	MONEY,
	AIR_PROFIT	MONEY,
	AIR_PRICE	MONEY,
	AIR_SALE_PRICE	MONEY,
	GROUP_PRICE	MONEY,
	GROUP_PROFIT	MONEY,
	AGENT_COM_PRICE	MONEY,
	PAY_COM_PRICE	MONEY,
	AIR_ETC_PROFIT	MONEY,
	AIR_ETC_PRICE	MONEY,
	AIR_ETC_COM_PRICE	MONEY,
	AIR_ETC_COM_PROFIT	MONEY,
	LAND_COM_PRICE	MONEY,
	LAND_PRICE	MONEY,
	IS_PROFIT CHAR(1)
)
AS
BEGIN
	DECLARE @RES_CODE VARCHAR(20)
	DECLARE @GROUP_PRICE MONEY
	DECLARE @GROUP_PROFIT MONEY
	DECLARE @PERSON_COUNT INT
	DECLARE @RES_COUNT INT
	DECLARE @LAND_PRICE MONEY
	DECLARE @LAND_COM_PRICE MONEY
	DECLARE @AGENT_COM_PRICE MONEY
	DECLARE @PAY_COM_PRICE MONEY
	DECLARE @AIR_ETC_PROFIT MONEY
	DECLARE @AIR_ETC_PRICE MONEY
	DECLARE @AIR_ETC_COM_PRICE MONEY
	DECLARE @AIR_ETC_COM_PROFIT MONEY
	DECLARE @IS_PROFIT CHAR(1)

	DECLARE USER_CURSOR2 CURSOR FOR
	SELECT RES_CODE FROM RES_MASTER WITH(NOLOCK)  WHERE PRO_CODE = @PRO_CODE AND RES_STATE <= 7
	ORDER BY RES_CODE

	-- 수익여부를 계산한다.
		SELECT @IS_PROFIT = DBO.FN_SET_IS_PROFIT(@PRO_CODE)


	-- 전체 인원수를 구한다. (유아를 제외한)
	SELECT @PERSON_COUNT = COUNT(*) FROM RES_MASTER A  WITH(NOLOCK) 
	INNER JOIN RES_CUSTOMER_DAMO B  WITH(NOLOCK) ON B.RES_CODE= A.RES_CODE 
	-- 이동과 취소는 포함시키지 않는다.
	WHERE A.PRO_CODE = @PRO_CODE AND B.RES_STATE in (0, 3, 4) AND B.AGE_TYPE IN (0, 1)

	-- 에러를 피하기 위한 로직
	IF (@PERSON_COUNT = 0) SET @PERSON_COUNT = 1

	-- 공동경비/수익을 구한다.
	SELECT 
		@GROUP_PRICE = SUM(
			CASE WHEN PROFIT_YN = 'N' THEN ISNULL(PRICE, 0)
			ELSE 0
			END
		) / @PERSON_COUNT,
		@GROUP_PROFIT = SUM(
			CASE WHEN PROFIT_YN = 'Y' THEN ISNULL(PRICE, 0)
			ELSE 0
			END
		) / @PERSON_COUNT
	FROM SET_GROUP  WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE AND PROFIT_YN = 'N'

	-- 항공비 기타비용 정리
	SELECT
		@AIR_ETC_PROFIT = SUM(ISNULL(AIR_ETC_PROFIT, 0))/ @PERSON_COUNT , 
		@AIR_ETC_PRICE = SUM(ISNULL(AIR_ETC_PRICE, 0))/ @PERSON_COUNT , 
		@AIR_ETC_COM_PRICE = SUM(ISNULL(
			CASE WHEN COM_RATE > 0 THEN 
			-1 * ISNULL(COM_RATE, 0) * 0.01 * ISNULL(AIR_ETC_PRICE, 0)
			ELSE ISNULL( CASE WHEN COMM_PRICE < 0 THEN COMM_PRICE ELSE 0 END, 0)
			END
		, 0))/ @PERSON_COUNT, 
		@AIR_ETC_COM_PROFIT = SUM(ISNULL(
							CASE WHEN COM_RATE > 0 THEN
								ISNULL(COM_RATE, 0) * 0.01 * ISNULL(AIR_ETC_PROFIT, 0)
							ELSE ISNULL(CASE WHEN COMM_PRICE > 0 THEN COMM_PRICE ELSE 0 END, 0)	END	, 0))/ @PERSON_COUNT
	FROM SET_AIR_AGENT WITH(NOLOCK) 
	WHERE PRO_CODE = @PRO_CODE


	OPEN USER_CURSOR2

	FETCH NEXT FROM USER_CURSOR2 INTO @RES_CODE

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 예약 인원수를 구한다. (유아를 제외한)
		SELECT @RES_COUNT = COUNT(*) FROM RES_CUSTOMER_DAMO B WITH(NOLOCK) 
		-- 이동과 취소는 포함시키지 않는다.
		WHERE B.RES_CODE = @RES_CODE AND B.RES_STATE in (0, 3, 4) AND B.AGE_TYPE IN (0, 1)

		-- 에러를 피하기 위한 로직
		IF (@RES_COUNT = 0) SET @RES_COUNT = 1

		-- 대리점 수수료
		SELECT 
			@AGENT_COM_PRICE = 
			SUM(
				CASE WHEN ISNULL(COMM_RATE, 0) = 0 THEN
					ISNULL(COMM_AMT, 0)
				ELSE
					ISNULL(COMM_RATE, 0) * ISNULL(dbo.FN_RES_GET_SALE_PRICE(RES_CODE), 0) * 0.01
				END
			) / @RES_COUNT
		FROM          
			RES_MASTER_DAMO WITH(NOLOCK) 
		WHERE
			RES_STATE NOT IN (8, 9) AND SALE_COM_CODE IS NOT NULL
			AND RES_CODE = @RES_CODE;

		-- 카드수수료
		SELECT
			@PAY_COM_PRICE = 
			SUM(
				CASE WHEN A.COM_RATE = 0 AND A.COM_PRICE <> 0 AND A.PAY_TYPE = 12 THEN A.COM_PRICE
				ELSE ISNULL(ISNULL(A.COM_RATE, 0) * ISNULL(B.PART_PRICE, 0) * 0.01, 0) END
			) / @RES_COUNT
		FROM PAY_MASTER_damo A  WITH(NOLOCK) 
		INNER JOIN PAY_MATCHING AS B  WITH(NOLOCK) ON B.PAY_SEQ = A.PAY_SEQ
		WHERE B.CXL_YN = 'N' AND B.RES_CODE = @RES_CODE;

		INSERT INTO @RESULT_TABLE
		-- 개인수익을 구한다.
		SELECT
		-- 기본 고객정보
		@PRO_CODE,
		Z.PRO_TYPE,
		B.RES_CODE,
		B.SEQ_NO,
		B.CUS_NAME, 
		B.LAST_NAME,
		B.FIRST_NAME,
		B.AGE_TYPE,
		B.GENDER,
		ISNULL(B.SALE_PRICE, 0) - ISNULL(B.DC_PRICE, 0) + ISNULL(B.CHG_PRICE, 0) + ISNULL(B.TAX_PRICE, 0) + ISNULL(B.PENALTY_PRICE, 0) As SALE_PRICE,
		--dbo.FN_RES_GET_TOTAL_PRICE(B.RES_CODE) AS [SALE_PRICE],
		B.RES_STATE,
		Z.PROFIT_EMP_CODE ,
		Z.PROFIT_TEAM_CODE,
		Z.PROFIT_TEAM_NAME,

		-- 개인경비합
		ISNULL(A.INS_PRICE, 0) + ISNULL(A.PASS_PRICE, 0) + ISNULL(A.VISA_PRICE, 0) + ISNULL(A.TAX_PRICE, 0) AS PERSON_PRICE, 
		ISNULL(A.ETC_PROFIT, 0) AS PERSON_PROFIT, 
		ISNULL(A.ETC_PRICE, 0) AS PERSON_ETC_PRICE,
		-- 항공비합
		C.AIR_PROFIT, 
		C.AIR_PRICE, 
		C.AIR_SALE_PRICE,
		-- 공동경비
			ISNULL(
			CASE 
				WHEN B.RES_STATE in (0, 3, 4) AND B.AGE_TYPE IN (0, 1) THEN @GROUP_PRICE 
				ELSE 0 
			END, 0)
		 AS GROUP_PRICE,
			ISNULL(CASE 
				WHEN B.RES_STATE in (0, 3, 4) AND B.AGE_TYPE IN (0, 1) THEN @GROUP_PROFIT 
				ELSE 0 
			END, 0)
		 AS GROUP_PROFIT,

		-- 대리점 수수료
			ISNULL(CASE 
				WHEN B.RES_STATE in (0, 3, 4) AND B.AGE_TYPE IN (0, 1) THEN @AGENT_COM_PRICE 
				ELSE 0 
			END, 0)
		 AS AGENT_COM_PRICE,

		-- 카드수수료
			ISNULL(CASE 
				WHEN B.RES_STATE in (0, 3, 4) AND B.AGE_TYPE IN (0, 1) THEN @PAY_COM_PRICE 
				ELSE 0 
			END, 0)
		 AS PAY_COM_PRICE,

		-- 항공기타비용정리
			ISNULL(CASE 
				WHEN B.RES_STATE in (0, 3, 4) AND B.AGE_TYPE IN (0, 1) THEN @AIR_ETC_PROFIT 
				ELSE 0 
			END, 0)
		 AS AIR_ETC_PROFIT,
			ISNULL(CASE 
				WHEN B.RES_STATE in (0, 3, 4) AND B.AGE_TYPE IN (0, 1) THEN @AIR_ETC_PRICE 
				ELSE 0 
			END, 0)
		 AS AIR_ETC_PRICE,
			ISNULL(CASE 
				WHEN B.RES_STATE in (0, 3, 4) AND B.AGE_TYPE IN (0, 1) THEN @AIR_ETC_COM_PRICE 
				ELSE 0 
			END, 0)
		 AS AIR_ETC_COM_PRICE,
			ISNULL(CASE 
				WHEN B.RES_STATE in (0, 3, 4) AND B.AGE_TYPE IN (0, 1) THEN @AIR_ETC_COM_PROFIT 
				ELSE 0 
			END, 0)
		 AS AIR_ETC_COM_PROFIT,

		-- 지상비합
			ISNULL((SELECT SUM(ISNULL(z.COM_PRICE, 0)) AS COM_PRICE FROM SET_LAND_CUSTOMER Z  WITH(NOLOCK) 
				WHERE Z.RES_CODE = B.RES_CODE AND Z.RES_SEQ_NO = B.SEQ_NO), 0) AS LAND_COM_PRICE,
			ISNULL((SELECT SUM(ISNULL(z.PAY_PRICE, 0)) AS COM_PRICE FROM SET_LAND_CUSTOMER Z  WITH(NOLOCK) 
				WHERE Z.RES_CODE = B.RES_CODE AND Z.RES_SEQ_NO = B.SEQ_NO), 0) AS LAND_PRICE,
		-- 수익여부
		@IS_PROFIT AS IS_PROFIT
		FROM 
			RES_CUSTOMER_DAMO B  WITH(NOLOCK) 
			INNER JOIN RES_MASTER_DAMO Z  WITH(NOLOCK) ON Z.RES_CODE = B.RES_CODE
			LEFT JOIN SET_CUSTOMER A  WITH(NOLOCK) ON B.RES_CODE = A.RES_CODE AND A.RES_SEQ_NO = B.SEQ_NO 
			LEFT JOIN 
			(
				SELECT
				RES_CODE,
				RES_SEQ_NO,
				SUM(ISNULL(COMM_PRICE, 0)) AS AIR_PROFIT, 
				SUM(ISNULL(PAY_PRICE, 0)) AS AIR_PRICE, 
				SUM(ISNULL(NET_PRICE, 0)) + SUM(ISNULL(TAX_PRICE, 0)) AS AIR_SALE_PRICE
				FROM
				SET_AIR_CUSTOMER  WITH(NOLOCK) WHERE RES_CODE = @RES_CODE
				GROUP BY RES_CODE, RES_SEQ_NO
			) C ON C.RES_CODE = B.RES_CODE AND C.RES_SEQ_NO = B.SEQ_NO
		WHERE B.RES_CODE = @RES_CODE AND B.RES_STATE IN (0, 3, 4)
		ORDER BY B.RES_CODE, B.CUS_NAME

		FETCH NEXT FROM USER_CURSOR2 INTO @RES_CODE
	END



	RETURN 
END









GO
