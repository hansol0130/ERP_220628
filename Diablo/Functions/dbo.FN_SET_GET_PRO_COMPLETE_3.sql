USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_SET_GET_PRO_COMPLETE_3
■ Description				: 행사코드의 모든 예약들에 대한 수익현황을 가져온다. (지점수익 변경 적용)
■ Input Parameter			:                  
		@PRO_CODE			: 행사코드
■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 

	SELECT * FROM DBO.FN_SET_GET_PRO_COMPLETE_3('JPPT101-181226')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2019-01-07		김성호			최초생성
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[FN_SET_GET_PRO_COMPLETE_3]
(	
	@PRO_CODE VARCHAR(20)
)
RETURNS 
@RESULT_TABLE TABLE 
(
	PRO_CODE	VARCHAR(20),		-- 행사코드
	PRO_TYPE	INT,				-- 행사구분
	RES_CODE	VARCHAR(20),		-- 예약코드
	RES_COUNT	INT,				-- 예약인원
	SALE_PRICE	MONEY,				-- 판매금액
--	MASTER_PROFIT	MONEY,			-- 행사팀 수익금액
	BRANCH_PROFIT	MONEY,			-- 수익팀 수익금액
	TOTAL_PROFIT	MONEY,			-- 전체 수익금액
	PROFIT_RATE	NUMERIC(5,2),		-- 수익 비율
	PROFIT_EMP_CODE	CHAR(7),		-- 수익자
	PROFIT_TEAM_CODE VARCHAR(10),	-- 수익팀코드
	PROFIT_TEAM_NAME VARCHAR(50),	-- 수익팀명
	ORDER_TYPE	INT					-- 정렬순서
)
AS
BEGIN

DECLARE @ONE_PROFIT_PRICE INT

	SELECT @ONE_PROFIT_PRICE = DBO.FN_SET_GET_PRO_PERSON_PROFIT(@PRO_CODE);

	WITH RES_LIST AS (
		SELECT
			A.PRO_CODE, A.RES_CODE, A.PROFIT_RATE, A.BRANCH_RATE, B.PRO_TYPE, --B.NEW_TEAM_NAME, B.PROFIT_TEAM_NAME,
			DBO.FN_SET_GET_RES_COUNT(B.RES_CODE) AS RES_COUNT,
			DBO.FN_RES_GET_TOTAL_PRICE(B.RES_CODE) AS SALE_PRICE,
			(CASE WHEN A.BRANCH_RATE > 0 THEN 'NEW' WHEN A.PROFIT_RATE < 100 THEN 'OLD' ELSE 'NORMAL' END) AS [SET_TYPE],
			(CASE WHEN A.BRANCH_RATE > 0 THEN A.BRANCH_RATE WHEN A.PROFIT_RATE < 100 THEN A.PROFIT_RATE ELSE 0 END) AS [SET_RATE]
		FROM SET_PROFIT A WITH(NOLOCK)
		INNER JOIN RES_MASTER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		WHERE A.PRO_CODE = @PRO_CODE AND B.RES_STATE <= 7
	)
	, BRANCH_LIST AS (
		-- 지점수익
		SELECT A.PRO_CODE, A.RES_CODE, 0 AS [RES_COUNT], 0 AS [SALE_PRICE], A.SET_RATE, A.PRO_TYPE,
			(
				CASE A.SET_TYPE
					WHEN 'NEW' THEN DBO.FN_SET_GET_RES_BRANCH_PRICE(A.RES_CODE)
					WHEN 'OLD' THEN (@ONE_PROFIT_PRICE * A.RES_COUNT * ISNULL(A.SET_RATE, 0) * 0.01)
				END
			) AS [BRANCH_PROFIT]
		FROM RES_LIST A
		WHERE A.SET_TYPE <> 'NORMAL'
	)
	INSERT INTO @RESULT_TABLE (ORDER_TYPE, PRO_CODE, PRO_TYPE, RES_CODE, RES_COUNT, SALE_PRICE, BRANCH_PROFIT, TOTAL_PROFIT, PROFIT_RATE, PROFIT_EMP_CODE, PROFIT_TEAM_CODE, PROFIT_TEAM_NAME)
	SELECT 1 AS PROFIT_TYPE, A.PRO_CODE, A.PRO_TYPE, A.RES_CODE, A.RES_COUNT, A.SALE_PRICE,
		(
			CASE A.SET_TYPE
				WHEN 'NEW' THEN (@ONE_PROFIT_PRICE * A.RES_COUNT - C.BRANCH_PROFIT)
				WHEN 'OLD' THEN (@ONE_PROFIT_PRICE * A.RES_COUNT * (100 - A.SET_RATE) * 0.01)
				ELSE @ONE_PROFIT_PRICE * A.RES_COUNT
			END
		) AS [BRANCH_PROFIT_PRICE],
		(@ONE_PROFIT_PRICE * A.RES_COUNT) AS TOTAL_PROFIT_PRICE,
		(100 - A.SET_RATE) AS [SET_RATE],
		(CASE A.SET_TYPE WHEN 'NORMAL' THEN B.PROFIT_EMP_CODE ELSE B.NEW_CODE END) AS [PROFIT_EMP_CODE],
		(CASE A.SET_TYPE WHEN 'NORMAL' THEN B.PROFIT_TEAM_CODE ELSE B.NEW_TEAM_CODE END) AS [PROFIT_TEAM_CODE],
		(CASE A.SET_TYPE WHEN 'NORMAL' THEN B.PROFIT_TEAM_NAME ELSE B.NEW_TEAM_NAME END) AS [PROFIT_TEAM_NAME]
	FROM RES_LIST A
	INNER JOIN RES_MASTER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	LEFT JOIN BRANCH_LIST C ON A.RES_CODE = C.RES_CODE
	UNION
	SELECT 2 AS PROFIT_TYPE, A.PRO_CODE, A.PRO_TYPE, A.RES_CODE, A.RES_COUNT, A.SALE_PRICE, A.BRANCH_PROFIT, 0 AS [TOTAL_PROFIT_PRICE], A.SET_RATE,
		B.PROFIT_EMP_CODE, B.PROFIT_TEAM_CODE, B.PROFIT_TEAM_NAME
	FROM BRANCH_LIST A
	INNER JOIN RES_MASTER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	ORDER BY RES_CODE, PROFIT_TYPE

	RETURN 
END


GO