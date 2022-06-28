USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_ACC_EV_SLIPD_INS_NEW
■ DESCRIPTION				: 행사 정산 전표 생성 시 사용되는 SP
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2012-08-13		투어소프트		최초생성
   2016-01-19		김성호			
   2019-01-17		김성호			수익부서 현재 담당자 현재 팀 가져오는 것으로 변경
   2019-08-28		김성호			수익부서 해당 행사 담당자 현재 팀에서 가져오는 것으로 변경 (전가영대리 요청)
   2020-11-25		김성호			단품상품 전표생성 로직 추가
   2021-06-01		김성호			지상비 항목을 이용하는 국내 항공 전표생성 예외처리 (PRO_TYPE, LAND_PRICE 활용)
   2022-01-04		김성호			여행수탁금 항목 (WHERE A.AMT_W > 0) 주석처리 (왜 필요한지 현재 파악 못함)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_ACC_EV_SLIPD_INS_NEW]
	@CHK CHAR(3), /* 체크 'NEW', 'ADD' */ 
	@PRO_CODE VARCHAR(20), /*        */ 
	@SLIP_MK_DAY CHAR(8), /* 전표일자          */ 
	@SLIP_MK_SEQ SMALLINT OUTPUT, /* 전표일련번호 */ 
	@EMP_NO VARCHAR(10) /* 사번              */
AS
	DECLARE @SLIP_FG CHAR(1)				 -- 분류
	       ,@DEB_SUM NUMERIC(12) = 0		 -- 차변값 합
	       ,@CRE_SUM NUMERIC(12) = 0		 -- 대변값 합
	       ,@JAN_AMT NUMERIC(12) = 0		 -- 차대변 합계
	       ,@SLIP_DET_CNT SMALLINT = 0		 -- 검색값 Row 수
	       ,@JUNL_FG VARCHAR(2) = 'EV'		 -- 분개전표구분 (EV: 일반, PV: 단품)
	
	DECLARE @USE_ACC_CD VARCHAR(10)			 -- 계정코드
	       ,@SITE_CD VARCHAR(10)			 -- 거래처코드
	       ,@INS_EMP_NO VARCHAR(10)			 -- 등록자 사번
	       ,@CALC_CD VARCHAR(4)				 -- 분개전표구분 (ACC_JUNL 테이블에서 세부 항목 확인가능)
	       ,@AMT_W NUMERIC(12)				 -- 거래금액
	       ,@DEB_AMT_W NUMERIC(12)			 -- 차변금액
	       ,@CRE_AMT_W NUMERIC(12)			 -- 대변금액
	       ,@REMARK VARCHAR(200)			 -- 비고
	       ,@BOHUM_SITE_CD VARCHAR(10)		 -- 보험사 거래처 코드
	       ,@DC_FG CHAR(1)					 -- 차대구분
	       ,@CHA_DEPT_CD VARCHAR(10)		 -- 행사담당팀코드
	       ,@CHA_DEPT_NM VARCHAR(50)		 -- 행사담당팀명
	       ,@MASTER_CODE VARCHAR(10)		 -- 마스터코드 
	       ,@PRO_NAME VARCHAR(400)			 -- 상품명
	       ,@PRO_EMP_CODE VARCHAR(10)		 -- 행상담당코드
	       ,@PRO_EMP_NAME VARCHAR(20)		 -- 행사담당자명
	       ,@RET INT						 -- 에러체크
	       ,@FG_NM1 VARCHAR(40)				 -- 더존 전달 필수
	       ,@FG_NM2 VARCHAR(40)				 -- 더존 전달 필수
	       ,@FG_NM3 VARCHAR(40)				 -- 더존 전달 필수
	       ,@PRO_TYPE INT					 -- 상품타입
	
	BEGIN TRANSACTION 
	
	-- 수익팀코드 190928
	SELECT @MASTER_CODE = PD.MASTER_CODE
	      ,@PRO_NAME = CONVERT(VARCHAR(40), PD.PRO_NAME) -- 상품명 
	      ,@BOHUM_SITE_CD = PD.INS_CODE -- 보험사거래처코드
	      ,@PRO_EMP_CODE = PD.NEW_CODE -- 담당자코드
	      ,@PRO_EMP_NAME = EM.KOR_NAME -- 담당자명
	      ,@CHA_DEPT_CD = EM.TEAM_CODE -- 담당부서코드
	      ,@CHA_DEPT_NM = ET.TEAM_NAME -- 담당부서명
	      ,@JUNL_FG = (CASE WHEN PM.ATT_CODE = '1' THEN 'PV' ELSE @JUNL_FG END)
	      ,@PRO_TYPE = ISNULL((SELECT MAX(PRO_TYPE) FROM RES_MASTER_damo WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE), 1)	-- 1: 패키지, 2: 항공, 3:호텔
	      ,@REMARK = '[정산] ' + SM.PRO_CODE + ' / ' + ET.TEAM_NAME + ' / ' + EM.KOR_NAME   
	FROM   SET_MASTER SM WITH(NOLOCK)
	       INNER JOIN PKG_DETAIL PD WITH(NOLOCK)
	            ON  SM.PRO_CODE = PD.PRO_CODE
	       INNER JOIN PKG_MASTER PM WITH(NOLOCK)
	            ON  PD.MASTER_CODE = PM.MASTER_CODE
	       INNER JOIN EMP_MASTER_damo EM WITH(NOLOCK)
	            ON  PD.NEW_CODE = EM.EMP_CODE
	       INNER JOIN EMP_TEAM ET WITH(NOLOCK)
	            ON  EM.TEAM_CODE = ET.TEAM_CODE
	WHERE  SM.PRO_CODE = @PRO_CODE;
	
	DECLARE CUR_1 SCROLL CURSOR 
	FOR
	
			SELECT *
			FROM (
	    		SELECT 'A' AS [CALC_CD]
	    			  ,NULL AS [SITE_CD]
	    			  ,@PRO_EMP_CODE AS [INS_EMP_NO]
	    			  ,'1' AS [DC_FG]
	    			  , ISNULL((
	    	      		SELECT
	    	      			CASE
	    	      				WHEN SGC.LAND_PRICE > 0 AND @PRO_TYPE = 2 THEN (SGC.SALE_PRICE - SGC.LAND_PRICE)
	    	      				ELSE (SALE_PRICE - AIR_PRICE - AIR_PROFIT - AIR_ETC_PRICE + AIR_ETC_PROFIT)	-- 총경비
	    	      			END
	    	      		FROM DBO.FN_SET_GET_COMPLETE(@PRO_CODE) SGC
	    			  ), 0) AS [AMT_W]
--		    	      ,(CASE WHEN @JUNL_FG = 'EV' THEN '여행수탁금' ELSE '외상매출금' END) AS [REMARK]
	    			  ,NULL AS [FG_NM1]
	    			  ,@MASTER_CODE AS [FG_NM2]
	    			  ,@PRO_NAME AS [FG_NM3]
	    		FROM   SET_MASTER A WITH(NOLOCK)
	    		WHERE  A.PRO_CODE = @PRO_CODE
	    			   AND NOT EXISTS (SELECT P.PRO_CODE FROM ACC_EV_SLIP P WITH(NOLOCK) WHERE P.PRO_CODE = A.PRO_CODE)	-- 중복방지
			) A
			--WHERE A.AMT_W > 0
	    	UNION ALL
	    	SELECT --'B' AS [CALC_CD],
	               (CASE
	               		WHEN DATEDIFF(DAY ,B.DEP_DATE ,ISNULL(C.RCV_DATE ,'2050-01-01')) < 0 AND A.PAY_PRICE > 0 THEN '1' 
	               		WHEN DATEDIFF(DAY ,B.DEP_DATE ,ISNULL(C.RCV_DATE ,'2050-01-01')) >= 0 AND A.PAY_PRICE > 0 THEN '2' 
	               		WHEN DATEDIFF(DAY ,B.DEP_DATE ,ISNULL(C.RCV_DATE ,'2050-01-01')) < 0 AND A.PAY_PRICE < 0 THEN '3' 
	               		WHEN DATEDIFF(DAY ,B.DEP_DATE ,ISNULL(C.RCV_DATE ,'2050-01-01')) >= 0 AND A.PAY_PRICE < 0 THEN '4' 
	               		ELSE '2' 
	               	END) AS [CALC_CD]
	    	      ,A.AGT_CODE AS [SITE_CD]
	    	      ,@PRO_EMP_CODE AS [INS_EMP_NO]
	    	      ,'2' AS [DC_FG]
	    	      ,A.PAY_PRICE AS [AMT_W]
--	    	      ,'지상비' AS [REMARK]
	    	      ,'G4' AS [FG_NM1]
	    	      ,A.PRO_CODE AS [FG_NM2]
	    	      ,CONVERT(VARCHAR(3) ,A.LAND_SEQ_NO) AS [FG_NM3]
	    	FROM   SET_LAND_AGENT A WITH(NOLOCK)
	    	       INNER JOIN PKG_DETAIL B WITH(NOLOCK)
	    	            ON  A.PRO_CODE = B.PRO_CODE
	    	       LEFT JOIN EDI_MASTER_damo C WITH(NOLOCK)
	    	            ON  A.EDI_CODE = C.EDI_CODE
	    	WHERE  A.PRO_CODE = @PRO_CODE
	    	       AND A.PAY_PRICE <> 0
	    	       AND @JUNL_FG <> 'PV' -- 단품상품 제외
	    	       AND @PRO_TYPE <> 2	-- 실시간 항공 제외
	    	       AND NOT EXISTS (SELECT P.PRO_CODE FROM ACC_EV_SLIP P WITH(NOLOCK) WHERE P.PRO_CODE = A.PRO_CODE)	-- 중복방지
	    	UNION ALL
	    	SELECT --'C',
					(CASE
						WHEN DATEDIFF(DAY, B.DEP_DATE, ISNULL(C.RCV_DATE, '2050-01-01')) < 0 AND A.PRICE > 0 THEN '1'
						WHEN DATEDIFF(DAY, B.DEP_DATE, ISNULL(C.RCV_DATE, '2050-01-01')) >= 0 AND A.PRICE > 0 THEN '2'
						WHEN DATEDIFF(DAY, B.DEP_DATE, ISNULL(C.RCV_DATE, '2050-01-01')) < 0 AND A.PRICE < 0 THEN '3'
						WHEN DATEDIFF(DAY, B.DEP_DATE, ISNULL(C.RCV_DATE, '2050-01-01')) >= 0 AND A.PRICE < 0 THEN '4'
						ELSE '2'
					END) AS [CALC_CD]
	    	      ,'90052' AS [SITE_CD]
	    	      ,@PRO_EMP_CODE AS [INS_EMP_NO]
	    	      ,'2' AS [DC_FG]
	    	      ,A.PRICE AS [AMT_W]
--	    	      ,'공동경비' AS [REMARK]
	    	      ,'G3' AS [FG_NM1]
	    	      ,A.PRO_CODE AS [FG_NM2]
	    	      ,CONVERT(VARCHAR(3) ,A.GRP_SEQ_NO) AS [FG_NM3]
	    	FROM   SET_GROUP A WITH(NOLOCK)
	    	       INNER JOIN PKG_DETAIL B WITH(NOLOCK)
	    	            ON  A.PRO_CODE = B.PRO_CODE
	    	       LEFT JOIN EDI_MASTER_damo C WITH(NOLOCK)
	    	            ON  A.EDI_CODE = C.EDI_CODE
	    	WHERE  A.PRO_CODE = @PRO_CODE
	    	       AND A.KOREAN_PRICE <> 0
	    	       AND @JUNL_FG <> 'PV' -- 단품상품 제외
	    	       AND NOT EXISTS (SELECT P.PRO_CODE FROM ACC_EV_SLIP P WITH(NOLOCK) WHERE P.PRO_CODE = A.PRO_CODE)	-- 중복방지
	    	UNION ALL
	    	SELECT A.CALC_CD, A.SITE_CD, A.INS_EMP_NO, A.DC_FG, A.AMT_W, A.FG_NM1, A.FG_NM2, A.FG_NM3 
	    	FROM (
	    		SELECT 'D' AS [CALC_CD]
	    			  ,@BOHUM_SITE_CD AS [SITE_CD]
	    			  ,@PRO_EMP_CODE AS [INS_EMP_NO]
	    			  ,'2' AS [DC_FG]
	    			  ,SUM(A.INS_PRICE) AS [AMT_W]
--	    			  ,'보험료' AS [REMARK]
	    			  ,NULL AS [FG_NM1]
	    			  ,NULL AS [FG_NM2]
	    			  ,NULL AS [FG_NM3]
	    		FROM   SET_CUSTOMER A WITH(NOLOCK)
	    		WHERE  PRO_CODE = @PRO_CODE
	    			   AND A.INS_PRICE <> 0
	    			   AND NOT EXISTS (SELECT P.PRO_CODE FROM ACC_EV_SLIP P WITH(NOLOCK) WHERE P.PRO_CODE = A.PRO_CODE)	-- 중복방지
	    	) A
	    	WHERE LEN(A.SITE_CD) > 0
	    	
	    	UNION ALL
	    	
	    	SELECT 'R' AS [CALC_CD]
	    	      ,A.AGT_CODE AS [SITE_CD]
	    	      ,@PRO_EMP_CODE AS [INS_EMP_NO]
	    	      ,'1' AS [DC_FG]
	    	      ,(A.PAY_PRICE * 10 / 11) AS [AMT_W]
--	    	      ,'매출원가' AS [REMARK]
	    	      ,NULL AS [FG_NM1]
	    	      ,@MASTER_CODE AS [FG_NM2]
	    	      ,@PRO_NAME AS [FG_NM3]
	    	FROM SET_LAND_AGENT A WITH(NOLOCK)
	    	WHERE  A.PRO_CODE = @PRO_CODE
	    	       AND A.PAY_PRICE <> 0
	    	       AND @JUNL_FG = 'PV' -- 단품상품 만
	    	       AND NOT EXISTS (SELECT P.PRO_CODE FROM ACC_EV_SLIP P WITH(NOLOCK) WHERE P.PRO_CODE = A.PRO_CODE)
	    	UNION ALL
	    	SELECT 'S' AS [CALC_CD]
	    	      ,A.AGT_CODE AS [SITE_CD]
	    	      ,@PRO_EMP_CODE AS [INS_EMP_NO]
	    	      ,'2' AS [DC_FG]
	    	      ,(A.PAY_PRICE * 10 / 11) AS [AMT_W]
--	    	      ,'상품' AS [REMARK]
	    	      ,NULL AS [FG_NM1]
	    	      ,@MASTER_CODE AS [FG_NM2]
	    	      ,@PRO_NAME AS [FG_NM3]
	    	FROM SET_LAND_AGENT A WITH(NOLOCK)
	    	WHERE  A.PRO_CODE = @PRO_CODE
	    	       AND A.PAY_PRICE <> 0
	    	       AND @JUNL_FG = 'PV' -- 단품상품 만
	    	       AND NOT EXISTS (SELECT P.PRO_CODE FROM ACC_EV_SLIP P WITH(NOLOCK) WHERE P.PRO_CODE = A.PRO_CODE)
	    	 
	    	       
	    	ORDER BY
	    	       1;
	
	OPEN CUR_1 
	
	FETCH NEXT FROM CUR_1 INTO @CALC_CD , -- 분개전표구분 (ACC_JUNL 테이블에서 세부 항목 확인가능)
	@SITE_CD , -- 거래처코드
	@INS_EMP_NO , -- 등록자 사번
	@DC_FG , -- 차변: 1, 대변: 2
	@AMT_W , -- 금액
--	@REMARK , -- 비고
	@FG_NM1 , -- 사용자 비고1 (EX. G4)
	@FG_NM2 , -- 사용자 비고2 (EX. EPP100-151208)
	@FG_NM3 -- 사용자 비고3 (EX. 1) 순번
	
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
	    IF @CHK = 'NEW'
	    BEGIN
	        SELECT @SLIP_FG = '3' /* 수입(1) 지출(2) 대체(3) */ 
	        EXEC @SLIP_MK_SEQ = SP_ACC_SLIPM_SEQ @SLIP_MK_DAY, @EMP_NO, @SLIP_FG, @JUNL_FG
	        SET @CHK = 'ADD'
	    END                     
	    
--	    SELECT @REMARK = '[정산] ' + @PRO_CODE + ' / ' + @CHA_DEPT_NM + ' / ' + @PRO_EMP_NAME   
	    
	    IF ISNULL(@AMT_W ,0) <> 0
	    BEGIN
	    	
	        SELECT 
			      @USE_ACC_CD = CASE 
	                                  WHEN USE_ACC_CD1 IS NULL THEN USE_ACC_CD2
	                                  ELSE USE_ACC_CD1
	                             END
	              ,@DEB_AMT_W = CASE 
	                                 WHEN USE_ACC_CD1 IS NULL THEN 0
	                                 ELSE (@AMT_W * (CASE WHEN @CALC_CD = '4' THEN -1 ELSE 1 END))
	                            END
	              ,@CRE_AMT_W = CASE 
	                                 WHEN USE_ACC_CD2 IS NULL THEN 0
	                                 ELSE (@AMT_W * (CASE WHEN @CALC_CD = '4' THEN -1 ELSE 1 END))
	                            END
	              ,@DC_FG = CASE 
	                             WHEN USE_ACC_CD1 IS NULL THEN '2'
	                             ELSE '1'
	                        END
	               --@DEB_AMT_W = CASE WHEN @DC_FG = '1' THEN @AMT_W ELSE 0 END,
	               --@CRE_AMT_W = CASE WHEN @DC_FG = '2' THEN @AMT_W ELSE 0 END
	        FROM   ACC_JUNL WITH(NOLOCK)
	        WHERE  JUNL_FG = CASE 
	                              WHEN @FG_NM1 IN ('G3' ,'G4') THEN 'EG'
	                              ELSE @JUNL_FG
	                         END
	               AND JUNL_CD = @CALC_CD 
	        
	        EXEC @RET = SP_ACC_SLIPD_INS_NEW @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD, @DC_FG, @SITE_CD, @CHA_DEPT_CD, @INS_EMP_NO, 
	        @PRO_CODE, NULL,@DEB_AMT_W, @CRE_AMT_W, @REMARK, @EMP_NO, @FG_NM1, @FG_NM2, @FG_NM3                              
	        
	        IF @RET <> 0
	            GOTO ERR_HANDLER 
	        
	        -- 차변/대변 합 계산
	        SELECT @DEB_SUM = @DEB_SUM + @DEB_AMT_W
	              ,@CRE_SUM = @CRE_SUM + @CRE_AMT_W
	              ,--@DEB_SUM = @DEB_SUM + (CASE WHEN @DC_FG = '1' THEN @DEB_AMT_W ELSE 0 END),
	               --@CRE_SUM = @CRE_SUM + (CASE WHEN @DC_FG = '1' THEN 0 ELSE @CRE_AMT_W END),
	               @SLIP_DET_CNT = @SLIP_DET_CNT + 1
	    END 
	    
	    FETCH NEXT FROM CUR_1 INTO @CALC_CD , 
	    @SITE_CD , 
	    @INS_EMP_NO , 
	    @DC_FG , 
	    @AMT_W , 
--	    @REMARK ,
	    @FG_NM1 ,
	    @FG_NM2 ,
	    @FG_NM3
	END
	
	/* CURSOR CLOSE */ 
	CLOSE CUR_1 
	
	/* CURSOR DEALLOCATE */ 
	DEALLOCATE CUR_1 
	
	
	-- 차변 - 대변
	SELECT @JAN_AMT = ISNULL(@DEB_SUM ,0) - ISNULL(@CRE_SUM ,0) 
	
	-- 차/대변 차이를 이용해 여행알선수수료 생성                   
	IF @JAN_AMT <> 0
	BEGIN
	    /* 여행알선수수료 */
	    
	    SELECT @USE_ACC_CD = USE_ACC_CD2
	          ,@DC_FG = '2'
	          ,@SITE_CD = NULL
	          ,@DEB_AMT_W = 0
	          ,@CRE_AMT_W = CASE 
	                             WHEN @JAN_AMT < 0 THEN @JAN_AMT
	                             ELSE @JAN_AMT * 10 / 11
	                        END
	    FROM   ACC_JUNL WITH(NOLOCK)
	    WHERE  JUNL_FG = @JUNL_FG
	           AND JUNL_CD = 'P'	-- EV: 여행알선수수료, PV: 상품매출
	           
		EXEC @RET = SP_ACC_SLIPD_INS_NEW @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD, @DC_FG, @SITE_CD, @CHA_DEPT_CD, @INS_EMP_NO, 
	        @PRO_CODE, NULL,@DEB_AMT_W, @CRE_AMT_W, @REMARK, @EMP_NO, NULL, @MASTER_CODE, @PRO_NAME
	    
	    -- 마이너스 금액은 예수부가세 항목이 없음
	    IF @JAN_AMT > 0
	    BEGIN
	        /* 예수부가세 */       
	        SELECT @USE_ACC_CD = USE_ACC_CD2
	              ,@DC_FG = '2'
	              ,@SITE_CD = NULL
	              ,@DEB_AMT_W = 0
	              ,@CRE_AMT_W = @JAN_AMT * 1 / 11
	        FROM   ACC_JUNL WITH(NOLOCK)
	        WHERE  JUNL_FG = @JUNL_FG
	               AND JUNL_CD = 'Q'
	        
	        EXEC @RET = SP_ACC_SLIPD_INS @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD, @DC_FG, @SITE_CD, @CHA_DEPT_CD, @INS_EMP_NO, 
				@PRO_CODE, NULL, @DEB_AMT_W, @CRE_AMT_W, @REMARK, @EMP_NO
	    END
	    
	    IF @RET <> 0
	        GOTO ERR_HANDLER
	END
	
	-- ACC_EV_SLIP 저장
	IF ISNULL(@DEB_SUM ,0) <> 0
	   OR ISNULL(@CRE_SUM ,0) <> 0
	   OR @SLIP_DET_CNT > 0
	BEGIN
	    INSERT INTO ACC_EV_SLIP
	      (
	        PRO_CODE
	       ,SLIP_MK_DAY
	       ,SLIP_MK_SEQ
	       ,INS_DT
	      )
	    VALUES
	      (
	        @PRO_CODE
	       ,@SLIP_MK_DAY
	       ,@SLIP_MK_SEQ
	       ,DEFAULT
	      )
	    
	    IF @RET <> 0
	        GOTO ERR_HANDLER
	END
	
	
	COMMIT TRANSACTION 
	RETURN 0

ERR_HANDLER: 
	ROLLBACK TRANSACTION 
	RETURN -1 
	
	
	
	/*      
	UPDATE ACC_JUNL SET USE_ACC_CD1 = NULL, USE_ACC_CD2 = '27500' WHERE JUNL_FG = 'EV' AND JUNL_CD = 'B'
	UPDATE ACC_JUNL SET USE_ACC_CD1 = NULL, USE_ACC_CD2 = '27500' WHERE JUNL_FG = 'EV' AND JUNL_CD = 'C'
	UPDATE ACC_JUNL SET USE_ACC_CD1 = NULL, USE_ACC_CD2 = '25300' WHERE JUNL_FG = 'EV' AND JUNL_CD = 'D'
	
	INSERT INTO ACC_JUNL (JUNL_FG, JUNL_CD, JUNL_CD_NM, USE_ACC_CD1, USE_ACC_CD2, REMARK, DEL_YN)
	VALUES ('EG', '1', '선급금', '13100', NULL, '정산전표-선급금', 'N')
	
	INSERT INTO ACC_JUNL (JUNL_FG, JUNL_CD, JUNL_CD_NM, USE_ACC_CD1, USE_ACC_CD2, REMARK, DEL_YN)
	VALUES ('EG', '2', '미지급랜드', '27500', NULL, '정산전표-미지급랜드', 'N')
	
	INSERT INTO ACC_JUNL (JUNL_FG, JUNL_CD, JUNL_CD_NM, USE_ACC_CD1, USE_ACC_CD2, REMARK, DEL_YN)
	VALUES ('EG', '3', '선급금(마이너스)', '13100', NULL, '정산전표-선급금(마이너스)', 'N')
	
	INSERT INTO ACC_JUNL (JUNL_FG, JUNL_CD, JUNL_CD_NM, USE_ACC_CD1, USE_ACC_CD2, REMARK, DEL_YN)
	VALUES ('EG', '4', '미수금', '12000', NULL, '정산전표-미수금', 'N')

	select * from ACC_JUNL where JUNL_FG in ('ev', 'eg')
	
	
	SELECT * FROM .DIABLO.DBO.ACC_JUNL
	
	*/
GO
