USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_PAY_MASTER_INFO_SELECT
■ DESCRIPTION				: 회원-예약된 상품의 결제 내역 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
PaymentTypeEnum 

XP_WEB_RES_PAY_MASTER_INFO_SELECT 'RP1906120971' ,0

은행 = 0, 일반계좌 = 1, OFF신용카드 = 2, PG신용카드 = 3, 상품권 = 4, 현금 = 5, 미수대체 = 6, 포인트_회원가입 = 7, 기타 = 8, 세금계산서 = 9, CCCF = 10, IND_TKT = 11, TASF = 12, ARS = 13, ARS호전환 = 14 , 가상계좌 = 15 ,  포인트_구매실적 = 71, 없음 = 999 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-09		박형만			최초생성
   2015-09-16		박형만			항공 매출전표 출력을 위한 데이터조회 
   2017-09-01		박형만			오래된순으로 정렬
   2018-01-13		박형만			damo PAY_NUM 수정 
   2019-06-19		박형만			NPAY 는 복합결제시 [(신용카드,계좌) + 포인트)] 그룹핑 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_RES_PAY_MASTER_INFO_SELECT]
	@RES_CODE RES_CODE ,
	@PAY_SEQ INT   -- 값이 있을경우 선택된 결제내역 한건만
AS 
BEGIN

	IF( @PAY_SEQ > 0 )
	BEGIN

		--총금액 구하기 
		DECLARE @PRO_TYPE INT 
		DECLARE @UNPAID_PRICE INT 
		SET @PRO_TYPE = (SELECT TOP 1 PRO_TYPE FROM RES_MASTER_DAMO WITH(NOLOCK) WHERE RES_CODE = @RES_CODE)

		--패키지,항공
		IF( @PRO_TYPE IN (1,2) )
		BEGIN 
			SET @UNPAID_PRICE = DBO.FN_RES_GET_TOTAL_PRICE(@RES_CODE) - DBO.FN_RES_GET_PAY_PRICE(@RES_CODE) 
		END 
		ELSE IF( @PRO_TYPE = 3 )
		BEGIN
			SET @UNPAID_PRICE = DBO.FN_RES_HTL_GET_TOTAL_PRICE(@RES_CODE) - DBO.FN_RES_GET_PAY_PRICE(@RES_CODE)  
		END 

		--해당 결제건만
		SELECT  TOP 1 
				B.AGT_CODE ,
				B.PAY_SEQ , A.RES_CODE , A.PART_PRICE, A.NEW_CODE AS CHARGE_CODE,
				B.PAY_DATE, 
				B.PAY_TYPE, 
				B.PAY_SUB_TYPE ,
				CASE WHEN B.PAY_TYPE = 10 AND AIR_GDS IN (101,102,103,104) THEN '신용카드' ELSE B.PAY_SUB_NAME END  AS PAY_SUB_NAME ,
				damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM) AS PAY_NUM , 
				B.PAY_METHOD, 
				B.PAY_NAME,
				B.ADMIN_REMARK , 
				B.PG_APP_NO ,
				(SELECT KOR_NAME FROM EMP_MASTER WITH(NOLOCK) WHERE EMP_CODE = A.NEW_CODE) AS CHARGE_NAME,
				(SELECT KOR_NAME FROM AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = B.AGT_CODE) AS AGT_NAME ,
				@UNPAID_PRICE  AS UNPAID_PRICE ,
				C.AIR_GDS , C.PNR_CODE1 , C.PNR_CODE2 , C.AIRLINE_CODE 
		FROM PAY_MATCHING A WITH(NOLOCK)
			INNER JOIN PAY_MASTER_DAMO B WITH(NOLOCK) 
				ON A.PAY_SEQ = B.PAY_SEQ 

			LEFT JOIN RES_AIR_DETAIL C  WITH(NOLOCK) 
				ON A.RES_CODE = C.RES_CODE 
				AND C.AIR_PRO_TYPE = 0 --실시간 
				AND C.AIR_GDS IN ( 101, 102, 103, 104 )   --국내 KE,OZ,LJ,TW -- 2015-09
		WHERE A.PAY_SEQ = @PAY_SEQ
		--AND (ISNULL(@CUS_NO,0) = 0 OR  CUS_NO = @CUS_NO)
		ORDER BY A.PAY_SEQ ASC , A.MCH_SEQ ASC 
	END 
	ELSE 
	BEGIN
		

		--2019-06-19 백업 
		-- NPAY 포인트 와 그룹핑 해서 나오게 해야 한데서,,개선 
		----전체 결제 리스트
		--SELECT	
		--		B.AGT_CODE ,
		--		B.PAY_SEQ , A.RES_CODE , A.PART_PRICE, A.NEW_CODE AS CHARGE_CODE,
		--		B.PAY_DATE, 
		--		B.PAY_TYPE, 
		--		B.PAY_SUB_TYPE ,
		--		CASE WHEN B.PAY_TYPE = 10 AND AIR_GDS IN (101,102,103,104) THEN '신용카드' ELSE B.PAY_SUB_NAME END  AS PAY_SUB_NAME ,
		--		damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM) AS PAY_NUM , 
		--		B.PAY_METHOD, 
		--		B.PAY_NAME,
		--		B.ADMIN_REMARK , 
		--		B.PG_APP_NO ,
		--		(SELECT KOR_NAME FROM EMP_MASTER WITH(NOLOCK) WHERE EMP_CODE = A.NEW_CODE) AS CHARGE_NAME,
		--		(SELECT KOR_NAME FROM AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = B.AGT_CODE) AS AGT_NAME ,
		--		CASE 
		--			-- 2 : OFF신용카드 , 3 : PG신용카드  ,  13 : ARS  14 : ARS호전환 
		--			WHEN PAY_TYPE IN ( 2 , 3 , 13 ,14) THEN 
		--				CASE WHEN LEN(damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM)) > 14 
		--					THEN  STUFF(damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM) , 5,8,'-****-****-') 
		--					ELSE ISNULL(PAY_SUB_NAME,'') 
		--				END 
		--			--  15 가상계좌 
		--			WHEN PAY_TYPE IN ( 15 ) THEN 
		--				ADMIN_REMARK 
		--			ELSE 
		--				damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM) 
		--		END AS PAY_INFO,
		--		C.AIR_GDS , C.PNR_CODE1 , C.PNR_CODE2 , C.AIRLINE_CODE ,
		--		CASE WHEN PAY_TYPE IN ( 16,17 ) THEN (SELECT TOP 1 NPAY_ID FROM NAVEr_PAY_RESULT WHERE PAY_SEQ = A.PAY_SEQ )
		--			WHEN  PAY_TYPE IN ( 18 ) THEN (SELECT TOP 1 NPAY_ID FROM NAVEr_PAY_RESULT WHERE POINT_PAY_SEQ = A.PAY_SEQ )  END AS NPAY_ID 
				
		--FROM PAY_MATCHING A WITH(NOLOCK)
		--	INNER JOIN PAY_MASTER_DAMO B WITH(NOLOCK) 
		--		ON A.PAY_SEQ = B.PAY_SEQ
			
		--	LEFT JOIN RES_AIR_DETAIL C  WITH(NOLOCK) 
		--		ON A.RES_CODE = C.RES_CODE 
		--		AND C.AIR_PRO_TYPE = 0 --실시간 
		--		AND C.AIR_GDS IN ( 101, 102, 103, 104 )   --국내 KE,OZ,LJ,TW -- 2015-09
				 
		--WHERE A.RES_CODE = @RES_CODE AND A.CXL_YN = 'N' AND B.CXL_YN = 'N'
		----AND (ISNULL(@CUS_NO,0) = 0 OR  CUS_NO = @CUS_NO)
		--ORDER BY A.PAY_SEQ ASC , A.MCH_SEQ ASC 
		
		--DECLARE 	@RES_CODE RES_CODE 
		--SET @RES_CODE = 'RP1906120971' 
		-- 금액을 NPAY 그룹핑이 적용된 T 테이블에서 가져옴 
		SELECT	
			B.AGT_CODE ,
			B.PAY_SEQ , A.RES_CODE , T.PART_PRICE, A.NEW_CODE AS CHARGE_CODE,
			B.PAY_DATE, 
			B.PAY_TYPE, 
			B.PAY_SUB_TYPE ,
			CASE WHEN B.PAY_TYPE = 10 AND AIR_GDS IN (101,102,103,104) THEN '신용카드' ELSE B.PAY_SUB_NAME END  AS PAY_SUB_NAME ,
			damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM) AS PAY_NUM , 
			B.PAY_METHOD, 
			B.PAY_NAME,
			B.ADMIN_REMARK , 
			B.PG_APP_NO ,
			(SELECT KOR_NAME FROM EMP_MASTER WITH(NOLOCK) WHERE EMP_CODE = A.NEW_CODE) AS CHARGE_NAME,
			(SELECT KOR_NAME FROM AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = B.AGT_CODE) AS AGT_NAME ,
			CASE 
				-- 2 : OFF신용카드 , 3 : PG신용카드  ,  13 : ARS  14 : ARS호전환 
				WHEN PAY_TYPE IN ( 2 , 3 , 13 ,14) THEN 
					CASE WHEN LEN(damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM)) > 14 
						THEN  STUFF(damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM) , 5,8,'-****-****-') 
						ELSE ISNULL(PAY_SUB_NAME,'') 
					END 
				--  15 가상계좌 
				WHEN PAY_TYPE IN ( 15 ) THEN 
					ADMIN_REMARK 
				ELSE 
					damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', B.SEC_PAY_NUM) 
			END AS PAY_INFO,
			C.AIR_GDS , C.PNR_CODE1 , C.PNR_CODE2 , C.AIRLINE_CODE ,
			T.NPAY_ID , T.PAY_CNT 
				
		FROM PAY_MATCHING A WITH(NOLOCK)
			INNER JOIN PAY_MASTER_DAMO B WITH(NOLOCK) 
				ON A.PAY_SEQ = B.PAY_SEQ

			INNER JOIN (
				--일반결제 
				SELECT A.PAY_SEQ , A.PART_PRICE , NULL AS NPAY_ID , NULL AS PAY_CNT 
				FROM PAY_MATCHING A WITH(NOLOCK)
					INNER JOIN PAY_MASTER_DAMO B WITH(NOLOCK) 
						ON A.PAY_SEQ = B.PAY_SEQ
				WHERE A.RES_CODE = @RES_CODE AND A.CXL_YN = 'N' AND B.CXL_YN = 'N'
				AND B.PAY_TYPE NOT IN  (16,17,18 ) 
				UNION ALL  -- UNION ALL 
				-- NPAY결제 
				SELECT 
				MIN(PAY_SEQ) AS PAY_SEQ , SUM(PART_PRICE) AS PART_PRICE , NPAY_ID , COUNT(*) AS PAY_CNT
				 FROM 
				( 
					SELECT  A.PAY_SEQ , A.PART_PRICE ,  PAY_TYPE ,  B.PAY_DATE , 
					CASE WHEN PAY_TYPE IN ( 16,17 ) THEN (SELECT TOP 1 NPAY_ID FROM NAVEr_PAY_RESULT WHERE PAY_SEQ = A.PAY_SEQ )
						WHEN  PAY_TYPE IN ( 18 ) THEN (SELECT TOP 1 NPAY_ID FROM NAVEr_PAY_RESULT WHERE POINT_PAY_SEQ = A.PAY_SEQ )  END AS NPAY_ID 
					FROM PAY_MATCHING A WITH(NOLOCK)
						INNER JOIN PAY_MASTER_DAMO B WITH(NOLOCK) 
							ON A.PAY_SEQ = B.PAY_SEQ
					WHERE A.RES_CODE = @RES_CODE AND A.CXL_YN = 'N' AND B.CXL_YN = 'N'
					AND B.PAY_TYPE IN  (16,17,18 ) 
				) TMP 
				GROUP BY NPAY_ID 
			) T 
				ON B.PAY_SEQ  = T.PAY_SEQ 
			
			LEFT JOIN RES_AIR_DETAIL C  WITH(NOLOCK) 
				ON A.RES_CODE = C.RES_CODE 
				AND C.AIR_PRO_TYPE = 0 --실시간 
				AND C.AIR_GDS IN ( 101, 102, 103, 104 )   --국내 KE,OZ,LJ,TW -- 2015-09
				 

	END 
END 
GO
