USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_ACC_AI_SLIPD_INS_NEW
■ DESCRIPTION				: DSR 전표 생성
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec SP_ACC_AI_SLIPD_INS 'NEW', '20100408',0,'JPY111-100117','20091103', 'MCLICK'                
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
									최초생성
   2015-08-31		김성호			국내항공 거래처 예외처리 추가
   2015-09-22		김성호			국내항공 거래처 예외처리 도착도시 체크하도록 수정
   2015-10-08		김성호			도착도시 ROUTING으로 수정
   2015-10-12		김성호			도착도시 ROUTING 전체 체크
   2015-11-10		김성호			발권자코드가 9999999인거 제외(국내항공 온라인발권 제외)
   2016-05-04		김성호			거래처 예외 부서 수정 (제주 -> 항공판매,법인)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_ACC_AI_SLIPD_INS_NEW]
         @CHK				CHAR(3),			/* 체크 'NEW', 'ADD'			*/
         @SLIP_MK_DAY		CHAR(8),			/* 전표일자					*/
         @SLIP_MK_SEQ		SMALLINT OUTPUT,	/* 전표일련번호				*/
         @PRO_CODE			VARCHAR(20),		/* 행사코드					*/
         @TCKOUT_DAY		DATETIME,			/* 발권일					*/
         @EMP_NO			VARCHAR(10),		/* 등록사번					*/
		 @DOMESTIC_YN		VARCHAR(1)			/* 국내티켓 유무				*/
AS                                                       
                    
                    
DECLARE  @SLIP_FG			CHAR(1),          /* 수입(1) 지출(2) 대체(3)  */                                                            
         @USE_ACC_CD		VARCHAR(10),      /* 계정코드                 */                                                           
         @TCK_CNT			NUMERIC(12),      /* 티켓수                   */                             
         @AIR_CD_SHORT		VARCHAR(10),                                   
         @REMARK			VARCHAR(100),     /* 비고11                   */                             
         @AMT_W				NUMERIC(12),                                   
         @START_DAY			CHAR(8),                                   
         @COMM_AMT			NUMERIC(12),                     
         @COMM_VAT			NUMERIC(12),                                   
         @CARD_AMT			NUMERIC(12),                    
         @CASH_AMT			NUMERIC(12),                    
         @TOT_CARD_AMT		NUMERIC(12),                    
         @TOT_CASH_AMT		NUMERIC(12),                             
         @PAN_DEPT_CD		VARCHAR(10),                                  
         @PAN_EMP_NO		VARCHAR(10),                            
         @MIN_TCK_NO		VARCHAR(10),                    
         @MAX_TCK_NO		VARCHAR(10),                       
         @TCK_NO			VARCHAR(10),               
         @SITE_CD			VARCHAR(10),                               
         @RET				INT,
         @ISSUE_CODE		VARCHAR(10),
		 @ISSUE_DEPT_CD		VARCHAR(10),
		 @JUNL_FG			VARCHAR(2),
		 @OVERSEA_CHECK		VARCHAR(1),
		 @GDS				INT



-- 분개전표구분코드 설정 (해외 AI, 국내 AK)
SELECT @JUNL_FG = (CASE WHEN @DOMESTIC_YN = 'Y' THEN 'AK' ELSE 'AI' END)
                    
                    
BEGIN TRANSACTION
                    
                   
   SELECT @CHK  = 'NEW',                  
          @TOT_CASH_AMT = 0,                  
          @TOT_CARD_AMT = 0                  
                    
                    
   DECLARE CUR_1 SCROLL CURSOR FOR

		WITH LIST AS
		(
			SELECT A.TICKET, DBO.FN_AIR_OVERSEA_CHECK(A.ROUTING) AS [OVERSEA_CHECK]
			FROM DSR_TICKET A WITH(NOLOCK)
			WHERE
				A.PRO_CODE = @PRO_CODE
				AND A.ISSUE_DATE >= @TCKOUT_DAY AND A.ISSUE_DATE < DATEADD(DAY, 1, @TCKOUT_DAY)
				AND A.TICKET_STATUS = 1  /*정상티켓*/
				AND ISNULL(A.CASH_PRICE, 0) + ISNULL(A.CARD_PRICE, 0) <> 0
				AND NOT EXISTS (SELECT AA.TICKET FROM ACC_DSR_SLIP AA WITH(NOLOCK) WHERE AA.TICKET = A.TICKET)
				AND A.ISSUE_CODE <> '9999999'
		)
		SELECT
			ISNULL(SUM(A.CASH_PRICE), 0) AS [CASH_AMT],
			ISNULL(SUM(A.CARD_PRICE), 0) AS [CARD_AMT],
			COUNT(*) AS [TCK_CNT],
			ISNULL(SUM(A.COMM_PRICE), 0) AS [COMM_AMT],
			(ISNULL(SUM(A.COMM_PRICE), 0) * 0.1) AS [COMM_VAT],
			MIN(A.SALE_CODE) AS [PAN_EMP_NO],
			MIN(B.TEAM_CODE) AS [PAN_DEPT_CD],
			MIN(A.TICKET) AS [MIN_TCK_NO],
			MAX(A.TICKET) AS [MAX_TCK_NO],
			A.AIRLINE_CODE AS [AIR_CD_SHORT],
			MIN(ISNULL(CONVERT(CHAR(8), A.[START_DATE], 112),'')) AS [START_DAY],
			MIN(A.ISSUE_CODE) AS [ISSUE_CODE],
			MIN(C.TEAM_CODE) AS [ISSUE_DEPT_CD],
			MAX(Z.OVERSEA_CHECK) AS [OVERSEA_CHECK],
			MAX(A.GDS) AS [GDS]
		FROM LIST Z
		INNER JOIN DSR_TICKET A WITH(NOLOCK) ON Z.TICKET = A.TICKET
		LEFT JOIN EMP_MASTER_damo B WITH(NOLOCK) ON A.SALE_CODE = B.EMP_CODE
		LEFT JOIN EMP_MASTER_damo C WITH(NOLOCK) ON A.ISSUE_CODE = C.EMP_CODE
		LEFT JOIN RES_CUSTOMER_damo D WITH(NOLOCK) ON A.RES_CODE = D.RES_CODE AND A.RES_SEQ_NO = D.SEQ_NO
		--WHERE ((@JUNL_FG = 'AI' AND Z.OVERSEA_CHECK = 'Y') OR (@JUNL_FG = 'AK' AND Z.OVERSEA_CHECK = 'N') OR (@DOMESTIC_YN = ''))
		WHERE ((@DOMESTIC_YN = 'N' AND A.GDS <= 100) OR (@DOMESTIC_YN = 'Y' AND A.GDS > 100))
		GROUP BY ISNULL(A.CASH_PRICE, 0), ISNULL(A.CARD_PRICE, 0), A.AIRLINE_CODE;

                    
   OPEN CUR_1                    
                    
  FETCH NEXT FROM CUR_1 INTO  @CASH_AMT,				-- 현금결제금액
                              @CARD_AMT,				-- 카드결제금액
                              @TCK_CNT,					-- 티켓 수
                              @COMM_AMT,				-- 커미션금액
                              @COMM_VAT,				-- 커미션금액의 1/10
                              @PAN_EMP_NO,				-- 판매자사원코드
                              @PAN_DEPT_CD,				-- 판매자부서코드
                              @MIN_TCK_NO,				-- 티켓번호
                              @MAX_TCK_NO,				-- 티켓번호
                              @AIR_CD_SHORT,			-- 항공사코드
                              @START_DAY,				-- 출발일
                              @ISSUE_CODE,				-- 발권자사원코드
							  @ISSUE_DEPT_CD,			-- 발권자팀명
							  @OVERSEA_CHECK,			-- 해외유무
							  @GDS						-- 사용 GDS

 WHILE ( @@FETCH_STATUS <> -1 )                    
   BEGIN                     
                    
     IF @CHK = 'NEW'  AND  (@CASH_AMT + @CARD_AMT) <> 0                   
     BEGIN
       SELECT @SLIP_FG = '3'		/* 수입(1) 지출(2) 대체(3) */                                
       EXEC @SLIP_MK_SEQ = SP_ACC_SLIPM_SEQ @SLIP_MK_DAY, @EMP_NO, @SLIP_FG, @JUNL_FG --'AI'                     
       SELECT @CHK = 'ADD'
     END
                       
	-- 거래처코드 설정
	-- 온라인판매 항공은 새로운 거래처코드로 가져온다
	SELECT @SITE_CD = A.DZ_CODE
	FROM ACC_CODE A WITH(NOLOCK)
	WHERE A.CD_FG = (
		CASE
			-- 1. 국내 도착 & 제주팀 & 아시아나 인 경우
			--WHEN @OVERSEA_CHECK = 'N' AND @ISSUE_DEPT_CD = '509' AND @AIR_CD_SHORT = 'OZ' THEN 'AJCD'
			-- 1. 국내, 2. 제주팀, 3. 항공사가 있으면(OZ 제외)
			--WHEN @OVERSEA_CHECK = 'N' AND @ISSUE_DEPT_CD <> '509' AND EXISTS(SELECT 1 FROM ACC_CODE AA WITH(NOLOCK) WHERE AA.CD_FG = 'AOCD' AND A.CD = @AIR_CD_SHORT) THEN 'AOCD'

			-- 1. 국내 티켓, 2. 항공판매&법인팀 발권, 3. 아시아나
			WHEN @GDS > 100 AND @ISSUE_DEPT_CD IN ('524', '525') AND @AIR_CD_SHORT = 'OZ' THEN 'AJCD'
			-- 1. 국내 티켓, 2. 항공판매&법인팀 이외 발권, 3. AOCD에 포함된 항공사
			WHEN @GDS > 100 AND @ISSUE_DEPT_CD NOT IN ('524', '525') AND EXISTS(SELECT 1 FROM ACC_CODE AA WITH(NOLOCK) WHERE AA.CD_FG = 'AOCD' AND A.CD = @AIR_CD_SHORT) THEN 'AOCD'
			ELSE 'ARCD'
		END) AND A.CD = @AIR_CD_SHORT

     
     IF @SITE_CD IS NULL OR @SITE_CD = ''             
        SET @SITE_CD = @AIR_CD_SHORT


     --SELECT @REMARK  = '항공' + @PRO_CODE + ' ' + @START_DAY + ' ' +  @MIN_TCK_NO + ' ' + @MAX_TCK_NO + ' ' + CONVERT(CHAR(8), @TCKOUT_DAY, 112)                  
--	SELECT @REMARK = (CASE WHEN @DOMESTIC_YN = 'Y' THEN '[국내항공] ' ELSE '[항공] ' END) + @PRO_CODE + ' / ' +  @MIN_TCK_NO + ' ' + @MAX_TCK_NO + ' (' + 
--		ISNULL((SELECT KOR_NAME FROM EMP_MASTER WHERE EMP_CODE = @PAN_EMP_NO), '') + ' / ' + 
--		ISNULL((SELECT KOR_NAME FROM EMP_MASTER WHERE EMP_CODE = @ISSUE_CODE), '') + ')'           
	SELECT @REMARK = (CASE WHEN @OVERSEA_CHECK = 'N' THEN '[국내항공] ' ELSE '[항공] ' END) + @PRO_CODE + ' / ' +  @MIN_TCK_NO + ' ' + @MAX_TCK_NO + ' (' + 
		ISNULL((SELECT KOR_NAME FROM EMP_MASTER_damo WHERE EMP_CODE = @PAN_EMP_NO), '') + ' / ' + 
		ISNULL((SELECT KOR_NAME FROM EMP_MASTER_damo WHERE EMP_CODE = @ISSUE_CODE), '') + ')'
		
     IF (@CASH_AMT + @CARD_AMT) <> 0                     
     BEGIN                    
                          
         SELECT @USE_ACC_CD = USE_ACC_CD1,                                  
                @AMT_W      = @CASH_AMT + @CARD_AMT                                                                              
           FROM ACC_JUNL WITH(NOLOCK)
          WHERE JUNL_FG = @JUNL_FG --'AI'                    
            AND JUNL_CD = 'A1'

          EXEC @RET = SP_ACC_SLIPD_INS  @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD, '1', @SITE_CD, @PAN_DEPT_CD, @PAN_EMP_NO,                   
                                        @PRO_CODE, NULL, @AMT_W, 0, @REMARK, @EMP_NO                               
                                                      
          IF @RET <> 0 GOTO ERR_HANDLER                       

      END
                          
      IF @COMM_AMT <> 0                     
      BEGIN                    
         SELECT @USE_ACC_CD = USE_ACC_CD1,                                    
                @AMT_W      = @COMM_AMT                               
           FROM ACC_JUNL WITH(NOLOCK)
          WHERE JUNL_FG = @JUNL_FG --'AI'                    
            AND JUNL_CD = 'A2'                    
                    
          EXEC @RET = SP_ACC_SLIPD_INS  @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD, '2', @SITE_CD, @PAN_DEPT_CD, @PAN_EMP_NO,                   
                                        @PRO_CODE, NULL, 0, @AMT_W, @REMARK, @EMP_NO                               


          IF @RET <> 0 GOTO ERR_HANDLER                                    


		  SELECT * FROM ACC_JUNL

          SELECT @USE_ACC_CD = USE_ACC_CD1,                               
                 @AMT_W      = @COMM_VAT                               
            FROM ACC_JUNL WITH(NOLOCK)
           WHERE JUNL_FG = @JUNL_FG --'AI'                    
			AND JUNL_CD = 'A3'                    
                    
          EXEC @RET = SP_ACC_SLIPD_INS  @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD, '2', @SITE_CD, @PAN_DEPT_CD, @PAN_EMP_NO,                   
                                        @PRO_CODE, NULL, 0, @AMT_W, @REMARK, @EMP_NO                               

                                  
          IF @RET <> 0 GOTO ERR_HANDLER                                          
                    
      END 
	                     
      IF @CASH_AMT + @CARD_AMT - @COMM_AMT - @COMM_VAT <> 0                     
      BEGIN                    
         SELECT @USE_ACC_CD = USE_ACC_CD1,                                               
				@AMT_W      = @CASH_AMT + @CARD_AMT - @COMM_AMT - @COMM_VAT
           FROM ACC_JUNL WITH(NOLOCK)
          WHERE JUNL_FG = @JUNL_FG --'AI'                    
            AND JUNL_CD = 'A4'                    
                    
          EXEC @RET = SP_ACC_SLIPD_INS  @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD, '2', @SITE_CD, @PAN_DEPT_CD, @PAN_EMP_NO,                   
                                        @PRO_CODE, NULL, 0, @AMT_W, @REMARK, @EMP_NO                              
                    
                                                      
          IF @RET <> 0 GOTO ERR_HANDLER                       
                    
      END

      IF @CARD_AMT <> 0                
      BEGIN                    
         SELECT @USE_ACC_CD = USE_ACC_CD1,                                  
                @AMT_W      = @CARD_AMT                      
		   FROM ACC_JUNL WITH(NOLOCK)
          WHERE JUNL_FG = @JUNL_FG --'AI'                    
            AND JUNL_CD = 'A5'                   
                    
           EXEC @RET = SP_ACC_SLIPD_INS  @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD, '1', @SITE_CD, @PAN_DEPT_CD, @PAN_EMP_NO,                   
                                        @PRO_CODE, NULL, @AMT_W, 0, @REMARK, @EMP_NO                              
                    
                                  
          IF @RET <> 0 GOTO ERR_HANDLER                                                          
                    
                                  
                              
          SELECT @USE_ACC_CD = USE_ACC_CD2,                                   
                 @AMT_W      = @CARD_AMT                                                
           FROM ACC_JUNL WITH(NOLOCK)
          WHERE JUNL_FG = @JUNL_FG --'AI'                    
             AND JUNL_CD = 'A5'                    
                    
           EXEC @RET = SP_ACC_SLIPD_INS  @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD, '2', @SITE_CD, @PAN_DEPT_CD, @PAN_EMP_NO,                   
                                        @PRO_CODE, NULL, 0, @AMT_W, @REMARK, @EMP_NO                              
                    
                                                      
          IF @RET <> 0 GOTO ERR_HANDLER                                                         
                    
      END                    
                        
      SELECT @TOT_CARD_AMT = @TOT_CARD_AMT + @CARD_AMT,                    
             @TOT_CASH_AMT = @TOT_CASH_AMT + @CASH_AMT                  
                         
                    
      FETCH NEXT FROM CUR_1 INTO  @CASH_AMT,                  
								  @CARD_AMT,                    
                                  @TCK_CNT,                    
                                  @COMM_AMT,                    
                                  @COMM_VAT,                    
                                  @PAN_EMP_NO,                    
                                  @PAN_DEPT_CD,                    
                                  @MIN_TCK_NO,                    
                                  @MAX_TCK_NO,                    
                                  @AIR_CD_SHORT,                                                
                                  @START_DAY,
								  @ISSUE_CODE,
								  @ISSUE_DEPT_CD,
								  @OVERSEA_CHECK,
								  @GDS
    END                    
                    
CLOSE      CUR_1    
                  
DEALLOCATE CUR_1

                    
     IF  @TOT_CASH_AMT + @TOT_CARD_AMT <> 0                          
     BEGIN                         
                       
          DECLARE CUR_TCK_NO SCROLL CURSOR FOR


		WITH LIST AS
		(
			SELECT A.TICKET, DBO.FN_AIR_OVERSEA_CHECK(A.ROUTING) AS [OVERSEA_CHECK], A.GDS
			FROM DSR_TICKET A WITH(NOLOCK)
			WHERE
				A.PRO_CODE = @PRO_CODE
				AND A.ISSUE_DATE >= @TCKOUT_DAY AND A.ISSUE_DATE < DATEADD(DAY, 1, @TCKOUT_DAY)
				AND A.TICKET_STATUS = 1  /*정상티켓*/
				AND ISNULL(A.CASH_PRICE, 0) + ISNULL(A.CARD_PRICE, 0) <> 0
				AND NOT EXISTS (SELECT AA.TICKET FROM ACC_DSR_SLIP AA WITH(NOLOCK) WHERE AA.TICKET = A.TICKET)
				AND A.ISSUE_CODE <> '9999999'
		)
		SELECT Z.TICKET
		FROM LIST Z
		--WHERE ((@JUNL_FG = 'AI' AND Z.OVERSEA_CHECK = 'Y') OR (@JUNL_FG = 'AK' AND Z.OVERSEA_CHECK = 'N') OR (@DOMESTIC_YN = ''))
		WHERE ((@DOMESTIC_YN = 'N' AND Z.GDS <= 100) OR (@DOMESTIC_YN = 'Y' AND Z.GDS > 100))
		ORDER BY Z.TICKET;

/*
		SELECT A.TICKET
		FROM DSR_TICKET A WITH(NOLOCK)
		LEFT JOIN RES_CUSTOMER_damo C WITH(NOLOCK) ON A.RES_CODE = C.RES_CODE AND A.RES_SEQ_NO = C.SEQ_NO
		LEFT JOIN PUB_CITY D WITH(NOLOCK) ON A.CITY_CODE = D.CITY_CODE
		WHERE A.PRO_CODE = @PRO_CODE
			AND A.ISSUE_DATE = @TCKOUT_DAY
			AND A.TICKET_STATUS = 1  /*정상티켓*/
			AND ISNULL(A.CASH_PRICE, 0) + ISNULL(A.CARD_PRICE, 0) <> 0
			AND NOT EXISTS (SELECT AA.TICKET FROM ACC_DSR_SLIP AA WITH(NOLOCK) WHERE AA.TICKET = A.TICKET)
			AND ((@JUNL_FG = 'AI' AND D.NATION_CODE <> 'KR') OR (@JUNL_FG = 'AK' AND D.NATION_CODE = 'KR'))
		ORDER BY A.TICKET;
*/

          OPEN CUR_TCK_NO                  
                    
          FETCH NEXT FROM CUR_TCK_NO INTO @TCK_NO                                                                            
                      
          WHILE ( @@FETCH_STATUS <> -1 )                    
          BEGIN                      
                                              
             INSERT INTO ACC_DSR_SLIP  (TICKET, SLIP_MK_DAY, SLIP_MK_SEQ, INS_DT)                  
                               VALUES ( @TCK_NO, @SLIP_MK_DAY, @SLIP_MK_SEQ, DEFAULT )                   
                               
                               
             IF @RET <> 0 GOTO ERR_HANDLER                                                         
                    
                               
             FETCH NEXT FROM CUR_TCK_NO INTO @TCK_NO                                                                                                  
                       
                       
          END                    
                    
          CLOSE      CUR_TCK_NO                    
                    
                  
          DEALLOCATE CUR_TCK_NO                        
                       
     END                    
                    
                    
                    
COMMIT TRANSACTION                       
RETURN 0                      
                      
ERR_HANDLER:                      
  ROLLBACK TRANSACTION                      
  RETURN -1
GO
