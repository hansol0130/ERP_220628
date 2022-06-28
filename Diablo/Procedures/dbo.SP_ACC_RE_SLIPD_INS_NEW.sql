USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_ACC_RE_SLIPD_INS_NEW
■ DESCRIPTION				: 입금전표생성
■ INPUT PARAMETER			: 
	@CHK					: 체크 'NEW', 'ADD'
	@SLIP_MK_DAY			: 전표일자
	@SLIP_MK_SEQ			: 전표일련번호
	@PAY_SEQ				: 입금내역
	@MCH_SEQ				: 매칭순번
	@EMP_NO					: 등록자코드
■ OUTPUT PARAMETER			: 
	@SLIP_MK_SEQ			: 전표일련번호
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2010-04-15		투어소프트		최초생성
   2011-06-01		김성호			PG 결제 시 결제사에 따라 더존 변경 되게 수정
   2014-06-19		김성호			ACC_SLIPD 항목이 1000이상일때 ACC_SLIPM 분할 작업
   2014-07-12		김성호			SP 분리 작업
   2015-04-28		김성호			함수 세팅 시 오류 수정 (CTE 이용 UNION 후 변수에 저장)
   2015-04-29		김성호			미수금대체 MALL_ID 입력되게 수정
   2017-12-13		김성호			계좌번호 ACC_CODE 테이블 참조하여 변환
   2018-01-10		김성호			ACC_CODE 테이블 미등록 계좌는 값 그대로 리턴하도록 수정
   2019-07-04		김성호			@MALL_ID VARCHAR(8) -> VARCHAR(10)으로 사이즈 수정
   2020-11-26		김성호			단품상품 입금 시 대변 계정코드 고정 (외상매출금:12400)
   2021-08-20		김성호			포인트구매실적 전표 생성 시 거래처코드 고정 등록 (18091)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_ACC_RE_SLIPD_INS_NEW]
   @CHK          CHAR(3),          /* 체크 'NEW', 'ADD' */                            
   @SLIP_MK_DAY  CHAR(8),          /* 전표일자 */                            
   @SLIP_MK_SEQ  SMALLINT OUTPUT,  /* 전표일련번호 */                            
   @PAY_SEQ      INT,              /*----- 입금내역 PK -----*/                             
   @MCH_SEQ      INT,                 
   @EMP_NO       EMP_CODE          /* 등록사번 */
AS
BEGIN
	DECLARE @SLIP_FG      CHAR(1),    /* 수입(1) 지출(2) 대체(3) */                            
		    @SLIP_DET_SEQ SMALLINT    /* 전표DETAIL 일련번호 */                             
                                  
	DECLARE @USE_ACC_CD1   VARCHAR(10),      /* 차변 계정코드 */                            
			@USE_ACC_CD2   VARCHAR(10),      /* 대변 계정코드 */                            
			@DEB_AMT_W     NUMERIC(12),      /* 차변금액 */                            
			@CRE_AMT_W     NUMERIC(12),      /* 대변금액 */                            
			@AMT_W         NUMERIC(12),      /* 대변금액 */                            
			@REMARK        VARCHAR(200),     /* 비고1 */                                             
			@DEB_USE_ACC_CD CHAR(10),       /* 차변 계정 */                            
			@CRE_USE_ACC_CD CHAR(10),       /* 대변 계정 */                            
			@EV_NO         VARCHAR(20),                            
			@EV_NM         VARCHAR(200),                            
			@START_DAY     CHAR(8),                                    
			@IN_EMP_NO     VARCHAR(10),      /* 입금자사번 */                                 
			@RES_NM        VARCHAR(20),      /* 예약자명 */                            
			@IN_NM         VARCHAR(20),      /* 입금고객명 */                                                    
			@SITE_CD       VARCHAR(10),                                   
			@DEPT_CD       VARCHAR(10),                                   
			@PAY_TYPE      INT,                            
			@PAY_SUB_TYPE  VARCHAR(50),                            
			@PAY_SUB_NAME  VARCHAR(50),                            
			@SAVE_ACC_NO   VARCHAR(20),                                    
			@RES_CODE      VARCHAR(20),                            
			@IO_DAY        VARCHAR(8),                           
			@JUNL_FG       VARCHAR(2),            
			@PAY_TYPE_NM   VARCHAR(20),          
			@RET           INT,
			@MALL_ID		VARCHAR(10),
			@FG_NM1			VARCHAR(40),
			@FG_NM2			VARCHAR(40),
			@FG_NM3			VARCHAR(40)
                                  
	BEGIN TRANSACTION

	-- 결제 타입 검색
	SELECT @PAY_TYPE_NM = B.PUB_VALUE
	FROM PAY_MASTER_damo A WITH(NOLOCK)
	LEFT JOIN COD_PUBLIC B WITH(NOLOCK) ON B.PUB_TYPE = 'PAY.PAYMENTTYPE' AND A.PAY_TYPE = B.PUB_CODE
	WHERE A.PAY_SEQ = @PAY_SEQ;
	
	/* @JUNL_FG 'PR' 선수 'RE' 예약 'EC' 기타 */
	WITH LIST AS 
	(
		SELECT
			'PR' AS [JUNL_FG],                        
			CONVERT(CHAR(8), A.PAY_DATE, 112) AS [IO_DAY],                             
			A.PAY_TYPE AS [PAY_TYPE],
			A.PAY_SUB_TYPE AS [PAY_SUB_TYPE],
			A.PAY_SUB_NAME AS [PAY_SUB_NAME],
			(CASE WHEN A.PAY_TYPE = '0' THEN DAMO.DBO.DEC_VARCHAR('DIABLO','DBO.PAY_MASTER','PAY_NUM', A.SEC_PAY_NUM) END) AS [SAVE_ACC_NO],  /* 예금계좌 */
			(A.PAY_PRICE - ISNULL((SELECT SUM(P.PART_PRICE) FROM PAY_MATCHING P WHERE P.PAY_SEQ = A.PAY_SEQ AND P.CXL_YN = 'N'),0)) AS [DEB_AMT_W],                                 
			(A.PAY_PRICE - ISNULL((SELECT SUM(P.PART_PRICE) FROM PAY_MATCHING P WHERE P.PAY_SEQ = A.PAY_SEQ AND P.CXL_YN = 'N'),0)) AS [CRE_AMT_W],        
			(A.PAY_PRICE - ISNULL((SELECT SUM(P.PART_PRICE) FROM PAY_MATCHING P WHERE P.PAY_SEQ = A.PAY_SEQ AND P.CXL_YN = 'N'),0)) AS [AMT_W],
			NULL AS [EV_NO],                          
			A.PAY_NAME AS [IN_NM],
			A.AGT_CODE AS [SITE_CD],
			A.NEW_CODE AS [IN_EMP_NO],
			('[선수입금' + @PAY_TYPE_NM + '] ' +  A.PAY_NAME + ' '  + ISNULL(A.PAY_REMARK, '')) AS [REMARK],
			NULL AS [RES_CODE],                          
			(SELECT B.TEAM_CODE FROM EMP_MASTER_damo B WHERE B.EMP_CODE = A.NEW_CODE) AS [DEPT_CD],
			A.MALL_ID
		FROM PAY_MASTER_DAMO A                            
		WHERE A.PAY_SEQ = @PAY_SEQ AND @MCH_SEQ = 0		-- 매칭순번이 없는 경우가 선수입금
			AND A.PAY_PRICE > ISNULL((SELECT SUM(P.PART_PRICE) FROM PAY_MATCHING P WHERE P.PAY_SEQ = A.PAY_SEQ AND P.CXL_YN = 'N'),0)                  
			AND NOT EXISTS (SELECT P.PAY_SEQ FROM ACC_PR_SLIP P WHERE P.PAY_SEQ =  A.PAY_SEQ AND P.SLIP_MK_SEQ > 0)
		UNION
		SELECT
			(CASE WHEN B.RES_CODE = 'R00000000000' THEN 'ET' ELSE 'RE' END),
			CONVERT(CHAR(8), A.PAY_DATE, 112),
			A.PAY_TYPE,                        
			A.PAY_SUB_TYPE,                                  
			A.PAY_SUB_NAME,                                  
			(CASE WHEN A.PAY_TYPE = '0' THEN DAMO.DBO.DEC_VARCHAR('DIABLO','DBO.PAY_MASTER','PAY_NUM', A.SEC_PAY_NUM) END),  /* 예금계좌 */                                  
			B.PART_PRICE,                            
			B.PART_PRICE,                                   
			B.PART_PRICE,                                   
			B.PRO_CODE,                        
			A.PAY_NAME,                            
			A.AGT_CODE,                            
			A.NEW_CODE,                          
			(A.PAY_NAME + ' '  + ISNULL(A.PAY_REMARK, '')),                           
			B.RES_CODE,                          
			(SELECT B.TEAM_CODE FROM EMP_MASTER_damo B WHERE B.EMP_CODE = A.NEW_CODE),
			A.MALL_ID
		FROM PAY_MASTER_DAMO A, PAY_MATCHING B
		WHERE A.PAY_SEQ = @PAY_SEQ AND A.PAY_SEQ = B.PAY_SEQ AND B.MCH_SEQ = @MCH_SEQ AND B.CXL_YN = 'N'
			AND NOT EXISTS (SELECT P.PAY_SEQ FROM ACC_RE_SLIP P WHERE P.PAY_SEQ = A.PAY_SEQ AND P.MCH_SEQ = B.MCH_SEQ AND P.SLIP_MK_SEQ > 0)
	)
	SELECT
		@JUNL_FG = A.JUNL_FG,
		@IO_DAY = A.IO_DAY,
		@PAY_TYPE = A.PAY_TYPE,
		@PAY_SUB_TYPE = A.PAY_SUB_TYPE,                                  
		@PAY_SUB_NAME = A.PAY_SUB_NAME,                                  
--		@SAVE_ACC_NO = A.SAVE_ACC_NO,
		-- 계좌번호 ACC_CODE 테이블 참조하여 변환
		@SAVE_ACC_NO =	ISNULL((SELECT REPLACE(DZ_NAME, '-', '') FROM ACC_CODE A1 WITH(NOLOCK) WHERE A1.CD_FG = 'BACC' AND A1.CD = A.SAVE_ACC_NO), A.SAVE_ACC_NO),
		@DEB_AMT_W = A.DEB_AMT_W,
		@CRE_AMT_W = A.CRE_AMT_W,
		@AMT_W = A.AMT_W,
		@EV_NO = A.EV_NO,
		@IN_NM = A.IN_NM,
		@SITE_CD = A.SITE_CD,
		@IN_EMP_NO = A.IN_EMP_NO,
		@REMARK = A.REMARK,
		@RES_CODE = A.RES_CODE,
		@DEPT_CD = A.DEPT_CD,
		@MALL_ID = A.MALL_ID
	FROM LIST A
	LEFT JOIN PKG_DETAIL B WITH(NOLOCK) ON A.EV_NO = B.PRO_CODE
	LEFT JOIN PKG_MASTER C WITH(NOLOCK) ON B.MASTER_CODE = C.MASTER_CODE;

	IF @JUNL_FG = 'RE'			-- 예약
	BEGIN
		SELECT @RES_NM      = '예약자:' + C.RES_NAME,                        
				@IN_EMP_NO   = C.PROFIT_EMP_CODE,                        
				@DEPT_CD     = C.PROFIT_TEAM_CODE,                        
				@START_DAY   = CONVERT(CHAR(8), D.DEP_DATE, 112),            
				@REMARK      = '[예약입금-' + @PAY_TYPE_NM + '] ' + @IN_NM + ' ' + D.PRO_CODE + ' ' +  D.PRO_NAME        
		FROM RES_MASTER_DAMO C,PKG_DETAIL D                           
		WHERE RES_CODE =  @RES_CODE                        
		AND C.PRO_CODE = D.PRO_CODE
	END
	ELSE IF @JUNL_FG = 'ET'		-- 기타
	BEGIN
		SELECT @REMARK      = '[기타입금-' + @PAY_TYPE_NM + '] ' + @REMARK             
	END

    --@REMARK      = ISNULL(A.PAY_REMARK, CONVERT(CHAR(10), CONVERT(DATETIME, D.DEP_DATE), 111) + ', ' +  C.PRO_NAME),         

	-- 회계기초코드관리 ACC_CODE 예외처리
	IF  @PAY_TYPE = 4				-- 상품권
		SET @SITE_CD = '18095'		-- 관광상품권
	ELSE IF @PAY_TYPE = 12			-- TASF
		SET @SITE_CD = '80023'		-- 이니시스
	ELSE IF @PAY_TYPE = 71			-- 포인트_구매실적
		SET @SITE_CD = '18091'		-- 포인트(구매실적)
	ELSE IF @PAY_TYPE =  2			-- OFF신용카드
		SELECT @SITE_CD = CD		-- 카드명으로 코드 검색
		FROM ACC_CODE
		WHERE CD_FG = 'CARD' AND CD_NM = @PAY_SUB_NAME

	-- 전표마스터 생성
    IF @CHK = 'NEW'  AND  @AMT_W <> 0                          
    BEGIN
        SELECT @SLIP_FG = '3' /* 대체전표 */                            
        EXEC @SLIP_MK_SEQ = SP_ACC_SLIPM_SEQ @SLIP_MK_DAY, @EMP_NO, @SLIP_FG, @JUNL_FG
    END
	-- 더존 제한으로 인해 항목 수가 1000이 넘으면 안된다.
	ELSE IF @AMT_W <> 0 AND (SELECT COUNT(*) FROM ACC_SLIPD WHERE SLIP_MK_DAY = @SLIP_MK_DAY AND SLIP_MK_SEQ = @SLIP_MK_SEQ) >= 1000
	BEGIN
		SELECT @SLIP_FG = '3' /* 대체전표 */
		EXEC @SLIP_MK_SEQ = SP_ACC_SLIPM_SEQ @SLIP_MK_DAY, @EMP_NO, @SLIP_FG, @JUNL_FG
	END

	-- 관리항목 4: 상품권
	IF @PAY_TYPE = 4
	BEGIN
		SELECT @USE_ACC_CD1 = USE_ACC_CD1, @USE_ACC_CD2 = USE_ACC_CD2
		  FROM ACC_JUNL                          
		 WHERE JUNL_FG = @JUNL_FG                            
		   AND JUNL_CD = CASE @PAY_SUB_NAME WHEN '본사상품권' THEN '40'
											WHEN '관광상품권' THEN '43'        
											ELSE '4' END
	END
	ELSE
	BEGIN
        SELECT @USE_ACC_CD1 = USE_ACC_CD1, @USE_ACC_CD2 = USE_ACC_CD2
          FROM ACC_JUNL                          
         WHERE JUNL_FG = @JUNL_FG                            
           AND JUNL_CD = CONVERT(VARCHAR(10),@PAY_TYPE)
	END

	-- 관리항목1은 예약코드
	SELECT @FG_NM1 = @RES_CODE, @FG_NM2 = NULL, @FG_NM3 = NULL

	-- 차변
    IF @DEB_AMT_W  <> 0                             
    BEGIN
		  -- 세금계산서는 금액의 1.1% 적용
          IF @PAY_TYPE = 9
             SELECT @DEB_AMT_W  = @DEB_AMT_W * 10 / 11

          -- 관리항목 세팅
          IF @USE_ACC_CD1 = '12300'	-- 미수금대체
             SET @FG_NM2 = @MALL_ID

          EXEC @RET = SP_ACC_SLIPD_INS_NEW  @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD1, '1', @SITE_CD, @DEPT_CD, @IN_EMP_NO, @EV_NO, @SAVE_ACC_NO, @DEB_AMT_W, 0, @REMARK, @EMP_NO, @FG_NM1, @FG_NM2, @FG_NM3
                                                              
          IF @RET <> 0 GOTO ERR_HANDLER                               
                      
			-- 세금계산서일때는 선급부가세 한번 더 등록
          IF @PAY_TYPE = 9
          BEGIN                        
            SELECT @USE_ACC_CD1 = USE_ACC_CD1, @DEB_AMT_W = (@CRE_AMT_W - @DEB_AMT_W), @FG_NM2 = NULL, @FG_NM3 = NULL
              FROM ACC_JUNL                          
             WHERE JUNL_FG = @JUNL_FG                            
               AND JUNL_CD = 91

              EXEC @RET = SP_ACC_SLIPD_INS_NEW @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD1, '1', @SITE_CD, @DEPT_CD, @IN_EMP_NO, @EV_NO, @SAVE_ACC_NO, @DEB_AMT_W, 0, @REMARK, @EMP_NO, @FG_NM1, @FG_NM2, @FG_NM3
                                                              
              IF @RET <> 0 GOTO ERR_HANDLER                               
          END
    END

	-- 대변                      
    IF @CRE_AMT_W  <> 0                             
    BEGIN
    	
		SELECT @FG_NM2 = NULL, @FG_NM3 = NULL
    	
    	-----------------------------------------------------------------------------
    	-- 대표속성 '온라인(단품)' 대변코드 고정(외상매출금: 12400)
		SELECT @USE_ACC_CD2 = '12400',  @FG_NM2 = A.MASTER_CODE, @FG_NM3 = CONVERT(VARCHAR(40), A.PRO_NAME)
		FROM PKG_DETAIL A WITH(NOLOCK)
		INNER JOIN PKG_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
		WHERE A.PRO_CODE = @EV_NO AND B.ATT_CODE = '1'
		-----------------------------------------------------------------------------

         EXEC @RET = SP_ACC_SLIPD_INS_NEW @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD2, '2', @SITE_CD, @DEPT_CD, @IN_EMP_NO, @EV_NO, @SAVE_ACC_NO, 0, @CRE_AMT_W, @REMARK, @EMP_NO, @FG_NM1, @FG_NM2, @FG_NM3
                                      
         IF @RET <> 0 GOTO ERR_HANDLER                               
	END                          
                          
	IF @AMT_W  <> 0                             
	BEGIN                          
		IF @JUNL_FG = 'PR'
		BEGIN
			INSERT INTO ACC_PR_SLIP (PAY_SEQ, SLIP_PROC_YN, SLIP_MK_DAY, SLIP_MK_SEQ, INS_DT)
			VALUES (@PAY_SEQ, 'Y', @SLIP_MK_DAY, @SLIP_MK_SEQ, DEFAULT)
		END
		ELSE
		BEGIN
			INSERT INTO ACC_RE_SLIP (PAY_SEQ, MCH_SEQ, SLIP_PROC_YN, SLIP_MK_DAY, SLIP_MK_SEQ, INS_DT)                          
			VALUES (@PAY_SEQ, @MCH_SEQ, 'Y', @SLIP_MK_DAY, @SLIP_MK_SEQ, DEFAULT)                           
		END

		IF @RET <> 0 GOTO ERR_HANDLER                                                                   
	END
                         
	COMMIT TRANSACTION      
	RETURN 0

	ERR_HANDLER:                              
		ROLLBACK TRANSACTION                              
		RETURN -1

END

GO
