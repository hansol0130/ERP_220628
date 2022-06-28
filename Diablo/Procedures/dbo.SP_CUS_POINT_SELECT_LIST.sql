USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: SP_CUS_POINT_SELECT_LIST  
■ Description				: 포인트 내역 조회  
■ Input Parameter			:                  
		@CUS_NO				: 고객 고유번호
		@PAGE_COUNT			: 조회할 페이지 갯수
		@PAGE_NUMBER		: 현재 페이지 번호
		@ORDERBY			: 정렬 순서
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_CUS_POINT_SELECT_LIST 15, 1000, 1, 'S'
■ Author					: 임형민  
■ Date						: 2010-05-12  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2010-04-28       임형민			최초생성 
   2010-06-03		박형만			암호화 적용 
   2012-03-02		박형만			READ UNCOMMITTED 설정
   2020-07-21		김성호			CONTENT, REFERENCE_CODE 조회 CASE 문 수정
   2020-08-03		김성호			적립포인트 중 남은 금액 추가
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[SP_CUS_POINT_SELECT_LIST]
(
	@CUS_NO					INT,
	@PAGE_COUNT				INT,
	@PAGE_NUMBER			INT,
	@ORDERBY				CHAR(1)
)

AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	BEGIN

		-- 변수 선언
		DECLARE @START_ROW_NUM INT, @END_ROW_NUM INT
		
		-- 페이징 변수에 값 셋팅
		SET @START_ROW_NUM = (@PAGE_COUNT * (@PAGE_NUMBER - 1)) + 1;
		SET @END_ROW_NUM = @PAGE_COUNT * @PAGE_NUMBER;

		-- 해당 고객의 포인트 내역 총 ROW 수를 조회한다
		SELECT COUNT(*) AS TOTAL_COUNT
		FROM DBO.CUS_POINT WITH(NOLOCK)
		WHERE CUS_NO = @CUS_NO
		
		-- 해당 고객의 현재 총 포인트 조회한다
		SELECT TOP 1 TOTAL_PRICE AS TOTAL_POINT
		FROM DBO.CUS_POINT WITH(NOLOCK)
		WHERE CUS_NO = @CUS_NO
		ORDER BY POINT_NO DESC;
		
		-- 포인트 사용내역를 조회한 뒤 ROWCOUNT를 붙여 NAMEING을 붙여준다
		WITH SELECT_LIST
		AS
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY 
					CASE @ORDERBY 
						WHEN 'S' THEN A.NEW_DATE
						WHEN 'V' THEN A.START_DATE
						WHEN 'P' THEN A.POINT_PRICE
					END
				DESC) AS ROW_INDEX,
				A.POINT_NO,
				A.RES_CODE,
				--(
				--	CASE B.PRO_TYPE 
				--		WHEN 3 THEN DBO.FN_RES_HTL_GET_TOTAL_PRICE(B.RES_CODE) 
				--		ELSE DBO.FN_RES_GET_TOTAL_PRICE(B.RES_CODE) 
				--	END
				--) AS PRO_PRICE, -- 사용안하는 값 숨김 (20.08.03)
				A.POINT_TYPE,
				A.ACC_USE_TYPE,
				A.POINT_PRICE,
				A.TOTAL_PRICE,
				(
					CASE A.POINT_TYPE 
						WHEN 1 THEN
							CASE A.ACC_USE_TYPE
								WHEN 1 THEN B.PRO_NAME 
								WHEN 4 THEN C.[SUBJECT] 
								--WHEN 5 THEN D.EVT_NAME 
								ELSE A.TITLE 
							END 
						WHEN 2 THEN 
							CASE A.ACC_USE_TYPE 
								WHEN 1 THEN B.PRO_NAME 
								ELSE A.TITLE 
							END 
					END
				) AS CONTENT,
				(
					CASE A.POINT_TYPE
						WHEN 1 THEN
							CASE A.ACC_USE_TYPE 
								WHEN 1 THEN B.PRO_CODE 
								WHEN 4 THEN CONVERT(VARCHAR(10), C.BOARD_SEQ) 
								--WHEN 5 THEN CONVERT(VARCHAR(10), D.EVT_SEQ) 
								ELSE ISNULL(B.PRO_CODE, '') 
							END
						WHEN 2 THEN B.PRO_CODE
					END
				) AS REFERENCE_CODE,
				(
					CASE A.CUS_NO
						WHEN (SELECT E.CUS_NO FROM DBO.RES_MASTER E WHERE A.CUS_NO = E.CUS_NO AND A.RES_CODE = E.RES_CODE) THEN 'Y' 
						ELSE 'N' 
					END
				) AS RES_YN,
				A.START_DATE,
				A.END_DATE,
				A.NEW_DATE,
				ISNULL((SELECT SUM(POINT_PRICE) FROM CUS_POINT_HISTORY CPH WITH(NOLOCK) WHERE CPH.ACC_POINT_NO = A.POINT_NO), 0) AS [USE_POINT_PRICE]
			FROM DBO.CUS_POINT A WITH(NOLOCK)
			LEFT JOIN DBO.RES_MASTER_DAMO B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
			LEFT JOIN DBO.HBS_DETAIL C WITH(NOLOCK) ON A.MASTER_SEQ = C.MASTER_SEQ AND A.BOARD_SEQ = C.BOARD_SEQ
			LEFT JOIN DBO.PUB_EVENT D WITH(NOLOCK) ON B.PRO_CODE = D.PRO_CODE 
			WHERE A.CUS_NO = @CUS_NO
		)
		
		-- NAMEING을 붙인 포인트 사용내역을 페이징에 맞게 다시 조회한다.
		SELECT *, (POINT_PRICE - USE_POINT_PRICE) AS [REST_POINT_PRICE]
		FROM SELECT_LIST WITH(NOLOCK)
		WHERE ROW_INDEX BETWEEN @START_ROW_NUM AND @END_ROW_NUM
		ORDER BY ROW_INDEX
	END
GO
